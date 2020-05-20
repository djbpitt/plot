<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/plot-lib"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" xmlns:f="http://www.obdurodon.org/function-variables"
    version="3.0">
    <!-- ================================================================= -->
    <!-- Library for statistical plotting in native XSLT                   -->
    <!-- Author: David J. Birnbaum, djbpitt@gmail.com                      -->
    <!-- Repo: https://github.com/djbpitt/plot                             -->
    <!-- License: GPL 3.0                                                  -->
    <!--                                                                   -->
    <!-- Conventions:                                                      -->
    <!--                                                                   -->
    <!-- All function variables are in f: namespace                        -->
    <!-- Multi-word names are hyphenated (except f:allX, f:allY)           -->
    <!-- ================================================================= -->
    <!-- ================================================================= -->
    <!-- Public (final) functions                                          -->
    <!-- ================================================================= -->
    <xsl:expose component="function" visibility="final"
        names="
        djb:validate-points#1 
        djb:split-points#1
        djb:random-sequence#1
        djb:get-weights-scale#3
        djb:get-weights-scale#2
        djb:weighted-average#4
        djb:gaussian#4
        djb:round-to-odd#1
        djb:expand-to-tenths#1
        djb:recenter#3
        "/>
    <xsl:function name="djb:validate-points" as="xs:boolean">
        <!-- ================================================================= -->
        <!-- djb:validate-points#1 (nb: plural)                                -->
        <!--                                                                   -->
        <!-- Validates cardinality and lexical form of input points            -->
        <!--                                                                   -->
        <!-- Parameters:                                                       -->
        <!--   $f:point-pairs as xs:string+ : SVG coordinate points            -->
        <!--                                                                   -->
        <!-- Return:                                                           -->
        <!--   True iff                                                        -->
        <!--     1. There are at least three points                            -->
        <!--     2. Each point matches regex "X,Y" where                       -->
        <!--        a. X and Y are doubles with optional leading sign)         -->
        <!--        b. there are no spaces                                     -->
        <!--     3. X values are arranged monotonically                        -->
        <!-- ================================================================= -->
        <xsl:param name="f:point-pairs" as="xs:string+"/>
        <!-- https://stackoverflow.com/questions/12643009/regular-expression-for-floating-point-numbers -->
        <xsl:sequence
            select="
            (count($f:point-pairs) ge 3)
            and
            (every $f:point-pair in $f:point-pairs
            satisfies djb:validate-point-regex($f:point-pair))
            and
            djb:validate-monotonic-X($f:point-pairs)
            "
        />
    </xsl:function>
    <xsl:function name="djb:split-points" as="xs:string+">
        <!-- ================================================================= -->
        <!-- djb:split-points#1                                                -->
        <!--                                                                   -->
        <!-- Splits SVG @points format into individual strings for each point  -->
        <!--                                                                   -->
        <!-- Parameters:                                                       -->
        <!--   $f:all-points as xs:string :                                    -->
        <!--      whitespace-delimited coordinate pairs                        -->
        <!--                                                                   -->
        <!-- Return:                                                           -->
        <!--   xs:string+ : one string for each point pair                     -->
        <!--                                                                   -->
        <!-- Note:                                                             -->
        <!--   Not currently used; remove?                                     -->
        <!-- ================================================================= -->
        <xsl:param name="f:all-points" as="xs:string"/>
        <xsl:sequence select="tokenize(normalize-space($f:all-points), ' ')"/>
    </xsl:function>
    <xsl:function name="djb:random-sequence" as="xs:double*">
        <!-- ============================================================ -->
        <!-- djb:random-sequence#1                                        -->
        <!-- Create a specified number of random numbers -100 < n < 0     -->
        <!-- ============================================================ -->
        <xsl:param name="count" as="xs:integer"/>
        <xsl:iterate select="1 to $count">
            <xsl:param name="G" as="map(xs:string, item())" select="random-number-generator()"/>
            <xsl:sequence select="$G?number"/>
            <xsl:next-iteration>
                <xsl:with-param name="G" select="$G?next()"/>
            </xsl:next-iteration>
        </xsl:iterate>
    </xsl:function>
    <xsl:function name="djb:get-weights-scale" as="xs:double+">
        <!-- ============================================================ -->
        <!-- djb:get=weights-scale#3                                      -->
        <!--                                                              -->
        <!-- Returns sequence of scaling values for different kernels     -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   f:kernel as xs:string : gaussian, rectangular, exponential -->
        <!--   f:window_size as xs:integer : width of window              -->
        <!--   f:stddev as xs:integer : controls width of bell            -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double+ : weights to be applied in scaling              -->
        <!--                                                              -->
        <!-- Notes:                                                       -->
        <!--   Gaussian mean = 0, peak = 1                                -->
        <!--   f:stddev: is ignored silently except for Gaussian          -->
        <!--             defaults to 5 if not specified                   -->
        <!--   Return full width of window (for end values)               -->
        <!-- ============================================================ -->
        <xsl:param name="f:kernel" as="xs:string"/>
        <xsl:param name="f:window-size" as="xs:integer"/>
        <xsl:param name="f:stddev" as="xs:double"/>
        <xsl:if test="$f:window-size mod 2 eq 0 or $f:window-size lt 3">
            <xsl:message terminate="yes">Window size must be odd integer greater than
                3</xsl:message>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$f:kernel eq 'gaussian'">
                <xsl:if test="$f:stddev le 0">
                    <xsl:message terminate="yes">σ must be greater than 0</xsl:message>
                </xsl:if>
                <xsl:sequence select="djb:gaussian-weights($f:window-size, $f:stddev)"/>
            </xsl:when>
            <xsl:when test="$f:kernel eq 'rectangular'">
                <!-- all values are equal to 1 -->
                <xsl:sequence select="(0 to ($f:window-size)) ! 1"/>
            </xsl:when>
            <xsl:when test="$f:kernel eq 'exponential'">
                <!-- 1/1, 1/2, 1/4, 1/8, ... -->
                <xsl:sequence select="(0 to ($f:window-size)) ! (math:pow(2, -1 * .))"/>
            </xsl:when>
            <xsl:when test="$f:kernel eq 'parabolic-down'">
                <!-- y = 1 - (d/N)^2 -->
                <xsl:sequence
                    select="(0 to ($f:window-size)) ! (1 - math:pow(. div $f:window-size, 2))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes"
                    select="'Invalid kernel (' || $f:kernel || '); must be one of: gaussian, rectangular, or exponential'"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="djb:get-weights-scale" as="xs:double+">
        <!-- ============================================================ -->
        <!-- djb:get=weights-scale#2                                      -->
        <!--                                                              -->
        <!-- Returns sequence of scaling values for different kernels     -->
        <!-- Calls djb:get-weights-scale#3 with σ =5                      -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   f:kernel as xs:string : gaussian, rectangular, exponential -->
        <!--   f: window_size as xs:integer : width of window             -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double+ : weights to be applied in scaling              -->
        <!--                                                              -->
        <!-- Notes:                                                       -->
        <!--   Gaussian mean = 0, peak = 1                                -->
        <!--   f:stddev is ignored silently except for Gaussian           -->
        <!--   Return full width of window (for end values)               -->
        <!-- ============================================================ -->
        <xsl:param name="f:kernel" as="xs:string"/>
        <xsl:param name="f:window-size" as="xs:integer"/>
        <xsl:if test="$f:window-size mod 2 eq 0 or $f:window-size lt 3">
            <xsl:message terminate="yes">Window size must be odd integer greater than
                3</xsl:message>
        </xsl:if>
        <!-- default to σ = 5 if not specified -->
        <xsl:sequence select="djb:get-weights-scale($f:kernel, $f:window-size, 5)"/>
    </xsl:function>
    <xsl:function name="djb:weighted-average" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:weighted-average#4                                       -->
        <!--                                                              -->
        <!-- Returns smoothed value for current point                     -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:focus as xs:integer : offset of focus point             -->
        <!--   $f:window_size as xs:integer : width of window (odd, > 3)  -->
        <!--   $f:input_values as xs:double+ : all Y values               -->
        <!--   $f:weights : weights scale (from djb:get-weights-scale)    -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double : weighted value for focus point                 -->
        <!--                                                              -->
        <!-- XQuery mockup:                                               -->
        <!--   let $sum_of_weights := sum($weights)                       -->
        <!--   let $sum_of_weighted_scores as xs:double :=                -->
        <!--     (for $i in 1 to count($weights)                          -->
        <!--     return $weights[$i] * $scores[$i]) => sum()              -->
        <!--   return $sum_of_weighted_scores div $sum_of_weights         -->
        <!-- ============================================================ -->
        <xsl:param name="f:focus" as="xs:integer"/>
        <xsl:param name="f:window-size" as="xs:integer"/>
        <xsl:param name="f:input-values" as="xs:double+"/>
        <xsl:param name="f:weights" as="xs:double+"/>
        <xsl:variable name="f:n" as="xs:integer" select="count($f:input-values)"/>
        <xsl:if test="$f:window-size mod 2 eq 0 or $f:window-size lt 3 or $f:window-size gt $f:n">
            <xsl:message terminate="yes">Window size must be 1) an odd integer, 2) greater than 3,
                and 3) not greater than the count of the input values</xsl:message>
        </xsl:if>
        <!-- adjust window for end cases -->
        <xsl:variable name="f:half-window" as="xs:integer" select="$f:window-size idiv 2"/>
        <xsl:variable name="f:left-edge" as="xs:integer">
            <xsl:choose>
                <xsl:when test="$f:focus le $f:half-window">
                    <!-- window touches left edge -->
                    <xsl:sequence select="1"/>
                </xsl:when>
                <xsl:when test="$f:focus gt ($f:n - $f:half-window)">
                    <!-- window touches right edge -->
                    <xsl:sequence select="$f:n - (2 * $f:half-window)"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- window not at edge -->
                    <xsl:sequence select="$f:focus - $f:half-window"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="f:right-edge" as="xs:integer">
            <xsl:choose>
                <xsl:when test="$f:focus ge ($f:n - $f:half-window)">
                    <xsl:sequence select="$f:n"/>
                </xsl:when>
                <xsl:when test="$f:focus le $f:half-window">
                    <xsl:sequence select="$f:window-size"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$f:focus + $f:half-window"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="f:weighted-values" as="xs:double+">
            <xsl:for-each select="reverse($f:left-edge to $f:focus)">
                <xsl:variable name="f:pos" as="xs:integer" select="position()"/>
                <xsl:sequence select="$f:input-values[current()] * $f:weights[$f:pos]"/>
            </xsl:for-each>
            <xsl:for-each select="($f:focus + 1) to $f:right-edge">
                <xsl:variable name="f:pos" as="xs:integer" select="position()"/>
                <xsl:sequence select="$f:input-values[current()] * $f:weights[$f:pos + 1]"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="f:sum-weighted-values" as="xs:double" select="sum($f:weighted-values)"/>
        <!-- compute sum of weights applied to all points in winow -->
        <xsl:variable name="f:sum-applied-weights" as="xs:double"
            select="
            $f:weights[1] + 
            sum($f:weights[position() = (2 to (1 + $f:focus - $f:left-edge))]) +
            sum($f:weights[position() = (2 to (1 + $f:right-edge - $f:focus))])
            "/>
        <xsl:sequence select="$f:sum-weighted-values div $f:sum-applied-weights"/>
    </xsl:function>
    <xsl:function name="djb:gaussian" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:gaussian#4 as xs:double                                  -->
        <!--                                                              -->
        <!-- $f:x as xs:double : input                                    -->
        <!-- $f:peak as xs:double : height of curve’s peak                -->
        <!-- $f:center as xs:double : X position of center of peak (mean) -->
        <!-- $f:stddev as xs:double : stddev (controls width of curve)    -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   xs:double, representing Y value corresponding to X         -->
        <!--                                                              -->
        <!-- https://en.wikipedia.org/wiki/Gaussian_function:             -->
        <!-- "The parameter a is the height of the curve's peak, b is the -->
        <!--   position of the center of the peak and c (the standard     -->
        <!--   deviation, sometimes called the Gaussian RMS width)        -->
        <!--   controls the width of the "bell".                          -->
        <!-- ============================================================ -->
        <xsl:param name="f:x" as="xs:double"/>
        <xsl:param name="f:peak" as="xs:double"/>
        <xsl:param name="f:mean" as="xs:double"/>
        <xsl:param name="f:stddev" as="xs:double"/>
        <xsl:sequence
            select="$f:peak * math:exp(-1 * (math:pow(($f:x - $f:mean), 2)) div (2 * math:pow($f:stddev, 2)))"
        />
    </xsl:function>
    <xsl:function name="djb:round-to-odd" as="xs:integer">
        <!-- ============================================================ -->
        <!-- djb:round-to-odd#1                                           -->
        <!-- Round even integer up to odd, return input odd unchanged     -->
        <!--                                                              -->
        <!-- Parameter                                                    -->
        <!--   $input as xs:integer : value to be rounded to odd          -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   If even, rounds up to odd; if odd, returns unchanged       -->
        <!-- ============================================================ -->
        <xsl:param name="input" as="xs:integer"/>
        <xsl:sequence select="(2 * floor($input div 2) + 1) => xs:integer()"/>
    </xsl:function>
    <xsl:function name="djb:recenter" as="xs:double+">
        <!-- ================================================================ -->
        <!-- djb:recenter#3                                                   -->
        <!--                                                                  -->
        <!-- Adjusts and recenters doubles, returns adjusted values           -->
        <!--                                                                  -->
        <!-- Parameters                                                       -->
        <!--   $f:input-values as xs:double+ : all input values               -->
        <!--   $f:a as xs:double : new minimum value                          -->
        <!--   $f:b as xs:double : new maximum value                          -->
        <!--                                                                  -->
        <!-- Returns                                                          -->
        <!--   xs:double+                                                     -->
        <!--                                                                  -->
        <!-- Note: https://stackoverflow.com/questions/5294955/how-to-scale-down-a-range-of-numbers-with-a-known-min-and-max-value -->
        <!--            (b - a)(x - min)                                      -->
        <!--    f(x) =  ——————————————   + a                                  -->
        <!--                max - min                                         -->
        <!-- ================================================================ -->
        <xsl:param name="f:input-values" as="xs:double+"/>
        <xsl:param name="f:a" as="xs:double"/>
        <xsl:param name="f:b" as="xs:double"/>
        <xsl:variable name="f:min" as="xs:double" select="min($f:input-values)"/>
        <xsl:variable name="f:max" as="xs:double" select="max($f:input-values)"/>
        <xsl:variable name="f:recentered-values"
            select="$f:input-values ! (((($f:b - $f:a) * (. - $f:min)) div ($f:max - $f:min)) + $f:a)"/>
        <xsl:sequence select="$f:recentered-values"/>
    </xsl:function>
    <xsl:function name="djb:expand-to-tenths" as="xs:double+">
        <!-- ============================================================ -->
        <!-- djb:expand-to-tenths#1                                       -->
        <!--                                                              -->
        <!-- Converts integer range to range of tenths                    -->
        <!--                                                              -->
        <!-- Parameter                                                    -->
        <!--   $f:half as xs:integer : upper bound of symmetrical range   -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   xs:double+ : symmetrical range in tenths                   -->
        <!-- ============================================================ -->
        <xsl:param name="f:half" as="xs:integer"/>
        <xsl:if test="$f:half le 0">
            <xsl:message terminate="yes">Input must be a positive integer</xsl:message>
        </xsl:if>
        <xsl:sequence
            select="
            for $i in (-10 * $f:half to 10 * $f:half)
            return
            $i div 10"
        />
    </xsl:function> ======= >>>>>>> 5561b4184c092ed94ffa98d9059d60821a97b77f <!-- ================================================================ -->
    <!-- ================================================================ -->
    <!-- Private functions                                                -->
    <!-- ================================================================ -->
    <xsl:function name="djb:validate-point-regex" as="xs:boolean">
        <!-- ================================================================= -->
        <!-- fjb:validate-point-regex#1 (nb: singular)                         -->
        <!--                                                                   -->
        <!-- Tests a single point and returns True if it matches regex         -->
        <!-- Regex: "X,Y" where                                                -->
        <!--   X and Y are doubles in canonic notation (optional leading sign) -->
        <!--   and there are no spaces                                         -->
        <!--                                                                   -->
        <!-- Parameters:                                                       -->
        <!--   $f:input-point as xs:string : point in X,Y format               -->
        <!--                                                                   -->
        <!-- Return:                                                           -->
        <!--   True iff point matches regex                                    -->
        <!-- ================================================================= -->
        <xsl:param name="f:input-point" as="xs:string"/>
        <!-- https://stackoverflow.com/questions/12643009/regular-expression-for-floating-point-numbers -->
        <xsl:variable name="f:float-regex" as="xs:string"
            select="'[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)'"/>
        <xsl:variable name="f:point-regex" as="xs:string"
            select="$f:float-regex || ',' || $f:float-regex"/>
        <xsl:sequence select="matches($f:input-point, $f:point-regex)"/>
    </xsl:function>
    <xsl:function name="djb:validate-monotonic-X" as="xs:boolean">
        <!-- ================================================================= -->
        <!-- djb:validate-monotonic-X#1                                        -->
        <!--                                                                   -->
        <!-- Tests input a sequence and returns True if X values are monotonic -->
        <!--                                                                   -->
        <!-- Parameters:                                                       -->
        <!--   $f:input-points as xs:string+ : all points in X,Y format        -->
        <!--                                                                   -->
        <!-- Return:                                                           -->
        <!--   True iff X is monotonic                                         -->
        <!-- ================================================================= -->
        <xsl:param name="f:point-pairs" as="xs:string+"/>
        <xsl:variable name="f:allX" as="xs:double+"
            select="$f:point-pairs ! tokenize(., ',')[1] ! number(.)"/>
        <xsl:sequence select="djb:monotonic($f:allX)"/>
    </xsl:function>
    <xsl:function name="djb:uniform" as="xs:boolean">
        <!-- ============================================================ -->
        <!-- djb:uniform#1                                                -->
        <!--                                                              -->
        <!-- Returns True iff all items in sequence are equal             -->
        <!--                                                              -->
        <!-- Parameter                                                    -->
        <!--   $f:seq as item()+ : sequence of any datatype               -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   xs:boolean : True iff all items in $seq are equal          -->
        <!--                                                              -->
        <!-- Note: O(n) counterpart to O(n^2) not($seq != $seq)           -->
        <!--   (from Michael Kay over xml.com Slack                       -->
        <!-- ============================================================ -->
        <xsl:param name="f:seq" as="item()+"/>
        <xsl:sequence select="not(head($f:seq) != tail($f:seq))"/>
    </xsl:function>
    <xsl:function name="djb:monotonic" as="xs:boolean">
        <!-- ============================================================ -->
        <!-- djb:monotonic#1                                              -->
        <!--                                                              -->
        <!-- Returns True iff sequence is monotonic (in either direction) -->
        <!--                                                              -->
        <!-- Parameter                                                    -->
        <!--   $f:seq as xs:double+ : sequence of numerical values        -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   True iff $f:seq is monotonically non-increasing or         -->
        <!--   non-decreasing                                             -->
        <!-- ============================================================ -->
        <xsl:param name="f:seq" as="xs:double+"/>
        <xsl:sequence
            select="
            (for $i in 2 to count($f:seq)
            return
            $f:seq[$i] ge $f:seq[$i - 1]) => djb:uniform()"
        />
    </xsl:function>
    <xsl:function name="djb:gaussian-weights" as="xs:double+">
        <!-- ============================================================ -->
        <!-- djb:gaussian-weights#2                                       -->
        <!--                                                              -->
        <!-- Returns sequence of values for Gaussian weighting            -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   window_size as xs:integer : width of window                -->
        <!--   stddev as xs:integer : controls width of bell              -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double+ : weights to be applied in scaling              -->
        <!--                                                              -->
        <!-- Notes:                                                       -->
        <!--   Mean - 0, peak = 1                                         -->
        <!--   Return full width of window (for end values)               -->
        <!-- ============================================================ -->
        <xsl:param name="f:window-size" as="xs:integer"/>
        <xsl:param name="f:stddev" as="xs:double"/>
        <xsl:for-each select="0 to ($f:window-size)">
            <xsl:sequence select="djb:gaussian(current(), 1, 0, $f:stddev)"/>
        </xsl:for-each>
    </xsl:function>
</xsl:package>

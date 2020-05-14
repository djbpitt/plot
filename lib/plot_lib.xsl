<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/plot_lib"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <!-- ================================================================= -->
    <!-- Public (final) functions                                          -->
    <!-- ================================================================= -->
    <xsl:expose component="function" visibility="final"
        names="
        djb:validate-points#1 
        djb:split-points#1
        djb:random-sequence#1
        djb:weighted-average#4
        djb:round-to-odd#1
        "/>
    <xsl:function name="djb:validate-points" as="xs:boolean">
        <!-- ================================================================= -->
        <!-- validate_points (nb: plural)                                      -->
        <!--                                                                   -->
        <!-- Validates cardinality and lexical form of input points            -->
        <!--                                                                   -->
        <!-- Parameters:                                                       -->
        <!--   $pointPairs as xs:string+ : sequence of SVG coordinate points   -->
        <!--                                                                   -->
        <!-- Return:                                                           -->
        <!--   True iff                                                        -->
        <!--     1. There are at least three points                            -->
        <!--     2. Each point matches regex "X,Y" where                       -->
        <!--        a. X and Y are doubles with optional leading sign)         -->
        <!--        b. there are no spaces                                     -->
        <!--     3. X values are arranged monotonically                        -->
        <!-- ================================================================= -->
        <xsl:param name="pointPairs" as="xs:string+"/>
        <!-- https://stackoverflow.com/questions/12643009/regular-expression-for-floating-point-numbers -->
        <xsl:sequence
            select="
            (count($pointPairs) ge 3)
            and
            (every $pointPair in $pointPairs
            satisfies djb:validate_point_regex($pointPair))
            and
            djb:validate_monotonic_X($pointPairs)
            "
        />
    </xsl:function>

    <xsl:function name="djb:split-points" as="xs:string+">
        <!-- ================================================================= -->
        <!-- split_points                                                      -->
        <!--                                                                   -->
        <!-- Splits SVG @points format into individual strings for each point  -->
        <!--                                                                   -->
        <!-- Parameters:                                                       -->
        <!--   $all_points as xs:string :                                      -->
        <!--      whitespace-delimited coordinate pairs                        -->
        <!--                                                                   -->
        <!-- Return:                                                           -->
        <!--   xs:string+ : one string for each point pair                     -->
        <!--                                                                   -->
        <!-- Note:                                                             -->
        <!--   Not currently used; remove?                                     -->
        <!-- ================================================================= -->
        <xsl:param name="all_points" as="xs:string"/>
        <xsl:sequence select="tokenize(normalize-space($all_points), ' ')"/>
    </xsl:function>

    <xsl:function name="djb:random-sequence" as="xs:double*">
        <!-- ============================================================ -->
        <!-- djb:random-sequence#1                                        -->
        <!-- Create a specified number of random numbers -100 < n < 0     -->
        <!-- Adapted from the XPath 3.1 functions spec                    -->
        <!-- ============================================================ -->
        <xsl:param name="length" as="xs:integer"/>
        <xsl:sequence select="djb:random-sequence($length, random-number-generator())"/>
    </xsl:function>

    <xsl:function name="djb:weighted-average" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:weighted_average                                         -->
        <!--                                                              -->
        <!-- Returns smoothed value for current point                     -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $focus as xs:integer : offset of focus point               -->
        <!--   $input_values as xs:double+ : all Y values                 -->
        <!--   $window_size as xs:integer : width of window (odd, > 3)    -->
        <!--   $stddev as xs:double : width of bell                       -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double : weighted value for focus point                 -->
        <!--                                                              -->
        <!-- Notes:                                                       -->
        <!--   Mean - 0, peak = 1                                         -->
        <!--   Return full width of window for end values                 -->
        <!--   Weights are computed with djb:gaussian_weights()           -->
        <!--                                                              -->
        <!-- XQuery mockup:                                               -->
        <!--   let $sum_of_weights := sum($weights)                       -->
        <!--   let $sum_of_weighted_scores as xs:double :=                -->
        <!--     (for $i in 1 to count($weights)                          -->
        <!--     return $weights[$i] * $scores[$i]) => sum()              -->
        <!--   return $sum_of_weighted_scores div $sum_of_weights         -->
        <!-- ============================================================ -->
        <xsl:param name="focus" as="xs:integer"/>
        <xsl:param name="input_values" as="xs:double+"/>
        <xsl:param name="window_size" as="xs:integer"/>
        <xsl:param name="stddev" as="xs:double+"/>
        <xsl:variable name="weights" as="xs:double+"
            select="djb:gaussian-weights($window_size, $stddev)"/>
        <xsl:variable name="n" as="xs:integer" select="count($input_values)"/>
        <xsl:if test="$window_size mod 2 eq 0 or $window_size lt 3 or $window_size gt $n">
            <xsl:message terminate="yes">Window size must be 1) an odd integer, 2) greater than 3,
                and 3) not greater than the count of the input values</xsl:message>
        </xsl:if>
        <!-- adjust window for end cases -->
        <xsl:variable name="half_window" as="xs:integer" select="$window_size idiv 2"/>
        <xsl:variable name="left_edge" as="xs:integer">
            <xsl:choose>
                <xsl:when test="$focus le $half_window">
                    <!-- window touches left edge -->
                    <xsl:sequence select="1"/>
                </xsl:when>
                <xsl:when test="$focus gt ($n - $half_window)">
                    <!-- window touches right edge -->
                    <xsl:sequence select="$n - (2 * $half_window)"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- window not at edge -->
                    <xsl:sequence select="$focus - $half_window"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="right_edge" as="xs:integer">
            <xsl:choose>
                <xsl:when test="$focus ge ($n - $half_window)">
                    <xsl:sequence select="$n"/>
                </xsl:when>
                <xsl:when test="$focus le $half_window">
                    <xsl:sequence select="$window_size"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$focus + $half_window"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="weighted_values" as="xs:double+">
            <!-- create weighted values -->
            <xsl:for-each select="1 to ($half_window + 1)">
                <!-- values for left side and focus -->
                <xsl:sequence select="$input_values[$focus + 1 - current()] * $weights[current()]"/>
            </xsl:for-each>
            <xsl:for-each select="1 to $half_window">
                <!-- values for right side -->
                <xsl:sequence select="$input_values[$focus + current()] * $weights[current() + 1]"/>
            </xsl:for-each>
        </xsl:variable>
        <!-- sum of weighted values div sum of applied weights -->
        <xsl:variable name="sum_applied_weights" as="xs:double"
            select="$weights[1] + sum(($weights[position() = 2 to ($half_window + 1)] ! (. * 2)))"/>
        <xsl:sequence select="sum($weighted_values) div $sum_applied_weights"/>
    </xsl:function>

    <xsl:function name="djb:round-to-odd" as="xs:integer">
        <!-- ============================================================ -->
        <!-- djb:round-to-odd()                                           -->
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
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Private functions                                                -->
    <!-- ================================================================ -->
    <xsl:function name="djb:validate_point_regex" as="xs:boolean">
        <!-- ================================================================= -->
        <!-- validate_point_regex (nb: singular)                               -->
        <!--                                                                   -->
        <!-- Tests a single point and returns True if it matches regex         -->
        <!-- Regex: "X,Y" where                                                -->
        <!--   X and Y are doubles in canonic notation (optional leading sign) -->
        <!--   and there are no spaces                                         -->
        <!--                                                                   -->
        <!-- Parameters:                                                       -->
        <!--   $inputPoint as xs:string : point in X,Y format                  -->
        <!--                                                                   -->
        <!-- Return:                                                           -->
        <!--   True iff point matches regex                                    -->
        <!-- ================================================================= -->
        <xsl:param name="inputPoint" as="xs:string"/>
        <!-- https://stackoverflow.com/questions/12643009/regular-expression-for-floating-point-numbers -->
        <xsl:variable name="float_regex" as="xs:string"
            select="'[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)'"/>
        <xsl:variable name="point_regex" as="xs:string" select="$float_regex || ',' || $float_regex"/>
        <xsl:sequence select="matches($inputPoint, $point_regex)"/>
    </xsl:function>

    <xsl:function name="djb:validate_monotonic_X" as="xs:boolean">
        <!-- ================================================================= -->
        <!-- validate_monotonic_X                                              -->
        <!--                                                                   -->
        <!-- Tests input a sequence and returns True if X values are monotonic -->
        <!--                                                                   -->
        <!-- Parameters:                                                       -->
        <!--   $inputPoints as xs:string+ : all points in X,Y format           -->
        <!--                                                                   -->
        <!-- Return:                                                           -->
        <!--   True iff X is monotonic                                         -->
        <!-- ================================================================= -->
        <xsl:param name="pointPairs" as="xs:string+"/>
        <xsl:variable name="allX" as="xs:double+"
            select="$pointPairs ! tokenize(., ',')[1] ! number(.)"/>
        <xsl:sequence select="djb:monotonic($allX)"/>
    </xsl:function>

    <xsl:function name="djb:uniform" as="xs:boolean">
        <!-- ============================================================ -->
        <!-- djb:uniform                                                  -->
        <!--                                                              -->
        <!-- Returns True iff all items in sequence are equal             -->
        <!--                                                              -->
        <!-- Parameter                                                    -->
        <!--   $seq as item()+ : sequence of any datatype                 -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   xs:boolean : True iff all items in $seq are equal          -->
        <!--                                                              -->
        <!-- Note: O(n) counterpart to O(n^2) not($seq != $seq)           -->
        <!--   (from Michael Kay over xml.com Slack                       -->
        <!-- ============================================================ -->
        <xsl:param name="seq" as="item()+"/>
        <xsl:sequence select="not(head($seq) != tail($seq))"/>
    </xsl:function>

    <xsl:function name="djb:monotonic" as="xs:boolean">
        <!-- ============================================================ -->
        <!-- djb:monotonic                                                -->
        <!--                                                              -->
        <!-- Returns True iff sequence is monotonic (in either direction) -->
        <!--                                                              -->
        <!-- Parameter                                                    -->
        <!--   $seq as xs:double+ : sequence of numerical values          -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   True iff $seq is monotonically non-increasing or           -->
        <!--   non-decreasing                                             -->
        <!-- ============================================================ -->
        <xsl:param name="seq" as="xs:double+"/>
        <xsl:sequence
            select="
            (for $i in 2 to count($seq)
            return
            $seq[$i] ge $seq[$i - 1]) => djb:uniform()"
        />
    </xsl:function>

    <xsl:function name="djb:expand-to-tenths" as="xs:double+">
        <!-- ============================================================ -->
        <!-- djb:expand-to-tenths                                         -->
        <!--                                                              -->
        <!-- Converts integer range to range of tenths                    -->
        <!--                                                              -->
        <!-- Parameter                                                    -->
        <!--   $half as xs:integer : upper bound of symmetrical range     -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   xs:double+ : symmetrical range in tenths                   -->
        <!-- ============================================================ -->
        <xsl:param name="half" as="xs:integer"/>
        <xsl:if test="$half le 0">
            <xsl:message terminate="yes">Input must be a positive integer</xsl:message>
        </xsl:if>
        <xsl:sequence
            select="
            for $i in (-10 * $half to 10 * $half)
            return
            $i div 10"
        />
    </xsl:function>

    <xsl:function name="djb:gaussian" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:gaussian() as xs:double                                  -->
        <!--                                                              -->
        <!-- $x as xs:double : input                                      -->
        <!-- $peak as xs:double : height of curve’s peak                  -->
        <!-- $center as xs:double : X position of center of peak (mean)   -->
        <!-- $stddev as xs:double : stddev (controls width of curve)      -->
        <!--                                                              -->
        <!-- Helper function for djb:gaussian-weights, which is a helper  -->
        <!--   function for djb:weighted-average                          -->
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
        <xsl:param name="x" as="xs:double"/>
        <xsl:param name="peak" as="xs:double"/>
        <xsl:param name="mean" as="xs:double"/>
        <xsl:param name="stddev" as="xs:double"/>
        <xsl:if test="$stddev le 0">
            <xsl:message terminate="yes">Stddev must be greater than 0</xsl:message>
        </xsl:if>
        <xsl:sequence
            select="$peak * math:exp(-1 * (math:pow(($x - $mean), 2)) div (2 * math:pow($stddev, 2)))"
        />
    </xsl:function>

    <xsl:function name="djb:gaussian-weights" as="xs:double+">
        <!-- ============================================================ -->
        <!-- djb:gaussian_weights                                         -->
        <!--                                                              -->
        <!-- Returns sequence of values for Gaussian weighting            -->
        <!--   Helper function for djb:weighted-average                   -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   window_size as xs:integer : width of window (odd, > 3)     -->
        <!--   stddev as xs:integer : controls width of bell              -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double+ : weights to be applied in scaling              -->
        <!--                                                              -->
        <!-- Notes:                                                       -->
        <!--   Mean - 0, peak = 1                                         -->
        <!--   Return full width of window (for end values)               -->
        <!-- ============================================================ -->
        <xsl:param name="window_size" as="xs:integer"/>
        <xsl:param name="stddev" as="xs:double"/>
        <xsl:if test="$window_size mod 2 eq 0 or $window_size lt 3">
            <xsl:message terminate="yes">Window size must be odd integer greater than
                3</xsl:message>
        </xsl:if>
        <xsl:for-each select="0 to ($window_size - 1)">
            <xsl:sequence select="djb:gaussian(current(), 1, 0, $stddev)"/>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:random-sequence">
        <!-- ============================================================ -->
        <!-- djb:random-sequence#2                                        -->
        <!-- Helper function for djb:random-sequence#1                    -->
        <!-- Adapted from the XPath 3.1 functions spec                    -->
        <!-- ============================================================ -->
        <xsl:param name="length" as="xs:integer"/>
        <xsl:param name="G" as="map(xs:string, item())"/>
        <xsl:choose>
            <xsl:when test="$length eq 0"/>
            <xsl:otherwise>
                <xsl:sequence select="$G?number, djb:random-sequence($length - 1, $G?next())"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:package>

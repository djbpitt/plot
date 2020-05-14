<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- ================================================================ -->
    <!-- Packages                                                         -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot_lib"/>
    <xsl:use-package name="http://www.obdurodon.org/smoothing"/>
    <xsl:use-package name="http://www.obdurodon.org/spline"/>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <xsl:function name="djb:gaussian_weights" as="xs:double+">
        <!-- ============================================================ -->
        <!-- djb:gaussian_weights                                         -->
        <!--                                                              -->
        <!-- Returns sequence of values for Gaussian weighting            -->
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

    <xsl:function name="djb:weighted_average" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:weighted_average                                         -->
        <!--                                                              -->
        <!-- Returns weighted value for current point                     -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $focus as xs:integer : offset of focus point               -->
        <!--   $input_values as xs:double+ : all Y values                 -->
        <!--   $window_size as xs:integer : width of window (odd, > 3)    -->
        <!--   $weights as xs:double : weights to be applied to window    -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double : weighted value for focus point                 -->
        <!--                                                              -->
        <!-- Notes:                                                       -->
        <!--   Mean - 0, peak = 1                                         -->
        <!--   Return full width of window for end values                 -->
        <!--                                                              -->
        <!-- XQuery mockup:
            let $sum_of_weights := sum($weights)
            let $sum_of_weighted_scores as xs:double := 
                (for $i in 1 to count($weights)
                return $weights[$i] * $scores[$i]) => sum()
            return $sum_of_weighted_scores div $sum_of_weights -->
        <!-- ============================================================ -->
        <xsl:param name="focus" as="xs:integer"/>
        <xsl:param name="input_values" as="xs:double+"/>
        <xsl:param name="window_size" as="xs:integer"/>
        <xsl:param name="weights" as="xs:double+"/>
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
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Create fake data, for testing, with a bit of jitter              -->
    <!-- ================================================================ -->
    <xsl:variable name="xScale" as="xs:integer" select="5"/>
    <xsl:variable name="allY" as="xs:double+"
        select="
            djb:random-sequence(100) ! (. * 100)"/>
    <xsl:variable name="points" as="xs:string+"
        select="
            for-each-pair(1 to count($allY), $allY, function ($a, $b) {
                string-join(($a * $xScale, -1 * $b), ',')
            })"/>

    <!-- ================================================================ -->
    <!-- Create list of weights the length of the window                  -->
    <!-- $stddev needed only for Gaussian                                 -->
    <!-- ================================================================ -->
    <!-- test window is 2/3 of all points-->
    <!--<xsl:variable name="window" as="xs:integer"
        select="djb:round-to-odd(xs:integer(round(count($allY) div 3 * 2)))"/>-->
    <xsl:variable name="window" as="xs:integer" select="3"/>
    <xsl:variable name="stddev" as="xs:double" select="5"/>
    <xsl:variable name="weights" as="xs:double+" select="djb:gaussian_weights($window, $stddev)"/>
    <xsl:variable name="adjustedY" as="xs:double+">
        <xsl:for-each select="1 to count($points)">
            <xsl:sequence select="djb:weighted_average(current(), $allY, $window, $weights)"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="adjustedPoints" as="xs:string+"
        select="
            for $x in (1 to count($adjustedY))
            return
                string-join(($x * $xScale, -1 * $adjustedY[$x]), ',')"/>

    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg"
            viewBox="-10 -110 {count($points) * $xScale + 20} 120" width="90%">
            <style type="text/css">
                .spline {
                    stroke: red;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                    fill: none;
                }</style>
            <!-- original points in black -->
            <xsl:for-each select="$points">
                <circle cx="{substring-before(current(), ',')}"
                    cy="{substring-after(current(), ',')}" r="0.5" fill="black"/>
            </xsl:for-each>
            <polyline points="{$points}" stroke="black" stroke-width="0.5" fill="none"/>
            <!-- adjusted points in blue -->
            <xsl:for-each select="$adjustedPoints">
                <circle cx="{substring-before(current(), ',')}"
                    cy="{substring-after(current(), ',')}" r="0.5" fill="blue"/>
            </xsl:for-each>
            <polyline points="{$adjustedPoints}" stroke="blue" stroke-width="0.5" fill="none"
                stroke-opacity="0.5"/>
            <xsl:sequence select="djb:spline($adjustedPoints, .4)"/>
        </svg>
        <xsl:message select="'avg($allY): ' || avg($allY)"/>
        <xsl:message select="'avg($adjustedY): ' || avg($adjustedY)"/>
    </xsl:template>
</xsl:stylesheet>

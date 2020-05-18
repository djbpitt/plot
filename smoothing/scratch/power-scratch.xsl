<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- ================================================================ -->
    <!-- Packages                                                         -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot_lib"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>
    <xsl:use-package name="http://www.obdurodon.org/spline"/>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
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
        <!--   $weights as xs:double+ : all weights (full window size)    -->
        <!--   $dummy as xs:boolean : fake to avoid class with library    -->
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
        <xsl:param name="focus" as="xs:integer"/>
        <xsl:param name="input_values" as="xs:double+"/>
        <xsl:param name="window_size" as="xs:integer"/>
        <xsl:param name="weights" as="xs:double+"/>
        <xsl:param name="dummy" as="xs:boolean"/>
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
            <xsl:for-each select="reverse($left_edge to $focus)">
                <xsl:variable name="pos" as="xs:integer" select="position()"/>
                <xsl:sequence select="$input_values[current()] * $weights[$pos]"/>
            </xsl:for-each>
            <xsl:for-each select="($focus + 1) to $right_edge">
                <xsl:variable name="pos" as="xs:integer" select="position()"/>
                <xsl:sequence select="$input_values[current()] * $weights[$pos + 1]"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="sum_weighted_values" as="xs:double" select="sum($weighted_values)"/>
        <!-- compute sum of weights applied to all points in winow -->
        <xsl:variable name="sum_applied_weights" as="xs:double"
            select="
                $weights[1] +
                sum($weights[position() = (2 to (1 + $focus - $left_edge))]) +
                sum($weights[position() = (2 to (1 + $right_edge - $focus))])
                "/>
        <xsl:sequence select="$sum_weighted_values div $sum_applied_weights"/>
    </xsl:function>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!-- ================================================================ -->
    <xsl:variable name="xScale" as="xs:integer" select="2"/>
    <xsl:variable name="yScale" as="xs:integer" select="-100"/>
    <xsl:variable name="n" as="xs:integer" select="100"/>
    <xsl:variable name="windowSize" as="xs:integer" select="25"/>
    <xsl:variable name="allY" as="xs:double+" select="djb:random-sequence($n + 1) ! (. * $yScale)"/>
    <xsl:variable name="points" as="xs:string+"
        select="
            for-each-pair(
            (0 to $n) ! (. * $xScale),
            $allY,
            function ($a, $b) {
                string-join(($a, $b), ',')
            })"/>
    <xsl:variable name="regression" as="item()+" select="djb:regression-line($points, true())"/>
    <xsl:variable name="m" as="xs:double" select="$regression[2]?m"/>
    <xsl:variable name="b" as="xs:double" select="$regression[2]?b"/>
    <xsl:variable name="adjustedY" as="xs:double+" select="$allY"/>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-10 -115 {20 + $n * $xScale} 125">
            <style type="text/css">
                #regression line {
                    stroke: red;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                }
                #exponential .spline {
                    stroke: green;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                    fill: none;
                }</style>
            <!-- ======================================================== -->
            <!-- Draw ruling lines                                        -->
            <!-- ======================================================== -->
            <rect x="0" y="{$yScale}" width="{$n * $xScale}" height="{-1 * $yScale}"
                stroke="lightgray" stroke-width="0.5" stroke-linecap="square" fill="none"/>
            <text x="-1" y="0" text-anchor="end" alignment-baseline="central" fill="lightgray"
                font-size="3">0.0</text>
            <text x="-1" y="-100" text-anchor="end" alignment-baseline="central" fill="lightgray"
                font-size="3">100.0</text>
            <text x="-1" y="{$b}" text-anchor="end" alignment-baseline="central" fill="lightgray"
                font-size="3">
                <xsl:value-of select="format-number(-1 * $b, '0.0')"/>
            </text>
            <text x="{$n * $xScale}" y="{$n * $m * $xScale + $b}" text-anchor="start"
                alignment-baseline="central" fill="lightgray" font-size="3">
                <xsl:value-of select="format-number(-1 * ($n * $m + $b), '0.0')"/>
            </text>
            <line x1="0" y1="{$b}" x2="{$n * $xScale}" y2="{$b}" stroke="lightgray"
                stroke-width="0.5" stroke-linecap="square"/>
            <text x="{$n * $xScale div 2}" y="{$yScale - 5}" text-anchor="middle" fill="black"
                font-size="4">
                <tspan>n = <xsl:value-of select="$n"/>; window = <xsl:value-of select="$windowSize"
                    />; weight(y) = 1</tspan>
                <tspan dx="-1" dy="-2" font-size="3">-d</tspan>
            </text>
            <!-- ======================================================== -->
            <!-- Plot data                                                -->
            <!-- ======================================================== -->
            <xsl:for-each select="$points">
                <circle cx="{substring-before(current(), ',')}"
                    cy="{substring-after(current(), ',')}" r="0.5" fill="black"/>
            </xsl:for-each>
            <polyline points="{$points}" stroke="black" stroke-width="0.5" fill="none"/>
            <!-- ======================================================== -->
            <!-- Plot regression line                                     -->
            <!-- ======================================================== -->
            <g id="regression">
                <xsl:sequence select="$regression[1]"/>
            </g>
            <!-- ======================================================== -->
            <!-- Plot y = x^-d, where d = distance from focal point       -->
            <!-- ======================================================== -->
            <xsl:variable name="weights" as="xs:double+"
                select="
                    for $i in 0 to (2 * $windowSize + 1)
                    return
                        math:pow(2, -1 * $i)"/>
            <xsl:variable name="adjustedY" as="xs:double+">
                <xsl:for-each select="0 to $n">
                    <xsl:sequence
                        select="djb:weighted-average(current(), $allY, $windowSize, $weights, false())"
                    />
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="adjustedPoints"
                select="
                    for-each-pair(
                    0 to $n,
                    $adjustedY,
                    function ($a, $b) {
                        string-join(($a * $xScale, $b), ',')
                    })"/>
            <g id="exponential">
                <xsl:sequence select="djb:spline($adjustedPoints, 0.4)"/>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

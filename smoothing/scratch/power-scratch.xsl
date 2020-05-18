<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- ================================================================ -->
    <!-- Packages                                                         -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>
    <xsl:use-package name="http://www.obdurodon.org/spline"/>
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
    <xsl:variable name="weights" as="xs:double+"
        select="djb:get-weights-scale('exponential', $windowSize, 1)"/>
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
            <text x="-1" y="0" text-anchor="end" alignment-baseline="central" fill="lightgray" font-size="3">0.0</text>
            <text x="-1" y="-100" text-anchor="end" alignment-baseline="central" fill="lightgray" font-size="3">100.0</text>
            <text x="-1" y="{$b}" text-anchor="end" alignment-baseline="central" fill="lightgray" font-size="3">
                <xsl:value-of select="format-number(-1 * $b, '0.0')"/>
            </text>
            <text x="{$n * $xScale}" y="{$n * $m * $xScale + $b}" text-anchor="start" alignment-baseline="central" fill="lightgray" font-size="3">
                <xsl:value-of select="format-number(-1 * ($n * $m + $b), '0.0')"/>
            </text>
            <line x1="0" y1="{$b}" x2="{$n * $xScale}" y2="{$b}" stroke="lightgray"
                stroke-width="0.5" stroke-linecap="square"/>
            <text x="{$n * $xScale div 2}" y="{$yScale - 5}" text-anchor="middle" fill="black" font-size="4">
                <tspan>n = <xsl:value-of select="$n"/>; window = <xsl:value-of select="$windowSize"/>; weight(y) = 1</tspan>
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
            <xsl:variable name="adjustedY" as="xs:double+">
                <xsl:for-each select="0 to $n">
                    <xsl:sequence
                        select="djb:weighted-average(current(), $windowSize, $allY, $weights)"
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

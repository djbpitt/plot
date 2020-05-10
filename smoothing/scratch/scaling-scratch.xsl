<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:use-package name="http://www.obdurodon.org/plot_lib"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="xScale" as="xs:integer" select="10"/>
    <xsl:variable name="yScale" as="xs:integer" select="25"/>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-25 -130 1310 260">
            <!-- horizontal ruling and Y labels -->
            <xsl:for-each select="0 to 10">
                <xsl:variable name="yPos" as="xs:integer" select="current() * $yScale"/>
                <line x1="{$xScale}" y1="-{$yPos}" x2="{100 * $xScale}" y2="-{$yPos}"
                    stroke="lightgray" stroke-width="0.5" stroke-linecap="square"/>
                <text x="{$xScale div 2}" y="-{$yPos}" fill="black" text-anchor="end"
                    alignment-baseline="central" font-size="6">
                    <xsl:value-of select="(current() div 10) ! format-number(., '0.0')"/>
                </text>
            </xsl:for-each>
            <!-- vertical ruling and X labels -->
            <xsl:for-each select="1 to 100">
                <xsl:variable name="xPos" as="xs:integer" select="current() * $xScale"/>
                <line x1="{$xPos}" y1="0" x2="{$xPos}" y2="-{$yScale * 10}" stroke="lightgray"
                    stroke-width="0.5" stroke-linecap="square"/>
                <text x="{$xPos}" y="8" text-anchor="middle" font-size="6">
                    <xsl:value-of select="current() - 1"/>
                </text>
            </xsl:for-each>
            <!-- data points-->
            <xsl:for-each select="1 to 100">
                <xsl:variable name="xPos" as="xs:integer" select="current() * $xScale"/>
                <circle cx="{$xPos}" cy="-{$yScale * 10 div current()}" r="1.5" fill="black"
                    fill-opacity=".5"/>
                <circle cx="{$xPos}" cy="-{$yScale * 20 div (1 + current())}" r="1.5" fill="red"
                    fill-opacity=".5"/>
                <circle cx="{$xPos}" cy="-{$yScale * 30 div (2 + current())}" r="1.5" fill="green"
                    fill-opacity=".5"/>
                <circle cx="{$xPos}" cy="-{$yScale * 100 div (9 + current())}" r="1.5" fill="indigo"
                    fill-opacity=".5"/>
                <!-- quadratic -->
                <circle cx="{$xPos}" cy="-{$yScale * 10 div (math:pow(2, current() - 1))}" r="1.5"
                    fill="blue" fill-opacity=".5"/>
                <!-- linear -->
                <circle cx="{$xPos}" cy="-{($yScale * (10 - ((current() - 1) div 10)))}" r="1.5"
                    fill="coral" fill-opacity="0.5"/>
                <!-- parabolic -->
                <circle cx="{$xPos}" cy="{($yScale div 1000) * -1 * math:pow((101 - current()), 2)}"
                    r="1.5" fill="darkorchid" fill-opacity="0.5"/>
                <circle cx="{$xPos}"
                    cy="{($yScale * -10) - ($yScale div -1000) * math:pow(current(), 2 )}" r="1.5"
                    fill="brown" fill-opacity="0.5"/>
                <!-- normal -->
                <!--
                    for $i in (-3 to 3) return 
                    100 * math:exp(-0.5 * (math:pow(($i - $mean) div $stddev, 2)))
                    div
                    math:sqrt(2 * math:pi())
                -->
            </xsl:for-each>
            <!-- data polylines -->
            <polyline
                points="{for $i in (1 to 100) return string-join(($i * $xScale, $yScale * -10 div $i), ',')}"
                stroke="black" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 100) return string-join(($i * $xScale, $yScale * -20 div (1 + $i)), ',')}"
                stroke="red" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 100) return string-join(($i * $xScale, $yScale * -30 div (2 + $i)), ',')}"
                stroke="green" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 100) return string-join(($i * $xScale, $yScale * -100 div (9 + $i)), ',')}"
                stroke="indigo" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 100) return string-join(($i * $xScale, $yScale * (-10 div math:pow(2, $i - 1))), ',')}"
                stroke="blue" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 100) return string-join(($i * $xScale, $yScale * (-10 + (($i - 1) div 10))), ',')}"
                stroke="coral" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 100) return string-join(($i * $xScale, ($yScale div -1000) * math:pow(101 - $i, 2)), ',')}"
                stroke="darkorchid" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 100) return string-join(($i * $xScale, 
                ($yScale * -10) - (($yScale div -1000) * math:pow($i, 2))
                ), ',')}"
                stroke="brown" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <xsl:for-each select="5, 10, 15, 20, 25, 30">
                <polyline
                    points="{
                for $i in (1 to 100) return string-join(
                ($i * $xScale,
                -1 * $yScale * djb:gaussian($i - 1, 10, 0, current())),','
                )
                }"
                    stroke="darkgoldenrod" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            </xsl:for-each>
            <!-- Chart labels -->
            <text x="{$xScale * 50}" y="20" text-anchor="middle" font-size="10">Distance from window
                focus point</text>
            <text x="-15" y="-{$yScale * 5}" text-anchor="middle" font-size="10" writing-mode="tb"
                >Weight</text>
            <!-- Legend -->
            <rect x="1015" y="-110" height="112" width="178" stroke="black" stroke-width="0.5"
                fill="ghostwhite"/>
            <text x="1020" y="-100" font-size="8">
                <tspan>Black: 1 / (d + 1)</tspan>
                <tspan x="1020" dy="12" fill="red">Red: 2 / (d + 2)</tspan>
                <tspan x="1020" dy="12" fill="green">Green: 3 / (d + 3)</tspan>
                <tspan x="1020" dy="12" fill="indigo">Indigo: 10 / (d + 9)</tspan>
                <tspan x="1020" dy="12" fill="blue">Blue: 1 / (2 ^ d)</tspan>
                <tspan x="1020" dy="12" fill="darkgoldenrod">Gold: Gaussian (σ=5, 10, 15, 20,
                    25, 30)</tspan>
                <tspan x="1020" dy="12" fill="coral">Coral: (100 - d) / 100 (negative
                    values)</tspan>
                <tspan x="1020" dy="12" fill="darkviolet">Dark violet: ((100 - d) ^ 2) / 100 (rises
                    after 100)</tspan>
                <tspan x="1020" dy="12" fill="brown">Brown: 100 - (((100 - d) ^ 2) / 100) (negative
                    values)</tspan>
            </text>
        </svg>
    </xsl:template>
</xsl:stylesheet>

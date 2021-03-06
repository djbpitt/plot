<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="xScale" as="xs:integer" select="10"/>
    <xsl:variable name="yScale" as="xs:integer" select="25"/>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-25 -300 600 550">
            <!-- horizontal ruling and Y labels -->
            <xsl:for-each select="0 to 10">
                <xsl:variable name="yPos" as="xs:integer" select="current() * $yScale"/>
                <line x1="{$xScale}" y1="-{$yPos}" x2="{50 * $xScale}" y2="-{$yPos}"
                    stroke="lightgray" stroke-width="0.5" stroke-linecap="square"/>
                <text x="{$xScale div 2}" y="-{$yPos}" fill="black" text-anchor="end" alignment-baseline="central" font-size="6">
                    <xsl:value-of select="(current() div 10) ! format-number(., '0.0')"/>
                </text>
            </xsl:for-each>
            <!-- vertical ruling and X labels -->
            <xsl:for-each select="1 to 50">
                <xsl:variable name="xPos" as="xs:integer" select="current() * $xScale"/>
                <line x1="{$xPos}" y1="0" x2="{$xPos}" y2="-{$yScale * 10}" stroke="lightgray"
                    stroke-width="0.5" stroke-linecap="square"/>
                <text x="{$xPos}" y="8" text-anchor="middle" font-size="6">
                    <xsl:value-of select="current() - 1"/>
                </text>
            </xsl:for-each>
            <!-- data points-->
            <xsl:for-each select="1 to 50">
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
                <circle cx="{$xPos}" cy="-{($yScale * (10 - ((current() - 1) div 5)))}" r="1.5"
                    fill="coral" fill-opacity="0.5"/>
                <!-- parabolic -->
                <circle cx="{$xPos}" cy="{$yScale * -10 * math:pow(((51 - current()) div 50),2)}"
                    r="1.5" fill="darkorchid" fill-opacity="0.5"/>
                <circle cx="{$xPos}" cy="{(1 - math:pow(current() div 50, 2)) * $yScale * -10}"
                    r="1.5" fill="brown" fill-opacity="0.5"/>
                <!-- gaussian -->
                <circle cx="{$xPos}" cy="-{$yScale * djb:gaussian(current() - 1, 10, 0, 5)}" r="1.5"
                    fill="darkgoldenrod" fill-opacity="0.5"/>
                <circle cx="{$xPos}" cy="-{$yScale * djb:gaussian(current() - 1, 10, 0, 10)}"
                    r="1.5" fill="darkgoldenrod" fill-opacity="0.5"/>
                <circle cx="{$xPos}" cy="-{$yScale * djb:gaussian(current() - 1, 10, 0, 15)}"
                    r="1.5" fill="darkgoldenrod" fill-opacity="0.5"/>
            </xsl:for-each>
            <!-- data polylines -->
            <polyline
                points="{for $i in (1 to 50) return string-join(($i * $xScale, $yScale * -10 div $i), ',')}"
                stroke="black" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 50) return string-join(($i * $xScale, $yScale * -20 div (1 + $i)), ',')}"
                stroke="red" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 50) return string-join(($i * $xScale, $yScale * -30 div (2 + $i)), ',')}"
                stroke="green" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 50) return string-join(($i * $xScale, $yScale * -100 div (9 + $i)), ',')}"
                stroke="indigo" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 50) return string-join(($i * $xScale, $yScale * (-10 div math:pow(2, $i - 1))), ',')}"
                stroke="blue" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 49) return string-join(($i * $xScale, $yScale * (-10 + (($i - 1) div 5))), ',')}"
                stroke="coral" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 50) return string-join(($i * $xScale, $yScale * -10 * math:pow(((51 - $i) div 50),2)), ',')}"
                stroke="darkorchid" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 50) return string-join(($i * $xScale, 
                (1 - math:pow($i div 50, 2)) * $yScale * -10
                ), ',')}"
                stroke="brown" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <xsl:for-each select="5, 10, 15">
                <polyline
                    points="{
                for $i in (1 to 50) return string-join(
                ($i * $xScale,
                -1 * $yScale * djb:gaussian($i - 1, 10, 0, current())),','
                )
                }"
                    stroke="darkgoldenrod" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            </xsl:for-each>
            <!-- Chart labels -->
            <text x="{$xScale * 25}" y="25" text-anchor="middle" font-size="12">Distance from window
                focus point</text>
            <text x="-15" y="-{$yScale * 5}" text-anchor="middle" font-size="12" writing-mode="tb">Weight</text>
            <text x="{$xScale * 25}" y="-{$yScale * 11}" text-anchor="middle" font-size="16">Sample
                scaling functions</text>
            <!-- Legend -->
            <g transform="translate({$xScale * 25 - 160}, 50)">
                <rect x="0" y="-5" height="133" width="320" stroke="black" stroke-width="0.5"
                    fill="ghostwhite"/>
                <xsl:for-each
                    select="'black', 'red', 'green', 'indigo', 'blue', 'darkgoldenrod', 'coral', 'darkviolet', 'brown'">
                    <rect x="5" y="{(position() - 1) * 14}" width="10" height="10"
                        fill="{current()}"/>
                </xsl:for-each>
                <text x="20" y="10" font-size="12">
                    <tspan>Harmonic: 1/(d + 1); 1/1, 1/2, 1/3, 1/4, …</tspan>
                    <tspan x="30" dy="14" fill="red">2/(d + 2); 2/2, 2/3, 2/4, 2/5, …</tspan>
                    <tspan x="30" dy="14" fill="green">3/(d + 3); 3/3, 3/4, 3/5, 3/6, …</tspan>
                    <tspan x="30" dy="14" fill="indigo">10/(d + 10); 10/10, 10/11, 10/12, 10/13,
                        …</tspan>
                    <tspan x="20" dy="14" fill="blue">Exponential: 2<tspan font-size="8" dy="-4">-d</tspan><tspan dy="4">; 1/1, 1/2, 1/4, 1/8, …</tspan></tspan>
                    <tspan x="20" dy="14" fill="darkgoldenrod">Gaussian (σ = 5, 10, 15)</tspan>
                    <tspan x="20" dy="14" fill="coral">Triangular: (N - d)/N; 50/50, 49/50, 48/50,
                        47/50, …</tspan>
                    <tspan x="20" dy="14" fill="darkviolet">Parabolic: ((N - d)/N)<tspan dy="-4" font-size="8">2</tspan><tspan dy="4">&#xa0;</tspan></tspan>
                    <tspan x="20" dy="14" fill="brown">Parabolic: 1 - (d/N)<tspan dy="-4" font-size="8">2</tspan></tspan>
                </text>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

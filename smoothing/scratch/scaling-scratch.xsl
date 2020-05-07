<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="xScale" as="xs:integer" select="10"/>
    <xsl:variable name="yScale" as="xs:integer" select="25"/>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-10 -130 1100 260">
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
                    <xsl:value-of select="current()"/>
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
                <circle cx="{$xPos}" cy="-{$yScale * 10 div (math:pow(2, current() - 1))}" r="1.5"
                    fill="blue" fill-opacity=".5"/>
                <circle cx="{$xPos}" cy="-{($yScale * (10 - ((current() - 1) div 10)))}" r="1.5"
                    fill="orange" fill-opacity="0.5"/>
                <circle cx="{$xPos}" cy="{($yScale div 1000) * -1 * math:pow((101 - current()), 2)}" r="1.5" fill="fuchsia"
                    fill-opacity="0.5"/>
            </xsl:for-each>
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
                points="{for $i in (1 to 100) return string-join(($i * $xScale, $yScale * (-10 div math:pow(2, $i - 1))), ',')}"
                stroke="blue" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <polyline
                points="{for $i in (1 to 100) return string-join(($i * $xScale, $yScale * (-10 + (($i - 1) div 10))), ',')}"
                stroke="orange" stroke-width="1" stroke-opacity="0.5" fill="none"/>
            <!--<polyline points=""/>-->
        </svg>
    </xsl:template>
    <!--
1/1 = 1.00
1/2 = 0.50
1/3 = 0.33
1/4 = 0.25
1/5 = 0.20

2/2 = 1.00
2/3 = 0.66
2/4 = 0.50
2/5 = 0.40
2/6 = 0.33
-->

</xsl:stylesheet>

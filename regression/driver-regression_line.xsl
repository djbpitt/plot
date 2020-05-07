<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>
    <!-- ================================================================= -->
    <!-- Sample regression line plotting (with fake data)                  -->
    <!--                                                                   -->
    <!-- Plot in upper right quadrant                                      -->
    <!--   Input is sequence of points with montonic X values              -->
    <!--   All Y values have been negated                                  -->
    <!--   Use @viewBox to pull into viewport                              -->
    <!-- ================================================================= -->
    <xsl:variable name="points" as="xs:string+"
        select="
            '50,-182',
            '100,-166',
            '150,-87',
            '200,-191',
            '250,-106',
            '300,-73',
            '350,-60',
            '400,-186',
            '450,-118'"/>
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="result" as="item()+" select="djb:regression_line($points)"/>
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="30 -230 460 270">
            <style>
                <![CDATA[
                .regression {
                    stroke: red;
                    stroke-width: 1;
                }]]>
            </style>
            <xsl:for-each select="1 to 9">
                <!-- vertical ruling lines and X labels -->
                <xsl:variable name="xPos" as="xs:integer" select="position() * 50"/>
                <line x1="{$xPos}" y1="0" x2="{$xPos}" y2="-200" stroke="lightgray"
                    stroke-width="0.5" stroke-linecap="square"/>
                <text x="{$xPos}" y="5" font-size="4" text-anchor="middle">
                    <xsl:value-of select="$xPos"/>
                </text>
            </xsl:for-each>
            <xsl:for-each select="0 to 20">
                <!-- horizontal ruling lines and Y labels -->
                <xsl:variable name="yPos" as="xs:integer" select="current() * -10"/>
                <line x1="50" y1="{$yPos}" x2="450" y2="{$yPos}" stroke="lightgray"
                    stroke-width="0.5" stroke-linecap="square"/>
                <text x="47" y="{$yPos}" text-anchor="end" alignment-baseline="central"
                    font-size="4">
                    <xsl:value-of select="-1 * $yPos"/>
                </text>
            </xsl:for-each>
            <text x="250" y="12" font-size="6" text-anchor="middle">Fake independent variable</text>
            <text x="35" y="-100" text-anchor="middle" writing-mode="tb" font-size="6">Fake
                dependent variable</text>
            <text x="250" y="-215" text-anchor="middle" font-size="8">Sample regression line</text>
            <g>
                <polyline points="{$points}" stroke="black" stroke-width="1" fill="none"/>
                <xsl:for-each select="$points">
                    <circle cx="{substring-before(current(), ',')}"
                        cy="{substring-after(current(), ',')}" r="2" fill="black"/>
                </xsl:for-each>
                <xsl:sequence select="$result"/>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

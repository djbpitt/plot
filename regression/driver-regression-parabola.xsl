<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="#all" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="debug" as="xs:boolean" select="false()"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>
    <!-- ================================================================= -->
    <!-- Sample regression parabola plotting (with fake data)              -->
    <!--                                                                   -->
    <!-- Plot in upper right quadrant                                      -->
    <!--   Input is sequence of points with montonic X values              -->
    <!--   All Y values have been negated                                  -->
    <!--   Use @viewBox to pull into viewport                              -->
    <!-- ================================================================= -->
    <xsl:variable name="xScale" as="xs:integer" select="10"/>
    <xsl:variable name="yScale" as="xs:integer" select="1"/>
    <xsl:variable name="maxX" as="xs:integer" select="50"/>
    <xsl:variable name="maxY" as="xs:integer" select="200"/>
    <xsl:variable name="points" as="xs:string+"
        select="
            '0, -14',
            '5,-8',
            '10,-24',
            '15,-38',
            '20,-40',
            '25,-52',
            '30,-60',
            '35,-64',
            '40,-120',
            '45, -178',
            '50, -160'
            "/>
    <xsl:variable name="allX" as="xs:double+" select="$points ! substring-before(., ',') ! number()"/>
    <xsl:variable name="allY" as="xs:double+" select="$points ! substring-after(., ',') ! number()"/>
    <xsl:variable name="scaled-points" as="xs:string+"
        select="
            for-each-pair($allX, $allY, function ($a, $b) {
                string-join(($a * $xScale, $b), ',')
            })"/>
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="linear-parameters" as="map(*)"
            select="djb:compute-regression-parameters($scaled-points)"/>
        <xsl:variable name="a" as="xs:double" select="$linear-parameters('a')"/>
        <xsl:variable name="b" as="xs:double" select="$linear-parameters('b')"/>
        <xsl:variable name="c" as="xs:double" select="$linear-parameters('c')"/>
        <xsl:variable name="parabola" as="element(svg:g)"
            select="djb:plot-parabolic-segment(0, 500, $a, $b, $c)"/>
        <xsl:if test="$debug">
            <xsl:message select="'x1: ', 10"/>
            <xsl:message select="'a: ', $a, '; b: ', $b, '; c: ', $c"/>
        </xsl:if>
        <xsl:variable name="regression-line" as="item()*"
            select="djb:regression-line($scaled-points, true())"/>

        <svg xmlns="http://www.w3.org/2000/svg"
            viewBox="-30 -{$maxY + 10} {($maxX * $xScale) + 40} {$maxY + 20}">
            <defs>
                <clipPath id="clip">
                    <rect x="0" y="-{$maxY}" width="{$maxX * $xScale}" height="{$maxY}"/>
                </clipPath>
            </defs>
            <style type="text/css">
                <![CDATA[
                .parabolic-regression,
                .regression {
                    stroke-width: 1;
                    stroke-opacity: 0.5;
                    stroke-linecap: round;
                }
                #parabola {
                    stroke: blue;
                }
                #line {
                    stroke: red;
                }]]>
            </style>
            <xsl:for-each select="0 to $maxX">
                <!-- vertical ruling lines and X labels -->
                <xsl:variable name="xPos" as="xs:double" select="current() * $xScale"/>
                <xsl:if test="current() mod 5 eq 0">
                    <line x1="{$xPos}" y1="0" x2="{$xPos}" y2="-{$maxY}" stroke="lightgray"
                        stroke-width="0.5" stroke-linecap="square"/>
                    <text x="{$xPos}" y="5" font-size="4" text-anchor="middle">
                    <xsl:value-of select="current()"/>
                    </text>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="0 to $maxY">
                <!-- horizontal ruling lines and Y labels -->
                <xsl:variable name="yPos" as="xs:integer" select="current() * $yScale"/>
                <xsl:if test="$yPos mod 10 eq 0">
                    <line x1="0" y1="-{$yPos}" x2="{$maxX * $xScale}" y2="-{$yPos}"
                        stroke="lightgray" stroke-width="0.5" stroke-linecap="square"/>
                    <text x="-2" y="-{$yPos}" text-anchor="end" alignment-baseline="central" font-size="4">
                    <xsl:value-of select="$yPos"/>
                </text>
                </xsl:if>
            </xsl:for-each>
            <text x="{$maxX * $xScale div 2}" y="12" font-size="6" text-anchor="middle">Fake independent variable</text>
            <text x="-15" y="-{$maxY div 2}" text-anchor="middle" writing-mode="tb" font-size="6">Fake
                dependent variable</text>
            <text x="{$maxX * $xScale div 2}" y="-210" text-anchor="middle" font-size="8">Sample regression <tspan fill="blue">parabola</tspan> and <tspan fill="red">line</tspan></text>
            <g>
                <xsl:for-each select="$points">
                    <circle cx="{substring-before(current(), ',') ! number() * $xScale}"
                        cy="{substring-after(current(), ',')}" r="2" fill="black"/>
                </xsl:for-each>
                <g id="parabola" clip-path="url(#clip)">
                    <xsl:sequence select="$parabola"/>
                </g>
                <g id="line" clip-path="url(#clip)">
                    <xsl:sequence select="$regression-line[1]"/>
                </g>
                <xsl:message select="$regression-line[2]"/>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="#all" version="3.0">
    <xsl:output method="xml" indent="yes"/>
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
    <xsl:variable name="points" as="xs:string+"
        select="
            '1, -1',
            '2, -4',
            '3, -9',
            '4, -16',
            '5, -25',
            '6, -36',
            '7, -49',
            '8, -64',
            '9, -81',
            '10, -100'
            "/>
    <xsl:variable name="allX" as="xs:double+" select="$points ! substring-before(., ',') ! number()"/>
    <xsl:variable name="allY" as="xs:double+" select="$points ! substring-after(., ',') ! number()"/>
    <xsl:variable name="scaled-points" as="xs:string+"
        select="
            for-each-pair($allX, $allY, function ($a, $b) {
                string-join(($a * $xScale, $b), ',')
            })"/>
    <xsl:template name="xsl:initial-template">

        <xsl:variable name="linear-parameters1" as="map(*)"
            select="djb:compute-regression-parameters($scaled-points)"/>
        <xsl:variable name="a1" as="xs:double" select="$linear-parameters1('a')"/>
        <xsl:variable name="b1" as="xs:double" select="$linear-parameters1('b')"/>
        <xsl:variable name="c1" as="xs:double" select="$linear-parameters1('c')"/>
        <xsl:variable name="parabola1" as="element(svg:g)"
            select="djb:plot-parabolic-segment(10, 100, $a1, $b1, $c1)"/>
        <xsl:message select="'x1: ', 10"/>
        <xsl:message select="'a: ', $a1, '; b: ', $b1, '; c: ', $c1"/>

        <xsl:variable name="linear-parameters2" as="map(*)"
            select="djb:compute-regression-parameters($scaled-points[position() gt 1])"/>
        <xsl:variable name="a2" as="xs:double" select="$linear-parameters2('a')"/>
        <xsl:variable name="b2" as="xs:double" select="$linear-parameters2('b')"/>
        <xsl:variable name="c2" as="xs:double" select="$linear-parameters2('c')"/>
        <xsl:variable name="parabola2" as="element(svg:g)"
            select="djb:plot-parabolic-segment(20, 100, $a2, $b2, $c2)"/>
        <xsl:message select="'x1: ', 20"/>
        <xsl:message select="'a: ', $a2, '; b: ', $b2, '; c: ', $c2"/>
        
        <xsl:variable name="linear-parameters3" as="map(*)"
            select="djb:compute-regression-parameters($scaled-points[position() gt 2])"/>
        <xsl:variable name="a3" as="xs:double" select="$linear-parameters3('a')"/>
        <xsl:variable name="b3" as="xs:double" select="$linear-parameters3('b')"/>
        <xsl:variable name="c3" as="xs:double" select="$linear-parameters3('c')"/>
        <xsl:variable name="parabola3" as="element(svg:g)"
            select="djb:plot-parabolic-segment(30, 100, $a3, $b3, $c3)"/>
        <xsl:message select="'x1: ', 30"/>
        <xsl:message select="'a: ', $a3, '; b: ', $b3, '; c: ', $c3"/>
        

        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-10 -110 120 120">
            <style type="text/css">
                <![CDATA[
                .parabolic-regression {
                    stroke-width: 1;
                    stroke-opacity: 0.5;
                }
                #parabola1 {
                    stroke: red;
                }
                #parabola2 {
                    stroke: blue;
                }
                #parabola3 {
                    stroke: green;
                }]]>
            </style>
            <xsl:for-each select="0 to 10">
                <!-- vertical ruling lines and X labels -->
                <xsl:variable name="xPos" as="xs:integer" select="(position() - 1) * $xScale"/>
                <line x1="{$xPos}" y1="0" x2="{$xPos}" y2="-100" stroke="lightgray"
                    stroke-width="0.5" stroke-linecap="square"/>
                <text x="{$xPos}" y="5" font-size="4" text-anchor="middle">
                    <xsl:value-of select="$xPos"/>
                </text>
            </xsl:for-each>
            <xsl:for-each select="0 to 10">
                <!-- horizontal ruling lines and Y labels -->
                <xsl:variable name="yPos" as="xs:integer" select="current() * -10"/>
                <line x1="0" y1="{$yPos}" x2="100" y2="{$yPos}" stroke="lightgray"
                    stroke-width="0.5" stroke-linecap="square"/>
                <text x="-2" y="{$yPos}" text-anchor="end" alignment-baseline="central" font-size="4">
                    <xsl:value-of select="-1 * $yPos"/>
                </text>
            </xsl:for-each>
            <!--<text x="250" y="12" font-size="6" text-anchor="middle">Fake independent variable</text>-->
            <!--<text x="35" y="-100" text-anchor="middle" writing-mode="tb" font-size="6">Fake
                dependent variable</text>-->
            <!--<text x="250" y="-215" text-anchor="middle" font-size="8">Sample regression line</text>-->
            <g>
                <xsl:for-each select="$points">
                    <circle cx="{substring-before(current(), ',') ! number() * $xScale}"
                        cy="{substring-after(current(), ',')}" r="0.5" fill="black"/>
                </xsl:for-each>
                <g id="parabola1">
                    <xsl:sequence select="$parabola1"/>
                </g>
                <g id="parabola2">
                    <xsl:sequence select="$parabola2"/>
                </g>
                <g id="parabola3">
                    <xsl:sequence select="$parabola3"/>
                </g>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

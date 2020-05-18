<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:f="http://www.obdurodon.org/function-variables"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- packages -->
    <xsl:use-package name="http://www.obdurodon.org/smoothing"/>
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>

    <!-- ================================================================ -->
    <!-- Test input data                                                  -->
    <!-- ================================================================ -->
    <!-- 20 points                                                        -->
    <!-- Y values have been negated; real data may have both + and - Y    -->
    <xsl:variable name="points" as="xs:string+"
        select="
            '1,-145',
            '2,-14',
            '3,-61',
            '4,-135',
            '5,-16',
            '6,-15',
            '7,-24',
            '8,-149',
            '9,-36',
            '10,-74',
            '11,-29',
            '12,-183',
            '13,-107',
            '14,-189',
            '15,-153',
            '16,-190',
            '17,-169',
            '18,-79',
            '19,-20',
            '20,-143'
            "/>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!--                                                                  -->
    <!-- $xSpacing as xs:integer : spread out X values                    -->
    <!-- $n as xs:integer : number of points                              -->
    <!-- $allX as xs:double+ : all X values                               -->
    <!-- $allY as xs:double+ : all Y values                               -->
    <!-- $stretchedPoints as xs:string+ : spread points along X axis      -->
    <!-- ================================================================ -->
    <xsl:variable name="xSpacing" as="xs:integer" select="25"/>
    <xsl:variable name="n" as="xs:integer" select="count($points)"/>
    <xsl:variable name="allX" as="xs:double+" select="$points ! substring-before(., ',') ! number()"/>
    <xsl:variable name="allY" as="xs:double+" select="$points ! substring-after(., ',') ! number()"/>
    <xsl:variable name="stretchedPoints" as="xs:string+"
        select="
            for $i in 1 to count($points)
            return
                $allX[$i] * $xSpacing || ',' || $allY[$i]"/>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Initial template                                                 -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg"
            viewBox="0 -210 {(count($points) + 1) * $xSpacing} 300">
            <style type="text/css">
                <![CDATA[
                .regression {
                    stroke: red;
                    stroke-width: 0.5;
                }]]></style>
            <g>
                <!-- horizontal ruling lines and Y labels -->
                <xsl:for-each select="0 to 20">
                    <line x1="{1 * $xSpacing}" y1="-{current() * 10}"
                        x2="{count($points) * $xSpacing}" y2="-{current() * 10}" stroke="lightgray"
                        stroke-width=".5" stroke-linecap="square"/>
                    <text x="{0.9 * $xSpacing}" y="-{current() * 10}" text-anchor="end"
                        font-size="6" alignment-baseline="central">
                        <xsl:value-of select="current() * 10"/>
                    </text>
                </xsl:for-each>
                <!-- vertical ruling lines and X labels -->
                <xsl:for-each select="1 to count($points)">
                    <xsl:variable name="xPos" as="xs:integer" select="current() * $xSpacing"/>
                    <line x1="{$xPos}" y1="0" x2="{$xPos}" y2="-200" stroke="lightgray"
                        stroke-width=".5" stroke-linecap="square"/>
                    <text x="{$xPos}" y="8" font-size="6" text-anchor="middle">
                        <xsl:value-of select="$points[current()] ! translate(., '-', '')"/>
                    </text>
                </xsl:for-each>
                <polyline points="{$stretchedPoints}" stroke="black" stroke-width="1" fill="none"/>
                <!-- default window is 3 -->
                <polyline points="{djb:smoothing($stretchedPoints)}" stroke="orange"
                    stroke-width=".5" fill="none"/>
                <xsl:for-each select="$stretchedPoints">
                    <circle cx="{substring-before(current(), ',')}" cy="{substring-after(., ',')}"
                        r="2" fill="black"/>
                </xsl:for-each>
                <polyline points="{djb:smoothing($stretchedPoints, 5)}" stroke="blue"
                    stroke-width=".5" fill="none"/>
                <polyline points="{djb:smoothing($stretchedPoints, 7)}" stroke="green"
                    stroke-width=".5" fill="none"/>
                <polyline points="{djb:smoothing($stretchedPoints, 9)}" stroke="fuchsia"
                    stroke-width=".5" fill="none"/>
                <xsl:sequence select="djb:regression-line($stretchedPoints)"/>
                <text x="{count($points) * $xSpacing div 2}" y="25" text-anchor="middle"
                    font-size="8">black = actual, <tspan fill="orange">orange = 3</tspan>, <tspan
                        fill="blue">blue = 5</tspan>, <tspan fill="green">green = 7</tspan>, <tspan
                        fill="fuchsia">fuchsia = 9</tspan>, <tspan fill="red">red =
                        regression</tspan></text>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

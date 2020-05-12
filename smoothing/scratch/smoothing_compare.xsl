<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:use-package name="http://www.obdurodon.org/plot_lib"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>
    <xsl:use-package name="http://www.obdurodon.org/smoothing"/>
    <xsl:use-package name="http://www.obdurodon.org/spline"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="allY" as="xs:double+" select="djb:random-sequence(100)"/>
    <xsl:variable name="points" as="xs:string+"
        select="
            for-each-pair((1 to 100), $allY, function ($a, $b) {
                string-join(($a * 2, ($b * -100) + 2), ',')
            })"/>
    <xsl:variable name="regression" as="item()+" select="djb:regression_line($points, true())"/>
    <xsl:variable name="m" as="xs:double" select="$regression[2]?m"/>
    <xsl:variable name="b" as="xs:double" select="$regression[2]?b"/>
    <xsl:variable name="window" as="xs:integer" select="15"/>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-12 -115 210 195">
            <style type="text/css">
                .regression {
                    stroke: red;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                }
                .spline {
                    stroke: blue;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                    fill: none;
                }</style>
            <g>
                <!-- X axis and line at 100%, with Y labels -->
                <line x1="2" y1="0" x2="200" y2="0" stroke="lightgray" stroke-width="0.5"
                    stroke-linecap="square"/>
                <text x="0" y="0" fill="lightgray" font-size="3" text-anchor="end"
                    alignment-baseline="central">0.0</text>
                <line x1="2" y1="-100" x2="200" y2="-100" stroke="lightgray" stroke-width="0.5"
                    stroke-linecap="square"/>
                <text x="0" y="-100" fill="lightgray" font-size="3" text-anchor="end"
                    alignment-baseline="central">100.0</text>
                <text x="0" y="{$b}" fill="lightgray" font-size="3" text-anchor="end"
                    alignment-baseline="central">
                    <xsl:value-of select="(-1 * number($b)) => format-number('0.0')"/>
                </text>
                <text x="208" y="-100" font-size="3" fill="lightgray" text-anchor="end"
                    alignment-baseline="central">100.0</text>
                <text x="208" y="0" font-size="3" fill="lightgray" text-anchor="end"
                    alignment-baseline="central">0.0</text>
                <text x="208" y="{$m * 200 + $b}" fill="red" fill-opacity="0.5" font-size="3"
                    text-anchor="end" alignment-baseline="central">
                    <xsl:value-of select="format-number(-1 * ($m * 200 + $b), '0.0')"/>
                </text>
                <!-- Y axis (both sides) -->
                <line x1="2" y1="-100" x2="2" y2="0" stroke="lightgray" stroke-width="0.5"
                    stroke-linecap="square"/>
                <line x1="200" y1="-100" x2="200" y2="0" stroke="lightgray" stroke-width="0.5"
                    stroke-linecap="square"/>
                <!-- horizontal line at regression intercept -->
                <line x1="2" y1="{$b}" x2="200" y2="{$b}" stroke="lightgray" stroke-width="0.5"/>
                <!-- data points and polyline -->
                <xsl:for-each select="$points">
                    <circle cx="{substring-before(current(), ',')}" cy="{substring-after(.,',')}"
                        r="0.65" fill="black"/>
                </xsl:for-each>
                <polyline points="{$points}" stroke="black" stroke-width="0.5" fill="none"/>
                <xsl:sequence select="$regression[1]"/>
                <xsl:sequence select="djb:smoothing($points, $window) => djb:spline(0.4)"/>
                <!-- graph labels -->
                <text x="100" y="8" text-anchor="middle" font-size="5">Fake independent
                    variable</text>
                <text x="-10" y="-50" text-anchor="middle" font-size="5" writing-mode="tb">Fake
                    dependent variable</text>
                <text x="100" y="-106" text-anchor="middle" font-size="8">
                    <xsl:value-of
                        select="
                            'Smoothing examples (window
                    = ' || $window || ')'"
                    />
                </text>
            </g>
            <g transform="translate(50, 15)">
                <rect x="0" y="0" width="100" height="51" fill="ghostwhite" stroke="black"
                    stroke-width="0.5"/>
                <!-- 'black', 'red', 'blue', 'green', 'indigo', 'darkgoldenrod', 'coral', 'darkviolet', 'brown -->
                <xsl:for-each
                    select="'black', 'red', 'gray', 'blue', 'green', 'indigo', 'darkgoldenrod'">
                    <rect x="2" y="{-5 + position() * 7}" width="5" height="5" fill="{current()}"/>
                </xsl:for-each>
                <text x="10" y="6" fill="black" font-size="5">
                    <tspan>Actual data</tspan>
                    <tspan x="10" dy="7" fill="red">
                        <xsl:value-of
                            select="'Regression line (' || format-number(-1 * $b, '0.0') || '–' || format-number(-1 * ($m * 200 + $b), '0.0') || ')'"
                        />
                    </tspan>
                    <tspan x="10" dy="7" fill="gray">
                        <xsl:value-of
                            select="'Y intercept of regression line (' || format-number(-1 * $b, '0.0') || ')'"
                        />
                    </tspan>
                    <tspan x="10" dy="7" fill="blue">Rectangular kernal</tspan>
                </text>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

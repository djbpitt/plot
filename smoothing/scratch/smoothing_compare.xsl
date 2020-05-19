<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- ================================================================ -->
    <!-- Packages                                                         -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>
    <xsl:use-package name="http://www.obdurodon.org/smoothing"/>
    <xsl:use-package name="http://www.obdurodon.org/spline"/>

    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!-- ================================================================ -->
    <!-- Data                                                             -->
    <!-- ================================================================ -->
    <xsl:variable name="allY" as="xs:double+" select="djb:random-sequence(100)"/>
    <xsl:variable name="xScale" as="xs:integer" select="2"/>
    <xsl:variable name="points" as="xs:string+"
        select="
            for-each-pair((1 to 100), $allY, function ($a, $b) {
                string-join(($a * $xScale, ($b * -100) + 2), ',')
            })"/>

    <!-- ================================================================ -->
    <!-- Regression line                                                  -->
    <!-- ================================================================ -->
    <xsl:variable name="regression" as="item()+" select="djb:regression-line($points, true())"/>
    <xsl:variable name="m" as="xs:double" select="$regression[2]?m"/>
    <xsl:variable name="b" as="xs:double" select="$regression[2]?b"/>

    <!-- ================================================================ -->
    <!-- Smoothing parameters                                             -->
    <!-- ================================================================ -->
    <xsl:variable name="window" as="xs:integer" select="25"/>

    <!-- ================================================================ -->
    <!-- Gaussian values                                                  -->
    <!-- ================================================================ -->
    <xsl:variable name="stddev" as="xs:double" select="5"/>
    <xsl:variable name="gaussian-weights" as="xs:double+"
        select="djb:get-weights-scale('gaussian', $window, $stddev)"/>
    <xsl:variable name="gaussian-Ys" as="xs:double+">
        <xsl:for-each select="1 to count($points)">
            <xsl:sequence
                select="djb:weighted-average(current(), $window, $allY, $gaussian-weights)"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="gaussian-points" as="xs:string+"
        select="
            for $x in (1 to count($gaussian-Ys))
            return
                string-join(($x * $xScale, -100 * $gaussian-Ys[$x]), ',')"/>

    <!-- ================================================================ -->
    <!-- Exponential values                                               -->
    <!-- ================================================================ -->
    <xsl:variable name="exponential-weights" as="xs:double+"
        select="djb:get-weights-scale('exponential', $window)"/>
    <xsl:variable name="exponential-Ys" as="xs:double+">
        <xsl:for-each select="1 to count($points)">
            <xsl:sequence
                select="djb:weighted-average(current(), $window, $allY, $exponential-weights)"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="exponential-points" as="xs:string+"
        select="
            for $x in (1 to count($exponential-Ys))
            return
                string-join(($x * $xScale, -100 * $exponential-Ys[$x]), ',')"/>

    <!-- ================================================================ -->
    <!-- Parabolic values                                                 -->
    <!-- ================================================================ -->
    <xsl:variable name="parabolic-weights" as="xs:double+"
        select="djb:get-weights-scale('parabolic-down', $window)"/>
    <xsl:variable name="parabolic-Ys" as="xs:double+">
        <xsl:for-each select="1 to count($points)">
            <xsl:sequence
                select="djb:weighted-average(current(), $window, $allY, $parabolic-weights)"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="parabolic-points" as="xs:string+"
        select="
            for $x in (1 to count($parabolic-Ys))
            return
                string-join(($x * $xScale, -100 * $parabolic-Ys[$x]), ',')
            "/>

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-12 -115 210 195">
            <style type="text/css">
                #linear {
                    stroke: blue;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                    fill: none;
                }
                #gaussian {
                    stroke: green;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                    fill: none;
                }
                #exponential {
                    stroke: indigo;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                    fill: none;
                }
                #parabolic {
                    stroke: darkgoldenrod;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                    fill: none;
                }
                .regression {
                    stroke: red;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                }</style>
            <g>
                <!-- ==================================================== -->
                <!-- Draw X axis and line at 100%, with Y labels          -->
                <!-- ==================================================== -->
                <line x1="2" y1="0" x2="200" y2="0" stroke="lightgray" stroke-width="0.5"
                    stroke-linecap="square"/>
                <text x="0" y="0" fill="lightgray" font-size="3" text-anchor="end" alignment-baseline="central">0.0</text>
                <line x1="2" y1="-100" x2="200" y2="-100" stroke="lightgray" stroke-width="0.5"
                    stroke-linecap="square"/>
                <text x="0" y="-100" fill="lightgray" font-size="3" text-anchor="end" alignment-baseline="central">100.0</text>
                <text x="0" y="{$b}" fill="lightgray" font-size="3" text-anchor="end" alignment-baseline="central">
                    <xsl:value-of select="(-1 * number($b)) => format-number('0.0')"/>
                </text>
                <text x="208" y="-100" font-size="3" fill="lightgray" text-anchor="end" alignment-baseline="central">100.0</text>
                <text x="208" y="0" font-size="3" fill="lightgray" text-anchor="end" alignment-baseline="central">0.0</text>
                <text x="208" y="{$m * 200 + $b}" fill="red" fill-opacity="0.5" font-size="3" text-anchor="end" alignment-baseline="central">
                    <xsl:value-of select="format-number(-1 * ($m * 200 + $b), '0.0')"/>
                </text>

                <!-- ==================================================== -->
                <!-- Draw Y axis (both sides)                             -->
                <!-- ==================================================== -->
                <line x1="2" y1="-100" x2="2" y2="0" stroke="lightgray" stroke-width="0.5"
                    stroke-linecap="square"/>
                <line x1="200" y1="-100" x2="200" y2="0" stroke="lightgray" stroke-width="0.5"
                    stroke-linecap="square"/>

                <!-- ==================================================== -->
                <!-- Plot horizontal line at regression intercept         -->
                <!-- ==================================================== -->
                <line x1="2" y1="{$b}" x2="200" y2="{$b}" stroke="lightgray" stroke-width="0.5"/>

                <!-- ==================================================== -->
                <!-- Plot data points and polyline                        -->
                <!-- ==================================================== -->
                <xsl:for-each select="$points">
                    <circle cx="{substring-before(current(), ',')}" cy="{substring-after(.,',')}"
                        r="0.65" fill="black"/>
                </xsl:for-each>
                <polyline points="{$points}" stroke="black" stroke-width="0.5" fill="none"/>

                <!-- ==================================================== -->
                <!-- Plot regression line                                 -->
                <!-- ==================================================== -->
                <xsl:sequence select="$regression[1]"/>

                <!-- ==================================================== -->
                <!-- Plot rectangular smoothing spline                    -->
                <!-- ==================================================== -->
                <g id="linear">
                    <!--<polyline points="{djb:smoothing($points, $window)}"/>-->
                    <xsl:sequence select="djb:smoothing($points, $window) => djb:spline(0.4)"/>
                </g>

                <!-- ==================================================== -->
                <!-- Plot Gaussian smoothing spline                       -->
                <!-- ==================================================== -->
                <g id="gaussian">
                    <xsl:sequence select="djb:spline($gaussian-points, 0.45)"/>
                </g>

                <!-- ==================================================== -->
                <!-- Plot exponential smoothing spline                    -->
                <!-- ==================================================== -->
                <g id="exponential">
                    <xsl:sequence select="djb:spline($exponential-points, 0.45)"/>
                </g>

                <!-- ==================================================== -->
                <!-- Plot parabolic smoothing spline                      -->
                <!-- ==================================================== -->
                <g id="parabolic">
                    <xsl:sequence select="djb:spline($parabolic-points, 0.45)"/>
                </g>

                <!-- ==================================================== -->
                <!-- Label axes and graph                                 -->
                <!-- ==================================================== -->
                <text x="100" y="8" text-anchor="middle" font-size="5">Fake independent
                    variable</text>
                <text x="-10" y="-50" text-anchor="middle" font-size="5" writing-mode="tb">Fake
                    dependent variable</text>
                <text x="100" y="-106" text-anchor="middle" font-size="8">
                    <xsl:value-of select="
                            'Smoothing examples (window
                    = ' || $window || ')'"/>
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
                    <tspan>Actual data (101 points)</tspan>
                    <tspan x="10" dy="7" fill="red">
                        <xsl:value-of select="'Regression line (' || format-number(-1 * $b, '0.0') || '–' || format-number(-1 * ($m * 200 + $b), '0.0') || ')'"/>
                    </tspan>
                    <tspan x="10" dy="7" fill="gray">
                        <xsl:value-of select="'Y intercept of regression line (' || format-number(-1 * $b, '0.0') || ')'"/>
                    </tspan>
                    <tspan x="10" dy="7" fill="blue">Rectangular kernel</tspan>
                    <tspan x="10" dy="7" fill="green">Gaussian kernel (σ = 5)</tspan>
                    <tspan x="10" dy="7" fill="indigo">Exponential kernel (y = 1 - 2<tspan dy="-2" font-size="4">-d</tspan><tspan dy="2">)</tspan></tspan>
                    <tspan x="10" dy="7" fill="darkgoldenrod">Parabolic kernel (y = 1 - (d/N)<tspan dy="-2" font-size="4">2</tspan><tspan dy="2" dx="-1">)</tspan></tspan>
                </text>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

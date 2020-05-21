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
    <xsl:variable name="xScale" as="xs:integer" select="4"/>
    <!-- ================================================================ -->
    <!-- Data                                                             -->
    <!-- ================================================================ -->
    <xsl:variable name="allX" as="xs:double+" select="0 to 50"/>
    <xsl:variable name="allY" as="xs:double+" select="($allX ! math:sin(.)) ! (. * -50 - 50)"/>
    <xsl:variable name="n" as="xs:integer" select="count($allX)"/>
    <xsl:variable name="allX-tenths" as="xs:double+"
        select="djb:expand-to-tenths(($n - 1) div 2) ! (. + ($n - 1) div 2)"/>
    <xsl:variable name="allY-tenths" as="xs:double+"
        select="($allX-tenths ! math:sin(.)) => djb:recenter(0, 100)"/>
    <xsl:variable name="points-tenths" as="xs:string+"
        select="
            for-each-pair($allX-tenths, $allY-tenths, function ($a, $b) {
                string-join(($a * $xScale, $b * -1), ',')
            })"/>
    <!-- ================================================================ -->
    <!-- Random sequence of jitters, scaled by $jitter-amp                -->
    <!-- ================================================================ -->
    <xsl:variable name="jitter-amp" as="xs:double" select="5"/>
    <xsl:variable name="jitters" as="xs:double+"
        select="djb:random-sequence($n) ! (. * $jitter-amp)"/>

    <!-- ================================================================ -->
    <!-- Y values with added jitter                                       -->
    <!-- ================================================================ -->
    <xsl:variable name="allY-with-jitter" as="xs:double+"
        select="
            ((for $i in (1 to $n)
            return
                (math:sin($allX[$i]) + $jitters[position() eq $i])) => djb:recenter(0, 100)) ! (. * -1)"/>
    <xsl:variable name="points" as="xs:string+"
        select="
            for-each-pair($allX, $allY-with-jitter, function ($a, $b) {
                string-join(($a * $xScale, $b), ',')
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
                select="djb:weighted-average(current(), $window, $allY-with-jitter, $gaussian-weights)"
            />
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="gaussian-points" as="xs:string+"
        select="
            for $x in (1 to $n)
            return
                string-join((($x - 1) * $xScale, $gaussian-Ys[$x]), ',')"/>

    <!-- ================================================================ -->
    <!-- Exponential values                                               -->
    <!-- ================================================================ -->
    <xsl:variable name="exponential-weights" as="xs:double+"
        select="djb:get-weights-scale('exponential', $window)"/>
    <xsl:variable name="exponential-Ys" as="xs:double+">
        <xsl:for-each select="1 to count($points)">
            <xsl:sequence
                select="djb:weighted-average(current(), $window, $allY-with-jitter, $exponential-weights)"
            />
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="exponential-points" as="xs:string+"
        select="
            for $x in (1 to count($exponential-Ys))
            return
                string-join((($x - 1) * $xScale, $exponential-Ys[$x]), ',')"/>

    <!-- ================================================================ -->
    <!-- Parabolic values                                                 -->
    <!-- ================================================================ -->
    <xsl:variable name="parabolic-weights" as="xs:double+"
        select="djb:get-weights-scale('parabolic-down', $window)"/>
    <xsl:variable name="parabolic-Ys" as="xs:double+">
        <xsl:for-each select="1 to count($points)">
            <xsl:sequence
                select="djb:weighted-average(current(), $window, $allY-with-jitter, $parabolic-weights)"
            />
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="parabolic-points" as="xs:string+"
        select="
            for $x in (1 to count($parabolic-Ys))
            return
                string-join((($x - 1) * $xScale, $parabolic-Ys[$x]), ',')
            "/>

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-20 -115 {$n * $xScale + 30} 195">
            <script type="text/javascript"><![CDATA[
            window.addEventListener('DOMContentLoaded', init, false);
            function init() {
                var rects = document.getElementsByClassName('toggle');
                for (var i = 0; i < rects.length; i++) {
                    rects[i].addEventListener('mouseover', emphasize, false);
                    rects[i].addEventListener('mouseout', deemphasize, false);
                }
            }
            function emphasize() {
                var target = this.id.substring(0, this.id.indexOf('-'));
                document.getElementById(target).classList.add('highlight');
            }
            function deemphasize() {
                var target = this.id.substring(0, this.id.indexOf('-'));
                document.getElementById(target).classList.remove('highlight');
            }//]]></script>
            <style type="text/css">
                .spline {
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                    fill: none;
                }
                .highlight .spline {
                    stroke-width: 1.5;
                    stroke-opacity: 0.75;
                }
                #rectangular {
                    stroke: blue;
                }
                #gaussian {
                    stroke: green;
                }
                #exponential {
                    stroke: indigo;
                }
                #parabolic {
                    stroke: darkgoldenrod;
                }
                #regression {
                    stroke: red;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                }
                #regression.highlight {
                    stroke-width: 1.5;
                    stroke-opacity: 0.75;
                }
                #data.highlight > polyline {
                    stroke-width: 1.5;
                }</style>
            <g>
                <!-- ==================================================== -->
                <!-- Draw X axis and line at 100%, with Y labels          -->
                <!-- ==================================================== -->
                <rect x="0" y="-100" width="{($n - 1) * $xScale}" height="100" stroke="lightgray"
                    stroke-width="0.5" fill="none"/>
                <text x="-1" y="0" fill="lightgray" font-size="3" text-anchor="end" alignment-baseline="central">0.0</text>
                <text x="-1" y="-100" fill="lightgray" font-size="3" text-anchor="end" alignment-baseline="central">100.0</text>
                <text x="-1" y="{$b}" fill="lightgray" font-size="3" text-anchor="end" alignment-baseline="central">
                    <xsl:value-of select="(-1 * number($b)) => format-number('0.0')"/>
                </text>
                <text x="{($n - 1) * $xScale + 8}" y="-100" font-size="3" fill="lightgray" text-anchor="end" alignment-baseline="central">100.0</text>
                <text x="{($n - 1) * $xScale + 8}" y="0" font-size="3" fill="lightgray" text-anchor="end" alignment-baseline="central">0.0</text>
                <text x="{($n - 1) * $xScale + 8}" y="{$m * 200 + $b}" fill="red" fill-opacity="0.5" font-size="3" text-anchor="end" alignment-baseline="central">
                    <xsl:value-of select="format-number(-1 * ($m * (($n - 1) * $xScale) + $b), '0.0')"/>
                </text>

                <!-- ==================================================== -->
                <!-- Plot horizontal line at regression intercept         -->
                <!-- ==================================================== -->
                <line x1="0" y1="{$b}" x2="{($n - 1) * $xScale}" y2="{$b}" stroke="lightgray"
                    stroke-width="0.5"/>

                <!-- ==================================================== -->
                <!-- Plot sine without jitter                             -->
                <!-- ==================================================== -->
                <polyline points="{$points-tenths}" stroke="lightgray" stroke-width="0.5"
                    fill="none"/>

                <!-- ==================================================== -->
                <!-- Plot data points and polyline                        -->
                <!-- ==================================================== -->
                <xsl:for-each select="$points">
                    <circle cx="{substring-before(current(), ',')}" cy="{substring-after(.,',')}"
                        r="0.65" fill="black"/>
                </xsl:for-each>
                <g id="data">
                    <polyline points="{$points}" stroke="black" stroke-width="0.5" fill="none"
                        id="black"/>
                </g>

                <!-- ==================================================== -->
                <!-- Plot regression line                                 -->
                <!-- ==================================================== -->
                <g id="regression">
                    <xsl:sequence select="$regression[1]"/>
                </g>

                <!-- ==================================================== -->
                <!-- Plot rectangular smoothing spline                    -->
                <!-- ==================================================== -->
                <g id="rectangular">
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
                <text x="{(($n - 1) * $xScale) div 2}" y="8" text-anchor="middle" font-size="5">Fake independent
                    variable</text>
                <text x="-10" y="-50" text-anchor="middle" font-size="5" writing-mode="tb">Fake
                    dependent variable</text>
                <text x="{(($n - 1) * $xScale) div 2}" y="-106" text-anchor="middle" font-size="8">
                    <xsl:value-of select="
                            'Smoothing examples (window
                    = ' || $window || ')'"/>
                </text>
            </g>
            <g transform="translate(50, 15)">
                <rect x="0" y="0" width="100" height="51" fill="ghostwhite" stroke="black"
                    stroke-width="0.5"/>
                <!-- boxes are clickable -->
                <rect x="2" y="1" width="5" height="5" fill="black" class="toggle" id="data-box"/>
                <rect x="2" y="8" width="5" height="5" fill="red" class="toggle" id="regression-box"/>
                <rect x="2" y="15" width="5" height="5" fill="gray"/>
                <rect x="2" y="22" width="5" height="5" fill="blue" class="toggle"
                    id="rectangular-box"/>
                <rect x="2" y="29" width="5" height="5" fill="green" class="toggle"
                    id="gaussian-box"/>
                <rect x="2" y="36" width="5" height="5" fill="indigo" class="toggle"
                    id="exponential-box"/>
                <rect x="2" y="43" width="5" height="5" fill="darkgoldenrod" class="toggle"
                    id="parabolic-box"/>
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

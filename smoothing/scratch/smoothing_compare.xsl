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
    <xsl:variable name="xMax" as="xs:integer" select="50"/>
    <xsl:variable name="xScale" as="xs:integer" select="4"/>
    <!--<xsl:variable name="window" as="xs:integer"
        select="($xMax div 3) ! xs:integer(.) ! djb:round-to-odd(.)"/>-->
    <xsl:variable name="window" as="xs:integer" select="3"/>

    <!-- ================================================================ -->
    <!-- Data                                                             -->
    <!-- ================================================================ -->
    <xsl:variable name="allX" as="xs:double+" select="0 to $xMax"/>
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
    <!-- Rectangular values                                               -->
    <!-- ================================================================ -->
    <xsl:variable name="rectangular-points" as="xs:string+"
        select="djb:get-weighted-points($points, 'rectangular', $window)"/>

    <!-- ================================================================ -->
    <!-- Gaussian values                                                  -->
    <!-- ================================================================ -->
    <xsl:variable name="stddev" as="xs:double" select="5"/>
    <xsl:variable name="gaussian-points" as="xs:string+"
        select="djb:get-weighted-points($points, 'gaussian', $window, $stddev)"/>

    <!-- ================================================================ -->
    <!-- Exponential values                                               -->
    <!-- ================================================================ -->
    <xsl:variable name="exponential-points" as="xs:string+"
        select="djb:get-weighted-points($points, 'exponential', $window)"/>

    <!-- ================================================================ -->
    <!-- Parabolic-up values                                              -->
    <!-- ================================================================ -->
    <xsl:variable name="parabolic-up-points" as="xs:string+"
        select="djb:get-weighted-points($points, 'parabolic-up', $window)"/>

    <!-- ================================================================ -->
    <!-- Parabolic-down values                                            -->
    <!-- ================================================================ -->
    <xsl:variable name="parabolic-down-points" as="xs:string+"
        select="djb:get-weighted-points($points, 'parabolic-down', $window)"/>

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-20 -115 {$n * $xScale + 30} 195">
            <!-- js highlights on mouseover -->
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
                    stroke-linecap: square;
                    fill: none;
                    clip-path: url(#clip-rectangular);
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
                #parabolicUp {
                    stroke: fuchsia;
                }
                #parabolicDown {
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
            <clipPath id="clip-rectangular">
                <rect x="0" y="-100" width="200" height="100"/>
            </clipPath>
            <g>
                <!-- ==================================================== -->
                <!-- Plot sine without jitter                             -->
                <!-- ==================================================== -->
                <polyline points="{$points-tenths}" stroke="lightgray" stroke-width="0.5"
                    fill="none"/>

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
                    <xsl:sequence
                        select="djb:smoothing($rectangular-points, $window) => djb:spline(0.4)"/>
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
                <!-- Plot parabolic up smoothing spline                   -->
                <!-- ==================================================== -->
                <g id="parabolicUp">
                    <xsl:sequence select="djb:spline($parabolic-up-points, 0.45)"/>
                </g>

                <!-- ==================================================== -->
                <!-- Plot parabolic down smoothing spline                 -->
                <!-- ==================================================== -->
                <g id="parabolicDown">
                    <xsl:sequence select="djb:spline($parabolic-down-points, 0.45)"/>
                </g>

                <!-- ==================================================== -->
                <!-- Draw X axis and line at 100%, with Y labels          -->
                <!-- ==================================================== -->
                <rect x="0" y="-100" width="{($n - 1) * $xScale}" height="100" stroke="lightgray"
                    stroke-width="0.5" fill="none"/>
                <text x="-1" y="0" fill="lightgray" font-size="3" text-anchor="end" alignment-baseline="central">0.0</text>
                <text x="-1" y="-100" fill="lightgray" font-size="3" text-anchor="end" alignment-baseline="central">100.0</text>
                <text x="-1" y="{$b}" fill="red" fill-opacity="0.5" font-size="3" text-anchor="end" alignment-baseline="central">
                    <xsl:value-of select="(-1 * number($b)) => format-number('0.0')"/>
                </text>
                <text x="{($n - 1) * $xScale + 8}" y="-100" font-size="3" fill="lightgray" text-anchor="end" alignment-baseline="central">100.0</text>
                <text x="{($n - 1) * $xScale + 8}" y="0" font-size="3" fill="lightgray" text-anchor="end" alignment-baseline="central">0.0</text>
                <text x="{($n - 1) * $xScale + 8}" y="{$m * (($n - 1) * $xScale) + $b}" fill="red" fill-opacity="0.5" font-size="3" text-anchor="end" alignment-baseline="central">
                    <xsl:value-of select="format-number(-1 * ($m * (($n - 1) * $xScale) + $b), '0.0')"/>
                </text>

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
            <g transform="translate({(($n - 1) * $xScale) div 2 - 50}, 15)">
                <rect x="0" y="0" width="100" height="58" fill="ghostwhite" stroke="black"
                    stroke-width="0.5"/>
                <!-- boxes are clickable -->
                <rect x="2" y="2" width="5" height="5" fill="black" class="toggle" id="data-box"/>
                <rect x="2" y="9" width="5" height="5" fill="red" class="toggle" id="regression-box"/>
                <rect x="2" y="16" width="5" height="5" fill="gray"/>
                <rect x="2" y="23" width="5" height="5" fill="blue" class="toggle"
                    id="rectangular-box"/>
                <rect x="2" y="30" width="5" height="5" fill="green" class="toggle"
                    id="gaussian-box"/>
                <rect x="2" y="37" width="5" height="5" fill="indigo" class="toggle"
                    id="exponential-box"/>
                <rect x="2" y="44" width="5" height="5" fill="fuchsia" class="toggle"
                    id="parabolicUp-box"/>
                <rect x="2" y="51" width="5" height="5" fill="darkgoldenrod" class="toggle"
                    id="parabolicDown-box"/>
                <text x="10" y="6" fill="black" font-size="5" alignment-baseline="central">
                    <tspan>Actual data (<xsl:value-of select="$n"/> points)</tspan>
                    <tspan x="10" dy="7" fill="red">
                        <xsl:value-of select="'Regression line (' || format-number(-1 * $b, '0.0') || '–' || format-number(-1 * ($m * 200 + $b), '0.0') || ')'"/>
                    </tspan>
                    <tspan x="10" dy="7" fill="gray">
                        <xsl:value-of select="'Sine without jitter'"/>
                    </tspan>
                    <tspan x="10" dy="7" fill="blue">Rectangular </tspan>
                    <tspan x="10" dy="7" fill="green">Gaussian (σ = 5)</tspan>
                    <tspan x="10" dy="7" fill="indigo">Exponential: y = 1 - 2<tspan dy="-2" font-size="4">-d</tspan><tspan dy="2">&#xa0;</tspan></tspan>
                    <tspan x="10" dy="7" fill="fuchsia">Parabolic (upward): y = ((N - d)/N)<tspan dy="-2" font-size="4">2</tspan><tspan dy="2">&#xa0;</tspan></tspan>
                    <tspan x="10" dy="7" fill="darkgoldenrod">Parabolic (downward): y = 1 - (d/N)<tspan dy="-2" font-size="4">2</tspan><tspan dy="2" dx="-1">)</tspan></tspan>
                </text>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

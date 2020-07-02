<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:svg="http://www.w3.org/2000/svg" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- ================================================================ -->
    <!-- Packages                                                         -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>
    <xsl:use-package name="http://www.obdurodon.org/smoothing"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>
    <xsl:use-package name="http://www.obdurodon.org/spline"/>

    <!-- ================================================================ -->
    <!-- Create fake data for testing                                     -->
    <!-- ================================================================ -->
    <xsl:variable name="pointCount" as="xs:integer" select="40"/>
    <xsl:variable name="xScale" as="xs:integer" select="5"/>
    <xsl:variable name="allY" as="xs:double+"
        select="
            djb:random-sequence($pointCount + 1) ! (. * 100)"/>
    <xsl:variable name="points" as="xs:string+"
        select="
            for-each-pair(0 to count($allY), $allY, function ($a, $b) {
                string-join(($a * $xScale, -1 * $b), ',')
            })"/>

    <!-- ================================================================ -->
    <!-- Smooth with different window sizes                               -->
    <!-- ================================================================ -->
    <xsl:variable name="smooth-3" as="element(svg:g)"
        select="
            djb:get-weighted-points($points, 'gaussian', 3, 5)
            => djb:spline()
            "/>
    <xsl:variable name="smooth-7" as="element(svg:g)"
        select="
            djb:get-weighted-points($points, 'gaussian', 7, 5)
            => djb:spline()
            "/>
    <xsl:variable name="smooth-11" as="element(svg:g)"
        select="
            djb:get-weighted-points($points, 'gaussian', 11, 5)
            => djb:spline()
            "/>
    <xsl:variable name="smooth-15" as="element(svg:g)"
        select="
            djb:get-weighted-points($points, 'gaussian', 15, 5)
            => djb:spline()
            "/>
    <!-- ================================================================ -->
    <!-- Plot                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 -115 205 155">
            <style type="text/css">
                .highlight {stroke-width: 2;}
            </style>
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
                    var target = 'smooth' + this.id.substring(this.id.indexOf('-'));
                    console.log(target);
                    document.getElementById(target).classList.add('highlight');
                }
                function deemphasize() {
                    var target = 'smooth' + this.id.substring(this.id.indexOf('-'));
                    document.getElementById(target).classList.remove('highlight');
                }//]]>
            </script>
            <g stroke-width="0.5" fill="0" stroke-opacity="0.5">
                <g id="smooth-3" stroke="green">
                    <xsl:sequence select="$smooth-3"/>
                </g>
                <g id="smooth-7" stroke="blue">
                    <xsl:sequence select="$smooth-7"/>
                </g>
                <g id="smooth-11" stroke="magenta">
                    <xsl:sequence select="$smooth-11"/>
                </g>
                <g id="smooth-15" stroke="orange">
                    <xsl:sequence select="$smooth-15"/>
                </g>
            </g>
            <polyline points="{$points}" stroke="black" stroke-width="0.5" fill="none"/>
            <rect x="0" y="-100" width="200" height="100" stroke="lightgray" stroke-width="0.5"
                fill="none"/>
            <g fill="lightgray" font-size="3">
                <text x="-1" y="0" text-anchor="end" alignment-baseline="central">0.0</text>
                <text x="-1" y="-100" text-anchor="end" alignment-baseline="central">100.0</text>
                <text x="207" y="0" text-anchor="end" alignment-baseline="central">0.0</text>
                <text x="207" y="-100" text-anchor="end" alignment-baseline="central">100.0</text>
            </g>
            <g transform="translate(25, 10)">
                <rect x="0" y="-5" width="27" height="27" stroke="black" stroke-width="0.5"
                    fill="none"/>
                <rect x="3" y="2" width="3" height="3" fill="green" class="toggle" id="rect-3"/>
                <rect x="3" y="7" width="3" height="3" fill="blue" class="toggle" id="rect-7"/>
                <rect x="3" y="12" width="3" height="3" fill="magenta" class="toggle" id="rect-11"/>
                <rect x="3" y="17" width="3" height="3" fill="orange" class="toggle" id="rect-15"/>
                <text x="8" y="0" font-size="4">
                    <tspan x="3">Window size</tspan>
                    <tspan x="8" dy="5">3</tspan>
                    <tspan x="8" dy="5">7</tspan>
                    <tspan x="8" dy="5">11</tspan>
                    <tspan x="8" dy="5">15</tspan>
                </text>
            </g>
            <text x="100" y="-105" font-size="5" fill="black" text-anchor="middle">Window size effects</text>
            <text x="100" y="5" font-size="4" fill="black" text-anchor="middle">Fake independent variable</text>
            <text x="-5" y="-50" font-size="4" fill="black" text-anchor="middle" writing-mode="tb">Fake dependent variable</text>
        </svg>
    </xsl:template>
</xsl:stylesheet>

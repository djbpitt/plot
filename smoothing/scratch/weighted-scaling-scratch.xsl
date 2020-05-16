<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- ================================================================ -->
    <!-- Packages                                                         -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot_lib"/>
    <xsl:use-package name="http://www.obdurodon.org/smoothing"/>
    <xsl:use-package name="http://www.obdurodon.org/spline"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Create fake data, for testing, with a bit of jitter              -->
    <!-- ================================================================ -->
    <xsl:variable name="pointCount" as="xs:integer" select="40"/>
    <xsl:variable name="xScale" as="xs:integer" select="5"/>
    <xsl:variable name="allY" as="xs:double+"
        select="
            djb:random-sequence($pointCount) ! (. * 100)"/>
    <xsl:variable name="points" as="xs:string+"
        select="
            for-each-pair(1 to count($allY), $allY, function ($a, $b) {
                string-join(($a * $xScale, -1 * $b), ',')
            })"/>

    <!-- ================================================================ -->
    <!-- Create list of weights the length of the window                  -->
    <!-- $stddev needed only for Gaussian                                 -->
    <!-- ================================================================ -->
    <!-- test window is 2/3 of all points-->
    <xsl:variable name="window-small" as="xs:integer" select="3"/>
    <xsl:variable name="window-mid" as="xs:integer"
        select="djb:round-to-odd(xs:integer(round(count($allY) div 3)))"/>
    <xsl:variable name="window-default" as="xs:integer"
        select="djb:round-to-odd(xs:integer(round(2 * count($allY) div 3)))"/>
    <xsl:variable name="stddev" as="xs:double" select="5"/>
    <!--<xsl:variable name="weights" as="xs:double+" select="djb:gaussian_weights($window, $stddev)"/>-->
    <xsl:variable name="adjustedY-small" as="xs:double+">
        <xsl:for-each select="1 to count($points)">
            <xsl:sequence select="djb:weighted-average(current(), $allY, $window-small, $stddev)"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="adjustedY-mid" as="xs:double+">
        <xsl:for-each select="1 to count($points)">
            <xsl:sequence select="djb:weighted-average(current(), $allY, $window-mid, $stddev)"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="adjustedY-default" as="xs:double+">
        <xsl:for-each select="1 to count($points)">
            <xsl:sequence select="djb:weighted-average(current(), $allY, $window-default, $stddev)"
            />
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="adjustedPoints-small" as="xs:string+"
        select="
            for $x in (1 to count($adjustedY-small))
            return
                string-join(($x * $xScale, -1 * $adjustedY-small[$x]), ',')"/>
    <xsl:variable name="adjustedPoints-mid" as="xs:string+"
        select="
            for $x in (1 to count($adjustedY-mid))
            return
                string-join(($x * $xScale, -1 * $adjustedY-mid[$x]), ',')"/>
    <xsl:variable name="adjustedPoints-default" as="xs:string+"
        select="
            for $x in (1 to count($adjustedY-default))
            return
                string-join(($x * $xScale, -1 * $adjustedY-default[$x]), ',')"/>

    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg"
            viewBox="-10 -110 {count($points) * $xScale + 20} 120">
            <style type="text/css">
                #small .spline {
                    stroke: fuchsia;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                    fill: none;
                }
                #mid .spline {
                    stroke: orange;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                    fill: none;
                }
                #default .spline {
                    stroke: green;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                    fill: none;
                }
                .regression {
                    stroke: red;
                    stroke-width: 0.5;
                    stroke-opacity: 0.5;
                    fill: none;
                }</style>
            <!-- original points in black -->
            <xsl:for-each select="$points">
                <circle cx="{substring-before(current(), ',')}"
                    cy="{substring-after(current(), ',')}" r="0.5" fill="black"/>
            </xsl:for-each>
            <polyline points="{$points}" stroke="black" stroke-width="0.5" fill="none"/>
            <!-- adjusted small window points in blue -->
            <xsl:for-each select="$adjustedPoints-small">
                <circle cx="{substring-before(current(), ',')}"
                    cy="{substring-after(current(), ',')}" r="0.5" fill="blue"/>
            </xsl:for-each>
            <polyline points="{$adjustedPoints-small}" stroke="blue" stroke-width="0.5" fill="none"
                stroke-opacity="0.5"/>
            <g id="small">
                <xsl:sequence select="djb:spline($adjustedPoints-small, .4)"/>
            </g>
            <g id="mid">
                <xsl:sequence select="djb:spline($adjustedPoints-mid, .4)"/>
            </g>
            <!-- adjusted default window points in green -->
            <g id="default">
                <xsl:sequence select="djb:spline($adjustedPoints-default, .4)"/>
            </g>
            <!-- linear regression -->
            <xsl:sequence select="djb:regression-line($points)"/>
        </svg>
    </xsl:template>
</xsl:stylesheet>

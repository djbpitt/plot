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
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Create fake data, for testing, with a bit of jitter              -->
    <!-- ================================================================ -->
    <xsl:variable name="xScale" as="xs:integer" select="5"/>
    <xsl:variable name="allY" as="xs:double+"
        select="
            djb:random-sequence(100) ! (. * 100)"/>
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
    <!--<xsl:variable name="window" as="xs:integer"
        select="djb:round-to-odd(xs:integer(round(count($allY) div 3 * 2)))"/>-->
    <xsl:variable name="window" as="xs:integer" select="3"/>
    <xsl:variable name="stddev" as="xs:double" select="5"/>
    <!--<xsl:variable name="weights" as="xs:double+" select="djb:gaussian_weights($window, $stddev)"/>-->
    <xsl:variable name="adjustedY" as="xs:double+">
        <xsl:for-each select="1 to count($points)">
            <xsl:sequence select="djb:weighted-average(current(), $allY, $window, $stddev)"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="adjustedPoints" as="xs:string+"
        select="
            for $x in (1 to count($adjustedY))
            return
                string-join(($x * $xScale, -1 * $adjustedY[$x]), ',')"/>

    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg"
            viewBox="-10 -110 {count($points) * $xScale + 20} 120" width="90%">
            <style type="text/css">
                .spline {
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
            <!-- adjusted points in blue -->
            <xsl:for-each select="$adjustedPoints">
                <circle cx="{substring-before(current(), ',')}"
                    cy="{substring-after(current(), ',')}" r="0.5" fill="blue"/>
            </xsl:for-each>
            <polyline points="{$adjustedPoints}" stroke="blue" stroke-width="0.5" fill="none"
                stroke-opacity="0.5"/>
            <xsl:sequence select="djb:spline($adjustedPoints, .4)"/>
        </svg>
    </xsl:template>
</xsl:stylesheet>

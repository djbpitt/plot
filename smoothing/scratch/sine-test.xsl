<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:f="http://www.obdurodon.org/function-variables"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- ================================================================ -->
    <!-- Packages                                                         -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>
    <xsl:use-package name="http://www.obdurodon.org/spline"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>

    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <!-- djb:recenter#3                                                   -->
    <!--                                                                  -->
    <!-- Adjusts and recenters doubles, returns adjusted values           -->
    <!--                                                                  -->
    <!-- Parameters                                                       -->
    <!--   $f:input-values as xs:double+ : all input values               -->
    <!--   $f:a as xs:double : new minimum value                          -->
    <!--   $f:b as xs:double : new maximum value                          -->
    <!--                                                                  -->
    <!-- Returns                                                          -->
    <!--   xs:double+                                                     -->
    <!--                                                                  -->
    <!-- Note: https://stackoverflow.com/questions/5294955/how-to-scale-down-a-range-of-numbers-with-a-known-min-and-max-value -->
    <!--            (b - a)(x - min)                                      -->
    <!--    f(x) =  ——————————————   + a                                  -->
    <!--                max - min                                         -->
    <!-- ================================================================ -->
    <xsl:function name="djb:recenter" as="xs:double+">
        <xsl:param name="f:input-values" as="xs:double+"/>
        <xsl:param name="f:a" as="xs:double"/>
        <xsl:param name="f:b" as="xs:double"/>
        <xsl:variable name="f:min" as="xs:double" select="min($f:input-values)"/>
        <xsl:variable name="f:max" as="xs:double" select="max($f:input-values)"/>
        <xsl:variable name="f:recentered-values"
            select="$f:input-values ! (((($f:b - $f:a) * -1 * (. - $f:min)) div ($f:max - $f:min)) + $f:a)"/>
        <xsl:sequence select="$f:recentered-values"/>
    </xsl:function>

    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!-- ================================================================ -->
    <xsl:variable name="xScale" as="xs:integer" select="10"/>
    <xsl:variable name="maxX" as="xs:integer" select="20"/>
    <!-- ================================================================ -->
    <!-- X values are in tenths                                           -->
    <!-- ================================================================ -->
    <xsl:variable name="allX" as="xs:double+"
        select="djb:expand-to-tenths($maxX idiv 2) ! (. + ($maxX idiv 2))"/>
    <!-- ================================================================ -->
    <!-- Random sequence of jitters, scaled by $jitter-amp                -->
    <!-- ================================================================ -->
    <xsl:variable name="jitter-amp" as="xs:double" select="1"/>
    <xsl:variable name="jitters" as="xs:double+"
        select="djb:random-sequence(count($allX)) ! (. * $jitter-amp)"/>
    <!-- ================================================================ -->
    <!-- Sine with jitter, recentered at y = -100 to 0                    -->
    <!-- ================================================================ -->
    <xsl:variable name="allY-with-jitter" as="xs:double+"
        select="
            (
            for $i in (1 to count($allX))
            return
                (math:sin($allX[$i])) + $jitters[position() eq $i]) => djb:recenter(0, 100)"/>
    <xsl:variable name="points" as="xs:string+"
        select="
            for-each-pair($allX, $allY-with-jitter, function ($a, $b) {
                string-join(($a * $xScale, $b), ',')
            })"/>

    <!-- ================================================================ -->
    <!-- Regression line, with m and b                                    -->
    <!-- ================================================================ -->
    <xsl:variable name="regression" as="item()+" select="djb:regression-line($points, true())"/>
    <xsl:variable name="m" as="xs:double" select="$regression[2]?m ! number(.)"/>
    <xsl:variable name="b" as="xs:double" select="$regression[2]?b ! number(.)"/>
    <xsl:variable name="end-intercept" as="xs:double" select="-1 * (count($allX) * $m + $b)"/>

    <!-- ======================================================== -->
    <!-- Sine without jitter                                      -->
    <!-- ======================================================== -->
    <xsl:variable name="plain-points" as="xs:string+"
        select="
            (for $x in $allX
            return
                string-join(($x * $xScale, math:sin($x) * -50 - 50), ','))"/>

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg"
            viewBox="{-5 * $xScale} -130 {($maxX + 10) * $xScale} 230">
            <style type="text/css">
                #jitter .spline {
                    stroke: black;
                    stroke-width: 0.5;
                    fill: none;
                }
                #plain .spline {
                    stroke: lightgray;
                    stroke-width: 0.5;
                    fill: none;
                }
                .regression {
                    stroke: coral;
                    stroke-width: 0.5;
                }</style>
            <!-- ======================================================== -->
            <!-- Labels                                                   -->
            <!-- ======================================================== -->
            <line x1="0" y1="-50" x2="{$maxX * $xScale}" y2="-50" stroke="lightgray"
                stroke-width="0.5"/>
            <text x="-1" y="-100" text-anchor="end" alignment-baseline="central" fill="lightgray" font-size="3">100.0</text>
            <text x="-1" y="-50" text-anchor="end" alignment-baseline="central" fill="lightgray" font-size="3">50.0</text>
            <text x="-1" y="0" text-anchor="end" alignment-baseline="central" fill="lightgray" font-size="3">0.0</text>
            <text x="-1" y="{$regression[2]?b}" text-anchor="end" alignment-baseline="central" fill="lightgray" font-size="3">
                <xsl:value-of select="($b * -1) ! format-number(., '0.0')"/>
            </text>
            <text x="{$maxX * $xScale + 1}" y="-{$end-intercept}" text-anchor="start" alignment-baseline="central" fill="lightgray" font-size="3">
                <xsl:value-of select="$end-intercept => format-number('0.0')"/>
            </text>
            <text x="{$maxX * $xScale div 2}" y="-110" text-anchor="middle" fill="black" font-size="5">Sine wave with jitter (artificial data)</text>
            <text x="{$maxX * $xScale div 2}" y="5" text-anchor="middle" fill="black" font-size="4">X values range from 0 to <xsl:value-of select="$maxX * 10"/> by tenths</text>
            <text x="-10" y="-50" text-anchor="middle" writing-mode="tb" fill="black" font-size="4">Y values recentered and scaled at 0 to 100</text>

            <!-- ======================================================== -->
            <!-- Legend                                                   -->
            <!-- ======================================================== -->
            <rect x="0" y="10" width="{$maxX * $xScale}" height="50" stroke="black"
                stroke-width="0.5" fill="ghostwhite"/>

            <!-- ======================================================== -->
            <!-- Sine without jitter                                      -->
            <!-- ======================================================== -->
            <g id="plain">
                <xsl:sequence select="djb:spline($plain-points)"/>
            </g>
            <!-- ======================================================== -->
            <!-- Sine with jitter                                         -->
            <!-- ======================================================== -->
            <g id="jitter">
                <polyline points="{$points}" class="spline"/>
            </g>
            <!-- ======================================================== -->
            <!-- Regression line                                          -->
            <!-- ======================================================== -->
            <xsl:sequence select="$regression[1]"/>

            <!-- ======================================================== -->
            <!-- Rectangular frame stands in for axes                     -->
            <!-- ======================================================== -->
            <rect x="0" y="-100" width="{$maxX * $xScale}" height="100" stroke="lightgray"
                stroke-width="0.5" fill="none"/>
        </svg>
    </xsl:template>
</xsl:stylesheet>

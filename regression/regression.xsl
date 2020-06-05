<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/regression"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:djb="http://www.obdurodon.org" xmlns:f="http://www.obdurodon.org/function-variables"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="#all" version="3.0">

    <!-- ================================================================ -->
    <!-- Stylesheet parameters                                            -->
    <!-- ================================================================ -->
    <!--<xsl:param name="debug" as="xs:boolean"/>-->

    <!-- ================================================================ -->
    <!-- Public (final) functions                                         -->
    <!-- ================================================================ -->
    <xsl:expose component="function" visibility="final"
        names="
        djb:regression-line#2 
        djb:regression-line#1
        djb:compute-regression-parameters#1
        djb:plot-parabolic-segment#5
        "/>

    <!-- ================================================================ -->
    <!-- Package dependencies                                             -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>
    <xsl:use-package name="http://www.obdurodon.org/linear-algebra-lib"/>

    <!-- ================================================================ -->
    <!-- Function declarations                                            -->
    <!-- ================================================================ -->
    <xsl:function name="djb:regression-line" as="item()+">
        <!-- ============================================================ -->
        <!-- djb:regression-line#2                                        -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $points as xs:string+ : all points in X,Y coordinate form  -->
        <!--   $debug as xs:boolean                                       -->
        <!--                                                              -->
        <!-- Return:                                                      -->
        <!--   element(svg:g) : contains <line>                           -->
        <!--   if $debug, also contains points, polyline, CSS             -->
        <!-- ============================================================ -->
        <xsl:param name="f:point-pairs" as="xs:string+"/>
        <xsl:param name="f:debug" as="xs:boolean"/>
        <!-- ============================================================ -->

        <!-- ============================================================ -->
        <!-- Computed values                                              -->
        <!--                                                              -->
        <!-- https://brownmath.com/stat/leastsq.htm                       -->
        <!--   y = mx + b                                                 -->
        <!--   m = ( n∑xy − (∑x)(∑y) ) / ( n∑x² − (∑x)² )                 -->
        <!--   b = ( ∑y − m∑x ) / n                                       -->
        <!-- ============================================================ -->
        <xsl:if test="not(djb:validate-points($f:point-pairs))">
            <xsl:message terminate="yes"
                select="'Invalid points: ' || string-join($f:point-pairs, '; ')"/>
        </xsl:if>
        <xsl:variable name="f:n" as="xs:integer" select="count($f:point-pairs)"/>
        <xsl:variable name="f:allX" as="xs:double+"
            select="$f:point-pairs ! substring-before(., ',') ! number(.)"/>
        <xsl:variable name="f:allY" as="xs:double+"
            select="$f:point-pairs ! substring-after(., ',') ! number(.)"/>
        <xsl:variable name="f:sumXY" as="xs:double+"
            select="
            for-each-pair($f:allX, $f:allY, function ($a, $b) {$a * $b}) => sum()"/>
        <xsl:variable name="f:sumX" as="xs:double" select="sum($f:allX)"/>
        <xsl:variable name="f:sumY" as="xs:double" select="sum($f:allY)"/>
        <xsl:variable name="f:sumX2" as="xs:double" select="($f:allX ! math:pow(., 2)) => sum()"/>
        <xsl:message select="$f:allX ! math:pow(., 2)"/>
        <xsl:variable name="f:m" as="xs:double"
            select="($f:n * $f:sumXY - $f:sumX * $f:sumY) div ($f:n * $f:sumX2 - math:pow($f:sumX, 2))"/>
        <xsl:variable name="f:b" as="xs:double" select="($f:sumY - $f:m * $f:sumX) div $f:n"/>
        <!-- ============================================================ -->
        <!-- Return value                                                 -->
        <!-- ============================================================ -->
        <g xmlns="http://www.w3.org/2000/svg">
            <line x1="{min($f:allX)}" y1="{$f:m * min($f:allX) + $f:b}" x2="{max($f:allX)}"
                y2="{$f:m * max($f:allX) + $f:b}" class="regression"/>
        </g>
        <xsl:if test="$f:debug">
            <xsl:message select="'sum of X = ', $f:sumX"/>
            <xsl:message select="'sum of Y = ', $f:sumY"/>
            <xsl:message select="'mean X = ', avg($f:allX)"/>
            <xsl:message select="'mean Y = ' , avg($f:allY)"/>
            <xsl:message select="'sum of squares = ', $f:sumX2"/>
            <xsl:message select="'sum of products = ', $f:sumXY"/>
            <xsl:message select="map {'m' : $f:m, 'b' : $f:b}"/>
        </xsl:if>
    </xsl:function>

    <xsl:function name="djb:regression-line" as="element(svg:g)">
        <!-- ============================================================ -->
        <!-- djb:regression-line#1                                        -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $points as xs:string+ : all points in X,Y coordinate form  -->
        <!--                                                              -->
        <!-- Return (by way of djb:regression-line#2):                    -->
        <!--   element(svg:g) : contains <line>                           -->
        <!-- ============================================================ -->
        <xsl:param name="points" as="xs:string+"/>
        <!-- ============================================================ -->
        <xsl:sequence select="djb:regression-line($points, false())"/>
    </xsl:function>

    <xsl:function name="djb:compute-regression-parameters" as="map(xs:string, xs:double)">
        <!-- ============================================================ -->
        <!-- djb:compute-regression-parameters#1                          -->
        <!--                                                              -->
        <!-- Formula from:                                                -->
        <!--   https://www.easycalculation.com/statistics/learn-quadratic-regression.php -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--  $allX as xs:string+ : points in X,Y format                  -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   map(xs:string, xs:double)                                  -->
        <!--   a: quadratic parameters, b: linear parameter, c: constant  -->
        <!-- ============================================================ -->
        <xsl:param name="f:points" as="xs:string+"/>
        <!-- ============================================================ -->

        <!-- ============================================================ -->
        <!-- Computed values                                              -->
        <!-- ============================================================ -->
        <xsl:variable name="f:n" select="count($f:points)"/>
        <xsl:variable name="f:allX" as="xs:double+"
            select="$f:points ! substring-before(., ',') ! number()"/>
        <xsl:variable name="f:allY" as="xs:double+"
            select="$f:points ! substring-after(., ',') ! number()"/>
        <xsl:variable name="f:sumX" as="xs:double" select="sum($f:allX)"/>
        <xsl:variable name="f:sumY" as="xs:double" select="sum($f:allY)"/>
        <xsl:variable name="f:sumX2" as="xs:double" select="sum($f:allX ! math:pow(., 2))"/>
        <xsl:variable name="f:sumX3" as="xs:double" select="sum($f:allX ! math:pow(., 3))"/>
        <xsl:variable name="f:sumX4" as="xs:double" select="sum($f:allX ! math:pow(., 4))"/>
        <xsl:variable name="f:sumXY" as="xs:double"
            select="
            sum(for-each-pair($f:allX, $f:allY, function ($a, $b) {
            $a * $b
            }))"/>
        <xsl:variable name="f:sumX2Y" as="xs:double"
            select="
            sum(for-each-pair($f:allX, $f:allY, function ($a, $b) {
            math:pow($a, 2) * $b
            }))"/>
        <xsl:variable name="f:sumXXf" as="xs:double"
            select="$f:sumX2 - (math:pow($f:sumX, 2) div $f:n)"/>
        <xsl:variable name="f:sumXYf" as="xs:double"
            select="$f:sumXY - ($f:sumX * $f:sumY) div $f:n"/>
        <xsl:variable name="f:sumXX2f" as="xs:double"
            select="$f:sumX3 - ($f:sumX2 * $f:sumX) div $f:n"/>
        <xsl:variable name="f:sumX2Yf" as="xs:double"
            select="$f:sumX2Y - ($f:sumX2 * $f:sumY) div $f:n"/>
        <xsl:variable name="f:sumX2X2f" as="xs:double"
            select="$f:sumX4 - math:pow($f:sumX2, 2) div $f:n"/>
        <xsl:variable name="f:a" as="xs:double"
            select="(($f:sumX2Yf * $f:sumXXf) - ($f:sumXYf * $f:sumXX2f)) div (($f:sumXXf * $f:sumX2X2f) - math:pow($f:sumXX2f, 2))"/>
        <xsl:variable name="f:b" as="xs:double"
            select="($f:sumXYf * $f:sumX2X2f - $f:sumX2Yf * $f:sumXX2f) div (($f:sumXXf * $f:sumX2X2f) - math:pow($f:sumXX2f, 2))"/>
        <xsl:variable name="f:c" as="xs:double"
            select="$f:sumY div $f:n - $f:b * ($f:sumX div $f:n) - $f:a * ($f:sumX2 div $f:n)"/>
        <xsl:sequence
            select="
            map {
            'a': $f:a,
            'b': $f:b,
            'c': $f:c
            }"
        />
    </xsl:function>

    <xsl:function name="djb:plot-parabolic-segment" as="element(svg:g)">
        <!-- ============================================================ -->
        <!-- djb:plot-parabolic-segment#5                                 -->
        <!--                                                              -->
        <!-- Formula for plotting parabolic segment as quadratic Bézier   -->
        <!--   curve documented at:                                       -->
        <!-- https://math.stackexchange.com/questions/335226/convert-segment-of-parabola-to-quadratic-bezier-curve -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:x1 as xs:double : X coordinate of segment start         -->
        <!--   $f:x2 as xs:double : X coordinate of segment end           -->
        <!--   $f:a as xs:double : y = ax^2 + bx + c                      -->
        <!--   $f:b as xs:double : y = ax^2 + bx + c                      -->
        <!--   $f:c as xs:double : y = ax^2 + bx + c                      -->
        <!--                                                              -->
        <!-- Return:                                                      -->
        <!--   element(svg:g) : contains <path>                           -->
        <!-- ============================================================ -->
        <xsl:param name="f:x1" as="xs:double"/>
        <xsl:param name="f:x2" as="xs:double"/>
        <xsl:param name="f:a" as="xs:double"/>
        <xsl:param name="f:b" as="xs:double"/>
        <xsl:param name="f:c" as="xs:double"/>
        <!-- ============================================================ -->
        <!-- Computed values                                              -->
        <!-- ============================================================ -->
        <xsl:variable name="f:y1" as="xs:double"
            select="-1 * djb:compute-parabolic-Y($f:x1, $f:a, $f:b, $f:c)"/>
        <xsl:variable name="f:y2" as="xs:double"
            select="-1 * djb:compute-parabolic-Y($f:x2, $f:a, $f:b, $f:c)"/>
        <xsl:variable name="f:controlX" as="xs:double" select="djb:compute-control-X($f:x1, $f:x2)"/>
        <xsl:variable name="f:controlY" as="xs:double"
            select="djb:compute-control-Y($f:x1, $f:x2, $f:a, $f:b, $f:c)"/>
        <!-- ============================================================ -->
        <!-- Plot parabolic segment                                       -->
        <!-- ============================================================ -->
        <g xmlns="http://www.w3.org/2000/svg">
            <path d="M{$f:x1},{-1 * $f:y1} Q{$f:controlX},{$f:controlY} {$f:x2},{-1 * $f:y2}"
                class="parabolic-regression" fill="none"/>
        </g>
    </xsl:function>

</xsl:package>

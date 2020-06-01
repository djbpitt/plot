<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" xmlns:f="http://www.obdurodon.org/function-variables"
    version="3.0">

    <!-- ================================================================ -->
    <!-- Stylesheet static parameters                                     -->
    <!-- ================================================================ -->
    <xsl:param name="debug" static="yes" as="xs:boolean" select="true()"/>

    <!-- ================================================================ -->
    <!-- Output configuration                                             -->
    <!-- ================================================================ -->
    <xsl:output method="xml" indent="yes"/>

    <!-- ================================================================ -->
    <!-- Packages                                                         -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>

    <!-- ================================================================ -->
    <!-- Source                                                           -->
    <!-- ================================================================ -->
    <!--
        https://www.easycalculation.com/statistics/learn-quadratic-regression.php
        
        Quadratic Regression Equation(y) = a x^2 + b x + c
        
        a = { [ Σ x^2y * Σ xx ] - [Σ xy * Σ xx^2 ] } / { [ Σ xx * Σ x^2x^2] - [Σ xx^2]^2 }
        b = { [ Σ xy * Σ x^2x^2 ] - [Σ x^2y * Σ xx^2 ] } / { [ Σ xx * Σ x^2x^2] - [Σ xx^2]^2 }
        c = [ Σ y / n ] - { b * [ Σ x / n ] } - { a * [ Σ x^2 / n ] }
        
        Where ,
        Σ x x = [ Σ x^2 ] - [ ( Σ x )^2 / n ]
        Σ x y = [ Σ x y ] - [ ( Σ x * Σ y ) / n ]
        Σ x x2 = [ Σ x^3 ] - [ ( Σ x^2 * Σ x ) / n ]
        Σ x2 y = [ Σ x^2 y] - [ ( Σ x^2 * Σ y ) / n ]
        Σ x2 x2 = [ Σ x^4 ] - [ ( Σ x^2 )^2 / n ]
        x and y are the Variables.
        a, b, and c are the Coefficients of the Quadratic Equation
        n = Number of Values or Elements
        Σ x= Sum of First Scores
        Σ y = Sum of Second Scores
        Σ x2 = Sum of Square of First Scores
        Σ x 3 = Sum of Cube of First Scores
        Σ x 4 = Sum of Power Four of First Scores
        Σ xy= Sum of the Product of First and Second Scores
        Σ x2y = Sum of Square of First Scores and Second Scores

        Find:
        Σ x 	 
        Σ y 	 
        Σ x^2 	 
        Σ x^3 	 
        Σ x^4 	 
        Σ xy  	 
        Σ x^2y 
    -->

    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <xsl:function name="djb:compute-regression-parameters" as="map(xs:string, xs:double)">
        <!-- ============================================================ -->
        <!-- djb:compute-regression-parameters#1                          -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--  $allX as xs:string+ : points in X,Y format                  -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   map(xs:string, xs:double)                                  -->
        <!--   a: quadratic parameters, b: linear parameter, c: constant  -->
        <!-- ============================================================ -->
        <xsl:param name="f:points" as="xs:string+"/>
        <xsl:variable name="f:n" select="count($points)"/>
        <xsl:variable name="f:allX" as="xs:double+"
            select="$points ! substring-before(., ',') ! number()"/>
        <xsl:variable name="f:allY" as="xs:double+"
            select="$points ! substring-after(., ',') ! number()"/>
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

    <xsl:function name="djb:compute-X-where-Y-equals-zero" as="xs:double*">
        <!-- https://math.stackexchange.com/questions/2332389/quadratic-equation-x-and-y-formula -->
        <!-- NB: could return 0, 1, or 2 values -->
        <xsl:param name="a" as="xs:double"/>
        <xsl:param name="b" as="xs:double"/>
        <xsl:param name="c" as="xs:double"/>
        <xsl:variable name="discriminant" as="xs:double" select="math:pow($b, 2) - 4 * $a * $c"/>
        <xsl:sequence
            select="((-1 * $b + math:sqrt($discriminant)) div (2 * $a), (-1 * $b - math:sqrt($discriminant)) div (2 * $a))"
        />
    </xsl:function>

    <xsl:function name="djb:compute-Y-from-X-parabola" as="xs:double">
        <xsl:param name="f:x" as="xs:double"/>
        <xsl:param name="f:a" as="xs:double"/>
        <xsl:param name="f:b" as="xs:double"/>
        <xsl:param name="f:c" as="xs:double"/>
        <xsl:sequence select="$f:a * math:pow($f:x, 2) + $f:b * $f:x + $f:c"/>
    </xsl:function>

    <xsl:function name="djb:compute-vertex-X-of-parabola" as="xs:double">
        <xsl:param name="f:a" as="xs:double"/>
        <xsl:param name="f:b" as="xs:double"/>
        <xsl:sequence select="(-1 * $f:b) div (2 * $f:a)"/>
    </xsl:function>
    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!-- ================================================================ -->
    <!--<xsl:variable name="points" as="xs:string+"
        select="'5,-49', '10,-36', '15,-25', '20,-16', '25,-9', '30,-4'"/>-->
    <xsl:variable name="points" as="xs:string+"
        select="'0,-49', '10,-36', '15,-25', '20,-25', '25,-36', '30,-49'"/>

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <!-- ============================================================ -->
        <!-- Compute all X and Y; a, b, c                                 -->
        <!-- ============================================================ -->
        <xsl:variable name="allX" as="xs:double+"
            select="$points ! substring-before(., ',') ! number()"/>
        <xsl:variable name="allY" as="xs:double+"
            select="$points ! substring-after(., ',') ! number()"/>
        <xsl:variable name="parameters" as="map(xs:string, xs:double)"
            select="djb:compute-regression-parameters($points)"/>
        <xsl:if test="$debug">
            <xsl:message select="'a: ', $parameters('a')"/>
            <xsl:message select="'b: ', $parameters('b')"/>
            <xsl:message select="'c: ', $parameters('c')"/>
        </xsl:if>
        <xsl:variable name="a" as="xs:double" select="$parameters('a')"/>
        <xsl:variable name="b" as="xs:double" select="$parameters('b')"/>
        <xsl:variable name="c" as="xs:double" select="$parameters('c')"/>
        <!-- ============================================================ -->
        <!-- Create SVG output                                            -->
        <!--                                                              -->
        <!-- Clip parabola to fit viewBox inside margins                  -->
        <!-- ============================================================ -->
        <xsl:variable name="width" as="xs:integer" select="100"/>
        <xsl:variable name="height" as="xs:integer" select="100"/>
        <xsl:variable name="margin" as="xs:integer" select="10"/>
        <svg xmlns="http://www.w3.org/2000/svg"
            viewBox="{-1 * $margin} {-1 * ($height + $margin)} {$width + 2 * $margin} {$height + 2 * $margin}">
            <defs>
                <clipPath id="clipPath-parabola">
                    <rect x="0" y="-{$height}" width="{$width}" height="{$height}"/>
                </clipPath>
            </defs>
            <!-- ======================================================== -->
            <!-- Plot axes                                                -->
            <!-- ======================================================== -->
            <line x1="0" y1="0" x2="{$width}" y2="0" stroke="gray" stroke-width="0.25"
                stroke-linecap="square"/>
            <line x1="0" y1="{-1 * $height}" x2="0" y2="0" stroke="gray" stroke-width="0.25"
                stroke-linecap="square"/>
            <!-- ======================================================== -->
            <!-- Plot all input points                                    -->
            <!-- ======================================================== -->
            <xsl:for-each select="1 to count($allX)">
                <circle cx="{$allX[current()]}" cy="{$allY[current()]}" r="0.5" fill="black"/>
            </xsl:for-each>
            <!-- ======================================================== -->
            <!-- Plot vertex                                              -->
            <!-- ======================================================== -->
            <xsl:variable name="vertexX" as="xs:double"
                select="djb:compute-vertex-X-of-parabola($a, $b)"/>
            <xsl:variable name="vertexY" as="xs:double"
                select="djb:compute-Y-from-X-parabola($vertexX, $a, $b, $c)"/>
            <xsl:if test="$debug">
                <circle cx="{$vertexX}" cy="{$vertexY}" r="0.5" stroke="green" stroke-width="0.1"
                    fill="none" class="vertex"/>
            </xsl:if>
            <!-- ======================================================== -->
            <!-- Plot parabola as quadratic Bézier curve                  -->
            <!-- http://apex.infogridpacific.com/dcp/svg-primitives-parabolas.html -->
            <!-- If a > 0, points down (SVG coordinates), else up         -->
            <!-- ======================================================== -->
            <xsl:variable name="parabola-direction" as="xs:integer"
                select="-1 * xs:integer($a div (abs($a)))"/>
            <xsl:variable name="bezier-start-X" as="xs:double+" select="0"/>
            <xsl:variable name="bezier-start-Y" as="xs:double"
                select="djb:compute-Y-from-X-parabola($bezier-start-X, $a, $b, $c)"/>
            <xsl:variable name="bezier-end-X" as="xs:double+" select="2 * $vertexX"/>
            <xsl:variable name="bezier-end-Y" as="xs:double"
                select="djb:compute-Y-from-X-parabola($bezier-end-X, $a, $b, $c)"/>
            <xsl:variable name="Y-diff" as="xs:double" select="abs($bezier-start-Y - $vertexY)"/>
            <xsl:variable name="control-X" as="xs:double" select="$vertexX"/>
            <xsl:variable name="control-Y" as="xs:double"
                select="$parabola-direction * ($vertexY + $Y-diff)"/>
            <xsl:if test="$debug">
                <circle cx="{$bezier-start-X}" cy="{$bezier-start-Y}" r="0.5" fill="pink"
                    class="bezier-start"/>
                <circle cx="{$bezier-end-X}" cy="{$bezier-end-Y}" r="0.5" fill="pink"
                    class="bezier-end"/>
                <circle cx="{$control-X}" cy="{$control-Y}" r="0.5" fill="blue" class="control"/>
                <xsl:message
                    select="'bezier-start: ', string-join(($bezier-start-X, $bezier-start-Y), ',')"/>
                <xsl:message
                    select="'bezier-end: ', string-join(($bezier-end-X, $bezier-end-Y), ',')"/>
                <xsl:message select="'control: ', string-join(($control-X, $control-Y), ',')"/>
            </xsl:if>
            <path
                d="M{$bezier-start-X},{$bezier-start-Y} Q{$control-X},{$control-Y} {$bezier-end-X},{$bezier-end-Y}"
                stroke="red" stroke-width="0.5" fill="none" clip-path="url(#clipPath-parabola)"/>
        </svg>
    </xsl:template>
</xsl:stylesheet>

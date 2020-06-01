<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" xmlns:f="http://www.obdurodon.org/function-variables"
    version="3.0">

    <!-- ================================================================ -->
    <!-- Stylesheet static parameters                                     -->
    <!-- ================================================================ -->
    <xsl:param name="debug" static="yes" as="xs:boolean" select="false()"/>

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

    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!-- ================================================================ -->
    <xsl:variable name="points" as="xs:string+" select="'2,3', '4,6', '6,4'"/>

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
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
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-11 -11 22 22">
            <!-- axes -->
            <line x1="-10" y1="0" x2="10" y2="0" stroke="gray" stroke-width="0.25"/>
            <line x1="0" y1="-10" x2="0" y2="10" stroke="gray" stroke-width="0.25"/>
            <!-- points -->
            <xsl:for-each select="1 to count($allX)">
                <circle cx="{$allX[current()]}" cy="{$allY[current()]}" r="0.5" fill="black"/>
            </xsl:for-each>
            <xsl:for-each select="0 to 10">
                <circle cx="{current()}"
                    cy="{$parameters('a') * math:pow(current(), 2) + $parameters('b') * current() + $parameters('c')}"
                    r="0.25" fill="red"/>
            </xsl:for-each>
        </svg>
    </xsl:template>
</xsl:stylesheet>

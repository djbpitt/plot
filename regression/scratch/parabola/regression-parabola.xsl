<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" xmlns:f="http://www.obdurodon.org/function-variables"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
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
    <!-- Packages                                                         -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>

    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <xsl:function name="djb:compute-regression-parabolic-function" as="map(xs:string, xs:double)">
        <xsl:param name="f:points" as="xs:string+"/>
        <xsl:variable name="n" select="count($points)"/>
        <xsl:variable name="allX" as="xs:double+"
            select="$points ! substring-before(., ',') ! number()"/>
        <xsl:variable name="allY" as="xs:double+"
            select="$points ! substring-after(., ',') ! number()"/>
        <xsl:variable name="sumX" as="xs:double" select="sum($allX)"/>
        <xsl:variable name="sumY" as="xs:double" select="sum($allY)"/>
        <xsl:variable name="sumX2" as="xs:double" select="sum($allX ! math:pow(., 2))"/>
        <xsl:variable name="sumX3" as="xs:double" select="sum($allX ! math:pow(., 3))"/>
        <xsl:variable name="sumX4" as="xs:double" select="sum($allX ! math:pow(., 4))"/>
        <xsl:variable name="sumXY" as="xs:double"
            select="
                sum(for-each-pair($allX, $allY, function ($a, $b) {
                    $a * $b
                }))"/>
        <xsl:variable name="sumX2Y" as="xs:double"
            select="
                sum(for-each-pair($allX, $allY, function ($a, $b) {
                    math:pow($a, 2) * $b
                }))"/>
        <xsl:variable name="sumXXf" as="xs:double" select="$sumX2 - (math:pow($sumX, 2) div $n)"/>
        <xsl:variable name="sumXYf" as="xs:double" select="$sumXY - ($sumX * $sumY) div $n"/>
        <xsl:variable name="sumXX2f" as="xs:double" select="$sumX3 - ($sumX2 * $sumX) div $n"/>
        <xsl:variable name="sumX2Yf" as="xs:double" select="$sumX2Y - ($sumX2 * $sumY) div $n"/>
        <xsl:variable name="sumX2X2f" as="xs:double" select="$sumX4 - math:pow($sumX2, 2) div $n"/>
        <xsl:variable name="a" as="xs:double"
            select="(($sumX2Yf * $sumXXf) - ($sumXYf * $sumXX2f)) div (($sumXXf * $sumX2X2f) - math:pow($sumXX2f, 2))"/>
        <xsl:variable name="b" as="xs:double"
            select="($sumXYf * $sumX2X2f - $sumX2Yf * $sumXX2f) div (($sumXXf * $sumX2X2f) - math:pow($sumXX2f, 2))"/>
        <xsl:variable name="c" as="xs:double"
            select="$sumY div $n - $b * ($sumX div $n) - $a * ($sumX2 div $n)"/>
        <xsl:sequence
            select="
                map {
                    'a': $a,
                    'b': $b,
                    'c': $c
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
        <xsl:variable name="parameters" as="map(xs:string, xs:double)"
            select="djb:compute-regression-parabolic-function($points)"/>
        <xsl:message select="'a: ', $parameters('a')"/>
        <xsl:message select="'b: ', $parameters('b')"/>
        <xsl:message select="'c: ', $parameters('c')"/>
    </xsl:template>
</xsl:stylesheet>

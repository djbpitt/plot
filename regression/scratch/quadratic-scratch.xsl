<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <!-- worksheet for calculation of quadratic linear regression -->
    <!-- https://www.easycalculation.com/statistics/learn-quadratic-regression.php -->
    <!--
        Formula:
        Quadratic Regression Equation(y) = a x^2 + b x + c
        a = { [ Σ x2 y * Σ xx ] - [Σ xy * Σ xx2 ] } / { [ Σ xx * Σ x2x 2] - [Σ xx2 ]2 }
        b = { [ Σ xy * Σ x2x2 ] - [Σ x2y * Σ xx2 ] } / { [ Σ xx * Σ x2x 2] - [Σ xx2 ]2 }
        c = [ Σ y / n ] - { b * [ Σ x / n ] } - { a * [ Σ x 2 / n ] }
        Where ,
        Σ x x = [ Σ x 2 ] - [ ( Σ x )2 / n ]
        Σ x y = [ Σ x y ] - [ ( Σ x * Σ y ) / n ] 
        Σ x x2 = [ Σ x 3 ] - [ ( Σ x 2 * Σ x ) / n ]
        Σ x2 y = [ Σ x 2 y] - [ ( Σ x 2 * Σ y ) / n ]
        Σ x2 x2 = [ Σ x 4 ] - [ ( Σ x 2 )2 / n ]
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
    -->
    <xsl:use-package name="http://www.obdurodon.org/plot_lib"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="inputPoints" as="xs:string" select="'2,3 4,6 6,4'"/>
    <xsl:function name="djb:regression_quadratic" as="item()*">
        <xsl:param name="inputPairs" as="xs:string"/>
        <xsl:variable name="pointPairs" as="xs:string+" select="djb:split_points($inputPoints)"/>
        <xsl:variable name="n" as="xs:integer" select="count($pointPairs)"/>
        <!-- table columns -->
        <xsl:variable name="allX" as="xs:double+"
            select="$pointPairs ! substring-before(., ',') ! number(.)"/>
        <xsl:variable name="allY" as="xs:double+"
            select="$pointPairs ! substring-after(., ',') ! number()"/>
        <xsl:variable name="sumX" as="xs:double" select="sum($allX)"/>
        <xsl:variable name="sumY" as="xs:double" select="sum($allY)"/>
        <xsl:variable name="sumX2" as="xs:double" select="sum($allX ! math:pow(., 2))"/>
        <xsl:variable name="sumX3" as="xs:double" select="sum($allX ! math:pow(., 3))"/>
        <xsl:variable name="sumX4" as="xs:double" select="sum($allX ! math:pow(., 4))"/>
        <xsl:variable name="sumXY" as="xs:double"
            select="
                (for $i in 1 to $n
                return
                    $allX[$i] * $allY[$i]) => sum()"/>
        <xsl:variable name="sumX2Y" as="xs:double"
            select="
                (for $i in 1 to $n
                return
                    math:pow($allX[$i], 2) * $allY[$i])
                => sum()"/>
        <!-- equivalences -->
        <xsl:variable name="sumX.X" as="xs:double" select="$sumX2 - (math:pow($sumX, 2) div $n)"/>
        <xsl:variable name="sumX.Y" as="xs:double" select="$sumXY - ($sumX * $sumY div $n)"/>
        <xsl:variable name="sumX.X2" as="xs:double" select="$sumX3 - ($sumX2 * $sumX div $n)"/>
        <xsl:variable name="sumX2.Y" as="xs:double" select="$sumX2Y - ($sumX2 * $sumY div $n)"/>
        <xsl:variable name="sumX2.X2" as="xs:double"
            select="$sumX4 - (math:pow(($sumX2), 2) div $n)"/>
        <!-- coefficients -->
        <xsl:variable name="a" as="xs:double"
            select="
                (($sumX2.Y * $sumX.X) -
                ($sumX.Y * $sumX.X2))
                div
                (($sumX.X * $sumX2.X2) -
                math:pow($sumX.X2, 2))
                "/>
        <xsl:variable name="b" as="xs:double"
            select="
                ($sumX.Y * $sumX2.X2 -
                $sumX2.Y * $sumX.X2)
                div
                ($sumX.X * $sumX2.X2 -
                math:pow($sumX.X2, 2)
                )
                "/>
        <xsl:variable name="c" as="xs:double"
            select="
                $sumY div $n -
                $b * $sumX div $n -
                $a * $sumX2 div $n
                "/>
        <!-- equation -->
        <xsl:variable name="eq" as="xs:string"
            select="
                concat(
                'y = ',
                $a ! round(., 3),
                'x^2 + ',
                $b ! round(., 3),
                'x + ',
                $c ! round(., 3)
                )"/>
        <xsl:sequence>
            <item>
                <xsl:sequence select="'$allX: ' || string-join($allX, ',')"/>
            </item>
            <item>
                <xsl:sequence select="'$allY: ' || string-join($allY, ',')"/>
            </item>
            <item>
                <xsl:sequence select="'$sumX: ' || $sumX"/>
            </item>
            <item>
                <xsl:sequence select="'$sumY: ' || $sumY"/>
            </item>
            <item>
                <xsl:sequence select="'$sumX2: ' || $sumX2"/>
            </item>
            <item>
                <xsl:sequence select="'$sumX3: ' || $sumX3"/>
            </item>
            <item>
                <xsl:sequence select="'$sumX4: ' || $sumX4"/>
            </item>
            <item>
                <xsl:sequence select="'$sumXY: ' || $sumXY"/>
            </item>
            <item>
                <xsl:sequence select="'$sumX2Y: ' || $sumX2Y"/>
            </item>
            <item>
                <xsl:sequence select="'$sumXX: ' || $sumX.X"/>
            </item>
            <item>
                <xsl:sequence select="'$sumX.Y: ' || $sumX.Y"/>
            </item>
            <item>
                <xsl:sequence select="'$sumX.X2: ' || $sumX.X2"/>
            </item>
            <item>
                <xsl:sequence select="'$sumX2.Y: ' || $sumX2.Y"/>
            </item>
            <item>
                <xsl:sequence select="'$sumX2.X2: ' || $sumX2.X2"/>
            </item>
            <item>
                <xsl:sequence select="'$a: ' || $a"/>
            </item>
            <item>
                <xsl:sequence select="'$b: ' || $b"/>
            </item>
            <item>
                <xsl:sequence select="'$c: ' || $c"/>
            </item>
            <item>
                <xsl:sequence select="$eq"/>
            </item>
        </xsl:sequence>
    </xsl:function>
    <xsl:template name="xsl:initial-template">
        <xsl:sequence select="djb:regression_quadratic($inputPoints)"/>
    </xsl:template>
</xsl:stylesheet>

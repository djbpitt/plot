<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:f="http://www.obdurodon.org/function-variables"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <!--
        https://math.stackexchange.com/questions/335226/convert-segment-of-parabola-to-quadratic-bezier-curve
    -->
    <xsl:output method="xml" indent="yes"/>

    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <xsl:function name="djb:compute-derivative" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:compute-derivative#3                                     -->
        <!--                                                              -->
        <!-- Return first derivative of quadratic (only) function         -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:x : X coordinate                                        -->
        <!--   $f:a : a parameter (ax^2 + bx + c)                         -->
        <!--   $f:b : b parameter (ax^2 + bx + c)                         -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double : f′(x)                                          -->
        <!-- ============================================================ -->
        <xsl:param name="f:x" as="xs:double"/>
        <xsl:param name="f:a" as="xs:double"/>
        <xsl:param name="f:b" as="xs:double"/>
        <xsl:sequence select="(2 * $f:a * $f:x) + $f:b"/>
    </xsl:function>

    <xsl:function name="djb:compute-parabolic-Y" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:compute-parabolic-Y#4                                    -->
        <!--                                                              -->
        <!-- Return ax^2 + bx + c                                         -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:x : X coordinate                                        -->
        <!--   $f:a : a parameter (ax^2 + bx + c)                         -->
        <!--   $f:b : b parameter (ax^2 + bx + c)                         -->
        <!--   $f:c : c parameter (ax^2 + bx + c)                         -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double : Y coordinate                                   -->
        <!-- ============================================================ -->
        <xsl:param name="f:x" as="xs:double"/>
        <xsl:param name="f:a" as="xs:double"/>
        <xsl:param name="f:b" as="xs:double"/>
        <xsl:param name="f:c" as="xs:double"/>
        <xsl:sequence select="math:pow($f:x, 2) * $f:a + $f:x * $f:b + $f:c"/>
    </xsl:function>

    <xsl:function name="djb:compute-control-x" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:compute-control-X#2                                      -->
        <!--                                                              -->
        <!-- Return X coordinate of quadratic Bézier control point        -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:x1 : X coordinate of segment start point                -->
        <!--   $f:x2 : X coordinate of segment end point                  -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double : X coordinate of quadratic Bézier control point -->
        <!-- ============================================================ -->
        <xsl:param name="f:x1" as="xs:double"/>
        <xsl:param name="f:x2" as="xs:double"/>
        <xsl:sequence select="($f:x1 + $f:x2) div 2"/>
    </xsl:function>

    <xsl:function name="djb:compute-control-Y" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:compute-control-Y#5                                      -->
        <!--                                                              -->
        <!-- Return Y coordinate of quadratic Bézier control point        -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:x1 : X coordinate of segment start point                -->
        <!--   $f:x2 : X coordinate of segment end point                  -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double : Y coordinate of quadratic Bézier control point -->
        <!-- ============================================================ -->
        <xsl:param name="f:x1" as="xs:double"/>
        <xsl:param name="f:x2" as="xs:double"/>
        <xsl:param name="f:a" as="xs:double"/>
        <xsl:param name="f:b" as="xs:double"/>
        <xsl:param name="f:c" as="xs:double"/>
        <xsl:sequence
            select="
                djb:compute-parabolic-Y($f:x1, $f:a, $f:b, $f:c) +
                djb:compute-derivative($f:x1, $f:a, $f:b) * (($f:x2 - $f:x1) div 2)
                "
        />
    </xsl:function>

    <!-- ================================================================ -->
    <!-- Stylesheet variables (arbitrary, for testing)                    -->
    <!-- ================================================================ -->
    <xsl:variable name="allX" as="xs:double" select="(-10 to 100) ! xs:double(.)"/>
    <xsl:variable name="a" as="xs:double" select=".05"/>
    <xsl:variable name="b" as="xs:double" select=".025"/>
    <xsl:variable name="c" as="xs:double" select="2"/>

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-10 -110 120 120">
            <!-- ======================================================== -->
            <!-- Axes                                                     -->
            <!-- ======================================================== -->
            <line x1="0" y1="0" x2="100" y2="0" stroke="lightgray" stroke-width="0.5"
                stroke-linecap="square"/>
            <line x1="0" y1="-100" x2="0" y2="0" stroke="lightgray" stroke-width="0.5"
                stroke-linecap="square"/>
            <!-- ======================================================== -->
            <!-- Points                                                   -->
            <!-- ======================================================== -->
            <xsl:for-each select="-10 to 100">
                <circle cx="{current()}" cy="{-1 * djb:compute-parabolic-Y(current(), $a, $b, $c)}"
                    r="0.25" fill="blue"/>
            </xsl:for-each>
            <!-- ======================================================== -->
            <!-- Arbitrary endpoints of parabola segment, for testing     -->
            <!-- ======================================================== -->
            <xsl:variable name="x1" as="xs:double" select="5"/>
            <xsl:variable name="x2" as="xs:double" select="36"/>
            <xsl:variable name="y1" as="xs:double"
                select="-1 * djb:compute-parabolic-Y($x1, $a, $b, $c)"/>
            <xsl:variable name="y2" as="xs:double"
                select="-1 * djb:compute-parabolic-Y($x2, $a, $b, $c)"/>
            <line x1="{$x1}" y1="-110" x2="{$x1}" y2="10" stroke="lightblue" stroke-width="0.25"/>
            <line x1="{$x2}" y1="-110" x2="{$x2}" y2="10" stroke="lightblue" stroke-width="0.25"/>
            <!-- ======================================================== -->
            <!-- $vertexX = (-1 * $b) div (2 * $a)                        -->
            <!-- ======================================================== -->
            <xsl:variable name="vertexX" as="xs:double" select="(-1 * $b) div (2 * $a)"/>
            <line x1="{$vertexX}" y1="-110" x2="{$vertexX}" y2="10" stroke="pink"
                stroke-width="0.25"/>
            <!-- ======================================================== -->
            <!-- Compute quadratic Bézier control point coordinates       -->
            <!-- ======================================================== -->
            <xsl:variable name="controlX" as="xs:double" select="djb:compute-control-x($x1, $x2)"/>
            <xsl:variable name="controlY" as="xs:double"
                select="-1 * djb:compute-control-Y($x1, $x2, $a, $b, $c)"/>
            <!-- ======================================================== -->
            <!-- Plot parabola segment                                    -->
            <!-- ======================================================== -->
            <path d="M{$x1},{$y1} Q{$controlX},{$controlY} {$x2},{$y2}" stroke="red"
                stroke-width="1" fill="none"/>
        </svg>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/regression"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:djb="http://www.obdurodon.org" xmlns:f="http://www.obdurodon.org/function-variables"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:expose component="function" visibility="final"
        names="
        djb:regression-line#2 
        djb:regression-line#1
        "/>
    <!-- ================================================================ -->
    <!-- Package dependencies                                             -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>
    <!-- ================================================================ -->

    <xsl:function name="djb:regression-line">
        <!-- ============================================================ -->
        <!-- name: djb:regression-line#2                                  -->
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
            <xsl:message terminate="yes" select="'Invalid points: ' || $f:point-pairs"/>
        </xsl:if>
        <xsl:variable name="f:n" as="xs:integer" select="count($f:point-pairs)"/>
        <xsl:variable name="f:allX" as="xs:double+"
            select="$f:point-pairs ! substring-before(., ',') ! number(.)"/>
        <xsl:variable name="f:allY" as="xs:double+"
            select="$f:point-pairs ! substring-after(., ',') ! number(.)"/>
        <xsl:variable name="f:sumXY" as="xs:double+"
            select="
            (for $i in 1 to $f:n
            return
            $f:allX[$i] * $f:allY[$i]) => sum()"/>
        <xsl:variable name="f:sumX" as="xs:double" select="sum($f:allX)"/>
        <xsl:variable name="f:sumY" as="xs:double" select="sum($f:allY)"/>
        <xsl:variable name="f:sumX2" as="xs:double" select="$f:allX ! math:pow(., 2) => sum()"/>
        <xsl:variable name="f:m" as="xs:double"
            select="($f:n * $f:sumXY - $f:sumX * $f:sumY) div ($f:n * $f:sumX2 - math:pow($f:sumX, 2))"/>
        <xsl:variable name="f:b" as="xs:double" select="($f:sumY - $f:m * $f:sumX) div $f:n"/>
        <!-- ============================================================ -->
        <!-- Return value                                                 -->
        <!-- ============================================================ -->
        <g xmlns="http://www.w3.org/2000/svg">
            <line x1="{min($f:allX)}" y1="{$f:b}" x2="{max($f:allX)}"
                y2="{$f:m * max($f:allX) + $f:b}" class="regression"/>
        </g>
        <xsl:if test="$f:debug">
            <xsl:sequence select="map {'m' : $f:m, 'b' : $f:b}"/>
        </xsl:if>
    </xsl:function>

    <xsl:function name="djb:regression-line">
        <xsl:param name="points" as="xs:string+"/>
        <xsl:sequence select="djb:regression-line($points, false())"/>
    </xsl:function>
</xsl:package>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/regression"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:djb="http://www.obdurodon.org" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="#all" version="3.0">
    <xsl:expose component="function" visibility="final"
        names="
        djb:regression_line#2 
        djb:regression_line#1
        "/>
    <!-- ================================================================ -->
    <!-- Package dependencies                                             -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot_lib"/>
    <!-- ================================================================ -->

    <xsl:function name="djb:regression_line">
        <!-- ============================================================ -->
        <!-- name: djb:regression_line#2                                  -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $points as xs:string+ : all points in X,Y coordinate form  -->
        <!--   $debug as xs:boolean                                       -->
        <!--                                                              -->
        <!-- Return:                                                      -->
        <!--   element(svg:g) : contains <line>                           -->
        <!--   if $debug, also contains points, polyline, CSS             -->
        <!-- ============================================================ -->
        <xsl:param name="pointPairs" as="xs:string+"/>
        <xsl:param name="debug" as="xs:boolean"/>
        <!-- ============================================================ -->

        <!-- ============================================================ -->
        <!-- Computed values                                              -->
        <!--                                                              -->
        <!-- https://brownmath.com/stat/leastsq.htm                       -->
        <!--   y = mx + b                                                 -->
        <!--   m = ( n∑xy − (∑x)(∑y) ) / ( n∑x² − (∑x)² )                 -->
        <!--   b = ( ∑y − m∑x ) / n                                       -->
        <!-- ============================================================ -->
        <xsl:if test="not(djb:validate_points($pointPairs))">
            <xsl:message terminate="yes" select="'Invalid points: ' || $pointPairs"/>
        </xsl:if>
        <xsl:variable name="n" as="xs:integer" select="count($pointPairs)"/>
        <xsl:variable name="allX" as="xs:double+"
            select="$pointPairs ! substring-before(., ',') ! number(.)"/>
        <xsl:variable name="allY" as="xs:double+"
            select="$pointPairs ! substring-after(., ',') ! number(.)"/>
        <xsl:variable name="sumXY" as="xs:double+"
            select="
            (for $i in 1 to $n
            return
            $allX[$i] * $allY[$i]) => sum()"/>
        <xsl:variable name="sumX" as="xs:double" select="sum($allX)"/>
        <xsl:variable name="sumY" as="xs:double" select="sum($allY)"/>
        <xsl:variable name="sumX2" as="xs:double" select="$allX ! math:pow(., 2) => sum()"/>
        <xsl:variable name="m" as="xs:double"
            select="($n * $sumXY - $sumX * $sumY) div ($n * $sumX2 - math:pow($sumX, 2))"/>
        <xsl:variable name="b" as="xs:double" select="($sumY - $m * $sumX) div $n"/>
        <!-- ============================================================ -->
        <!-- Return value                                                 -->
        <!-- ============================================================ -->
        <g xmlns="http://www.w3.org/2000/svg">
            <xsl:if test="$debug">
                <!-- debug output includes background, data points and connecting polyline -->
                <style><![CDATA[
                    .regression {stroke: red; stroke-width: 1;} 
                    .background {fill: papayawhip;}
                    ]]></style>
                <rect x="{min($allX) - 10}" y="{min($allY) - 10}" width="{max($allX) - min($allX) + 20}"
                    height="{max($allY) - min($allY) + 20}" class="background"/>
                <polyline stroke="lightgray" stroke-width="1" fill="none" points="{$pointPairs}"/>
                <xsl:for-each select="1 to $n">
                    <circle cx="{$allX[current()]}" cy="{$allY[current()]}" r="2" color="lightgray"
                    />
                </xsl:for-each>
            </xsl:if>
            <line x1="{min($allX)}" y1="{$b}" x2="{max($allX)}" y2="{$m * max($allX) + $b}"
                class="regression"/>
        </g>
        <xsl:if test="$debug">
            <xsl:sequence select="map {'m' : $m, 'b' : $b}"/>
        </xsl:if>
    </xsl:function>

    <xsl:function name="djb:regression_line">
        <xsl:param name="points" as="xs:string+"/>
        <xsl:sequence select="djb:regression_line($points, false())"/>
    </xsl:function>
</xsl:package>

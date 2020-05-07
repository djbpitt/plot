<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!--
        https://brownmath.com/stat/leastsq.htm
        m = ( n∑xy − (∑x)(∑y) ) / ( n∑x² − (∑x)² )
        b = ( ∑y − m∑x ) / n
    -->
    <xsl:variable name="points" as="xs:string+"
        select="'50,182', '100,166', '150,87', '200,191', '250,106', '300,73', '350,60', '400,186', '450,118'"/>
    <xsl:variable name="n" as="xs:integer" select="count($points)"/>
    <xsl:variable name="allX" as="xs:double+"
        select="$points ! substring-before(., ',') ! number(.)"/>
    <xsl:variable name="allY" as="xs:double+" select="$points ! substring-after(., ',') ! number(.)"/>
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
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg">
            <g transform="translate(10, {min($allY)})">
                <polyline stroke="black" stroke-width="1" fill="none" points="{$points}"/>
                <line x1="{min($allX)}" y1="{$b}" x2="{max($allX)}" y2="{$m * max($allX) + $b}"
                    stroke="red" stroke-width="1"/>
            </g>
        </svg>
        <xsl:message select="$m || ':' || $b"/>
    </xsl:template>
</xsl:stylesheet>

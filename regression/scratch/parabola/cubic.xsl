<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:f="http://www.obdurodon.org/function-variables"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!--
       https://math.stackexchange.com/questions/335226/convert-segment-of-parabola-to-quadratic-bezier-curve 
    -->
    <xsl:function name="djb:compute-Y" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:compute-Y#2                                              -->
        <!-- ============================================================ -->
        <xsl:param name="f:x" as="xs:double"/>
        <xsl:param name="f:a" as="xs:double"/>
        <xsl:param name="f:c" as="xs:double"/>
        <xsl:sequence select="$f:a * math:pow($f:x, 2) + $f:c"/>
    </xsl:function>
    <xsl:function name="djb:compute-half-parabola" as="xs:string">
        <!-- ============================================================ -->
        <!-- djb:compute-half-parabola#2                                  -->
        <!-- Notes:                                                       -->
        <!-- ============================================================ -->
        <xsl:param name="f:maxX" as="xs:integer"/>
        <xsl:variable name="P1" as="xs:string" select="concat('M0,', -1 * $f:maxX)"/>
        <xsl:variable name="C" as="xs:string" select="concat('Q', $f:maxX div 2, ',', -1 * $f:maxX)"/>
        <xsl:variable name="P2" as="xs:string" select="concat($f:maxX, ',0')"/>
        <xsl:sequence select="string-join(($P1, $C, $P2), ' ')"/>
    </xsl:function>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-110 -110 220 220">
            <xsl:variable name="maxX" as="xs:integer" select="80"/>
            <!-- axes -->
            <line x1="-100" y1="0" x2="100" y2="0" stroke="lightgray" stroke-width="0.5"/>
            <line x1="0" y1="-100" x2="0" y2="100" stroke="lightgray" stroke-width="0.5"/>
            <!-- ruling -->
            <xsl:for-each select="xs:integer(-1 * $maxX div 10) to xs:integer($maxX div 10)">
                <line x1="{current() * 10}" y1="-100" x2="{current() * 10}" y2="100"
                    stroke="lightskyblue" stroke-width="0.5"/>
                <text x="{current() * 10 - .4}" y=".2" text-anchor="end" alignment-baseline="hanging" font-size="3" fill="lightskyblue">
                    <xsl:value-of select="current() * 10"/>
                </text>
            </xsl:for-each>
            <xsl:for-each select="xs:integer(-1 * $maxX div 10) to xs:integer($maxX div 10)">
                <line x1="-100" y1="{current() * 10}" x2="100" y2="{current() * 10}"
                    stroke="lightskyblue" stroke-width="0.5"/>
                <xsl:if test="current() ne 0">
                    <text x="-0.5" y="{current() * 10 + 0.4}" text-anchor="end" alignment-baseline="hanging" font-size="3" fill="lightskyblue">
                    <xsl:value-of select="current() * 10"/>
                </text>
                </xsl:if>
            </xsl:for-each>
            <!--
                Sample: X ranges from -100 to 100
                Y peaks at -100                    
            -->
            <xsl:for-each select="0 to $maxX">
                <!-- symmetrical: maxX = maxY -->
                <circle cx="{current()}" cy="{djb:compute-Y(current(), 1 div $maxX, -1 * $maxX)}"
                    r="1.5" stroke="red" stroke-width="0.25" stroke-opacity="0.5" fill="none"/>
            </xsl:for-each>
            <path d="{djb:compute-half-parabola($maxX)}" stroke="purple" stroke-width="0.5"
                fill="none"/>
        </svg>
    </xsl:template>
</xsl:stylesheet>

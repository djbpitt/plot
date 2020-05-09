<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:f="http://www.obdurodon.org/function"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:function name="djb:expand-to-tenths" as="xs:double+">
        <!-- ============================================================ -->
        <!-- djb:expand-to-tenths                                         -->
        <!--                                                              -->
        <!-- Converts integer range to range of tenths                    -->
        <!--                                                              -->
        <!-- Parameter                                                    -->
        <!--   $half as xs:integer : upper bound of symmetrical range     -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   xs:double+ : symmetrical range in tenths                   -->
        <!-- ============================================================ -->
        <xsl:param name="half" as="xs:integer"/>
        <xsl:if test="$half le 0">
            <xsl:message terminate="yes">Input must be a positive integer</xsl:message>
        </xsl:if>
        <xsl:sequence
            select="
                for $i in (-10 * $half to 10 * $half)
                return
                    $i div 10"
        />
    </xsl:function>
    <xsl:function name="djb:normal" as="xs:double+">
        <!-- ============================================================ -->
        <!-- djb:normal                                                   -->
        <!--                                                              -->
        <!-- Returns Y values of normal curve with X values in tenths     -->
        <!--                                                              -->
        <!-- Parameter                                                    -->
        <!--   $x as xs:double : X coordinate of point on normal curve    -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   xs:double : Y value of point on normal curve               -->
        <!--                                                              -->
        <!-- Notes:                                                       -->
        <!--   Assume μ = 0 and σ = 1                                     -->
        <!-- ============================================================ -->
        <xsl:param name="x" as="xs:double"/>
        <xsl:sequence
            select="
                100 * math:exp(-1 * (math:pow($x, 2)) div 2)
                div
                math:sqrt(2 * math:pi())"
        />
    </xsl:function>
    <xsl:variable name="half" as="xs:integer" select="3"/>
    <xsl:variable name="xScale" as="xs:double" select="10"/>
    <xsl:variable name="yScale" as="xs:double" select="100"/>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-50 -50 110 70">
            <g>
                <xsl:for-each select="0 to 4">
                    <xsl:variable name="xEnd" as="xs:double" select="$xScale * $half"/>
                    <xsl:variable name="yPos" as="xs:double" select="$yScale * current() div -10"/>
                    <line x1="{-1 * $xEnd}" y1="{$yPos}" x2="{$xEnd}" y2="{$yPos}"
                        stroke="lightgray" stroke-width="0.5" stroke-linecap="square"/>
                    <text x="{(-1 * $xEnd) - 1}" y="{$yPos}" text-anchor="end"
                        alignment-baseline="central" font-size="3">
                        <xsl:value-of select="(current() div 10) => format-number('0.0')"/>
                    </text>
                </xsl:for-each>
                <xsl:for-each select="-3 to 3">
                    <xsl:variable name="xPos" as="xs:double" select="current() * $xScale"/>
                    <line x1="{$xPos}" y1="0" x2="{$xPos}" y2="-{.45 * $yScale}" stroke="lightgray"
                        stroke-width="0.5" stroke-linecap="square"/>
                    <text x="{$xPos}" y="5" text-anchor="middle" font-size="3">
                        <xsl:value-of
                            select="
                                if (current() eq 0) then
                                    'μ'
                                else
                                    concat('σ', abs(current()))"
                        />
                    </text>
                </xsl:for-each>

                <xsl:variable name="allX" as="xs:double+" select="djb:expand-to-tenths($half)"/>
                <polyline
                    points="{for $x in ($allX) return string-join(($x * $xScale, -1 * djb:normal($x)), ',')}"
                    stroke="black" stroke-width="1" fill="none"/>
            </g>
            <!--<g transform="translate(0, 400)">
                <xsl:variable name="allY" as="xs:double+" select=""/>
            </g>-->
        </svg>
    </xsl:template>
</xsl:stylesheet>

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
        <xsl:param name="mean" as="xs:double"/>
        <xsl:param name="stddev" as="xs:double"/>
        <xsl:if test="$stddev le 0">
            <xsl:message terminate="yes">Stddev must be greater than 0</xsl:message>
        </xsl:if>
        <xsl:sequence
            select="
                100 * math:exp(-1 * (math:pow($x - $mean, 2)) div (2 * math:pow($stddev, 2)))
                div
                ($stddev * math:sqrt(2 * math:pi()))"
        />
    </xsl:function>

    <xsl:function name="djb:gaussian" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:gaussian() as xs:double                                  -->
        <!--                                                              -->
        <!-- $peak as xs:double : height of curve’s peak                  -->
        <!-- $center as xs:double : X position of center of peak          -->
        <!-- $stddev as xs:double : stddev (controls width of curve)      -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   xs:double, representing Y value corresponding to X         -->
        <!--                                                              -->
        <!-- https://en.wikipedia.org/wiki/Gaussian_function:             -->
        <!-- "The parameter a is the height of the curve's peak, b is the -->
        <!--   position of the center of the peak and c (the standard     -->
        <!--   deviation, sometimes called the Gaussian RMS width)        -->
        <!--   controls the width of the "bell".                          -->
        <!-- ============================================================ -->
        <xsl:param name="x" as="xs:double"/>
        <xsl:param name="peak" as="xs:double"/>
        <xsl:param name="center" as="xs:double"/>
        <xsl:param name="stddev" as="xs:double"/>
        <xsl:if test="$stddev le 0">
            <xsl:message terminate="yes">Stddev must be greater than 0</xsl:message>
        </xsl:if>
        <xsl:sequence
            select="$peak * math:exp(-1 * (math:pow(($x - $mean), 2)) div (2 * math:pow($stddev, 2)))"
        />
    </xsl:function>

    <xsl:variable name="half" as="xs:integer" select="4"/>
    <xsl:variable name="mean" as="xs:double" select="0"/>
    <xsl:variable name="stddev" as="xs:double" select="1"/>
    <xsl:variable name="xScale" as="xs:double" select="10"/>
    <xsl:variable name="yScale" as="xs:double" select="100"/>
    <xsl:variable name="allX" as="xs:double+" select="djb:expand-to-tenths($half)"/>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-50 -110 110 240">
            <g>
                <xsl:for-each select="0 to 10">
                    <!-- horizontal ruling and Y labels-->
                    <xsl:variable name="xEnd" as="xs:double" select="$xScale * $half"/>
                    <xsl:variable name="yPos" as="xs:double" select="$yScale * current() div -10"/>
                    <line x1="{-1 * $xEnd}" y1="{$yPos}" x2="{$xEnd}" y2="{$yPos}"
                        stroke="lightgray" stroke-width="0.5" stroke-linecap="square"/>
                    <text x="{(-1 * $xEnd) - 1}" y="{$yPos}" text-anchor="end"
                        alignment-baseline="central" font-size="3">
                        <xsl:value-of select="(current() div 10) => format-number('0.0')"/>
                    </text>
                </xsl:for-each>
                <xsl:for-each select="$half * -1 to $half">
                    <!-- vertical ruling and X labels -->
                    <xsl:variable name="xPos" as="xs:double" select="current() * $xScale"/>
                    <line x1="{$xPos}" y1="0" x2="{$xPos}" y2="{-1 * $yScale}" stroke="lightgray"
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
                <!-- plot curve-->
                <polyline
                    points="{for $x in ($allX) return string-join(($x * $xScale, -1 * djb:normal($x, $mean, $stddev)), ',')}"
                    stroke="black" stroke-width="1" fill="none"/>
            </g>
            <g transform="translate(0, 120)">
                <xsl:for-each select="0 to 10">
                    <xsl:variable name="yPos" as="xs:double"
                        select="-1 * current() * $yScale div 10"/>
                    <line x1="0" y1="{$yPos}" x2="{10 * $xScale}" y2="{$yPos}" stroke="lightgray"
                        stroke-width="0.5" stroke-linecap="square"/>
                </xsl:for-each>
                <polyline
                    points="{
                    for $x in ($allX) return string-join(($x * $xScale, -1 * djb:gaussian($x, $yScale, 0, 1)), ',')
                    }"
                    stroke="black" stroke-width="1" fill="none"/>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

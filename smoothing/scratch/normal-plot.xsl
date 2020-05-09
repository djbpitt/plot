<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:f="http://www.obdurodon.org/function"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:function name="djb:normal" as="xs:double+">
        <xsl:param name="half" as="xs:integer"/>
        <xsl:if test="$half lt 3">
            <xsl:message terminate="yes">Input must be an integer greater than 3</xsl:message>
        </xsl:if>
        <xsl:sequence
            select="
                for $i in (-1 * $half to $half)
                return
                    100 * math:exp(-1 * ($i * $i) div 2)
                    div
                    math:sqrt(2 * math:pi())"
        />
    </xsl:function>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 -100 500 500">
            <xsl:for-each select="3 to 10">
                <g transform="translate({300 * ((position() - 1) mod 2)},{100 * ((position() - 1) idiv 2)})">
                    <xsl:variable name="allY" select="djb:normal(current())"/>
                    <polyline
                        points="{for-each-pair((-1 * current() to current()), $allY, function($a, $b) {string-join(($a * 10, $b * -1), ',')})}"
                        stroke="black" stroke-width="1" fill="none"/>
                </g>
            </xsl:for-each>
        </svg>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:f="http://www.obdurodon.org/function-variables"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>
    <xsl:function name="djb:plot-points" as="element()+">
        <xsl:param name="f:points" as="xs:string+"/>
        <xsl:param name="f:fill" as="xs:string"/>
        <xsl:for-each select="$f:points">
            <xsl:variable name="f:coordinates" as="xs:string+" select="tokenize(., ',')"/>
            <circle cx="{$f:coordinates[1]}" cy="{$f:coordinates[2]}" r="2" fill="{$f:fill}"/>
        </xsl:for-each>
        <polyline points="{$f:points}" stroke="{$f:fill}" stroke-width="0.5" fill="none"/>
    </xsl:function>
    <xsl:variable name="djb:points" as="xs:string+"
        select="
            for-each-pair(
            (50, 100, 150, 200, 250, 300, 350, 400, 450),
            (182, 166, 87, 191, 106, 73, 60, 186, 118),
            function ($a, $b) {
                string-join(($a, -1 * $b), ',')
            }
            )"/>
    <xsl:variable name="djb:adjusted-points" as="xs:string+"
        select="djb:get-weighted-points($djb:points, 'gaussian', 3, 5)"/>
    <xsl:template name="xsl:initial-template">
        <svg viewBox="0 -150 500 150">
            <g>
                <xsl:sequence select="djb:plot-points($djb:points, 'green')"/>
            </g>
            <g>
                <xsl:sequence select="djb:plot-points($djb:adjusted-points, 'red')"/>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

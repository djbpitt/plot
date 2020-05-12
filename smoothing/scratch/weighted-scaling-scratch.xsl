<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <xsl:use-package name="http://www.obdurodon.org/plot_lib"/>
    <xsl:use-package name="http://www.obdurodon.org/smoothing"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:function name="djb:gaussian_weight" as="xs:double">
        <!--
            focus : offset of center of window
            window : width of window
            points : all Y values
            peak : max Y of returned values
            mean : mean
            stddev : stddev
        -->
        <xsl:param name="focus" as="xs:integer"/>
        <xsl:param name="window" as="xs:integer"/>
        <xsl:param name="points" as="xs:double"/>
        <xsl:param name="peak" as="xs:double"/>
        <xsl:param name="mean" as="xs:double"/>
        <xsl:param name="stddev" as="xs:double"/>
        <circle cx="{$xPos}" cy="-{$yScale * djb:gaussian(current() - 1, 10, 0, 5)}" r="1.5"
            fill="darkgoldenrod" fill-opacity="0.5"/>
    </xsl:function>
    <xsl:variable name="allY" as="xs:double+"
        select="
            djb:random-sequence(100) ! (. * 100)"/>
    <xsl:variable name="points" as="xs:string+"
        select="
            for-each-pair(1 to 100, $allY, function ($a, $b) {
                string-join(($a, -1 * $b), ',')
            })"/>

    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-10 -110 120 120" width="50%">
            <xsl:for-each select="$points">
                <circle cx="{substring-before(current(), ',')}"
                    cy="{substring-after(current(), ',')}" r="0.5"/>
            </xsl:for-each>
            <polyline points="{$points}" stroke="black" stroke-width="0.5" fill="none"/>
        </svg>
    </xsl:template>
</xsl:stylesheet>

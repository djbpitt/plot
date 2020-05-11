<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:use-package name="http://www.obdurodon.org/plot_lib"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>
    <xsl:use-package name="http://www.obdurodon.org/smoothing"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="allY" as="xs:double+" select="djb:random-sequence(100)"/>
    <xsl:variable name="points" as="xs:string+"
        select="
            for-each-pair((1 to 100), $allY, function ($a, $b) {
                string-join(($a * 2, ($b * -100) + 2), ',')
            })"/>
    <xsl:variable name="regression" as="item()+" select="djb:regression_line($points, true())"/>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-10 -110 220 110" width="50%">
            <style type="text/css">
                .regression {
                    stroke: red;
                    stroke-width: 0.5;
                }</style>
            <g>
                <line x1="0" y1="-100" x2="0" y2="0" stroke="lightgray" stroke-width="0.5"/>
                <line x1="0" y1="{$regression[2]?b}" x2="200" y2="{$regression[2]?b}"
                    stroke="lightgray" stroke-width="0.5"/>
                <polyline points="{$points}" stroke="black" stroke-width="0.5" fill="none"/>
                <xsl:sequence select="$regression[1]"/>
                <polyline points="{djb:smoothing($points, 9)}" stroke="blue" stroke-width="0.5"
                    fill="none"/>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <xsl:function name="djb:decimal-to-hex" as="xs:string*">
        <!--
            Adapted for XSLT 3.1 from
            https://gist.github.com/xpathr/2653476 (license information not available)
            by David J. Birnbaum 2019-10-30
            MIT License
        -->
        <xsl:param name="in" as="xs:double"/>
        <xsl:variable name="results" as="xs:string+">
            <xsl:if test="$in gt 0">
                <xsl:sequence select="djb:decimal-to-hex(floor($in div 16))"/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$in mod 16 lt 10">
                    <xsl:value-of select="$in mod 16"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="codepoints-to-string(xs:integer($in mod 16 + 55))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="replace(string-join($results), '^0+', '')"/>
    </xsl:function>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template name="xsl:initial-template">
        <root>
            <xsl:for-each select="(57366, 57383, 57346)">
                <ex>
                    <xsl:value-of select="djb:decimal-to-hex(.)"/>
                </ex>
            </xsl:for-each>
        </root>
    </xsl:template>
</xsl:stylesheet>

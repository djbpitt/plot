<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:djb="http://www.obdurodon.org"
    exclude-result-prefixes="#all" version="3.0">
    <xsl:output method="xml" indent="yes" item-separator="|"/>
    <xsl:function name="djb:value" as="item()*">
        <xsl:param name="stem" as="xs:string"/>
        <xsl:param name="stress_pos" as="xs:integer"/>
        <xsl:param name="ending" as="xs:string"/>
        <xsl:value-of select="substring($stem, 1, $stress_pos - 1)"/>
        <stress>
            <xsl:value-of select="substring($stem, $stress_pos, 1)"/>
        </stress>
        <xsl:value-of select="substring($stem, $stress_pos + 1)"/>
        <xsl:value-of select="$ending"/>
    </xsl:function>
    <xsl:function name="djb:sequence" as="item()*">
        <xsl:param name="stem" as="xs:string"/>
        <xsl:param name="stress_pos" as="xs:integer"/>
        <xsl:param name="ending" as="xs:string"/>
        <xsl:sequence select="substring($stem, 1, $stress_pos - 1)"/>
        <stress>
            <xsl:sequence select="substring($stem, $stress_pos, 1)"/>
        </stress>
        <xsl:sequence select="substring($stem, $stress_pos + 1)"/>
        <xsl:sequence select="$ending"/>
    </xsl:function>
    <xsl:template match="/">
        <root>
            <variable>
                <xsl:sequence select="djb:value('potato', 4, 'es')"/>
            </variable>
            <sequence>
                <xsl:sequence select="djb:sequence('potato', 4, 'es')"/>
            </sequence>
        </root>
    </xsl:template>
</xsl:stylesheet>

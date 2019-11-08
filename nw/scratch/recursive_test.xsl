<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <!-- 
        Causes stack overflow at 1896 
        Can it be fixed with <xsl:iterate>
    -->
    <xsl:function name="djb:stuff" as="xs:integer*">
        <xsl:param name="in" as="xs:integer*"/>
        <xsl:message select="count($in)"/>
        <xsl:variable name="new" as="xs:integer*" select="$in, $in[last()] + 1"/>
        <xsl:sequence select="djb:stuff($new)"/>
    </xsl:function>
    <xsl:template name="xsl:initial-template">
        <xsl:sequence select="djb:stuff(1)"/>
    </xsl:template>
</xsl:stylesheet>

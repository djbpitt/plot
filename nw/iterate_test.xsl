<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <!--
        No stack overflow
        Compare to recursive_test.xsl
    -->
    <xsl:template name="xsl:initial-template">
        <xsl:iterate select="1 to 1000000">
            <xsl:param name="in" as="xs:integer*" select="1"/>
            <xsl:variable name="new" as="xs:integer*" select="$in, $in[last()] + 1"/>
            <xsl:message select="count($in)"/>
            <xsl:next-iteration>
                <xsl:with-param name="in" as="xs:integer*" select="$new"/>
            </xsl:next-iteration>
        </xsl:iterate>
    </xsl:template>
</xsl:stylesheet>

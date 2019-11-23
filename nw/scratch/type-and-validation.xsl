<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <!--
        Create element with @xsl:validation equal to 'preserve'
            This preserves type annotation on attributes and children
        Create attribute with @xsl:type to specify type
        Avoid having to cast attributes to use them as numeric in subsequent processing
    -->
    <xsl:variable name="cells" as="element(cell)+">
        <cell xsl:validation="preserve">
            <xsl:attribute name="n" type="xs:integer">11</xsl:attribute>
            <xsl:text>x</xsl:text>
        </cell>
        <cell xsl:validation="preserve">
            <xsl:attribute name="n" type="xs:integer">2</xsl:attribute>
            <xsl:text>x</xsl:text>
        </cell>
    </xsl:variable>
    <xsl:template name="xsl:initial-template">
        <xsl:perform-sort select="$cells">
            <xsl:sort select="@n"/>
        </xsl:perform-sort>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="no"/>
    <xsl:template name="xsl:initial-template" match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="/*">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:attribute name="n" select="generate-id()"/>
            <xsl:attribute name="type" select="'start'"/>
        </xsl:element>
        <xsl:apply-templates/>
        <xsl:element name="{name()}">
            <xsl:attribute name="n" select="generate-id()"/>
            <xsl:attribute name="type" select="'end'"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>

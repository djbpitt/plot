<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:f="urn:stylesheet-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:import href="levenstein.xsl"/>
    <xsl:output method="text" indent="no"/>
    <xsl:variable name="ebb" select="'Elisa Beshero Bondar'" as="xs:string"/>
    <xsl:variable name="mrm" select="'Mary Russell Mitford'" as="xs:string"/>
    <xsl:template name="xsl:initial-template">
        <xsl:value-of select="f:levenshtein($ebb, $mrm)"/>
    </xsl:template>
</xsl:stylesheet>
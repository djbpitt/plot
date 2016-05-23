<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:import href="bitmask.xsl"/>
    <xsl:template match="/">
        <xsl:value-of select="djb:lpad('1', 10)"/>
    </xsl:template>
</xsl:stylesheet>
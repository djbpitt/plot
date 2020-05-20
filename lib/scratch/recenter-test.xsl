<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template name="xsl:initial-template">
        <root>
            <xsl:sequence select="djb:recenter((1 to 10), 10, 13)"/>
        </root>
    </xsl:template>
</xsl:stylesheet>

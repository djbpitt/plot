<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:key name="cellByRowCol" match="cell" use="@row/number()"/>
    <xsl:variable name="cells" as="document-node(element(cells))">
        <xsl:document>
            <cells>
                <cell row='1' col='1'>a</cell>
                <cell row='1' col='2'>b</cell>
                <cell row='2' col='1'>c</cell>
                <cell row='2' col='2'>d</cell>
            </cells>
        </xsl:document>
    </xsl:variable>
    <xsl:template name="xsl:initial-template">
        <xsl:sequence select="key('cellByRowCol', 1, $cells)"/>
    </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="text"/>
    <xsl:variable name="root" as="document-node()" select="/"/>
    <xsl:template match="/">
        <root xmlns="http://www.w3.org/1998/Math/MathML">
            <xsl:for-each-group select="values/*" group-by="name()">
                <xsl:element name="{current-grouping-key()}">
                    <xsl:variable name="times" as="xs:double+">
                        <xsl:for-each select="current-group()">
                            <xsl:value-of select="min * 60 + sec"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of separator="" select="current-grouping-key(), ': ', $times => sort() => subsequence(2,3) => avg() => round(3), '&#x0a;'"/>
                </xsl:element>
            </xsl:for-each-group>
        </root>
    </xsl:template>
</xsl:stylesheet>

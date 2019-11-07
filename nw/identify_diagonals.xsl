<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <!-- 
        Scratch pad to find cell positions by diagonal
        Number of diagonals is sum of string-lengths + 1
        In x,y pair, x = row and y = column 
            2,2 is 0; strings begin at 3,1 and 1,3
    -->
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:variable name="top" as="xs:string" select="'kitten'"/>
    <xsl:variable name="left" as="xs:string" select="'sitting'"/>
    <xsl:variable name="topLength" as="xs:integer" select="string-length($top)"/>
    <xsl:variable name="leftLength" as="xs:integer" select="string-length($left)"/>
    <xsl:template name="xsl:initial-template">
        <xsl:for-each select="1 to (string-length($top) + string-length($left) + 1)">
            <xsl:variable name="rowNo" as="xs:integer"
                select="
                    if (. le string-length($left) + 1) then
                        . + 1
                    else
                        string-length($left) + 2"/>
            <row>
                <xsl:variable name="firstCol" as="xs:integer"
                    select="2"/>
                <xsl:variable name="lastCol" as="xs:integer" select="$rowNo"/>
                <xsl:for-each select="$firstCol to $lastCol">
                    <xsl:variable name="colNo" as="xs:integer" select="if (position() le $topLength + 1) then . else 100"/>
                    <xsl:value-of select="string-join(('[', $rowNo + 1 - position(), ',', $colNo, '] '))"/>
                </xsl:for-each>
            </row>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>

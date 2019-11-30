<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <!-- 
        DocBook <table> has <title> and <tgroup cols="x"> children
        <tgroup> has a <tbody> child
        <tbody> has <row> children, which has <entry> children
    -->
    <xsl:variable name="csv" select="unparsed-text-lines('timings.csv')"/>
    <xsl:template name="xsl:initial-template">
        <table>
            <title>EE and HE performance</title>
            <tgroup cols="{count(tokenize($csv[1], ','))}">
                <thead>
                    <row>
                        <xsl:for-each select="tokenize($csv[1], ',')">
                            <entry align="center">
                                <xsl:value-of select="."/>
                            </entry>
                        </xsl:for-each>
                    </row>
                </thead>
                <tbody>
                    <xsl:for-each select="$csv[position() gt 1]">
                        <row>
                            <xsl:for-each select="tokenize(current(), ',')">
                                <entry align="right">
                                    <xsl:value-of select="."/>
                                </entry>
                            </xsl:for-each>
                        </row>
                    </xsl:for-each>
                </tbody>
            </tgroup>
        </table>
    </xsl:template>
</xsl:stylesheet>

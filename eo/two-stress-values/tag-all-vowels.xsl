<?xml version="1.0" encoding="UTF-8"?>

<!--
    eo stress count, file 2 of 5
    
    filename: tag-all-vowels.xsl
    Input: eo.xml
    Output: eo_all-vowels-tagged.xml
    
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- Identity transformation as default -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- Transform <stress> to <vowel stress="1"> -->
    <xsl:template match="stress">
        <vowel stress="1">
            <xsl:apply-templates/>
        </vowel>
    </xsl:template>
    <!-- 
        Use regex to find unstressed vowels in <line> elements
        Tag as <vowel stress="0">
    -->
    <xsl:template match="line/text()">
        <xsl:analyze-string select="." regex="[аэыоуяеиёю]" flags="i">
            <xsl:matching-substring>
                <vowel stress="0">
                    <xsl:value-of select="."/>
                </vowel>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="root" as="document-node()" select="/"/>
    <xsl:variable name="maxVowelPosition" as="xs:integer" select="max(//line/count(vowel))"/>
    <xsl:key name="vowelByPosition" match="vowel" use="count(preceding-sibling::vowel) + 1"/>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/">
        <positions>
            <xsl:for-each select="1 to $maxVowelPosition">
                <xsl:variable name="vowelsAtPosition" as="element(vowel)+"
                    select="$root/key('vowelByPosition', current())"/>
                <xsl:variable name="stressedAtPosition" as="element(vowel)*"
                    select="$vowelsAtPosition[@stress = '1']"/>
                <xsl:variable name="unstressedAtPosition" as="element(vowel)*"
                    select="$vowelsAtPosition[@stress = '-1']"/>
                <xsl:variable name="ambiguousAtPosition" as="element(vowel)*"
                    select="$vowelsAtPosition[@stress = '0']"/>
                <position n="{current()}" total="{count($vowelsAtPosition)}"
                    stressed="{count($stressedAtPosition)}"
                    unstressed="{count($unstressedAtPosition)}"
                    ambiguous="{count($ambiguousAtPosition)}"/>
            </xsl:for-each>
        </positions>
    </xsl:template>
</xsl:stylesheet>

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
        <xsl:variable name="offsets" as="element(offset)+">
            <xsl:for-each select="1 to $maxVowelPosition">
                <xsl:variable name="vowelsAtPosition" as="element(vowel)+"
                    select="$root/key('vowelByPosition', current())"/>
                <xsl:variable name="stressedAtPosition" as="element(vowel)*"
                    select="$vowelsAtPosition[@stress = '1']"/>
                <xsl:variable name="unstressedAtPosition" as="element(vowel)*"
                    select="$vowelsAtPosition[@stress = '-1']"/>
                <xsl:variable name="ambiguousAtPosition" as="element(vowel)*"
                    select="$vowelsAtPosition[@stress = '0']"/>
                <offset n="{current()}" total="{count($vowelsAtPosition)}"
                    stressed="{count($stressedAtPosition)}"
                    unstressed="{count($unstressedAtPosition)}"
                    ambiguous="{count($ambiguousAtPosition)}"/>
            </xsl:for-each>
        </xsl:variable>
        <report>
            <xsl:apply-templates select="$offsets">
                <xsl:with-param name="offsets" select="$offsets"/>
            </xsl:apply-templates>
        </report>
    </xsl:template>
    <xsl:template match="offset">
        <xsl:param name="offsets"/>
        <xsl:variable name="selfRatio" as="xs:double"
            select="@stressed div (@stressed + @unstressed)"/>
        <xsl:variable name="precedingRatio" as="xs:double">
            <xsl:variable name="preceding" as="element(position)?"
                select="$offsets[position() eq current()/position() - 1]"/>
            <xsl:variable name="precedingSum" as="xs:double?"
                select="sum($preceding/@stressedAtPosition, $preceding/@untressedAtPosition)"/>
            <xsl:choose>
                <xsl:when test="position() eq 1">0</xsl:when>
                <xsl:when test="$precedingSum eq 0">0</xsl:when>
                <!--<xsl:otherwise>
                    <xsl:value-of select="$preceding/@stressed div $precedingSum"/>
                </xsl:otherwise>-->
                <xsl:otherwise>
                    <xsl:value-of select="$precedingSum"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <item n="{@n}" selfRatio="{$selfRatio}" precedingSum="{$precedingRatio}"/>
    </xsl:template>
</xsl:stylesheet>

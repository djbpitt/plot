<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:djb="http://www.obdurodon.org"
    exclude-result-prefixes="#all" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="vowels" as="xs:string+" select="'a', 'e', 'i', 'o', 'u', 'y'"/>
    <xsl:function name="djb:value" as="item()*">
        <!-- correct output, passes test, validates input parameters -->
        <xsl:param name="stem" as="xs:string"/>
        <xsl:param name="stress_pos" as="xs:integer"/>
        <xsl:param name="ending" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$stress_pos lt 1">
                <!-- $stress_pos is less than 1 -->
                <xsl:message terminate="no">Error in djb:value() input: $stress_pos is less than 1</xsl:message>
            </xsl:when>
            <xsl:when test="string-length($stem) lt $stress_pos">
                <!-- stem is too short -->
                <xsl:message terminate="no">Error in djb:value() input: $stem is shorter than $stress_pos</xsl:message>
            </xsl:when>
            <xsl:when test="not(lower-case(substring($stem, $stress_pos, 1)) = $vowels)">
                <!-- stress would fall on a consonant -->
                <xsl:message terminate="no">Stress would fall on a consonant</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring($stem, 1, $stress_pos - 1)"/>
                <stress>
                    <xsl:value-of select="substring($stem, $stress_pos, 1)"/>
                </stress>
                <xsl:value-of select="substring($stem, $stress_pos + 1)"/>
                <xsl:value-of select="$ending"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="djb:value-min" as="item()*">
        <!-- <xsl:value-of> creates correct output and passes test -->
        <xsl:param name="stem" as="xs:string"/>
        <xsl:param name="stress_pos" as="xs:integer"/>
        <xsl:param name="ending" as="xs:string"/>
        <xsl:value-of select="substring($stem, 1, $stress_pos - 1)"/>
        <stress>
            <xsl:value-of select="substring($stem, $stress_pos, 1)"/>
        </stress>
        <xsl:value-of select="substring($stem, $stress_pos + 1)"/>
        <xsl:value-of select="$ending"/>
    </xsl:function>
    <xsl:function name="djb:sequence" as="item()*">
        <!-- <xsl:sequence> creates incorrect output and fails test -->
        <xsl:param name="stem" as="xs:string"/>
        <xsl:param name="stress_pos" as="xs:integer"/>
        <xsl:param name="ending" as="xs:string"/>
        <xsl:sequence select="substring($stem, 1, $stress_pos - 1)"/>
        <stress>
            <xsl:sequence select="substring($stem, $stress_pos, 1)"/>
        </stress>
        <xsl:sequence select="substring($stem, $stress_pos + 1)"/>
        <xsl:sequence select="$ending"/>
    </xsl:function>
    <xsl:template match="/">
        <root>
            <minimum>
                <sequence type="incorrect">
                    <xsl:sequence select="djb:sequence('potato', 4, 'es')"/>
                </sequence>
                <variable type="correct">
                    <xsl:sequence select="djb:value-min('potato', 4, 'es')"/>
                </variable>
            </minimum>
            <full>
                <short-stem type="bad-input">
                    <xsl:sequence select="djb:value('po', 4, 'es')"/>
                </short-stem>
                <no-stem type="bad-input">
                    <xsl:sequence select="djb:value('', 4, 'es')"/>
                </no-stem>
                <bad-pos type="bad-input">
                    <xsl:sequence select="djb:value('potato', -1, 'es')"/>
                </bad-pos>
                <bad-pos type="bad-input">
                    <xsl:sequence select="djb:value('potato', 0, 'es')"/>
                </bad-pos>
                <consonant-stress type="bad-input">
                    <xsl:sequence select="djb:value('potato', 3, 'es')"/>
                </consonant-stress>
                <variable type="correct">
                    <xsl:sequence select="djb:value('potato', 4, 'es')"/>
                </variable>
            </full>
        </root>
    </xsl:template>
</xsl:stylesheet>

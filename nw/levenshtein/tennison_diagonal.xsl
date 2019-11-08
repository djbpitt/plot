<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="stuff"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:function name="my:LevenshteinDistanceC" as="xs:integer">
        <xsl:param name="string1" as="xs:string"/>
        <xsl:param name="string2" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$string1 = ''">
                <xsl:sequence select="string-length($string2)"/>
            </xsl:when>
            <xsl:when test="$string2 = ''">
                <xsl:sequence select="string-length($string1)"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- djb: Use characters instead of codepoints for legibility -->
                <xsl:sequence
                    select="
                        my:LevenshteinDistanceC(
                        for $i in string-to-codepoints($string1) return codepoints-to-string($i),
                        for $i in string-to-codepoints($string2) return codepoints-to-string($i),
                        string-length($string1),
                        string-length($string2),
                        (1, 0, 1),
                        2)"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="my:LevenshteinDistanceC" as="xs:integer">
        <xsl:param name="chars1" as="xs:string*"/>
        <xsl:param name="chars2" as="xs:string*"/>
        <xsl:param name="length1" as="xs:integer"/>
        <xsl:param name="length2" as="xs:integer"/>
        <xsl:param name="lastDiag" as="xs:integer*"/>
        <xsl:param name="total" as="xs:integer"/>
        <xsl:variable name="shift" as="xs:integer"
            select="
                if ($total > $length2) then
                    ($total - ($length2 + 1))
                else
                    0"/>
        <xsl:variable name="diag" as="xs:integer*">
            <xsl:for-each
                select="
                    max((0, $total - $length2)) to
                    min(($total, $length1))">
                <xsl:variable name="i" as="xs:integer" select="."/>
                <xsl:variable name="j" as="xs:integer" select="$total - $i"/>
                <xsl:variable name="d" as="xs:integer" select="($i - $shift) * 2"/>
                <xsl:if test="$j &lt; $length2">
                    <xsl:sequence select="$lastDiag[$d - 1]"/>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$i = 0">
                        <xsl:sequence select="$j"/>
                    </xsl:when>
                    <xsl:when test="$j = 0">
                        <xsl:sequence select="$i"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence
                            select="
                                min(($lastDiag[$d - 1] + 1,
                                $lastDiag[$d + 1] + 1,
                                $lastDiag[$d] +
                                (if ($chars1[$i] eq $chars2[$j]) then
                                    0
                                else
                                    1)))"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$total = $length1 + $length2">
                <xsl:sequence select="exactly-one($diag)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence
                    select="
                        my:LevenshteinDistanceC(
                        $chars1, $chars2,
                        $length1, $length2,
                        $diag, $total + 1)"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="s1" as="xs:string" select="'kitten'"/>
        <xsl:variable name="s2" as="xs:string" select="'sitting'"/>
        <xsl:value-of select="my:LevenshteinDistanceC($s1, $s2)"/>
    </xsl:template>
</xsl:stylesheet>

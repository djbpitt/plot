<?xml version="1.0" encoding="UTF-8"?>
<!-- find_strong-and-weak.xsl
    
    Input: eo.xml
    
    In the input, all vowels are tagged as <vowel> with a @stress attribute, the value of which must be one of
        -1 'unstressed', 1 'stressed' or 0 'stress unknown'
        
    Output is a list of vocalic positions across the line, where strong positions have a valence of 1 and weak of 0
    
    Method described at http://poetry.obdurodon.org/metrical-analysis.xhtml
    
    This routine does not yet determine the meter; it stops after finding strong and weak positions
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:djb="http://www.obdurodon.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="root" as="document-node()" select="/"/>
    <xsl:variable name="maxVowelPosition" as="xs:integer" select="max(//line/count(vowel))"/>
    <xsl:key name="vowelByPosition" match="vowel" use="count(preceding-sibling::vowel) + 1"/>
    <xsl:function name="djb:ratio" as="xs:double">
        <!-- Returns stressed count divided by sum of stressed and unstressed (ignores unknowns) -->
        <xsl:param name="offset" as="element(offset)"/>
        <xsl:variable name="ratio" as="xs:double"
            select="
                if (sum($offset/@stressed, $offset/@unstressed) eq 0) then
                    0
                else
                    $offset/@stressed div sum(($offset/@stressed, $offset/@unstressed))"/>
        <xsl:sequence select="$ratio"/>
    </xsl:function>
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
            <xsl:for-each select="1 to count($offsets)">
                <xsl:variable name="selfRatio" as="xs:double"
                    select="djb:ratio($offsets[current()])"/>
                <xsl:variable name="precedingRatio" as="xs:double?"
                    select="
                        if (current() gt 1) then
                            djb:ratio($offsets[current() - 1])
                        else
                            0"/>
                <xsl:variable name="followingRatio" as="xs:double?"
                    select="
                        if (current() lt count($offsets)) then
                            djb:ratio($offsets[current() + 1])
                        else
                            0"/>
                <!-- Calculate valence -->
                <!-- Postion is strong (1) when self is greater than both neighors; otherwise position is weak (0) -->
                <xsl:variable name="valence" as="xs:integer">
                    <xsl:choose>
                        <xsl:when
                            test="$selfRatio gt $precedingRatio and $selfRatio gt $followingRatio"
                            >1</xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- Done! -->
                <item n="{current()}" valence="{$valence}"/>
            </xsl:for-each>
        </report>
    </xsl:template>
</xsl:stylesheet>

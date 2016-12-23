<?xml version="1.0" encoding="UTF-8"?>

<!--
    eo stress count, file 4 of 5
    
    filename: create-stress-report.xsl
    Input: eo_all-vowels-tagged.xml
    Output: stress-report.xml
    
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- Save document node in variable so that it will be accessible in for-each over atomic values-->
    <xsl:variable name="root" as="document-node()" select="/"/>
    <!-- Maximum number of vowel positions in a line -->
    <xsl:variable name="max-vowels" as="xs:integer" select="max(//line/count(vowel))"/>
    <xsl:template match="/">
        <valences>
            <xsl:for-each select="1 to $max-vowels">
                <!-- Sequence of all <vowel> elements in current position in all lines -->
                <xsl:variable name="vowels_at_position" as="element(vowel)*"
                    select="$root//line/vowel[position() = current()]"/>
                <xsl:variable name="position_count" as="xs:integer"
                    select="count($vowels_at_position)"/>
                <xsl:variable name="stressed_count" as="xs:integer"
                    select="count($vowels_at_position[@stress eq '1'])"/>
                <position offset="{.}" vowel-count="{$position_count}" stress-count="{$stressed_count}"/>
            </xsl:for-each>
        </valences>
    </xsl:template>
</xsl:stylesheet>

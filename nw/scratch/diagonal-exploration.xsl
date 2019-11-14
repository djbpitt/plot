<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:key name="cellByRowCol" match="cell" use="(@row, @col)" composite="yes"/>
    <xsl:template name="xsl:initial-template">
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- top and left strings and their lengths                -->
        <!--   $top, $top_len, $left, $left_len                    -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="top" as="xs:string+" select="'k', 'i', 't'"/>
        <xsl:variable name="top_len" as="xs:integer" select="count($top)"/>
        <xsl:variable name="left" as="xs:string+" select="'d', 'o', 'l', 't'"/>
        <xsl:variable name="left_len" as="xs:integer" select="count($left)"/>
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- scores for gap, match, and mismatch .                 -->
        <!--   $gap_inc, $match_inc, $mismatch_inc                 -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="gap_inc" as="xs:integer" select="-2"/>
        <xsl:variable name="match_inc" as="xs:integer" select="1"/>
        <xsl:variable name="mismatch_inc" as="xs:integer" select="-1"/>
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- number of diagonals =                                 -->
        <!-- sum of counts of the sequences - 1                    -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="diag_count" as="xs:integer" select="$top_len + $left_len - 1"/>
        <!-- -->
        <!-- Procedure:
            1. Create <cell> with 
                @row, @col: calculated by looping through diagonal
                @match: use @row and @col to read values from $top and $left by position()
            2. a) find each neighbor using @row and @col key
               b) read appropriate score input (@gap-score, @match-score, @mismmatch-score) from it
               c) use these to compute and choose new cell value and ascertain which neighbor was source (d, l, u)
            3. write new value into cell
            4. @direction copied from source, with its direction added at the end (cumulative)
            5. Use known value to calculate and store @gap-score, @match-score, @mismatch-score

            length of diagonal is available inside iteration as $diag
            number of items in each sequence is available as template variables $top_len and $left_len
            sequence items are available as template variables $top and $left
            $gap-inc, $match-inc, and $mismatch-inc are increments available as template variables
        -->
        <xsl:iterate select="1 to $diag_count">
            <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
            <!-- neighbors are on last two diagonals               -->
            <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
            <xsl:param name="ult" as="element(cell)*"/>
            <xsl:param name="penult" as="element(cell)*"/>
            <xsl:variable name="search_space" as="element(cell)*" select="$ult | $penult"/>
            <!-- process each diagonal -->
            <xsl:variable name="diag" as="xs:integer" select="."/>
            <xsl:message select="'Processing diag', $diag"/>
            <diag n="{$diag}">
                <xsl:for-each select="max((1, $diag - $top_len)) to min(($diag, $top_len))">
                    <xsl:variable name="col" as="xs:integer" select="."/>
                    <xsl:for-each select="$diag - $col + 1">
                        <xsl:variable name="row" as="xs:integer" select="."/>
                        <xsl:value-of separator="" select="'[', $row, ',', $col, '] '"/>
                    </xsl:for-each>
                </xsl:for-each>
            </diag>
            <xsl:next-iteration>
                <xsl:with-param name="ult">
                    <cell/>
                </xsl:with-param>
                <xsl:with-param name="penult">
                    <cell/>
                </xsl:with-param>
            </xsl:next-iteration>
        </xsl:iterate>
    </xsl:template>
</xsl:stylesheet>

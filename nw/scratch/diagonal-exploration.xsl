<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:key name="cellByRowCol" match="cell" use="(@row, @col)" composite="yes"/>
    <xsl:function name="djb:get_diag_cells" as="element(diag)+">
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- djb:get_diag_cells()                                  -->
        <!-- returns all cell in specified diagonal .              -->
        <!-- parameters:                                           -->
        <!--   $diag as xs:integer                                 -->
        <!--   @left_len xs:integer (total number of rows)         -->
        <!--   @ltop_len xs:integer (total number of columns)      -->
        <!-- return: <diag>, with $diag as @n and <cell> contents  -->
        <!--   note: <cell> elements specify @row and @col         -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:param name="diag" as="xs:integer"/>
        <xsl:param name="left_len" as="xs:integer"/>
        <xsl:param name="top_len" as="xs:integer"/>
        <!--
            $row_start is 1 until $top_len, then augment by $diag - $top_len to
                shift down one row (wrapping around upper right corner)
            $col is $diag - $row + 1 (otherwise would start at 0, since $diag 1
                has [1,1])
            based on https://www.jenitennison.com/2007/05/06/levenshtein-distance-on-the-diagonal.html 
        -->
        <xsl:if test="($diag, $left_len, $top_len) &lt; 1">
            <xsl:message terminate="yes"
                select="'$diag, $top_len, and $left_len must all be positive integers'"/>
        </xsl:if>
        <xsl:if test="$diag gt sum(($top_len, $left_len, -1))">
            <xsl:message terminate="yes"
                select="'$diag cannot be greater than $left_len + $top_len - 1'"/>
        </xsl:if>
        <xsl:variable name="shift" as="xs:integer"
            select="
                if ($diag gt $top_len) then
                    ($diag - $top_len)
                else
                    0"/>
        <xsl:variable name="row_start" as="xs:integer" select="1 + $shift"/>
        <xsl:variable name="row_end" as="xs:integer" select="min(($diag, $left_len))"/>
        <diag n="{$diag}">
            <xsl:for-each select="$row_start to $row_end">
                <xsl:variable name="row" as="xs:integer" select="."/>
                <xsl:variable name="col" as="xs:integer" select="$diag - $row + 1"/>
                <cell row="{$row}" col="{$col}"/>
            </xsl:for-each>
        </diag>
    </xsl:function>
    <xsl:function name="djb:create_grid" as="element(diag)+">
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- djb:create_grid()                                     -->
        <!-- finds all cells in grid, organized by diagonal        -->
        <!-- parameters:                                           -->
        <!--   $left_len as xs:integer()                           -->
        <!--   $top_len as xs:integer                              -->
        <!-- returns:                                              -->
        <!--   element(diag)+ (from djb:get_diag_cells) .          -->
        <!-- dependencies:                                         -->
        <!--   calls djb:get_diag_cells() for each diagonal        -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:param name="left_len" as="xs:integer"/>
        <xsl:param name="top_len" as="xs:integer"/>
        <xsl:if test="($left_len, $top_len) &lt; 1">
            <xsl:message terminate="yes"
                select="'$left_len and $top_len must both be positive integers'"/>
        </xsl:if>
        <xsl:variable name="diag_count" as="xs:integer" select="$top_len + $left_len - 1"/>
        <xsl:for-each select="1 to $diag_count">
            <xsl:sequence select="djb:get_diag_cells(., $left_len, $top_len)"/>
        </xsl:for-each>
    </xsl:function>
    <xsl:function name="djb:grid_as_html_table" as="element(html:table)">
        <xsl:param name="in" as="element(diag)+"/>
        <xsl:variable name="row_count" as="xs:integer" select="max($in//@row) => xs:integer()"/>
        <xsl:variable name="col_count" as="xs:integer"
            select="max($in//@col/number()) => xs:integer()"/>
        <table xmlns="http://www.w3.org/1999/xhtml">
            <xsl:for-each select="1 to $row_count">
                <xsl:variable name="row" as="xs:integer" select="."/>
                <tr>
                    <xsl:for-each select="1 to $col_count">
                        <xsl:variable name="col" as="xs:integer" select="."/>
                        <td>
                            <xsl:value-of separator="" select="'[', $row, ',', $col, ']'"/>
                        </td>
                    </xsl:for-each>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:function>
    <xsl:template name="xsl:initial-template">
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- top and left strings and their lengths                -->
        <!--   $top, $top_len, $left, $left_len                    -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="top" as="xs:string+" select="'k', 'i', 't'"/>
        <xsl:variable name="top_len" as="xs:integer" select="count($top)"/>
        <xsl:variable name="left" as="xs:string+" select="'s', 'i', 't', 't', 'i'"/>
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
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Diagonal exploration</title>
            </head>
            <body>
                <h1>Diagonal exploration</h1>
                <h2>
                    <xsl:sequence select="$left_len, 'rows x', $top_len, 'columns'"/>
                </h2>
                <xsl:sequence
                    select="djb:create_grid($left_len, $top_len) => djb:grid_as_html_table()"/>
            </body>
        </html>
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
        <!--        <xsl:iterate select="1 to $diag_count">
            <!-\- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -\->
            <!-\- neighbors are on last two diagonals               -\->
            <!-\- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -\->
            <xsl:param name="ult" as="element(cell)*"/>
            <xsl:param name="penult" as="element(cell)*"/>
            <xsl:variable name="search_space" as="element(cell)*" select="$ult | $penult"/>
            <!-\- process each diagonal -\->
            <xsl:variable name="diag" as="xs:integer" select="."/>
            <xsl:message select="'Processing diag', $diag"/>
            <diag n="{$diag}">
                <!-\-
                    $row_start is 1 until $left_len, then augment by $diag - $left_len
                    $row_end is $diag until $left_len, and then stays at $left_len
                    $col is $diag - $row + 1 (otherwise would start at 0, since $diag 1
                        has [1,1])
                -\->
                <xsl:variable name="shift" as="xs:integer"
                    select="
                        if ($diag gt $top_len) then
                            ($diag - $top_len)
                        else
                            0"/>
                <xsl:variable name="row_start" as="xs:integer" select="1 + $shift"/>
                <xsl:variable name="row_end" as="xs:integer" select="min(($diag, $left_len))"/>
                <xsl:for-each select="$row_start to $row_end">
                    <xsl:variable name="row" as="xs:integer" select="."/>
                    <xsl:for-each select="1">
                        <xsl:variable name="col" as="xs:integer" select="$diag - $row + 1"/>
                        <xsl:value-of separator="" select="'[', $row, ',', $col, ']'"/>
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
        </xsl:iterate>-->
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- David J. Birnbaum (djbpitt@gmail.com)                      -->
    <!-- djbpitt@gmail.com, http://www.obdurodon.org                -->
    <!-- https://github.com/djbpitt/xstuff/nw .                     -->
    <!--                                                            -->
    <!-- Needleman Wunsch alignment in XSLT 3.0                     -->
    <!-- See:                                                       -->
    <!--   https://www.cs.sjsu.edu/~aid/cs152/NeedlemanWunsch.pdf   -->
    <!--                                                            -->
    <!-- In case of ties, arbitrarily favor diagonal, then left     -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->

    <xsl:output method="xml" indent="yes"/>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- stylesheet variables                                       -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- arrow_map                                                  -->
    <!--                                                            -->
    <!-- retrieve arrow for source of best cell score               -->
    <!-- d, u, l = diagonal, from up, from left                     -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:variable name="arrow_map" as="map(xs:string, xs:string)"
        select='
            map {
                "d": "↘",
                "u": "↓",
                "l": "→"
            }'/>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- scoring (may be altered):                              -->
    <!--   match    =  1                                        -->
    <!--   mismatch = -1                                        -->
    <!--   gap      = -2                                        -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:variable name="match" as="xs:integer" select="1"/>
    <xsl:variable name="mismatch" as="xs:integer" select="-1"/>
    <xsl:variable name="gap" as="xs:integer" select="-2"/>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- functions                                                  -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:explode                                                -->
    <!--                                                            -->
    <!-- split string into sequence of one-character strings        -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:explode" as="xs:string*">
        <!-- explode string into sequence of single characters -->
        <xsl:param name="in" as="xs:string?"/>
        <xsl:sequence
            select="
                for $c in string-to-codepoints($in)
                return
                    codepoints-to-string($c)"
        />
    </xsl:function>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:nw                                                     -->
    <!--                                                            -->
    <!-- align two strings using Needleman Wunsch algorithm         -->
    <!-- returns a <table> element in no namespace with <row> and   -->
    <!--   <cell> content, where <cell> has attributes              -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:nw" as="element(table)">
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- input is two sequences of strings, $s1 and $s2         -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:param name="s1" as="xs:string+"/>
        <xsl:param name="s2" as="xs:string+"/>

        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- create table                                           -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <table>
            <xsl:iterate select="1 to count($s2)">
                <xsl:param name="rows" as="element(row)+">
                    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                    <!-- top two rows are characters and gap values -->
                    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                    <row>
                        <cell>&#xa0;</cell>
                        <cell>&#xa0;</cell>
                        <xsl:for-each select="$s1">
                            <cell>
                                <xsl:value-of select="."/>
                            </cell>
                        </xsl:for-each>
                    </row>
                    <row>
                        <cell>&#xa0;</cell>
                        <cell>0</cell>
                        <xsl:for-each select="$s1">
                            <cell>
                                <xsl:value-of select="$gap * position()"/>
                            </cell>
                        </xsl:for-each>
                    </row>
                </xsl:param>
                <xsl:param name="column_offset" as="xs:integer" select="1"/>
                <xsl:on-completion>
                    <xsl:sequence select="$rows"/>
                </xsl:on-completion>
                <xsl:variable name="current_row_number" as="xs:integer" select="current()"/>
                <xsl:variable name="new_rows" as="element(row)+">
                    <xsl:sequence select="$rows"/>
                    <row>
                        <cell>
                            <xsl:value-of select="$s2[current()]"/>
                        </cell>
                        <cell>
                            <xsl:value-of select="$gap * position()"/>
                        </cell>
                        <xsl:iterate select="1 to count($s1)">
                            <xsl:param name="last_cell" as="element(cell)?" select="()"/>
                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <!-- character match test               -->
                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <xsl:variable name="top_string" as="xs:string" select="$s1[current()]"/>
                            <xsl:variable name="left_string" as="xs:string"
                                select="$s2[$column_offset]"/>
                            <xsl:variable name="string_match" as="xs:integer"
                                select="
                                    if ($top_string eq $left_string) then
                                        $match
                                    else
                                        $mismatch"/>
                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <!-- neighboring values                 -->
                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <xsl:variable name="row_above" as="element(row)"
                                select="$rows[count($rows)]"/>
                            <xsl:variable name="current_column" as="xs:integer" select="current()"/>
                            <xsl:variable name="cell_up" as="element(cell)"
                                select="$row_above/cell[$current_column + 2]"/>
                            <xsl:variable name="cell_diag" as="element(cell)"
                                select="$row_above/cell[$current_column + 1]"/>
                            <xsl:variable name="cell_left" as="item()?"
                                select="
                                    if ($last_cell) then
                                        $last_cell
                                    else
                                        $gap * $current_row_number"/>
                            <xsl:variable name="scores" as="element(score)+">
                                <score source="u" value="{$cell_up + $gap}"/>
                                <score source="l" value="{$cell_left + $gap}"/>
                                <score source="d" value="{$cell_diag + xs:integer($string_match)}"/>
                            </xsl:variable>
                            <xsl:variable name="best_scores" as="element(score)+">
                                <xsl:for-each select="$scores[@value = max($scores/@value)]">
                                    <!-- Select by value, then sort by @xml:id 
                                        (conveniently, preference corresponds to alphabetical)
                                    -->
                                    <xsl:sort select="@source"/>
                                    <xsl:sequence select="."/>
                                </xsl:for-each>
                            </xsl:variable>
                            <xsl:variable name="cell_value" as="xs:double"
                                select="$best_scores[1]/@value"/>
                            <xsl:variable name="cell_from" as="xs:string"
                                select="$best_scores[1]/@source"/>
                            <xsl:variable name="cell_arrow" as="xs:string"
                                select="$arrow_map($cell_from)"/>

                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <!-- create the cell                    -->
                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <xsl:variable name="new_cell" as="element(cell)">
                                <cell top_string="{$top_string}" left-string="{$left_string}"
                                    match="{$string_match}" cell_up="{$cell_up}"
                                    cell_left="{$cell_left}" cell_diag="{$cell_diag}"
                                    cell_from="{$cell_from}" cell_arrow="{$cell_arrow}">
                                    <xsl:value-of select="$cell_value"/>
                                </cell>
                            </xsl:variable>
                            <xsl:sequence select="$new_cell"/>
                            <xsl:next-iteration>
                                <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                                <!-- cells need to look left        -->
                                <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                                <xsl:with-param name="last_cell" as="element(cell)"
                                    select="$new_cell"/>
                            </xsl:next-iteration>
                        </xsl:iterate>
                    </row>
                </xsl:variable>
                <xsl:next-iteration>
                    <xsl:with-param name="rows" as="element(row)+" select="$new_rows"/>
                    <xsl:with-param name="column_offset" as="xs:integer" select="$column_offset + 1"
                    />
                </xsl:next-iteration>
            </xsl:iterate>
        </table>
    </xsl:function>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:align                                                  -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:align" as="element(table)">
        <xsl:param name="in" as="element(table)"/>
        <xsl:param name="s1" as="xs:string*"/>
        <xsl:param name="s2" as="xs:string*"/>
        <xsl:param name="current_row" as="xs:integer"/>
        <xsl:param name="current_column" as="xs:integer"/>
        <xsl:param name="pairs" as="element(pair)*"/>
        <xsl:variable name="current_cell" as="element(cell)?"
            select="$in/row[$current_row]/cell[$current_column]"/>
        <xsl:choose>
            <xsl:when test="empty($s1) and empty($s2)">
                <!-- First two rows and columns are strings and gap values-->
                <table>
                    <xsl:sequence select="$pairs"/>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="new_pairs" as="element(pair)+">
                    <xsl:sequence select="$pairs"/>
                    <pair>
                        <xsl:value-of select="concat('[', $current_row, ',', $current_column, ']')"
                        />
                    </pair>
                </xsl:variable>
                <xsl:variable name="new_row" as="xs:integer"
                    select="
                        if ($current_cell/@cell_from = ('d', 'u')) then
                            $current_row - 1
                        else
                            $current_row"/>
                <xsl:variable name="new_column" as="xs:integer"
                    select="
                        if ($current_cell/@cell_from = ('d', 'l')) then
                            $current_column - 1
                        else
                            $current_column"/>
                <xsl:variable name="new_s1" as="xs:string*"
                    select="
                        if ($current_cell/@cell_from = ('d', 'l')) then
                            subsequence($s1, 1, count($s1) - 1)
                        else
                            $s1"/>
                <xsl:variable name="new_s2" as="xs:string*"
                    select="
                        if ($current_cell/@cell_from = ('d', 'u')) then
                            subsequence($s2, 1, count($s2) - 1)
                        else
                            $s2"/>
                <xsl:message select="string-join(($new_row, $new_column), '; ')"/>
                <xsl:sequence
                    select="djb:align($in, $new_s1, $new_s2, max(($new_row, 3)), max(($new_column, 3)), $new_pairs)"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- main                                                       -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="s1" as="xs:string" select="'koala'"/>
        <xsl:variable name="s2" as="xs:string" select="'precoalesce'"/>
        <xsl:variable name="table"
            select="
                djb:nw(if (count($s1) eq 1 and count($s2) eq 1) then
                    djb:explode($s1)
                else
                    $s1,
                if (count($s1) eq 1 and count($s2) eq 1) then
                    djb:explode($s2)
                else
                    $s2)"/>
        <xsl:variable name="alignment" as="element(table)?"
            select="
                djb:align(
                $table,
                if (count($s1) eq 1 and count($s2) eq 1) then
                    djb:explode($s1)
                else
                    $s1,
                if (count($s1) eq 1 and count($s2) eq 1) then
                    djb:explode($s2)
                else
                    $s2,
                $table/count(row),
                $table/row[1]/count(cell),
                ()
                )"/>
        <!--<xsl:sequence select="$alignment"/>-->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- For HTML output                                        -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Needleman Wunsch test</title>
                <link rel="stylesheet" type="text/css" href="http://www.obdurodon.org/css/style.css"/>
                <style type="text/css">
                    #grid th,
                    #grid td {
                        text-align: right;
                    }
                    #grid th:first-of-type {
                        text-align: left;
                    }
                    #grid tr:first-of-type > th {
                        text-align: center;
                    }
                    #grid td:before {
                        content: attr(data-cell_arrow) " ";
                        font-size: small;
                    }
                    #grid [data-match = "1"] {
                        background-color: palegreen;
                    }
                    #grid [data-match = "-1"] {
                        background-color: pink;
                    }</style>
            </head>
            <body>
                <h1>Needleman Wunsch test</h1>
                <p>Generated <xsl:value-of select="current-dateTime()"/></p>
                <h2>Grid</h2>
                <xsl:sequence select="$table"/>
                <xsl:apply-templates select="$table" mode="html"/>
                <h2>Alignment</h2>
                <xsl:variable name="alignment"
                    select="djb:align($table, $s1, $s2, $table/count(row), $table/row[1]/count(cell), ())"/>
                <xsl:sequence select="$alignment"/>
                <!--<p>
                    <xsl:text>Match = </xsl:text>
                    <xsl:value-of select="$match"/>
                    <xsl:text>, mismatch = </xsl:text>
                    <xsl:value-of select="$mismatch"/>
                    <xsl:text>, gap = </xsl:text>
                    <xsl:value-of select="$gap"/>
                    <xsl:text>. In case of tie scores, favor diagonal, then left, then up.</xsl:text>
                </p>-->
            </body>
        </html>
    </xsl:template>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- templates for HTML output                                  -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:template match="table" mode="html" xmlns="http://www.w3.org/1999/xhtml">
        <table id="grid">
            <xsl:apply-templates mode="html"/>
        </table>
    </xsl:template>
    <xsl:template match="row" mode="html" xmlns="http://www.w3.org/1999/xhtml">
        <tr>
            <xsl:apply-templates mode="html"/>
        </tr>
    </xsl:template>
    <xsl:template match="cell" mode="html" xmlns="http://www.w3.org/1999/xhtml">
        <xsl:element
            name="{if (count(preceding::row) lt 2 or count(preceding-sibling::cell) lt 2) then 'th' else 'td'}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{concat('data-', name())}" select="."/>
            </xsl:for-each>
            <xsl:apply-templates mode="html"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="table[@type eq 'alignment']" mode="html"
        xmlns="http://www.w3.org/1999/xhtml">
        <table id="alignment">
            <xsl:apply-templates select="row" mode="html"/>
        </table>
    </xsl:template>
    <xsl:template match="table[@type eq 'alignment']/row" mode="html"
        xmlns="http://www.w3.org/1999/xhtml">
        <tr>
            <xsl:apply-templates mode="html"/>
        </tr>
    </xsl:template>
    <xsl:template match="table[@type eq 'alignment']/row/cell" xmlns="http://www.w3.org/1999/xhtml">
        <td>
            <xsl:apply-templates mode="html"/>
        </td>
    </xsl:template>
</xsl:stylesheet>

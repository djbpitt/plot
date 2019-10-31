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
    <!-- functions                                                  -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:explode                                                -->
    <!--                                                            -->
    <!-- split string into sequence of one-character strings        -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:explode" as="xs:string+">
        <!-- explode string into sequence of single characters -->
        <xsl:param name="in" as="xs:string"/>
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
        <!-- input is two strings, $s1 and $s2                      -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:param name="s1" as="xs:string"/>
        <xsl:param name="s2" as="xs:string"/>

        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- explode strings into sequences of single characters .  -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="s1_e" as="xs:string+" select="djb:explode($s1)"/>
        <xsl:variable name="s2_e" as="xs:string+" select="djb:explode($s2)"/>

        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- scoring (may be altered):                              -->
        <!--   match    =  1                                        -->
        <!--   mismatch = -1                                        -->
        <!--   gap      = -2                                        -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="match" as="xs:integer" select="1"/>
        <xsl:variable name="mismatch" as="xs:integer" select="-1"/>
        <xsl:variable name="gap" as="xs:integer" select="-2"/>

        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- create table                                           -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <table>
            <xsl:iterate select="1 to count($s2_e)">
                <xsl:param name="rows" as="element(row)+">
                    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                    <!-- top two rows are characters and gap values -->
                    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                    <row>
                        <cell>&#xa0;</cell>
                        <cell>&#xa0;</cell>
                        <xsl:for-each select="$s1_e">
                            <cell>
                                <xsl:value-of select="."/>
                            </cell>
                        </xsl:for-each>
                    </row>
                    <row>
                        <cell>&#xa0;</cell>
                        <cell>0</cell>
                        <xsl:for-each select="$s1_e">
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
                            <xsl:value-of select="$s2_e[current()]"/>
                        </cell>
                        <cell>
                            <xsl:value-of select="$gap * position()"/>
                        </cell>
                        <xsl:iterate select="1 to count($s1_e)">
                            <xsl:param name="last_cell" as="element(cell)?" select="()"/>
                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <!-- character match test               -->
                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <xsl:variable name="top_string" as="xs:string" select="$s1_e[current()]"/>
                            <xsl:variable name="left_string" as="xs:string"
                                select="$s2_e[$column_offset]"/>
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
                            <xsl:variable name="cell_up_score" as="xs:double"
                                select="$cell_up + $gap"/>
                            <xsl:variable name="cell_left_score" as="xs:double"
                                select="$cell_left + $gap"/>
                            <xsl:variable name="cell_diag_score" as="xs:double"
                                select="$cell_diag + xs:integer($string_match)"/>
                            <xsl:variable name="cell_value" as="xs:double"
                                select="max(($cell_diag_score, $cell_left_score, $cell_up_score))"/>

                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <!-- create the cell                    -->
                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <xsl:variable name="new_cell" as="element(cell)">
                                <cell top_string="{$top_string}" left-string="{$left_string}"
                                    match="{$string_match}" cell_up="{$cell_up}"
                                    cell_left="{$cell_left}" cell_diag="{$cell_diag}">
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
    <!-- main                                                       -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="s1" as="xs:string" select="'califs'"/>
        <xsl:variable name="s2" as="xs:string" select="'biali'"/>
        <xsl:variable name="table" select="djb:nw($s1, $s2)"/>
        <!-- Uncomment one or the other to output raw XML or HTML   -->
        <!--<xsl:sequence select="$table"/>-->
        <xsl:apply-templates select="$table" mode="html"/>
    </xsl:template>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- templates for HTML output                                  -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:template match="table" mode="html" xmlns="http://www.w3.org/1999/xhtml">
        <html>
            <head>
                <title>Needleman Wunsch test</title>
                <link rel="stylesheet" type="text/css" href="http://www.obdurodon.org/css/style.css"/>
                <style type="text/css">
                    th, td {
                        text-align: right;
                    }
                    th:first-of-type {
                        text-align: left;
                    }
                    tr:first-of-type > th {
                        text-align: center;
                    }
                    [data-match = "1"] {
                        background-color: palegreen;
                    }
                    [data-match = "-1"] {
                        background-color: pink;
                    }</style>
            </head>
            <body>
                <h1>Needleman Wunsch test</h1>
                <p>
                    <xsl:value-of select="current-dateTime()"/>
                </p>
                <table>
                    <xsl:apply-templates mode="html"/>
                </table>
            </body>
        </html>
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
</xsl:stylesheet>

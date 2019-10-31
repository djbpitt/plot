<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
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
    <xsl:function name="djb:nw">
        <!-- input is two strings, s1 and s2 -->
        <xsl:param name="s1" as="xs:string"/>
        <xsl:param name="s2" as="xs:string"/>
        <!-- explode strings them into sequences of single characters -->
        <xsl:variable name="s1_e" select="djb:explode($s1)"/>
        <xsl:variable name="s2_e" select="djb:explode($s2)"/>
        <!-- scoring: match = 1, mismatch = -1, gap = -2 -->
        <xsl:variable name="match" as="xs:integer" select="1"/>
        <xsl:variable name="mismatch" as="xs:integer" select="-1"/>
        <xsl:variable name="gap" as="xs:integer" select="-2"/>
        <table>
            <xsl:iterate select="1 to count($s2_e)">
                <xsl:param name="rows" as="element(row)+">
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
                <xsl:variable name="new_rows" as="element(row)*">
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
                            <!-- character match -->
                            <xsl:variable name="top_string" as="xs:string" select="$s1_e[current()]"/>
                            <xsl:variable name="left_string" as="xs:string"
                                select="$s2_e[$column_offset]"/>
                            <xsl:variable name="string_match" as="xs:boolean"
                                select="$top_string eq $left_string"/>
                            <!-- neighboring values to check -->
                            <xsl:variable name="row_above" as="element(row)"
                                select="$rows[count($rows)]"/>
                            <xsl:variable name="current_column" as="xs:integer" select="current()"/>
                            <xsl:variable name="cell_up" as="item()"
                                select="$row_above/cell[$current_column + 2]"/>
                            <xsl:variable name="cell_left" as="item()?"
                                select="
                                    if ($last_cell) then
                                        $last_cell
                                    else
                                        $s1_e[current() - 1]"/>
                            <xsl:variable name="cell_value" as="item()"
                                select="max(($cell_up, $last_cell)) + xs:integer($string_match)"/>
                            <!-- create the cell -->
                            <xsl:variable name="new_cell" as="element(cell)">
                                <cell top_string="{$top_string}" left-string="{$left_string}"
                                    match="{$string_match}" current_column="{$current_column}"
                                    cell_up="{$cell_up}" cell_left="{$cell_left}">
                                    <xsl:value-of select="$cell_value"/>
                                </cell>
                            </xsl:variable>
                            <xsl:sequence select="$new_cell"/>
                            <xsl:next-iteration>
                                <xsl:with-param name="last_cell" as="element(cell)"
                                    select="$new_cell"/>
                            </xsl:next-iteration>
                        </xsl:iterate>
                    </row>
                </xsl:variable>
                <xsl:next-iteration>
                    <xsl:with-param name="rows" select="$new_rows"/>
                    <xsl:with-param name="column_offset" select="$column_offset + 1"/>
                </xsl:next-iteration>
            </xsl:iterate>
        </table>
    </xsl:function>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- main                                                       -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="s1" as="xs:string" select="'calif'"/>
        <xsl:variable name="s2" as="xs:string" select="'bailiff'"/>
        <xsl:variable name="table" select="djb:nw($s1, $s2)"/>
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
                <link rel="stylesheet" type="text/css" href="http://www.obdurodon.org/css/style.css"
                />
            </head>
            <body>
                <h1>Needleman Wunsch test</h1>
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
        <td>
            <xsl:for-each select="@*">
                <xsl:attribute name="{concat('data-', name())}" select="."/>
            </xsl:for-each>
            <xsl:apply-templates mode="html"/>
        </td>
    </xsl:template>
    <xsl:template match="br" mode="html" xmlns="http://www.w3.org/1999/xhtml">
        <br/>
    </xsl:template>
</xsl:stylesheet>

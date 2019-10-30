<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- functions -->
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

        <xsl:iterate select="1 to count($s1_e)">
            <xsl:param name="cells" as="element(row)*">
                <!-- initialize top row -->
                <row>
                    <cell/>
                    <xsl:for-each select="$s1_e">
                        <cell>
                            <xsl:value-of select="."/>
                        </cell>
                    </xsl:for-each>
                </row>
                <row>
                    <cell s1="''" s2="''">0</cell>
                    <xsl:for-each select="$s1_e">
                        <cell s1="{.}" s2="''">
                            <xsl:value-of select="$gap * position()"/>
                        </cell>
                    </xsl:for-each>
                </row>
            </xsl:param>
            <xsl:on-completion>
                <table>
                    <xsl:sequence select="$cells"/>
                </table>
            </xsl:on-completion>
            <xsl:variable name="new_cells" as="element(row)+">
                <xsl:sequence select="$cells"/>
                <row>
                    <cell>
                        <xsl:value-of select="$s1_e[current()]"/>
                    </cell>
                </row>
            </xsl:variable>
            <xsl:next-iteration>
                <xsl:with-param name="cells" select="$new_cells"/>
            </xsl:next-iteration>
        </xsl:iterate>
    </xsl:function>

    <!-- main -->
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="s1" as="xs:string" select="'calif'"/>
        <xsl:variable name="s2" as="xs:string" select="'bailiff'"/>
        <xsl:variable name="table" select="djb:nw($s1, $s2)"/>
        <xsl:sequence select="$table"/>
        <!--<xsl:apply-templates select="$table" mode="html"/>-->
    </xsl:template>

    <!-- html table output -->
    <xsl:template match="table" mode="html" xmlns="http://www.w3.org/1999/xhtml">
        <html>
            <head>
                <title>Needleman Wunsch test</title>
                <link rel="stylesheet" type="text/css" href="http://www.obdurodon.org/css/style.css"
                />
            </head>
            <body>
                <h1>Needleman Wunsch test</h1>
                <h2>F table</h2>
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
            <xsl:apply-templates/>
        </td>
    </xsl:template>
</xsl:stylesheet>

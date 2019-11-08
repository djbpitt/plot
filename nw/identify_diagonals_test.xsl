<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <!--
        Given a rectangular matrix, group cells by diagonal, where diagonal #1 - [1,1]
        
        The diagonal is row + column - 1
    -->
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:function name="djb:get_diag" as="element(cell)">
        <xsl:param name="cell" as="element(cell)"/>
        <!-- no need to compute position because they are returned in document order -->
        <!--<xsl:variable name="diag_pos" as="xs:integer" select="xs:integer($cell/@row)"/>-->
        <xsl:variable name="diag" as="xs:integer" select="xs:integer($cell/@col + $cell/@row - 1)"/>
        <xsl:copy select="$cell" copy-namespaces="no">
            <xsl:copy-of select="$cell/@*"/>
            <xsl:attribute name="diag" select="$diag"/>
        </xsl:copy>
    </xsl:function>
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="cells" as="element(cell)+">
            <xsl:for-each select="1 to 5">
                <xsl:variable name="rowNo" as="xs:integer" select="."/>
                <xsl:for-each select="1 to 6">
                    <xsl:variable name="colNo" as="xs:integer" select="."/>
                    <cell row="{$rowNo}" col="{$colNo}"/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="with_diags"
            select="
                for $cell in $cells
                return
                    djb:get_diag($cell)"/>
        <xsl:for-each-group select="$with_diags" group-by="@diag">
            <diag diag_no="{current-grouping-key()}">
                <xsl:for-each select="current-group()">
                    <xsl:sequence select="string-join(('[', @row, ',', @col, ']'))"/>
                </xsl:for-each>
            </diag>
        </xsl:for-each-group>
    </xsl:template>
</xsl:stylesheet>

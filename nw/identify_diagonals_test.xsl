<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

    <!--
        The functions below were experimental. They aren’t needed in
        production because the diagonal can be computed for each cell
        when the cell is created, and therefore does not need to be 
        added later.
    -->

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- functions                                                  -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:get_diag                                               -->
    <!--                                                            -->
    <!-- $in as element(cell)                                       -->
    <!-- returns $in with new @diag attribute                       -->
    <!--                                                            -->
    <!-- adds @diag attribute indicating diagonal for cell .        -->
    <!-- diag = row + column -1                                     -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:get_diag" as="element(cell)">
        <xsl:param name="in" as="element(cell)"/>
        <!-- no need to compute position because the cells are returned in document order -->
        <!--<xsl:variable name="diag_pos" as="xs:integer" select="xs:integer($cell/@row)"/>-->
        <xsl:variable name="diag" as="xs:integer" select="xs:integer($in/@col + $in/@row - 1)"/>
        <xsl:copy select="$in">
            <xsl:copy-of select="$in/@*"/>
            <xsl:attribute name="diag" select="$diag"/>
        </xsl:copy>
    </xsl:function>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:add_diags                                              -->
    <!--                                                            -->
    <!-- $in as element(cell)+                                      -->
    <!-- returns each cell with new @diag attribute                 -->
    <!--                                                            -->
    <!-- adds @diag attribute to sequence of cells                  -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:process_cells" as="element(cell)+">
        <xsl:param name="in" as="element(cell)+"/>
        <xsl:for-each select="$in">
            <xsl:sequence select="djb:get_diag(.)"/>
        </xsl:for-each>
    </xsl:function>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:group_by_diag                                          -->
    <!--                                                            -->
    <!-- $in as element(cell)+                                      -->
    <!-- returns sequence of <diag> elements with cartesian         -->
    <!--   coordinates of cells, in document order                  -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:group_by_diag" as="element(diag)+">
        <xsl:param name="in" as="element(cell)+"/>
        <xsl:for-each-group select="$in" group-by="@diag">
            <diag diag_no="{current-grouping-key()}">
                <xsl:for-each select="current-group()">
                    <xsl:sequence select="string-join(('[', @row, ',', @col, ']'))"/>
                </xsl:for-each>
            </diag>
        </xsl:for-each-group>
    </xsl:function>

    <!-- sample input tables, 5x6, 5x5, 6x5 -->
    <xsl:variable name="inputs" as="element(input)+">
        <input name="r5xc6">
            <xsl:for-each select="1 to 5">
                <xsl:variable name="rowNo" as="xs:integer" select="."/>
                <xsl:for-each select="1 to 6">
                    <xsl:variable name="colNo" as="xs:integer" select="."/>
                    <cell row="{$rowNo}" col="{$colNo}" diag="{$rowNo + $colNo - 1}"/>
                </xsl:for-each>
            </xsl:for-each>
        </input>
        <input name="r5xr5">
            <xsl:for-each select="1 to 5">
                <xsl:variable name="rowNo" as="xs:integer" select="."/>
                <xsl:for-each select="1 to 5">
                    <xsl:variable name="colNo" as="xs:integer" select="."/>
                    <cell row="{$rowNo}" col="{$colNo}" diag="{$rowNo + $colNo - 1}"/>
                </xsl:for-each>
            </xsl:for-each>
        </input>
        <input name="r6xc5">
            <xsl:for-each select="1 to 6">
                <xsl:variable name="rowNo" as="xs:integer" select="."/>
                <xsl:for-each select="1 to 5">
                    <xsl:variable name="colNo" as="xs:integer" select="."/>
                    <cell row="{$rowNo}" col="{$colNo}" diag="{$rowNo + $colNo - 1}"/>
                </xsl:for-each>
            </xsl:for-each>
        </input>
    </xsl:variable>

    <xsl:template name="xsl:initial-template">
        <xsl:for-each select="$inputs">
            <sample>
                <label>
                    <xsl:value-of select="max(cell/@row), 'rows by', max(cell/@col), 'columns'"/>
                </label>
                <cells>
                    <xsl:sequence select="djb:group_by_diag(./cell)"/>
                </cells>
            </sample>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>

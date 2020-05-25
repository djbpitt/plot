<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:f="http://www.obdurodon.org/function-variables"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0" xmlns:array="http://www.w3.org/2005/xpath-functions/array">
    <xsl:output method="xml" indent="yes"/>
    <!-- ================================================================ -->
    <!-- Packages                                                         -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/linear-algebra-lib"/>


    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <xsl:function name="djb:dump-matrix-cells">
        <xsl:param name="input" as="array(array(*)*)"/>
        <xsl:for-each select="1 to array:size($input)">
            <xsl:variable name="row-number" as="xs:integer" select="current()"/>
            <xsl:for-each select="1 to array:size($input(1))">
                <xsl:variable name="column-number" select="current()"/>
                <cell n="{concat('(', $row-number, ',', $column-number, ')')}">
                    <xsl:sequence select="$input($row-number)($column-number)"/>
                </cell>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================ -->
    <!-- Stylesheet variables: test data                                  -->
    <!-- ================================================================ -->
    <xsl:variable name="tests" as="array(array(*)*)+">
        <xsl:sequence
            select="
                [
                    [[4], [5], [6]],
                    [[1, 2, 3]]
                ],
                [
                    [[1, 2, 3]],
                    [[4], [5], [6]]
                ]"
        />
    </xsl:variable>

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <xsl:for-each select="$tests">
            <xsl:variable name="left-matrix" as="array(array(*))" select="current()(1)"/>
            <xsl:variable name="right-matrix" as="array(array(*))" select="current()(2)"/>
            <xsl:variable name="dot-product" as="array(array(*))"
                select="djb:dot-product($left-matrix, $right-matrix)"/>
            <test n="{position()}">
                <input-left-matrix>
                    <xsl:sequence select="djb:dump-matrix-cells($left-matrix)"/>
                </input-left-matrix>
                <input-right-matrix>
                    <xsl:sequence select="djb:dump-matrix-cells($right-matrix)"/>
                </input-right-matrix>
                <output-matrix>
                    <xsl:sequence select="djb:dump-matrix-cells($dot-product)"/>
                </output-matrix>
            </test>
        </xsl:for-each>
        <!--<test n="2">
            <xsl:variable name="left-matrix" as="array(array(*))" select="[[1, 2, 3]]"/>
            <xsl:variable name="right-matrix" as="array(array(*))" select="[[4], [5], [6]]"/>
            <xsl:variable name="dot-product" as="array(array(*))"
                select="djb:dot-product($left-matrix, $right-matrix)"/>
            <input-left-matrix>
                <xsl:sequence select="djb:dump-matrix-cells($left-matrix)"/>
            </input-left-matrix>
            <input-right-matrix>
                <xsl:sequence select="djb:dump-matrix-cells($right-matrix)"/>
            </input-right-matrix>
            <output-matrix>
                <xsl:sequence select="djb:dump-matrix-cells($dot-product)"/>
            </output-matrix>
        </test>-->
    </xsl:template>
</xsl:stylesheet>

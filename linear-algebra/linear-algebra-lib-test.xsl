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

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="left-matrix" as="array(array(*))" select="[[4], [5], [6]]"/>
        <xsl:variable name="right-matrix" as="array(array(*))" select="[[1, 2, 3]]"/>
        <xsl:variable name="dot-product" as="array(array(*))"
            select="djb:dot-product($left-matrix, $right-matrix)"/>
        <output-matrix>
            <xsl:for-each select="1 to array:size($dot-product)">
                <row n="{current()}">
                    <xsl:sequence select="$dot-product(current())"/>
                </row>
            </xsl:for-each>
        </output-matrix>
    </xsl:template>
</xsl:stylesheet>

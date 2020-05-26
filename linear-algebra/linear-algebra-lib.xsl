<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/linear-algebra-lib"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" xmlns:f="http://www.obdurodon.org/function-variables"
    version="3.0">
    <!-- ================================================================ -->
    <!-- Packages                                                         -->
    <!--                                                                  -->
    <!-- Uses djb:uniform#1 to check length of matrix rows                -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>

    <!-- ================================================================ -->
    <!-- Control default behavior of debug messaging                      -->
    <!-- ================================================================ -->
    <xsl:param name="debug" static="yes" as="xs:boolean" select="false()"/>

    <!-- ================================================================ -->
    <!-- Final functions, templates and variables                         -->
    <!-- ================================================================ -->
    <xsl:expose component="function" names="djb:dot-product#2" visibility="final"/>

    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <xsl:function name="djb:dot-product" as="array(array(*)*)">
        <!-- ============================================================ -->
        <!-- djb:dot-product#2                                            -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:left-matrix as array(array(*)*) : m x n matrix          -->
        <!--   $f:right-matrix as array(array(*)*) : n x p matrix         -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   array(array(*)*) : dot product of input matrices           -->
        <!--                                                              -->
        <!-- Notes:                                                       -->
        <!--   Matrices are arrays (rows) of arrays (row values)          -->
        <!--     E.g.: [ [ 1, 2 ], [3, 4] ]                               -->
        <!--   Validation:                                                -->
        <!--     Left column count = right row count                      -->
        <!--     Input matrix rows have uniform length                    -->
        <!-- ============================================================ -->
        <xsl:param name="f:left-matrix" as="array(array(*)*)"/>
        <xsl:param name="f:right-matrix" as="array(array(*)*)"/>
        <!-- ============================================================ -->
        <!-- Local variables                                              -->
        <!-- ============================================================ -->
        <xsl:variable name="f:left-row-count" as="xs:integer" select="array:size($f:left-matrix)"/>
        <xsl:variable name="f:left-column-count" as="xs:integer"
            select="array:size($f:left-matrix(1))"/>
        <xsl:variable name="f:right-row-count" as="xs:integer" select="array:size($f:right-matrix)"/>
        <xsl:variable name="f:right-column-count" as="xs:integer"
            select="array:size($f:right-matrix(1))"/>
        <!-- ============================================================ -->
        <!-- Validate input                                               -->
        <!-- ============================================================ -->
        <xsl:if test="$f:left-column-count ne $f:right-row-count">
            <xsl:message terminate="yes"
                select="
                'Left column count (' || 
                $f:left-column-count || 
                ') and right row count(' || 
                $f:right-row-count || ') must match'"
            />
        </xsl:if>
        <xsl:variable name="left-row-sizes" as="xs:integer+"
            select="array:for-each($f:left-matrix, array:size#1)"/>
        <xsl:variable name="right-row-sizes" as="xs:integer+"
            select="array:for-each($f:right-matrix, array:size#1)"/>
        <xsl:if test="not(djb:uniform($left-row-sizes) and djb:uniform($right-row-sizes))">
            <xsl:message terminate="yes"
                select="'Invalid input: matrix has rows of different lengths'"/>
        </xsl:if>
        <!-- ============================================================ -->
        <!-- Debug messages                                               -->
        <!-- ============================================================ -->
        <xsl:if test="$debug">
            <xsl:message select="'Left row count: ' || $f:left-row-count"/>
            <xsl:message select="'Left column  count: ' || $f:left-column-count"/>
            <xsl:message select="'Right row count: ' || $f:right-row-count"/>
            <xsl:message select="'Right column count: ' || $f:right-column-count"/>
            <xsl:message
                select="'Left matrix: ' || $f:left-row-count || ' x ' || $f:left-column-count"/>
            <xsl:message
                select="'Right matrix: ' || $f:right-row-count || ' x ' || $f:right-column-count"/>
        </xsl:if>
        <!-- ============================================================ -->
        <!-- Compute dot product                                          -->
        <!-- ============================================================ -->
        <xsl:variable name="f:output-rows" as="array(*)+">
            <xsl:for-each select="1 to $f:left-row-count">
                <xsl:variable name="f:left-row-pos" as="xs:integer" select="current()"/>
                <xsl:variable name="f:output-row" as="xs:double+">
                    <xsl:for-each select="1 to $f:right-column-count">
                        <xsl:variable name="f:output-row-item" as="xs:double">
                            <!-- create output row for each column in right matrix-->
                            <xsl:variable name="f:right-column-pos" select="current()"/>
                            <xsl:sequence
                                select="
                        array {(for $i in 1 to $f:right-row-count 
                        return $f:left-matrix($f:left-row-pos)($i) * $f:right-matrix($i)($f:right-column-pos))
                        => sum()
                        }"
                            />
                        </xsl:variable>
                        <xsl:sequence select="$f:output-row-item"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:sequence select="array {$f:output-row ! .}"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:sequence select="array {$f:output-rows}"/>
    </xsl:function>
</xsl:package>

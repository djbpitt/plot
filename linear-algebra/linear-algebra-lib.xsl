<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/linear-algebra-lib"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" xmlns:f="http://www.obdurodon.org/function-variables"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- ================================================================ -->
    <!-- Control default behavior of debug messaging                      -->
    <!-- ================================================================ -->
    <xsl:param name="debug" static="yes" as="xs:boolean" select="true()"/>

    <!-- ================================================================ -->
    <!-- Final functions, templates and variables                         -->
    <!-- ================================================================ -->
    <xsl:expose component="function" names="djb:dot-product#2" visibility="final"/>

    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <xsl:function name="djb:dot-product">
        <!-- ============================================================ -->
        <!-- djb:dot-product#2                                            -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:left-matrix as array(*) : m x n matrix                  -->
        <!--   $f:right-matrix as array(*) : vector (1-d matrix)          -->
        <!--                                                              -->
        <!-- Notes:                                                       -->
        <!--   Matrices are arrays (rows) of arrays (row values)          -->
        <!--   Validates that length of right matrix row = left row count -->
        <!--                                                              -->
        <!-- TODO:                                                        -->
        <!--   Validate that all rows in left matrix have same length     -->
        <!-- ============================================================ -->
        <xsl:param name="f:left-matrix" as="array(*)"/>
        <xsl:param name="f:right-matrix" as="array(*)"/>
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
        <xsl:if
            test="$f:right-column-count ne $f:left-row-count and $f:left-column-count ne $f:right-row-count">
            <xsl:message terminate="yes"
                select="
                'Left row count (' || 
                $f:left-row-count || 
                ') and right column count(' || 
                $f:right-column-count || ') must match'"
            />
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

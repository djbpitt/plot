<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/linear-algebra-lib"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" xmlns:f="http://www.obdurodon.org/function-variables"
    version="3.0">

    <xsl:param name="debug" as="xs:boolean"/>

    <!-- ================================================================ -->
    <!-- Packages                                                         -->
    <!--                                                                  -->
    <!-- Uses djb:uniform#1 to check length of matrix rows                -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>

    <!-- ================================================================ -->
    <!-- Final functions, templates and variables                         -->
    <!-- ================================================================ -->
    <xsl:expose component="function" visibility="final"
        names="
        djb:transpose-matrix#1
        djb:dot-product#2
        djb:compute-derivative#3
        djb:compute-parabolic-Y#4
        djb:compute-control-X#2
        djb:compute-control-Y#5
        djb:compute-vertex-X#2
        "/>

    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <xsl:function name="djb:transpose-matrix" as="array(array(*)+)">
        <!-- ============================================================ -->
        <!-- djb:transpose-matrix#1                                       -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:input-matrix as array(array(*)+) : m x n matrix         -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   array(array(*)+) : n x m transpose of input                -->
        <!--                                                              -->
        <!-- Notes:                                                       -->
        <!--   Matrices are arrays (rows) of arrays (row values)          -->
        <!--     E.g.: [ [ 1, 2 ], [3, 4] ]                               -->
        <!--   Validation:                                                -->
        <!--     Input matrix rows have uniform length                    -->
        <!-- ============================================================ -->
        <xsl:param name="f:input-matrix" as="array(array(xs:integer+)+)"/>

        <!-- ============================================================ -->
        <!-- Local variables                                              -->
        <!-- ============================================================ -->
        <xsl:variable name="input-row-sizes" as="xs:integer+"
            select="array:for-each($f:input-matrix, array:size#1)"/>
        <xsl:variable name="f:input-column-count" as="xs:integer"
            select="array:size($f:input-matrix(1))"/>

        <!-- ============================================================ -->
        <!-- Validate input                                               -->
        <!-- ============================================================ -->
        <xsl:if test="not(djb:uniform($input-row-sizes))">
            <xsl:message terminate="yes"
                select="'Invalid input: matrix has rows of different lengths'"/>
        </xsl:if>

        <!-- ============================================================ -->
        <!-- Compute transposed matrix                                    -->
        <!-- ============================================================ -->
        <xsl:variable name="f:output-rows" as="array(xs:integer+)+">
            <xsl:for-each select="1 to $f:input-column-count">
                <xsl:variable name="f:input-column-pos" as="xs:integer" select="current()"/>
                <xsl:variable name="f:output-row-contents" as="xs:integer+"
                    select="
                    for $f:input-row-pos in (1 to array:size($f:input-matrix))
                    return $f:input-matrix($f:input-row-pos)($f:input-column-pos)
                    "/>
                <xsl:sequence select="array {$f:output-row-contents}"/>
            </xsl:for-each>
        </xsl:variable>
        <!-- ============================================================ -->
        <!-- Return result                                                -->
        <!-- ============================================================ -->
        <xsl:sequence select="array {$f:output-rows}"/>
    </xsl:function>

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

    <xsl:function name="djb:compute-derivative" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:compute-derivative#3                                     -->
        <!--                                                              -->
        <!-- Return first derivative of quadratic (only) function         -->
        <!--   f′(x) = 2ax + b                                            -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:x as xs:double: X coordinate                            -->
        <!--   $f:a as xs:double: a parameter (ax^2 + bx + c)             -->
        <!--   $f:b as xs:double: b parameter (ax^2 + bx + c)             -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double : f′(x)                                          -->
        <!-- ============================================================ -->
        <xsl:param name="f:x" as="xs:double"/>
        <xsl:param name="f:a" as="xs:double"/>
        <xsl:param name="f:b" as="xs:double"/>
        <xsl:sequence select="(2 * $f:a * $f:x) + $f:b"/>
    </xsl:function>

    <xsl:function name="djb:compute-parabolic-Y" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:compute-parabolic-Y#4                                    -->
        <!--                                                              -->
        <!-- Return ax^2 + bx + c                                         -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:x : X coordinate                                        -->
        <!--   $f:a : a parameter (ax^2 + bx + c)                         -->
        <!--   $f:b : b parameter (ax^2 + bx + c)                         -->
        <!--   $f:c : c parameter (ax^2 + bx + c)                         -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double : Y coordinate                                   -->
        <!-- ============================================================ -->
        <xsl:param name="f:x" as="xs:double"/>
        <xsl:param name="f:a" as="xs:double"/>
        <xsl:param name="f:b" as="xs:double"/>
        <xsl:param name="f:c" as="xs:double"/>
        <xsl:sequence select="math:pow($f:x, 2) * $f:a + $f:x * $f:b + $f:c"/>
    </xsl:function>

    <xsl:function name="djb:compute-control-X" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:compute-control-X#2                                      -->
        <!--                                                              -->
        <!-- Return X coordinate of quadratic Bézier control point        -->
        <!--   for parabolic segment                                      -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:x1 : X coordinate of segment start point                -->
        <!--   $f:x2 : X coordinate of segment end point                  -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double : X coordinate of quadratic Bézier control point -->
        <!-- ============================================================ -->
        <xsl:param name="f:x1" as="xs:double"/>
        <xsl:param name="f:x2" as="xs:double"/>
        <xsl:sequence select="($f:x1 + $f:x2) div 2"/>
    </xsl:function>

    <xsl:function name="djb:compute-control-Y" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:compute-control-Y#5                                      -->
        <!--                                                              -->
        <!-- Return Y coordinate of quadratic Bézier control point        -->
        <!--   for parabolic segment                                      -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:x1 : X coordinate of segment start point                -->
        <!--   $f:x2 : X coordinate of segment end point                  -->
        <!--   $f:a : a parameter (ax^2 + bx + c)                         -->
        <!--   $f:b : b parameter (ax^2 + bx + c)                         -->
        <!--   $f:c : c parameter (ax^2 + bx + c)                         -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double : Y coordinate of quadratic Bézier control point -->
        <!-- ============================================================ -->
        <xsl:param name="f:x1" as="xs:double"/>
        <xsl:param name="f:x2" as="xs:double"/>
        <xsl:param name="f:a" as="xs:double"/>
        <xsl:param name="f:b" as="xs:double"/>
        <xsl:param name="f:c" as="xs:double"/>
        <xsl:variable name="f:result" as="xs:double"
            select="
            djb:compute-parabolic-Y($f:x1, $f:a, $f:b, $f:c) +
            djb:compute-derivative($f:x1, $f:a, $f:b) * (($f:x2 - $f:x1) div 2)
            "/>
        <xsl:sequence select="$f:result"/>
        <xsl:if test="$debug">
            <xsl:message select="'control-Y: ', $f:result"/>
        </xsl:if>
    </xsl:function>

    <xsl:function name="djb:compute-vertex-X" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:compute-vertex-X#2                                      -->
        <!--                                                              -->
        <!-- Return X coordinate of vertex of parabola                    -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:a : y = ax^2 + bx + c                                   -->
        <!--   $f:b : y = ax^2 + bx + c                                   -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double : X coordinate of vertex                         -->
        <!-- ============================================================ -->
        <xsl:param name="f:a" as="xs:double"/>
        <xsl:param name="f:b" as="xs:double"/>
        <xsl:sequence select="(-1 * $f:b) div (2 * $f:a)"/>
    </xsl:function>
</xsl:package>

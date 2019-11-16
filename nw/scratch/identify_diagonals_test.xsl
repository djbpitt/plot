<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:key name="cellByRowCol" match="cell" use="(@row, @col)" composite="yes"/>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- two input strings as stylesheet parameters                -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:param name="in1" as="xs:string" required="yes"/>
    <xsl:param name="in2" as="xs:string" required="yes"/>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- user-defined functions                                    -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:get_diag_cells()                                      -->
    <!-- returns all cell in specified diagonal .                  -->
    <!-- parameters:                                               -->
    <!--   $diag as xs:integer                                     -->
    <!--   @left_len xs:integer (total number of rows)             -->
    <!--   @ltop_len xs:integer (total number of columns)          -->
    <!-- return: <diag>, with $diag as @n and <cell> contents      -->
    <!--   note: <cell> elements specify @row and @col             -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:get_diag_cells" as="element(diag)+">
        <xsl:param name="diag" as="xs:integer"/>
        <xsl:param name="left_len" as="xs:integer"/>
        <xsl:param name="top_len" as="xs:integer"/>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- trap input errors                                     -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:if test="($diag, $left_len, $top_len) &lt; 1">
            <xsl:message terminate="yes"
                select="'$diag, $top_len, and $left_len must all be positive integers'"/>
        </xsl:if>
        <xsl:if test="$diag gt sum(($top_len, $left_len, -1))">
            <xsl:message terminate="yes"
                select="'$diag cannot be greater than $left_len + $top_len - 1'"/>
        </xsl:if>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- $row_start is 1 until $top_len (last row), then       -->
        <!--   augment by $diag - $top_len to shift down one row   -->
        <!--   (wrapping around upper right corner)                -->
        <!-- $col is $diag - $row + 1 (otherwise would start at 0, -->
        <!--   since $diag 1 has [1,1])                            -->
        <!-- based on https://www.jenitennison.com/2007/05/06/     -->
        <!--   levenshtein-distance-on-the-diagonal.html           -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="shift" as="xs:integer"
            select="
                if ($diag gt $top_len) then
                    ($diag - $top_len)
                else
                    0"/>
        <xsl:variable name="row_start" as="xs:integer" select="1 + $shift"/>
        <xsl:variable name="row_end" as="xs:integer" select="min(($diag, $left_len))"/>
        <diag n="{$diag}">
            <xsl:for-each select="$row_start to $row_end">
                <xsl:variable name="row" as="xs:integer" select="."/>
                <xsl:variable name="col" as="xs:integer" select="$diag - $row + 1"/>
                <cell row="{$row}" col="{$col}"/>
            </xsl:for-each>
        </diag>
    </xsl:function>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:create_grid()                                         -->
    <!-- finds all cells in grid, organized by diagonal            -->
    <!-- parameters:                                               -->
    <!--   $left_len as xs:integer .                               -->
    <!--   $top_len as xs:integer                                  -->
    <!-- returns:                                                  -->
    <!--   element(diag)+ (from djb:get_diag_cells)                -->
    <!-- dependencies:                                             -->
    <!--   calls djb:get_diag_cells() for each diagonal            -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:create_grid" as="element(diag)+">
        <xsl:param name="left_len" as="xs:integer"/>
        <xsl:param name="top_len" as="xs:integer"/>
        <xsl:if test="($left_len, $top_len) &lt; 1">
            <xsl:message terminate="yes"
                select="'$left_len and $top_len must both be positive integers'"/>
        </xsl:if>
        <xsl:variable name="diag_count" as="xs:integer" select="$top_len + $left_len - 1"/>
        <xsl:for-each select="1 to $diag_count">
            <xsl:sequence select="djb:get_diag_cells(., $left_len, $top_len)"/>
        </xsl:for-each>
    </xsl:function>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:tokenize_input()                                      -->
    <!-- finds all cells in grid, organized by diagonal            -->
    <!-- parameters:                                               -->
    <!--   $top as xs:string                                       -->
    <!--   $left as xs:string .                                    -->
    <!-- returns:                                                  -->
    <!--   map:                                                    -->
    <!--     top: tokenized input as xs:string+                    -->
    <!--     left: tokenized input as xs:string+                   -->
    <!--     type: 'words' or 'characters'                         -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:tokenize_input" as="map(xs:string, item()+)">
        <xsl:param name="top" as="xs:string"/>
        <xsl:param name="left" as="xs:string"/>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- normalize whitespace                                  -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="top_n" as="xs:string" select="normalize-space($top)"/>
        <xsl:variable name="left_n" as="xs:string" select="normalize-space($left)"/>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- validate input                                        -->
        <!-- no null strings                                       -->
        <!-- both strings must be either single- or multiple-word  -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:if test="(string-length($top_n), string-length($left_n)) = 0">
            <xsl:message select="'Null strings are not permitted'" terminate="yes"/>
        </xsl:if>
        <xsl:if
            test="
                not(
                (matches($top_n, '\s') and matches($left_n, '\s'))
                or
                not(matches($top_n, '\s')) and not(matches($left_n, '\s'))
                )">
            <xsl:message
                select="'Either both strings must be single words or both strings must be multiple words'"
                terminate="yes"/>
        </xsl:if>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- split the inputs                                      -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="top_out" as="xs:string+"
            select="
                if (matches($top_n, '\s')) then
                    tokenize($top_n, '\s+')
                else
                    for $c in string-to-codepoints($top_n)
                    return
                        codepoints-to-string($c)"/>
        <xsl:variable name="left_out" as="xs:string+"
            select="
                if (matches($left_n, '\s')) then
                    tokenize($left_n, '\s+')
                else
                    for $c in string-to-codepoints($left_n)
                    return
                        codepoints-to-string($c)"/>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- are we returning characters or words?                 -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="input_type" as="xs:string+"
            select="
                if (matches($top_n, '\s')) then
                    'words'
                else
                    'characters'"/>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- return tokenized sequences and type in map            -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:sequence
            select="
                map {
                    'top': $top_out,
                    'left': $left_out,
                    'type': $input_type
                }"
        />
    </xsl:function>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- main                                                      -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:template name="xsl:initial-template">
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- copy stylesheet parameters locally (needed by xspec)  -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:param name="in1" as="xs:string" select="$in1"/>
        <xsl:param name="in2" as="xs:string" select="$in2"/>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- extract token sequence and length from both strings   -->
        <!-- $input_type is 'words' or 'characters'                -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="result" as="map(xs:string, item()+)"
            select="djb:tokenize_input($in1, $in2)"/>
        <xsl:variable name="top" as="xs:string+" select="$result('top')"/>
        <xsl:variable name="top_len" as="xs:integer" select="count($top)"/>
        <xsl:variable name="left" as="xs:string+" select="$result('left')"/>
        <xsl:variable name="left_len" as="xs:integer" select="count($left)"/>
        <xsl:variable name="input_type" as="xs:string" select="$result('type')"/>
    </xsl:template>

</xsl:stylesheet>

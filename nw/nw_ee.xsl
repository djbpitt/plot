<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:html="http://www.w3.org/1999/xhtml" xmlns:saxon="http://saxon.sf.net/"
    exclude-result-prefixes="#all" version="3.0">

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- David J. Birnbaum (djbpitt@gmail.com)                      -->
    <!-- djbpitt@gmail.com, http://www.obdurodon.org                -->
    <!-- https://github.com/djbpitt/xstuff/nw                       -->
    <!--                                                            -->
    <!-- Needleman Wunsch alignment in XSLT 3.0                     -->
    <!-- Outputs alignment table and optional grid as html          -->
    <!--                                                            -->
    <!-- See:                                                       -->
    <!--   https://www.cs.sjsu.edu/~aid/cs152/NeedlemanWunsch.pdf   -->
    <!--                                                            -->
    <!-- In case of ties, arbitrarily favor diagonal, then left     -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->

    <xsl:output method="xml" indent="yes"/>
    <xsl:key name="cellByRowCol" match="cell" use="@row, @col" composite="yes"/>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- stylesheet parameters                                     -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- $output_grid                                              -->
    <!--   type: xs:boolean                                        -->
    <!--   default: false                                          -->
    <!--   effect: outputs full grid as well as alignment table    -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:param name="output_grid" static="yes" as="xs:boolean" select="false()"/>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- $paragraph_count                                          -->
    <!--   type: xs:integer                                        -->
    <!--   default: 1                                              -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:param name="paragraph_count" static="yes" as="xs:integer" select="1"/>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- stylesheet variables                                      -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- scoring (may be altered):                              -->
    <!--   match    =  1                                        -->
    <!--   mismatch = -1                                        -->
    <!--   gap      = -2                                        -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:variable name="match_score" as="xs:integer" select="1"/>
    <xsl:variable name="mismatch_score" as="xs:integer" select="-1"/>
    <xsl:variable name="gap_score" as="xs:integer" select="-2"/>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- user-defined functions                                    -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->

    <xsl:function name="djb:tokenize_input" as="map(xs:string, item()+)">
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- djb:tokenize_input()                                      -->
        <!-- split single-word input into characters and               -->
        <!--   multi-word input into words                             -->
        <!-- parameters:                                               -->
        <!--   $top as xs:string                                       -->
        <!--   $left as xs:string                                      -->
        <!-- returns:                                                  -->
        <!--   map:                                                    -->
        <!--     top: tokenized input as xs:string+                    -->
        <!--     left: tokenized input as xs:string+                   -->
        <!--     type: 'words' or 'characters'                         -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
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

    <xsl:function name="djb:get_diag_cells" as="element(diag)+">
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- djb:get_diag_cells()                                      -->
        <!-- return all cell in specified diagonal                     -->
        <!-- parameters:                                               -->
        <!--   $diag as xs:integer                                     -->
        <!--   @left_len xs:integer (total number of rows)             -->
        <!--   @ltop_len xs:integer (total number of columns)          -->
        <!-- return: <diag>, with $diag as @n and <cell> contents      -->
        <!--   note: <cell> elements specify @row and @col             -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
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
        <diag xsl:validation="preserve" xsl:default-validation="preserve">
            <xsl:attribute name="n" type="xs:integer" select="$diag"/>
            <xsl:for-each select="$row_start to $row_end" saxon:threads="10">
                <cell>
                    <xsl:attribute name="row" type="xs:integer" select="."/>
                    <xsl:attribute name="col" type="xs:integer" select="$diag - . + 1"/>
                </cell>
            </xsl:for-each>
            <!-- create row and column 0 where needed -->
            <xsl:if test="$diag lt $top_len">
                <xsl:variable name="tmp" as="xs:integer" select="$diag + 1"/>
                <cell>
                    <xsl:attribute name="row" type="xs:integer" select="0"/>
                    <xsl:attribute name="col" type="xs:integer" select="$tmp"/>
                    <xsl:attribute name="score" type="xs:integer" select="$tmp"/>
                    <xsl:attribute name="gap_score" type="xs:integer" select="$tmp * $gap_score"/>
                    <xsl:attribute name="source" type="xs:string" select="'l'"/>
                </cell>
            </xsl:if>
            <xsl:if test="$diag lt $left_len">
                <xsl:variable name="tmp" as="xs:integer" select="$diag + 1"/>
                <cell>
                    <xsl:attribute name="row" type="xs:integer" select="$tmp"/>
                    <xsl:attribute name="col" type="xs:integer" select="0"/>
                    <xsl:attribute name="score" type="xs:integer" select="$tmp"/>
                    <xsl:attribute name="gap_score" type="xs:integer" select="$tmp * $gap_score"/>
                    <xsl:attribute name="source" type="xs:string" select="'u'"/>
                </cell>
            </xsl:if>
        </diag>
    </xsl:function>

    <xsl:function name="djb:create_grid" as="element(diag)+">
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- djb:create_grid()                                         -->
        <!-- create all cells in grid, organized by diagonal           -->
        <!-- parameters:                                               -->
        <!--   $left_len as xs:integer                                 -->
        <!--   $top_len as xs:integer                                  -->
        <!-- returns:                                                  -->
        <!--   element(diag)+ (from djb:get_diag_cells)                -->
        <!-- dependencies:                                             -->
        <!--   calls djb:get_diag_cells() for each diagonal            -->
        <!-- note: for testing during development, not in production   -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:param name="left_len" as="xs:integer"/>
        <xsl:param name="top_len" as="xs:integer"/>
        <xsl:if test="($left_len, $top_len) &lt; 1">
            <xsl:message terminate="yes"
                select="'$left_len and $top_len must both be positive integers'"/>
        </xsl:if>
        <xsl:variable name="diag_count" as="xs:integer" select="$top_len + $left_len - 1"/>
        <xsl:for-each select="1 to $diag_count" saxon:threads="10" default-validation="preserve">
            <xsl:sequence select="djb:get_diag_cells(., $left_len, $top_len)"/>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:find_path" as="element(result)">
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- djb:find_path()                                           -->
        <!-- generate alignment grid, recording full paths             -->
        <!-- parameters:                                               -->
        <!--   $diag_count as xs:integer                               -->
        <!--   $left_len as xs:integer                                 -->
        <!--   $top_len as xs:integer                                  -->
        <!--   $left_tokens as xs:string+                              -->
        <!--   $top_tokens as xs:string+                               -->
        <!-- returns:                                                  -->
        <!--   <result> with <path> (xs:string) and                    -->
        <!--   optional <cells> (element(cell)+) children              -->
        <!-- <path> is full optimal path as string of d, l, and u      -->
        <!-- <cells> is all cells (used to render full grid) when .    -->
        <!--   stylesheet param $output_grid is set to true            -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->

        <xsl:param name="diag_count" as="xs:integer"/>
        <xsl:param name="left_len" as="xs:integer"/>
        <xsl:param name="top_len" as="xs:integer"/>
        <xsl:param name="left_tokens" as="xs:string+"/>
        <xsl:param name="top_tokens" as="xs:string+"/>
        <xsl:iterate select="1 to $diag_count" default-validation="preserve">
            <!-- $ult and $penult hold the preceding two diags, with modification -->
            <xsl:param name="ult" as="element(cell)+">
                <cell>
                    <xsl:attribute name="row" type="xs:integer" select="1"/>
                    <xsl:attribute name="col" type="xs:integer" select="0"/>
                    <xsl:attribute name="score" type="xs:integer" select="$gap_score"/>
                    <xsl:attribute name="gap_score" type="xs:integer" select="$gap_score * 2"/>
                    <xsl:if test="$output_grid">
                        <xsl:attribute name="source" type="xs:string" select="'u'"/>
                    </xsl:if>
                    <xsl:attribute name="path" type="xs:string" select="'u'"/>
                </cell>
                <cell>
                    <xsl:attribute name="row" type="xs:integer" select="0"/>
                    <xsl:attribute name="col" type="xs:integer" select="1"/>
                    <xsl:attribute name="score" type="xs:integer" select="$gap_score"/>
                    <xsl:attribute name="gap_score" type="xs:integer" select="$gap_score * 2"/>
                    <xsl:if test="$output_grid">
                        <xsl:attribute name="source" type="xs:string" select="'l'"/>
                    </xsl:if>
                    <xsl:attribute name="path" type="xs:string" select="'l'"/>
                </cell>
            </xsl:param>
            <xsl:param name="penult" as="element(cell)+">
                <cell>
                    <xsl:attribute name="row" type="xs:integer" select="0"/>
                    <xsl:attribute name="col" type="xs:integer" select="0"/>
                    <xsl:attribute name="score" type="xs:integer" select="0"/>
                </cell>
            </xsl:param>
            <!-- this will be allowed to accumulate only if $output_grid is true -->
            <xsl:param name="cumulative" as="element(cell)*" select="$penult | $ult"/>
            <xsl:on-completion>
                <result>
                    <!-- always return <path>, optionally return cumulative <cells> -->
                    <path>
                        <xsl:value-of select="$ult/@path"/>
                    </path>
                    <xsl:if test="$output_grid">
                        <cells>
                            <xsl:sequence select="$cumulative"/>
                        </cells>
                    </xsl:if>
                </result>
            </xsl:on-completion>
            <xsl:variable name="current_diag" select="djb:get_diag_cells(., $left_len, $top_len)"
                as="element(diag)+"/>
            <!-- search space as document for key use-->
            <xsl:variable name="search_space" as="document-node(element(root))">
                <xsl:document>
                    <root>
                        <xsl:sequence select="$ult | $penult"/>
                    </root>
                </xsl:document>
            </xsl:variable>
            <xsl:variable name="current" as="element(cell)+">
                <xsl:for-each select="$current_diag/cell" saxon:threads="10">
                    <!-- 
                        is the current cell a match? 
                        need to atomize explicitly; otherwise it does a node test and returns True 
                        [current()/data(@row)] or [current()/number(@row)] is 
                            faster than [position() eq current()/@row]
                    -->
                    <xsl:variable name="current_match" as="xs:integer"
                        select="
                            if ($left_tokens[current()/data(@row)] eq $top_tokens[current()/data(@col)]) then
                                $match_score
                            else
                                $mismatch_score"/>
                    <!-- get three values, mapped to sources, sort by score, then source -->
                    <xsl:variable name="d_cell" as="element(cell)?"
                        select="key('cellByRowCol', (@row - 1, @col - 1), $search_space)"/>
                    <xsl:variable name="l_cell" as="element(cell)?"
                        select="key('cellByRowCol', (@row, @col - 1), $search_space)"/>
                    <xsl:variable name="u_cell" as="element(cell)?"
                        select="key('cellByRowCol', (@row - 1, @col), $search_space)"/>
                    <xsl:variable name="winners" as="element(winner)+">
                        <xsl:if test="$d_cell">
                            <winner>
                                <xsl:attribute name="name" type="xs:string" select="'d'"/>
                                <xsl:attribute name="score" type="xs:integer"
                                    select="$d_cell/@score + $current_match"/>
                                <xsl:attribute name="path" type="xs:string" select="$d_cell/@path"/>
                            </winner>
                        </xsl:if>
                        <xsl:if test="$l_cell">
                            <winner>
                                <xsl:attribute name="name" type="xs:string" select="'l'"/>
                                <xsl:attribute name="score" type="xs:integer"
                                    select="$l_cell/@gap_score"/>
                                <xsl:attribute name="path" type="xs:string" select="$l_cell/@path"/>
                            </winner>
                        </xsl:if>
                        <xsl:if test="$u_cell">
                            <winner>
                                <xsl:attribute name="name" type="xs:string" select="'u'"/>
                                <xsl:attribute name="score" type="xs:integer"
                                    select="$u_cell/@gap_score"/>
                                <xsl:attribute name="path" type="xs:string" select="$u_cell/@path"/>
                            </winner>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="winners_sorted" as="element(winner)+">
                        <xsl:perform-sort select="$winners">
                            <xsl:sort select="@score" order="descending" stable="no"/>
                            <xsl:sort select="@name"/>
                        </xsl:perform-sort>
                    </xsl:variable>
                    <xsl:copy>
                        <xsl:copy-of select="@*"/>
                        <xsl:variable name="current_score" as="xs:integer"
                            select="$winners_sorted[1]/@score"/>
                        <xsl:if test="$output_grid">
                            <xsl:attribute name="data-match" type="xs:integer"
                                select="$current_match"/>
                        </xsl:if>
                        <xsl:attribute name="score" type="xs:integer" select="$current_score"/>
                        <xsl:attribute name="gap_score" type="xs:integer"
                            select="$current_score + $gap_score"/>
                        <xsl:if test="$output_grid">
                            <xsl:attribute name="source" type="xs:string"
                                select="$winners_sorted[1]/@name"/>
                        </xsl:if>
                        <xsl:attribute name="path" type="xs:string"
                            select="string-join(($winners_sorted[1]/@path, $winners_sorted[1]/@name))"
                        />
                    </xsl:copy>
                </xsl:for-each>
            </xsl:variable>
            <xsl:next-iteration>
                <xsl:with-param name="ult" as="element(cell)+" select="$current"/>
                <xsl:with-param name="penult" as="element(cell)*" select="$ult"/>
                <!-- accumulate cells only if grid output is required -->
                <xsl:with-param name="cumulative" as="element(cell)*"
                    select="
                        if ($output_grid) then
                            ($cumulative, $current)
                        else
                            ()"
                />
            </xsl:next-iteration>
        </xsl:iterate>
    </xsl:function>

    <xsl:function name="djb:grid_to_html" as="element(html:table)">
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- djb:grid_to_html()                                        -->
        <!-- outputs alignment grid as HTML table                      -->
        <!-- parameters:                                               -->
        <!--   cells as element(cell)+                                 -->
        <!-- returns:                                                  -->
        <!--   HTML document                                           -->
        <!-- note: diagnostic only; not used in production             -->
        <!--   to use, set iterator to return $cumulative              -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:param name="cells" as="element(cell)+"/>
        <xsl:param name="top" as="xs:string+"/>
        <xsl:param name="left" as="xs:string+"/>
        <table id="alignment_grid" xmlns="http://www.w3.org/1999/xhtml">
            <tr>
                <td>&#xa0;</td>
                <td>&#xa0;</td>
                <xsl:for-each select="$left">
                    <th>
                        <xsl:sequence select="."/>
                    </th>
                </xsl:for-each>
            </tr>
            <xsl:for-each select="distinct-values($cells/@row)" saxon:threads="10">
                <xsl:sort stable="no"/>
                <xsl:variable name="row" as="xs:integer" select="."/>
                <tr>
                    <th>
                        <xsl:sequence select="($top[$row], '&#xa0;')[1]"/>
                    </th>
                    <xsl:for-each select="$cells[@row = $row]" saxon:threads="10">
                        <xsl:sort select="@col" stable="no"/>
                        <td>
                            <xsl:if test="$output_grid">
                                <xsl:copy-of select="@data-match"/>
                            </xsl:if>
                            <xsl:value-of select="@score"/>
                        </td>
                    </xsl:for-each>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:function>

    <xsl:function name="djb:create_alignment_table" as="element(html:table)">
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- djb:create_alignment_table()                              -->
        <!-- generates alignment table                                 -->
        <!-- parameters:                                               -->
        <!--   $path as xs:string (d, l, and u steps)                  -->
        <!--   $left_tokens as xs:string+                              -->
        <!--   $top_tokens as xs:string+                               -->
        <!-- returns:                                                  -->
        <!--   html <table> with two rows                              -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:param name="path" as="xs:string"/>
        <xsl:param name="left_tokens_in" as="xs:string*"/>
        <xsl:param name="top_tokens_in" as="xs:string*"/>
        <!-- 
            break optimal path into individual steps of d, l, u
            traverse from the end
        -->
        <xsl:variable name="path_steps" as="xs:string+"
            select="
                reverse(for $c in string-to-codepoints($path)
                return
                    codepoints-to-string($c))"/>
        <xsl:iterate select="1 to count($path_steps)">
            <xsl:param name="left_tokens" as="xs:string*" select="reverse($left_tokens_in)"/>
            <xsl:param name="top_tokens" as="xs:string*" select="reverse($top_tokens_in)"/>
            <xsl:param name="left_cells" as="element(html:td)*" select="()"/>
            <xsl:param name="top_cells" as="element(html:td)*" select="()"/>
            <xsl:on-completion>
                <xsl:sequence>
                    <table xmlns="http://www.w3.org/1999/xhtml">
                        <tr>
                            <th>Left</th>
                            <xsl:sequence select="reverse($left_cells)"/>
                        </tr>
                        <tr>
                            <th>Top</th>
                            <xsl:sequence select="reverse($top_cells)"/>
                        </tr>
                    </table>
                </xsl:sequence>
            </xsl:on-completion>
            <xsl:variable name="current_direction" as="xs:string" select="$path_steps[current()]"/>
            <xsl:variable name="new_left_tokens" as="xs:string*"
                select="
                    if ($current_direction = ('d', 'u')) then
                        tail($left_tokens)
                    else
                        $left_tokens"/>
            <xsl:variable name="new_top_tokens" as="xs:string*"
                select="
                    if ($current_direction = ('d', 'l')) then
                        tail($top_tokens)
                    else
                        $top_tokens"/>
            <xsl:variable name="match_test" as="xs:integer?">
                <!-- to style cells according to whether they match -->
                <xsl:if test="$current_direction eq 'd'">
                    <xsl:choose>
                        <xsl:when test="head($left_tokens) = head($top_tokens)">
                            <xsl:sequence select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="-1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="new_left_cell" as="element(html:td)">
                <td xmlns="http://www.w3.org/1999/xhtml">
                    <xsl:if test="$current_direction eq 'd'">
                        <xsl:attribute name="data-match" select="$match_test"/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="$current_direction = ('d', 'u')">
                            <xsl:sequence select="head($left_tokens)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="'&#xa0;'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </xsl:variable>
            <xsl:variable name="new_top_cell" as="element(html:td)">
                <td xmlns="http://www.w3.org/1999/xhtml">
                    <xsl:if test="$current_direction eq 'd'">
                        <xsl:attribute name="data-match" select="$match_test"/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="$current_direction = ('d', 'l')">
                            <xsl:sequence select="head($top_tokens)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="'&#xa0;'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </xsl:variable>
            <xsl:next-iteration>
                <xsl:with-param name="left_tokens" as="xs:string*" select="$new_left_tokens"/>
                <xsl:with-param name="top_tokens" as="xs:string*" select="$new_top_tokens"/>
                <xsl:with-param name="left_cells" select="$left_cells, $new_left_cell"/>
                <xsl:with-param name="top_cells" select="$top_cells, $new_top_cell"/>
            </xsl:next-iteration>
        </xsl:iterate>
    </xsl:function>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- main                                                       -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:template name="xsl:initial-template">
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- choose input (for testing)                             -->
        <!--                                                        -->
        <!-- number of paragraphs to align is supplied by static    -->
        <!--   $paragraph_count parameter (defaults to 1)           -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->

        <xsl:variable name="darwin_1859_xml" as="document-node(element(ch))"
            select="doc('texts/darwin_1859_01.xml')"/>
        <xsl:variable name="darwin_1860_xml" as="document-node(element(ch))"
            select="doc('texts/darwin_1860_01.xml')"/>
        <xsl:variable name="left" as="xs:string+"
            select="string-join($darwin_1859_xml//p[position() le $paragraph_count], ' ')"/>
        <xsl:variable name="top" as="xs:string+"
            select="string-join($darwin_1860_xml//p[position() le $paragraph_count], ' ')"/>
        <xsl:variable name="total_ps" as="xs:integer" select="count($darwin_1859_xml//p)"/>
        <xsl:if test="$paragraph_count gt $total_ps">
            <xsl:message
                select="'You asked for', $paragraph_count, 'paragraph(s) and the source contains', $total_ps"
            />
        </xsl:if>

        <!-- short single strings for testing -->
        <!--<xsl:variable name="left" as="xs:string" select="'kitten'"/>
        <xsl:variable name="top" as="xs:string" select="'sitting'"/>-->

        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- tokenize inputs and count                              -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="tokenized_input" as="map(xs:string, item()+)"
            select="djb:tokenize_input($left, $top)"/>
        <xsl:variable name="top_tokens" as="xs:string+" select="$tokenized_input('top')"/>
        <xsl:variable name="top_len" as="xs:integer" select="count($top_tokens)"/>
        <xsl:variable name="left_tokens" as="xs:string+" select="$tokenized_input('left')"/>
        <xsl:variable name="left_len" as="xs:integer" select="count($left_tokens)"/>
        <xsl:variable name="input_type" as="xs:string" select="$tokenized_input('type')"/>
        <xsl:variable name="diag_count" as="xs:integer" select="$top_len + $left_len - 1"/>

        <xsl:variable name="grid_data" as="element(result)"
            select="djb:find_path($diag_count, $left_len, $top_len, $left_tokens, $top_tokens)"/>
        <xsl:variable name="alignment_table" as="element(html:table)+"
            select="djb:create_alignment_table($grid_data//path, $left_tokens, $top_tokens)"/>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Needleman Wunsch alignnment</title>
                <link rel="stylesheet" type="text/css" href="http://www.obdurodon.org/css/style.css"/>
                <style type="text/css">
                    #alignment_grid td {
                        text-align: right;
                    }
                    td[data-match = "1"] {
                        background-color: palegreen;
                    }
                    td[data-match = "-1"] {
                        background-color: pink;
                    }</style>
            </head>
            <body>
                <h1>Needleman Wunsch alignment</h1>
                <h2>Input</h2>
                <ul>
                    <li>
                        <strong>Left: </strong>
                        <xsl:sequence select="concat($left, ' (', $left_len, ' ', $input_type, ')')"
                        />
                    </li>
                    <li>
                        <strong>Top: </strong>
                        <xsl:sequence select="concat($top, ' (', $top_len, ' ', $input_type, ')')"/>
                    </li>
                </ul>
                <h2>Alignment table</h2>
                <xsl:sequence select="$alignment_table"/>
                <xsl:if test="$output_grid">
                    <h2>Alignment grid</h2>
                    <xsl:sequence
                        select="djb:grid_to_html($grid_data//cell, $left_tokens, $top_tokens)"/>
                </xsl:if>
            </body>
        </html>

    </xsl:template>

</xsl:stylesheet>

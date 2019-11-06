<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- David J. Birnbaum (djbpitt@gmail.com)                      -->
    <!-- djbpitt@gmail.com, http://www.obdurodon.org                -->
    <!-- https://github.com/djbpitt/xstuff/nw .                     -->
    <!--                                                            -->
    <!-- Needleman Wunsch alignment in XSLT 3.0                     -->
    <!-- See:                                                       -->
    <!--   https://www.cs.sjsu.edu/~aid/cs152/NeedlemanWunsch.pdf   -->
    <!--                                                            -->
    <!-- In case of ties, arbitrarily favor diagonal, then left     -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->

    <xsl:output method="xml" indent="yes"/>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- stylesheet variables                                       -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- arrow_map                                                  -->
    <!--                                                            -->
    <!-- retrieve arrow for source of best cell score               -->
    <!-- d, u, l = diagonal, from up, from left                     -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:variable name="arrow_map" as="map(xs:string, xs:string)"
        select='
            map {
                "d": "↘",
                "u": "↓",
                "l": "→"
            }'/>
    <!-- Darwin texts can be used to test word-level alignment-->
    <xsl:variable name="darwin_1859" as="xs:string">WHEN we look to the individuals of the same
        variety or sub-variety of our older cultivated plants and animals, one of the first points
        which strikes us, is, that they generally differ much more from each other, than do the
        individuals of any one species or variety in a state of nature. When we reflect on the vast
        diversity of the plants and animals which have been cultivated, and which have varied during
        all ages under the most different climates and treatment, I think we are driven to conclude
        that this greater variability is simply due to our domestic productions having been raised
        under conditions of life not so uniform as, and somewhat different from, those to which the
        parent-species have been exposed under nature. There is, also, I think, some probability in
        the view propounded by Andrew Knight, that this variability may be partly connected with
        excess of food. It seems pretty clear that organic beings must be exposed during several
        generations to the new conditions of life to cause any appreciable amount of variation; and
        that when the organisation has once begun to vary, it generally continues to vary for many
        generations. No case is on record of a variable being ceasing to be variable under
        cultivation. Our oldest cultivated plants, such as wheat, still often yield new varieties:
        our oldest domesticated animals are still capable of rapid improvement or
        modification.</xsl:variable>
    <xsl:variable name="darwin_1872" as="xs:string">Causes of Variability. WHEN we compare the
        individuals of the same variety or sub-variety of our older cultivated plants and animals,
        one of the first points which strikes us is, that they generally differ more from each other
        than do the individuals of any one species or variety in a state of nature. And if we
        reflect on the vast diversity of the plants and animals which have been cultivated, and
        which have varied during all ages under the most different climates and treatment, we are
        driven to conclude that this great variability is due to our domestic productions having
        been raised under conditions of life not so uniform as, and somewhat different from, those
        to which the parent-species had been exposed under nature. There is, also, some probability
        in the view propounded by Andrew Knight, that this variability may be partly connected with
        excess of food. It seems clear that organic beings must be exposed during several
        generations to new conditions to cause any great amount of variation; and that, when the
        organisation has once begun to vary, it generally continues varying for many generations. No
        case is on record of a variable organism ceasing to vary under cultivation. Our oldest
        cultivated plants, such as wheat, still yield new varieties: our oldest domesticated animals
        are still capable of rapid improvement or modification.</xsl:variable>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- scoring (may be altered):                              -->
    <!--   match    =  1                                        -->
    <!--   mismatch = -1                                        -->
    <!--   gap      = -2                                        -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:variable name="match" as="xs:integer" select="1"/>
    <xsl:variable name="mismatch" as="xs:integer" select="-1"/>
    <xsl:variable name="gap" as="xs:integer" select="-2"/>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- functions                                                  -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:explode                                                -->
    <!--                                                            -->
    <!-- split string into sequence of one-character strings        -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:explode" as="xs:string*">
        <!-- explode string into sequence of single characters -->
        <xsl:param name="in" as="xs:string*"/>
        <xsl:sequence
            select="
                for $c in string-to-codepoints($in)
                return
                    codepoints-to-string($c)"
        />
    </xsl:function>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:nw                                                     -->
    <!--                                                            -->
    <!-- align two strings using Needleman Wunsch algorithm         -->
    <!-- returns a <table> element in no namespace with <row> and   -->
    <!--   <cell> content, where <cell> has attributes              -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:nw" as="element(table)">
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- input is two sequences of strings, $s1 and $s2         -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:param name="s1" as="xs:string+"/>
        <xsl:param name="s2" as="xs:string+"/>

        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- create table                                           -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <table>
            <xsl:iterate select="1 to count($s2)">
                <xsl:param name="rows" as="element(row)+">
                    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                    <!-- top two rows are characters and gap values -->
                    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                    <row>
                        <cell>&#xa0;</cell>
                        <cell>&#xa0;</cell>
                        <xsl:for-each select="$s1">
                            <cell>
                                <xsl:value-of select="."/>
                            </cell>
                        </xsl:for-each>
                    </row>
                    <row>
                        <cell>&#xa0;</cell>
                        <cell>0</cell>
                        <xsl:for-each select="$s1">
                            <cell cell_from="l" cell_arrow="→" top_string="{.}">
                                <xsl:value-of select="$gap * position()"/>
                            </cell>
                        </xsl:for-each>
                    </row>
                </xsl:param>
                <xsl:param name="column_offset" as="xs:integer" select="1"/>
                <xsl:on-completion>
                    <xsl:sequence select="$rows"/>
                </xsl:on-completion>
                <xsl:variable name="current_row_number" as="xs:integer" select="current()"/>
                <xsl:variable name="new_rows" as="element(row)+">
                    <xsl:sequence select="$rows"/>
                    <row>
                        <cell>
                            <xsl:value-of select="$s2[current()]"/>
                        </cell>
                        <cell cell_from="u" cell_arrow="↓" left_string="{$s2[current()]}">
                            <xsl:value-of select="$gap * position()"/>
                        </cell>
                        <xsl:iterate select="1 to count($s1)">
                            <xsl:param name="last_cell" as="element(cell)?" select="()"/>
                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <!-- character match test               -->
                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <xsl:variable name="top_string" as="xs:string" select="$s1[current()]"/>
                            <xsl:variable name="left_string" as="xs:string"
                                select="$s2[$column_offset]"/>
                            <xsl:variable name="string_match" as="xs:integer"
                                select="
                                    if ($top_string eq $left_string) then
                                        $match
                                    else
                                        $mismatch"/>
                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <!-- neighboring values                 -->
                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <xsl:variable name="row_above" as="element(row)"
                                select="$rows[count($rows)]"/>
                            <xsl:variable name="current_column" as="xs:integer" select="current()"/>
                            <xsl:variable name="cell_up" as="element(cell)"
                                select="$row_above/cell[$current_column + 2]"/>
                            <xsl:variable name="cell_diag" as="element(cell)"
                                select="$row_above/cell[$current_column + 1]"/>
                            <xsl:variable name="cell_left" as="item()?"
                                select="
                                    if ($last_cell) then
                                        $last_cell
                                    else
                                        $gap * $current_row_number"/>
                            <xsl:variable name="scores" as="element(score)+">
                                <score source="u" value="{$cell_up + $gap}"/>
                                <score source="l" value="{$cell_left + $gap}"/>
                                <score source="d" value="{$cell_diag + xs:integer($string_match)}"/>
                            </xsl:variable>
                            <xsl:variable name="best_scores" as="element(score)+">
                                <xsl:for-each select="$scores[@value = max($scores/@value)]">
                                    <!-- Select by value, then sort by @xml:id 
                                        (conveniently, preference corresponds to alphabetical)
                                    -->
                                    <xsl:sort select="@source"/>
                                    <xsl:sequence select="."/>
                                </xsl:for-each>
                            </xsl:variable>
                            <xsl:variable name="cell_value" as="xs:double"
                                select="$best_scores[1]/@value"/>
                            <xsl:variable name="cell_from" as="xs:string"
                                select="$best_scores[1]/@source"/>
                            <xsl:variable name="cell_arrow" as="xs:string"
                                select="$arrow_map($cell_from)"/>

                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <!-- create the cell                    -->
                            <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                            <xsl:variable name="new_cell" as="element(cell)">
                                <cell top_string="{$top_string}" left_string="{$left_string}"
                                    match="{$string_match}" cell_up="{$cell_up}"
                                    cell_left="{$cell_left}" cell_diag="{$cell_diag}"
                                    cell_from="{$cell_from}" cell_arrow="{$cell_arrow}">
                                    <xsl:value-of select="$cell_value"/>
                                </cell>
                            </xsl:variable>
                            <xsl:sequence select="$new_cell"/>
                            <xsl:next-iteration>
                                <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                                <!-- cells need to look left        -->
                                <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
                                <xsl:with-param name="last_cell" as="element(cell)"
                                    select="$new_cell"/>
                            </xsl:next-iteration>
                        </xsl:iterate>
                    </row>
                </xsl:variable>
                <xsl:next-iteration>
                    <xsl:with-param name="rows" as="element(row)+" select="$new_rows"/>
                    <xsl:with-param name="column_offset" as="xs:integer" select="$column_offset + 1"
                    />
                </xsl:next-iteration>
            </xsl:iterate>
        </table>
    </xsl:function>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:align                                                  -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:align" as="element(table)">
        <xsl:param name="in" as="element(table)"/>
        <xsl:param name="s1" as="xs:string*"/>
        <xsl:param name="s2" as="xs:string*"/>
        <xsl:param name="current_row" as="xs:integer"/>
        <xsl:param name="current_column" as="xs:integer"/>
        <xsl:param name="pairs" as="element(pair)*"/>
        <xsl:iterate select="1 to 100000">
            <xsl:param name="in" as="element(table)" select="$in"/>
            <xsl:param name="s1" as="xs:string*" select="$s1"/>
            <xsl:param name="s2" as="xs:string*" select="$s2"/>
            <xsl:param name="current_row" as="xs:integer" select="$current_row"/>
            <xsl:param name="current_column" as="xs:integer" select="$current_column"/>
            <xsl:param name="pairs" as="element(pair)*" select="$pairs"/>
            <xsl:variable name="current_cell" as="element(cell)?"
                select="$in/row[$current_row]/cell[$current_column]"/>
            <xsl:choose>
                <xsl:when test="$current_row eq 2 and $current_column eq 2">
                    <xsl:break>
                        <table>
                            <xsl:sequence select="$pairs"/>
                        </table>
                    </xsl:break>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="new_pairs" as="element(pair)+">
                        <xsl:sequence select="$pairs"/>
                        <pair>
                            <top>
                                <xsl:choose>
                                    <xsl:when test="$current_cell/@cell_from = ('d', 'l')">
                                        <xsl:value-of select="$current_cell/@top_string"/>
                                    </xsl:when>
                                    <xsl:otherwise> </xsl:otherwise>
                                </xsl:choose>
                            </top>
                            <bottom>
                                <xsl:choose>
                                    <xsl:when test="$current_cell/@cell_from = ('d', 'u')">
                                        <xsl:value-of select="$current_cell/@left_string"/>
                                    </xsl:when>
                                    <xsl:otherwise> </xsl:otherwise>
                                </xsl:choose>
                            </bottom>
                        </pair>
                    </xsl:variable>
                    <xsl:variable name="new_row" as="xs:integer"
                        select="
                            if ($current_cell/@cell_from = ('d', 'u')) then
                                $current_row - 1
                            else
                                $current_row"/>
                    <xsl:variable name="new_column" as="xs:integer"
                        select="
                            if ($current_cell/@cell_from = ('d', 'l')) then
                                $current_column - 1
                            else
                                $current_column"/>
                    <xsl:variable name="new_s1" as="xs:string*"
                        select="
                            if ($current_cell/@cell_from = ('d', 'l')) then
                                subsequence($s1, 1, count($s1) - 1)
                            else
                                $s1"/>
                    <xsl:variable name="new_s2" as="xs:string*"
                        select="
                            if ($current_cell/@cell_from = ('d', 'u')) then
                                subsequence($s2, 1, count($s2) - 1)
                            else
                                $s2"/>
                    <xsl:next-iteration>
                        <!-- $table doesn't change, so don't send it recursively -->
                        <xsl:with-param name="s1" as="xs:string*" select="$new_s1"/>
                        <xsl:with-param name="s2" as="xs:string*" select="$new_s2"/>
                        <xsl:with-param name="current_row" as="xs:integer" select="$new_row"/>
                        <xsl:with-param name="current_column" as="xs:integer" select="$new_column"/>
                        <xsl:with-param name="pairs" as="element(pair)+" select="$new_pairs"/>
                    </xsl:next-iteration>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:iterate>
    </xsl:function>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- main                                                       -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="s1" as="xs:string+" select="tokenize($darwin_1859, '\s+')"/>
        <xsl:variable name="s2" as="xs:string+" select="tokenize($darwin_1872, '\s+')"/>
        <!--<xsl:variable name="s1" as="xs:string+" select="'koala'"/>
        <xsl:variable name="s2" as="xs:string+" select="'wombat'"/>-->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- if both inputs are single words, align by character    -->
        <!--   otherwise align by word                              -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="table"
            select="
                djb:nw(if (count($s1) eq 1 and count($s2) eq 1) then
                    djb:explode($s1)
                else
                    $s1,
                if (count($s1) eq 1 and count($s2) eq 1) then
                    djb:explode($s2)
                else
                    $s2)"/>
        <xsl:variable name="alignment" as="element(table)?"
            select="
                djb:align(
                $table,
                if (count($s1) eq 1 and count($s2) eq 1) then
                    djb:explode($s1)
                else
                    $s1,
                if (count($s1) eq 1 and count($s2) eq 1) then
                    djb:explode($s2)
                else
                    $s2,
                $table/count(row),
                $table/row[1]/count(cell),
                ()
                )"/>

        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- For HTML output                                        -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Needleman Wunsch test</title>
                <link rel="stylesheet" type="text/css" href="http://www.obdurodon.org/css/style.css"/>
                <style type="text/css">
                    #grid th,
                    #grid td {
                        text-align: right;
                    }
                    #grid th:first-of-type {
                        text-align: left;
                    }
                    #grid tr:first-of-type > th {
                        text-align: center;
                    }
                    #grid td:before,
                    #grid th:before {
                        content: attr(data-cell_arrow) " ";
                        font-size: small;
                    }
                    [data-match = "1"] {
                        background-color: palegreen;
                    }
                    [data-match = "-1"] {
                        background-color: pink;
                    }
                    #alignment th {
                        text-align: left;
                    }</style>
            </head>
            <body>
                <h1>Needleman Wunsch test</h1>
                <p>
                    <strong>Alignment scale: </strong>
                    <xsl:variable name="scale" as="xs:string"
                        select="
                            if (count($s1) eq 1 and count($s2) eq 1) then
                                'character'
                            else
                                'word'"/>
                    <xsl:value-of select="$scale"/>
                    <br/>
                    <strong>Top input: </strong>
                    <xsl:value-of select="string-join($s1, ' ') || ' ('"/>
                    <xsl:value-of
                        select="
                            if ($scale eq 'character') then
                                string-length($s1)
                            else
                                count($s1)"/>
                    <xsl:value-of select="')'"/>
                    <br/>
                    <strong>Bottom input: </strong>
                    <xsl:value-of select="string-join($s2, ' ') || ' ('"/>
                    <xsl:value-of
                        select="
                            if ($scale eq 'character') then
                                string-length($s2)
                            else
                                count($s2)"/>
                    <xsl:value-of select="')'"/>
                    <br/>
                    <strong>Generated: </strong>
                    <xsl:value-of select="current-dateTime()"/>
                </p>
                <h2>Grid</h2>
                <!-- uncomment for diagnostics -->
                <!--<xsl:sequence select="$table"/>-->
                <xsl:apply-templates select="$table" mode="html"/>
                <h2>Alignment</h2>
                <xsl:variable name="alignment"
                    select="djb:align($table, $s1, $s2, $table/count(row), $table/row[1]/count(cell), ())"/>
                <!-- uncomment for diagnostics -->
                <!--<xsl:sequence select="$alignment"/>-->
                <xsl:apply-templates select="$alignment" mode="alignment">
                    <xsl:with-param name="s1" as="xs:string+" select="$s1"/>
                    <xsl:with-param name="s2" as="xs:string+" select="$s2"/>
                </xsl:apply-templates>
            </body>
        </html>
    </xsl:template>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- templates for HTML grid                                    -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:template match="table" mode="html" xmlns="http://www.w3.org/1999/xhtml">
        <table id="grid">
            <xsl:apply-templates mode="html"/>
        </table>
    </xsl:template>
    <xsl:template match="row" mode="html" xmlns="http://www.w3.org/1999/xhtml">
        <tr>
            <xsl:apply-templates mode="html"/>
        </tr>
    </xsl:template>
    <xsl:template match="cell" mode="html" xmlns="http://www.w3.org/1999/xhtml">
        <xsl:element
            name="{if (count(preceding::row) lt 2 or count(preceding-sibling::cell) lt 2) then 'th' else 'td'}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{concat('data-', name())}" select="."/>
            </xsl:for-each>
            <xsl:apply-templates mode="html"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="table[@type eq 'alignment']" mode="html"
        xmlns="http://www.w3.org/1999/xhtml">
        <table id="alignment">
            <xsl:apply-templates select="row" mode="html"/>
        </table>
    </xsl:template>
    <xsl:template match="table[@type eq 'alignment']/row" mode="html"
        xmlns="http://www.w3.org/1999/xhtml">
        <tr>
            <xsl:apply-templates mode="html"/>
        </tr>
    </xsl:template>
    <xsl:template match="table[@type eq 'alignment']/row/cell" xmlns="http://www.w3.org/1999/xhtml">
        <td>
            <xsl:apply-templates mode="html"/>
        </td>
    </xsl:template>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- templates for HTML alignment table                         -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:template match="table" mode="alignment" xmlns="http://www.w3.org/1999/xhtml">
        <xsl:param name="s1" as="xs:string+"/>
        <xsl:param name="s2" as="xs:string+"/>
        <table id="alignment">
            <tr>
                <th>
                    <xsl:value-of select="substring(string-join($s1, ' '), 1, 12)"/>
                    <xsl:value-of
                        select="
                            if (string-length(string-join($s1, ' ')) gt 12) then
                                '…'
                            else
                                ()"
                    />
                </th>
                <xsl:apply-templates select="reverse(pair/top)" mode="alignment"/>
            </tr>
            <tr>
                <th>
                    <xsl:value-of select="substring(string-join($s2, ' '), 1, 12)"/>
                    <xsl:value-of
                        select="
                            if (string-length(string-join($s1)) gt 12) then
                                '…'
                            else
                                ()"
                    />
                </th>
                <xsl:apply-templates select="reverse(pair/bottom)" mode="alignment"/>
            </tr>
        </table>
    </xsl:template>
    <xsl:template match="top | bottom" mode="alignment" xmlns="http://www.w3.org/1999/xhtml">
        <xsl:variable name="match" as="xs:integer"
            select="
                if (../top eq ../bottom) then
                    1
                else
                    if (exists(../top/text()) and exists(../bottom/text())) then
                        -1
                    else
                        0"/>
        <td data-match="{$match}">
            <xsl:apply-templates/>
        </td>
    </xsl:template>
</xsl:stylesheet>

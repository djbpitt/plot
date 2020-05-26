<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array" version="3.0"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:html="http://www.w3.org/1999/xhtml">
    <xsl:output method="xml" indent="yes" doctype-system="about:legacy-compat"/>
    <xsl:use-package name="http://www.obdurodon.org/linear-algebra-lib"/>
    <xsl:function name="djb:dump-matrix-cells" as="element(html:table)">
        <xsl:param name="input" as="array(array(*)*)"/>
        <xsl:variable name="column-count" as="xs:integer" select="array:size($input(1))"/>
        <table>
            <tr>
                <th>&#xa0;</th>
                <xsl:for-each select="1 to $column-count">
                    <th>
                        <xsl:value-of select="current()"/>
                    </th>
                </xsl:for-each>
            </tr>
            <xsl:for-each select="1 to array:size($input)">
                <xsl:variable name="row-number" as="xs:integer" select="current()"/>
                <tr>
                    <th>
                        <xsl:value-of select="current()"/>
                    </th>
                    <xsl:for-each select="1 to array:size($input(1))">
                        <xsl:variable name="column-number" select="current()"/>
                        <td>
                            <xsl:sequence select="$input($row-number)($column-number)"/>
                        </td>
                    </xsl:for-each>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:function>
    <xsl:function name="djb:get-matrix-dimensions" as="xs:string">
        <xsl:param name="input" as="array(array(*)*)"/>
        <xsl:variable name="row-count" as="xs:integer" select="array:size($input)"/>
        <xsl:variable name="column-count" as="xs:integer" select="array:size($input(1))"/>
        <h3 class="dimensions">
            <xsl:sequence select="string-join(($row-count, $column-count), ' x ')"/>
        </h3>
    </xsl:function>

    <xsl:template name="xsl:initial-template">
        <xsl:variable name="input-matrix" as="array(array(xs:integer+)+)"
            select="
                [
                    [1, 2, 3],
                    [4, 5, 6]
                ]"/>
        <xsl:variable name="transposed-matrix" select="djb:transpose-matrix($input-matrix)"/>
        <html>
            <head>
                <title>Transpose-matrix tests</title>
                <style type="text/css">
                    .table-wrapper {
                        display: flex;
                        padding-bottom: 1em;
                    }
                    .table-wrapper > section {
                        margin: 0 1em;
                    }
                    table,
                    tr,
                    th,
                    td {
                        border: black 1px solid;
                        border-collapse: collapse;
                        padding: .5em;
                    }
                    table {
                        margin: auto;
                    }
                    th,
                    td {
                        text-align: right;
                    }</style>
            </head>
            <body>
                <section class="table-wrapper">
                    <section>
                        <h3>
                            <xsl:text>Input (</xsl:text>
                            <xsl:sequence select="djb:get-matrix-dimensions($input-matrix)"/>
                            <xsl:text>)</xsl:text>
                        </h3>
                        <xsl:sequence select="djb:dump-matrix-cells($input-matrix)"/>
                    </section>
                    <section>
                        <h3>
                            <xsl:text>Output (</xsl:text>
                            <xsl:sequence select="djb:get-matrix-dimensions($transposed-matrix)"/>
                            <xsl:text>)</xsl:text>
                        </h3>
                        <xsl:sequence select="djb:dump-matrix-cells($transposed-matrix)"/>
                    </section>
                </section>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

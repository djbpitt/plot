<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:f="http://www.obdurodon.org/function-variables" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
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
    <xsl:function name="djb:dump-matrix-cells" as="element(html:div)">
        <xsl:param name="input" as="array(array(*)*)"/>
        <div class="cells">
            <xsl:for-each select="1 to array:size($input)">
                <xsl:variable name="row-number" as="xs:integer" select="current()"/>
                <xsl:for-each select="1 to array:size($input(1))">
                    <xsl:variable name="column-number" select="current()"/>
                    <div class="cell">
                        <xsl:sequence
                            select="concat('(', $row-number, ',', $column-number, '): '), $input($row-number)($column-number)"
                        />
                    </div>
                </xsl:for-each>
            </xsl:for-each>
        </div>
    </xsl:function>
    <xsl:function name="djb:get-matrix-dimensions" as="element(html:h3)">
        <xsl:param name="input" as="array(array(*)*)"/>
        <xsl:variable name="row-count" as="xs:integer" select="array:size($input)"/>
        <xsl:variable name="column-count" as="xs:integer" select="array:size($input(1))"/>
        <h3 class="dimensions">
            <xsl:sequence select="string-join(($row-count, $column-count), ' x ')"/>
        </h3>
    </xsl:function>
    <xsl:function name="djb:dump-matrix" as="element()+">
        <xsl:param name="input" as="array(array(*)+)"/>
        <xsl:sequence select="djb:get-matrix-dimensions($input)"/>
        <xsl:sequence select="djb:dump-matrix-cells($input)"/>
    </xsl:function>

    <!-- ================================================================ -->
    <!-- Stylesheet variables: test data                                  -->
    <!-- ================================================================ -->
    <xsl:variable name="tests" as="array(array(*)*)+">
        <xsl:sequence
            select="
                [
                    [
                        [1, 2, 3],
                        [4, 5, 6]
                    ],
                    [
                        [7, 8],
                        [9, 10],
                        [11, 12]
                    ]
                ],
                [
                    [
                        [4],
                        [5],
                        [6]
                    ],
                    [
                        [1, 2, 3]
                    ]
                ],
                [
                    [
                        [1, 2, 3]
                    ],
                    [
                        [4],
                        [5],
                        [6]
                    ]
                ]"
        />
    </xsl:variable>

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <html>
            <head>
                <title>Dot-product tests</title>
            </head>
            <body>
                <h1>Dot product tests</h1>
                <xsl:for-each select="$tests">
                    <xsl:variable name="left-matrix" as="array(array(*))" select="current()(1)"/>
                    <xsl:variable name="right-matrix" as="array(array(*))" select="current()(2)"/>
                    <xsl:variable name="dot-product" as="array(array(*))"
                        select="djb:dot-product($left-matrix, $right-matrix)"/>
                    <div>
                        <h2>
                            <xsl:text>Test #</xsl:text>
                            <xsl:value-of select="position()"/>
                        </h2>
                        <div class="input-left-matrix">
                            <h3>
                                <xsl:text>Input (</xsl:text>
                                <xsl:sequence select="djb:dump-matrix($left-matrix)"/>
                                <xsl:text>)</xsl:text>
                            </h3>
                        </div>
                        <div class="input-right-matrix">
                            <xsl:sequence select="djb:dump-matrix($right-matrix)"/>
                        </div>
                        <div class="output-matrix">
                            <xsl:sequence select="djb:dump-matrix($dot-product)"/>
                        </div>
                    </div>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

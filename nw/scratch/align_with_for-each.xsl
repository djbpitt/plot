<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:variable name="top" as="xs:string+"
        select="
            reverse(for $c in string-to-codepoints('koala')
            return
                codepoints-to-string($c))"/>
    <xsl:variable name="left" as="xs:string+"
        select="
            reverse(for $c in string-to-codepoints('cola')
            return
                codepoints-to-string($c))"/>
    <xsl:variable name="path" as="xs:string+"
        select="
            reverse(for $c in string-to-codepoints('ddldd')
            return
                codepoints-to-string($c))"/>
    <xsl:template name="xsl:initial-template">
        <html>
            <head>
                <title>test</title>
            </head>
            <body>
                <table>
                    <tr>
                        <th>Top</th>
                        <xsl:variable name="top_tds" as="element(html:td)+">
                            <xsl:for-each select="$path">
                                <xsl:variable name="top_whereami" as="xs:integer"
                                    select="position()"/>
                                <xsl:variable name="top_offset" as="xs:integer"
                                    select="
                                        count(
                                        (
                                        index-of($path[position() le $top_whereami], 'd'),
                                        index-of($path[position() le $top_whereami], 'l')
                                        )
                                        )"/>
                                <td>
                                    <xsl:sequence
                                        select="
                                            if (current() = ('d', 'l')) then
                                                $top[$top_offset]
                                            else
                                                '&#xa0;'"
                                    />
                                </td>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:sequence select="reverse($top_tds)"/>
                    </tr>
                    <tr>
                        <th>Left</th>
                        <xsl:variable name="left_tds" as="element(html:td)+">
                            <xsl:for-each select="$path">
                                <xsl:variable name="left_whereami" as="xs:integer"
                                    select="position()"/>
                                <xsl:variable name="left_offset" as="xs:integer"
                                    select="
                                        count(
                                        (
                                        index-of($path[position() le $left_whereami], 'd'),
                                        index-of($path[position() le $left_whereami], 'u')
                                        )
                                        )"/>
                                <td>
                                    <xsl:sequence
                                        select="
                                            if (current() = ('d', 'u')) then
                                                $left[$left_offset]
                                            else
                                                ()"
                                    />
                                </td>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:sequence select="reverse($left_tds)"/>
                    </tr>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

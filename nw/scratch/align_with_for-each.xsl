<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml" xmlns:djb="http://www.obdurodon.org"
    xmlns:saxon="http://saxon.sf.net/" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="#all" version="3.0">
    <!--
        The following link is helpful for verification:
        http://rna.informatik.uni-freiburg.de/Teaching/index.jsp?toolName=Needleman-Wunsch
    -->
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:function name="djb:explode" as="xs:string+">
        <xsl:param name="in" as="xs:string"/>
        <xsl:sequence
            select="
                reverse(for $c in string-to-codepoints($in)
                return
                    codepoints-to-string($c))"
        />
    </xsl:function>
    <xsl:function name="djb:get_offset" as="xs:integer">
        <!--
            $path is list of d, l, and u values
            $pos is position in list currently being evaluated
            $direction is whether to consider d + l or d + u            
        -->
        <xsl:param name="path" as="xs:string+"/>
        <xsl:param name="pos" as="xs:integer"/>
        <xsl:param name="direction" as="xs:string"/>
        <xsl:sequence
            select="
                count(
                (
                index-of($path[position() le $pos], 'd'),
                index-of($path[position() le $pos], $direction)
                )
                )
                "
        />
    </xsl:function>
    <xsl:variable name="top" as="xs:string+" select="djb:explode('serafim')"/>
    <xsl:variable name="left" as="xs:string+" select="djb:explode('perfume')"/>
    <xsl:variable name="path" as="xs:string+" select="djb:explode('dddldddu')"/>
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
                            <xsl:for-each select="$path" saxon:threads="10">
                                <xsl:variable name="top_whereami" as="xs:integer"
                                    select="position()"/>
                                <td>
                                    <xsl:sequence
                                        select="
                                            if (current() = ('d', 'l')) then
                                                $top[djb:get_offset($path, $top_whereami, 'l')]
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
                            <xsl:for-each select="$path" saxon:threads="10">
                                <xsl:variable name="left_whereami" as="xs:integer"
                                    select="position()"/>
                                <td>
                                    <xsl:sequence
                                        select="
                                            if (current() = ('d', 'u')) then
                                                $left[djb:get_offset($path, $left_whereami, 'u')]
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

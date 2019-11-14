<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- two input strings as stylesheet parameters            -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:param name="in1" as="xs:string" required="yes"/>
    <xsl:param name="in2" as="xs:string" required="yes"/>

    <xsl:function name="djb:tokenize_input" as="map(xs:string, item()+)">
        <xsl:param name="top" as="xs:string"/>
        <xsl:param name="left" as="xs:string"/>
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- validate input                                        -->
        <!-- no null strings                                       -->
        <!-- both strings must be either single  or multiple-word  -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- normalize whitespace first                            -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="top_n" as="xs:string" select="normalize-space($top)"/>
        <xsl:variable name="left_n" as="xs:string" select="normalize-space($left)"/>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- check for mismatch parameter types                    -->
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
    <xsl:template name="xsl:initial-template">
        <xsl:param name="in1" as="xs:string" select="$in1"/>
        <xsl:param name="in2" as="xs:string" select="$in2"/>
        <xsl:variable name="result" as="map(xs:string, item()+)"
            select="djb:tokenize_input($in1, $in2)"/>
        <xsl:variable name="top" as="xs:string+" select="$result('top')"/>
        <xsl:variable name="top_len" as="xs:integer" select="count($top)"/>
        <xsl:variable name="left" as="xs:string+" select="$result('left')"/>
        <xsl:variable name="left_len" as="xs:integer" select="count($left)"/>
        <xsl:variable name="input_type" as="xs:string" select="$result('type')"/>
        <xsl:message select="$top"/>
    </xsl:template>
</xsl:stylesheet>

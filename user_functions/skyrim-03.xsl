<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml">
    <xsl:output method="xml" indent="yes" doctype-system="about:legacy-compat"/>
    <!-- ================================================================ -->
    <!-- Create tables of characters and factions in skyrim.xml           -->
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!-- ================================================================ -->
    <xsl:variable name="root" as="document-node()" select="/"/>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <xsl:function name="djb:get-attribute-names" as="xs:string+">
        <!-- ============================================================ -->
        <!-- djb:get-attribute names                                      -->
        <!-- Synopsis: return distinct attribute names by element type    -->
        <!--   Omit @id, sort alphabetically                              -->
        <!--                                                              -->
        <!-- Parameters                                                   -->
        <!--   input as xs:string: gi of element type                     -->
        <!-- Return:                                                      -->
        <!--   xs:string+: sequence of attribute names                    -->
        <!-- ============================================================ -->
        <xsl:param name="input" as="xs:string"/>
        <xsl:sequence
            select="
                $root//cast/*[name() eq $input]/(@* except @id)
                ! name()
                => distinct-values()
                => sort()
                "
        />
    </xsl:function>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <xsl:function name="djb:title-case" as="xs:string">
        <!-- ============================================================ -->
        <!-- djb:titleCase                                                -->
        <!-- Synopsis: upper-case first letter of string                  -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   input as xs:string: attribute name                         -->
        <!-- Return                                                       -->
        <!--   xs:string: attribute name with initial capitalization      -->
        <!-- ============================================================ -->
        <xsl:param name="input" as="xs:string"/>
        <xsl:sequence
            select="
                upper-case(substring($input, 1, 1))
                ||
                substring($input, 2)"
        />
    </xsl:function>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <xsl:function name="djb:create-table" as="element(xhtml:section)">
        <!-- ============================================================ -->
        <!-- djb:create-table                                             -->
        <!-- Synopsis: create section with h2 and table for element type  -->
        <!--                                                              -->
        <!-- Dependencies:                                                -->
        <!--   djb:get-attribute-names()                                  -->
        <!--   djb:title-case()                                           -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   input as xs:string: element type                           -->
        <!-- Return                                                       -->
        <!--   section element with h2 and table                          -->
        <!-- ============================================================ -->
        <xsl:param name="input" as="xs:string"/>
        <xsl:variable name="attributes" as="xs:string+" select="djb:get-attribute-names($input)"/>
        <section>
            <h2>
                <xsl:value-of select="djb:title-case($input)"/>
            </h2>
            <table>
                <tr>
                    <th>ID</th>
                    <xsl:for-each select="$attributes">
                        <th>
                            <xsl:value-of select="djb:title-case(.)"/>
                        </th>
                    </xsl:for-each>
                </tr>
                <xsl:apply-templates select="$root//cast/*[name() eq $input]">
                    <xsl:sort select="lower-case(@id)"/>
                    <xsl:with-param name="attribute-names" as="xs:string+"
                        select="'id', $attributes"/>
                </xsl:apply-templates>
            </table>
        </section>
    </xsl:function>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Skyrim</title>
            </head>
            <body>
                <h1>Skyrim</h1>
                <xsl:for-each select="'character', 'faction'">
                    <xsl:sequence select="djb:create-table(.)"/>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="character | faction">
        <xsl:param name="attribute-names" as="xs:string+" required="yes"/>
        <xsl:variable name="matched" as="element()" select="."/>
        <tr>
            <xsl:for-each select="$attribute-names">
                <!-- force order -->
                <xsl:apply-templates select="$matched/@*[name() eq current()]"/>
            </xsl:for-each>
        </tr>
    </xsl:template>

    <xsl:template match="@*">
        <td>
            <xsl:value-of select="."/>
        </td>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output method="xml" indent="yes" doctype-system="about:legacy-compat"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Skyrim</title>
            </head>
            <body>
                <h1>Skyrim</h1>
                <section>
                    <h2>Characters</h2>
                    <table>
                        <tr>
                            <th>id</th>
                            <xsl:for-each
                                select="distinct-values(//cast/character/(@* except @id)/name())">
                                <xsl:sort/>
                                <th>
                                    <xsl:value-of select="."/>
                                </th>
                            </xsl:for-each>
                        </tr>
                        <xsl:apply-templates select="//cast/character"/>
                    </table>
                </section>
                <section>
                    <h2>Factions</h2>
                    <table>
                        <tr>
                            <th>id</th>
                            <xsl:for-each
                                select="distinct-values(//cast/faction/(@* except @id)/name())">
                                <xsl:sort/>
                                <th>
                                    <xsl:value-of select="."/>
                                </th>
                            </xsl:for-each>
                        </tr>
                        <xsl:apply-templates select="//cast/faction"/>
                    </table>
                </section>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="character | faction">
        <tr>
            <xsl:apply-templates select="@id"/>
            <xsl:apply-templates select="@* except @id">
                <xsl:sort select="name()"/>
            </xsl:apply-templates>
        </tr>
    </xsl:template>
    <xsl:template match="@*">
        <td>
            <xsl:value-of select="."/>
        </td>
    </xsl:template>
</xsl:stylesheet>

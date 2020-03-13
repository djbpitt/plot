<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" version="3.0">
    <xsl:output method="xml" indent="yes" doctype-system="about:legacy-compat"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Skyrim</title>
                <style>
                    table { border-collapse: collapse; }
                    table, th, td { border: 1px solid black; }
                </style>
            </head>
            <body>
                <h1>Skyrim</h1>
                <h2>Cast of characters</h2>
                <table>
                    <tr>
                        <th>Name</th>
                        <th>Faction</th>
                        <th>Alignment</th>
                    </tr>
                    <xsl:apply-templates select="//cast/character"/>
                </table>
                <h2>Factions</h2>
                <table>
                    <tr>
                        <th>Name</th>
                        <th>Alignment</th>
                    </tr>
                    <xsl:apply-templates select="//cast/faction"/>
                </table>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="character">
        <tr>
            <td>
                <xsl:apply-templates select="@id"/>
            </td>
            <td>
                <xsl:apply-templates select="@loyalty"/>
            </td>
            <td>
                <xsl:apply-templates select="@alignment"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="faction">
        <tr>
            <td>
                <xsl:apply-templates select="@id"/>
            </td>
            <td>
                <xsl:apply-templates select="@alignment"/>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>

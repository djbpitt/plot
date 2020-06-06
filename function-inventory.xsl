<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/1999/xhtml" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:function name="djb:title-case" as="xs:string">
        <xsl:param name="input" as="xs:string"/>
        <xsl:sequence select="upper-case(substring($input, 1, 1)) || substring($input, 2)"/>
    </xsl:function>
    <xsl:template match="/">
        <html>
            <head>
                <title>Function inventory</title>
                <link type="text/css" rel="stylesheet" href="http://www.obdurodon.org/css/style.css"
                />
            </head>
            <body>
                <h1>Function inventory</h1>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="package">
        <hr/>
        <section id="{@name}">
            <h2>
                <xsl:text>Package: </xsl:text>
                <xsl:value-of select="@name"/>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="@url"/>
                <xsl:text>)</xsl:text>
            </h2>
            <dl>
                <xsl:apply-templates/>
            </dl>
        </section>
    </xsl:template>
    <xsl:template match="final | private">
        <h3>
            <xsl:value-of select="djb:title-case(name())"/>
        </h3>
        <xsl:apply-templates>
            <xsl:sort/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="function">
        <dt>
            <code>
                <xsl:apply-templates select="name"/>
            </code>
        </dt>
        <dd>
            <ul>
                <xsl:apply-templates select="* except name"/>
            </ul>
        </dd>
    </xsl:template>
    <xsl:template match="description | arity | note">
        <li>
            <strong>
                <xsl:value-of select="djb:title-case(name())"/>
                <xsl:text>: </xsl:text>
            </strong>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="code">
        <code>
            <xsl:apply-templates/>
        </code>
    </xsl:template>
</xsl:stylesheet>

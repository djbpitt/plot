<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/2000/svg" version="3.0">
    <xsl:use-package name="http://www.obdurodon.org/bezier"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="points" as="xs:string"
        select="'50,182 100,166 150,87 200,191 250,106 300,73 350,60 400,186 450,118'"/>
    <xsl:variable name="result" as="element()+" select="djb:bezier($points, 0.4, true())"/>
    <xsl:template name="xsl:initial-template">
        <xsl:result-document href="images/one-spline.xhtml" method="xml" indent="yes"
            doctype-public="about:legacy-compat">
            <xsl:sequence select="$result[2]"/>
        </xsl:result-document>
        <svg>
            <g transform="translate(10, 10)">
                <xsl:sequence select="$result[1]"/>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

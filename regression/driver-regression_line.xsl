<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>
    <xsl:variable name="points" as="xs:string"
        select="'50,182 100,166 150,87 200,191 250,106 300,73 350,60 400,186 450,118'"/>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg">
            <g transform="translate(10, 10)">
                <xsl:sequence select="djb:regression_line($points)"/>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

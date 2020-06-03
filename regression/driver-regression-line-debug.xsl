<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>
    <!-- ================================================================= -->
    <!-- Sample regression line plotting (with fake data)                  -->
    <!--                                                                   -->
    <!-- Plot in upper right quadrant                                      -->
    <!--   Input is sequence of points with montonic X values              -->
    <!--   All Y values have been negated                                  -->
    <!--   Use @viewBox to pull into viewport                              -->
    <!-- ================================================================= -->
    <xsl:variable name="points" as="xs:string+"
        select="
            '50,-182',
            '100,-166',
            '150,-87',
            '200,-191',
            '250,-106',
            '300,-73',
            '350,-60',
            '400,-186',
            '450,-118'"/>
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="result" as="item()+" select="djb:regression_line($points, true())"/>
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="30 -230 460 270">
            <g>
                <xsl:sequence select="$result[1]"/>
            </g>
        </svg>
        <xsl:message select="$result[2]"/>
    </xsl:template>
</xsl:stylesheet>

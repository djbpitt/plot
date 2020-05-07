<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <!-- ================================================================ -->
    <!-- Test plot_lib functions                                          -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot_lib"/>
    <xsl:output method="text"/>
    <xsl:variable name="inputString" as="xs:string" select="'50,182 100,166 150,87 200,191 250,106'"/>
    <xsl:template name="xsl:initial-template">
        <xsl:choose>
            <xsl:when
                test="
                    string-join(djb:split_points($inputString), ' ') eq
                    '50,182 100,166 150,87 200,191 250,106'">
                <xsl:text>djb:split_points passes</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Oops! djb:split_points fails</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:choose>
            <xsl:when
                test="djb:validate_points(('50,1.82', '1.00,166', '150,-87', '+200,191', '250,106'))">
                <xsl:text>djb:validate_points() accepts valid input</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Oops! djb:validate_points fails on valid data</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:choose>
            <xsl:when test="not(djb:validate_points(('1,2', '2,3')))">
                <xsl:text>djb:validate_points() correctly fails with fewer than three points</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Oops! djb:validate_points() incorrectly accepts fewer than three points</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:choose>
            <xsl:when test="not(djb:validate_points(('1,2', '2,3', '.,5')))">
                <xsl:text>djb:validate_points() correctly fails with bad point</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Oops! djb:validate_points() incorrectly accepts bad point</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template>
</xsl:stylesheet>

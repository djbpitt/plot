<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <!-- 
        Scratch pad to find cell positions by diagonal
        Number of diagonals is sum of string-lengths + 1
        In x,y pair, x = row and y = column 
            2,2 is 0; strings begin at 3,1 and 1,3
    -->
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:variable name="top" as="xs:string" select="'kitten'"/>
    <xsl:variable name="left" as="xs:string" select="'sitting'"/>
    <xsl:variable name="topLength" as="xs:integer" select="string-length($top)"/>
    <xsl:variable name="leftLength" as="xs:integer" select="string-length($left)"/>
    <xsl:template name="xsl:initial-template">
        <!-- 
            Number of diagonals equals sum of string lengths + 1
            Add 1 to range because we start counting at 2
        -->
        <xsl:for-each select="2 to ($topLength + $leftLength + 2)">
            <!--
                the $diagNo lets us figure out when we've hit bottom
            -->
            <xsl:variable name="diagNo" as="xs:integer" select="position()"/>
            <!-- 
                $rowNo ranges from 2 to the length of $left + 2
                Start at 2, increment by 1, and stop at length of $left + 2
            -->
            <xsl:variable name="rowNo" as="xs:integer" select="min((string-length($left) + 2, .))"/>
            <row>
                <!--
                    columns start at 2 until (and including) when we hit bottom, and then add 1
                    we hit bottom with $diagNo + 2 - $rowNo
                -->
                <xsl:variable name="firstCol" as="xs:integer"
                    select="
                        if ($diagNo le $leftLength + 1) then
                            2
                        else
                            $diagNo - $leftLength + 1
                        "/>
                <xsl:variable name="lastCol" as="xs:integer" select="min(($rowNo, $topLength + 2))"/>
                <xsl:for-each select="$firstCol to $lastCol">
                    <xsl:variable name="colNo" as="xs:integer"
                        select="
                            if (position() le $topLength + 1) then
                                .
                            else
                                100"/>
                    <xsl:value-of
                        select="string-join(('[', $rowNo + 1 - position(), ',', $colNo, '] '))"/>
                </xsl:for-each>
            </row>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>

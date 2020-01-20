<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0" default-validation="preserve">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="row_data" as="xs:string+" select="unparsed-text-lines('timings.tsv')"/>
    <xsl:variable name="rows" as="element(row)+">
        <xsl:for-each select="$row_data[position() gt 1]">
            <row>
                <xsl:for-each select="tokenize(., '\t')">
                    <cell type="xs:integer">
                        <xsl:sequence select="xs:double(.)"/>
                    </cell>
                </xsl:for-each>
            </row>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="maxY" as="xs:double" select="max($rows//cell)"/>
    <xsl:variable name="width" as="xs:integer" select="800"/>
    <xsl:variable name="xScale" as="xs:double" select="$width div count($rows)"/>
    <xsl:variable name="height" as="xs:integer" select="600"/>
    <xsl:variable name="yScale" as="xs:double" select="$maxY div $height"/>
    <xsl:variable name="yGridScale" as="xs:integer" select="1000"/>
    <xsl:variable name="cols" as="xs:integer+" select="2 to count($rows[1]/cell)"/>
    <xsl:variable name="colors" as="xs:string+" select="'blue', 'green', 'red', 'brown', 'darkviolet'"/>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg">
            <g transform="translate({$xScale}, {$height + 10})">
                <!-- axes -->
                <line x1="{0.5 * $xScale}" y1="0" x2="{$width * 1.05}" y2="0" stroke="black"
                    stroke-width="2" stroke-linecap="square"/>
                <line x1="{0.5 * $xScale}" y1="0" x2="{0.5 * $xScale}" y2="-{$height}"
                    stroke="black" stroke-width="2" stroke-linecap="square"/>
                <text x="{($width * 1.05 - 0.5 * $xScale) div 2}" y="35" text-anchor="middle"
                    >Threads</text>
                <text x="-{0.5 * $xScale}" y="-{$height div 2}" text-anchor="middle"
                    writing-mode="tb">Milliseconds</text>
                <!-- vertical grid lines and X labels-->
                <xsl:for-each select="1 to count($rows)">
                    <xsl:variable name="xPos" as="xs:double" select=". * $xScale"/>
                    <line x1="{$xPos}" y1="0" x2="{$xPos}" y2="-{$height}" stroke="lightgray"
                        stroke-width="1"/>
                    <text x="{$xPos}" y="15" text-anchor="middle">
                        <xsl:sequence select="."/>
                    </text>
                </xsl:for-each>
                <!-- horizontal grid lines and Y labels -->
                <xsl:for-each select="1 to xs:integer(floor($maxY div $yGridScale))">
                    <xsl:variable name="yPos" as="xs:double"
                        select=". * $yGridScale div $yScale * -1"/>
                    <line x1="{0.5 * $xScale}" y1="{$yPos}" x2="{$width}" y2="{$yPos}"
                        stroke="lightgray" stroke-width="1"/>
                    <text x="{0.4 * $xScale}" y="{$yPos}" text-anchor="end" dy="0.3em">
                        <xsl:sequence select=". * $yGridScale"/>
                    </text>
                </xsl:for-each>
                <xsl:for-each select="$cols">
                    <xsl:variable name="col" as="xs:integer" select="."/>
                    <polyline fill-opacity="0"
                        points="{string-join((
                        for $i in 1 to count($rows)
                        return (($i * $xScale) || ',' || ($rows[$i]/cell[position() eq $col]) div $yScale * -1)),' ')
                        
                        }"
                        stroke="{$colors[position() eq current() - 1]}" stroke-width="2"/>
                </xsl:for-each>
                <!-- legend -->
                <rect x="{3 * $xScale}" y="-300" width="110" height="140" fill="seashell"
                    stroke="black" stroke-width="2"/>
                <xsl:for-each select="1 to count($colors)">
                    <text x="{3.1 * $xScale}" y="-{300 - ((6 - current()) * 25)}"
                        fill="{$colors[current()]}">
                        <xsl:sequence
                            select="
                                current() || ' paragraph' || (if (current() ne 1) then
                                    's'
                                else
                                    ())"
                        />
                    </text>
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

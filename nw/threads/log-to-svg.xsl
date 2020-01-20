<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Abandoned without plotting data in favor of spark lines
    Otherwise would need to plot Y values logarithmically
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- ========================================================== -->
    <!-- read plain-text input from file                            -->
    <!-- ========================================================== -->
    <xsl:variable name="in" as="xs:string+" select="unparsed-text-lines('log.txt')"/>

    <!-- ========================================================== -->
    <!-- convert input to sequence of <measurement> elements        -->
    <!--
            <measurement>
                <paragraphs> ...</paragraphs>
                <threads> ... </threads>
                <time> ... </time>
            </measurement>
    -->
    <!-- ========================================================== -->
    <xsl:variable name="data" as="element(measurement)+">
        <xsl:for-each select="$in[starts-with(., '*')]">
            <xsl:variable name="pos" as="xs:integer" select="position()"/>
            <measurement>
                <xsl:variable name="meta_parts" as="xs:string+"
                    select="$in[not(starts-with(., '*'))][position() eq $pos] => tokenize('\s+')"/>
                <paragraphs>
                    <xsl:sequence select="$meta_parts[1]"/>
                </paragraphs>
                <threads>
                    <xsl:sequence select="$meta_parts[4]"/>
                </threads>
                <xsl:variable name="timing_parts" as="xs:string+"
                    select="tokenize(current(), '\s+')"/>
                <time>
                    <xsl:sequence
                        select="$timing_parts[contains(., 'ms')] => replace('[^\d\.]', '')"/>
                </time>
            </measurement>
        </xsl:for-each>
    </xsl:variable>

    <!-- ========================================================== -->
    <!-- SVG constants and ranges                                   -->
    <!-- ========================================================== -->
    <xsl:variable name="maxY" as="xs:double" select="max($data//time)"/>
    <xsl:variable name="width" as="xs:integer" select="800"/>
    <xsl:variable name="xScale" as="xs:double"
        select="$width div count(distinct-values($data//threads))"/>
    <xsl:variable name="height" as="xs:integer" select="600"/>
    <xsl:variable name="yScale" as="xs:double" select="$maxY div $height"/>
    <xsl:variable name="yGridCount" as="xs:integer" select="20"/>
    <xsl:variable name="paragraph_nos" as="xs:integer+"
        select="1 to xs:integer(max($data/paragraphs))"/>
    <xsl:variable name="thread_nos" as="xs:integer+" select="1 to xs:integer(max($data//threads))"/>
    <!-- https://sashat.me/2017/01/11/list-of-20-simple-distinct-colors/ -->
    <xsl:variable name="colors" as="xs:string+"
        select="
            '#e6194B',
            '#3cb44b',
            '#ffe119',
            '#4363d8',
            '#f58231',
            '#911eb4',
            '#42d4f4',
            '#f032e6',
            '#bfef45',
            '#469990',
            '#e6beff',
            '#9A6324',
            '#800000',
            '#808000',
            '#000075'"/>

    <!-- ========================================================== -->
    <!-- main                                                       -->
    <!-- ========================================================== -->
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg">
            <g transform="translate(30,{$height * 1.1})">
                <!-- ============================================== -->
                <!-- axes                                           -->
                <!-- ============================================== -->
                <line x1="{0.5 * $xScale}" y1="0" x2="{$width * 1.05}" y2="0" stroke="black"
                    stroke-width="2" stroke-linecap="square"/>
                <line x1="{0.5 * $xScale}" y1="0" x2="{0.5 * $xScale}" y2="-{$height * 1.1}"
                    stroke="black" stroke-width="2" stroke-linecap="square"/>
                <text x="{($width * 1.05 - 0.5 * $xScale) div 2}" y="35" text-anchor="middle"
                    >Threads</text>
                <text x="-{0.5 * $xScale}" y="-{$height div 2}" text-anchor="middle"
                    writing-mode="tb">Milliseconds</text>
                <!-- ============================================== -->
                <!-- vertical grid lines and X labels               -->
                <!-- ============================================== -->
                <xsl:for-each select="$thread_nos">
                    <xsl:variable name="xPos" as="xs:double" select=". * $xScale"/>
                    <line x1="{$xPos}" y1="0" x2="{$xPos}" y2="-{$height * 1.1}" stroke="lightgray"
                        stroke-width="1"/>
                    <text x="{$xPos}" y="15" text-anchor="middle">
                        <xsl:sequence select="."/>
                    </text>
                </xsl:for-each>
                <!-- ============================================== -->
                <!-- horizontal grid lines and Y labels             -->
                <!-- ============================================== -->
                <xsl:variable name="yGridSpacing" as="xs:double" select="$maxY div $yGridCount"/>
                <xsl:for-each select="1 to ($yGridCount + 1)">
                    <xsl:variable name="yPos" select="-1 * . * $yGridSpacing div $maxY * $height"/>
                    <line x1="{0.5 * $xScale}" y1="{$yPos}" x2="{$width}" y2="{$yPos}"
                        stroke="lightgray" stroke-width="1"/>
                    <text x="{0.4 * $xScale}" y="{$yPos}" dy="0.3em" stroke="black"
                        text-anchor="end">
                        <xsl:sequence select="xs:integer(. * $yScale * $yScale)"/>
                    </text>
                </xsl:for-each>
                <!-- ============================================== -->
                <!-- data                                           -->
                <!-- ============================================== -->
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

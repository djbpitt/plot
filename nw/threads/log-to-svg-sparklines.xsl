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
    <!-- main                                                       -->
    <!-- ========================================================== -->
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg">
            <g transform="translate(10, 200)">
                <xsl:for-each select="1 to xs:integer(max($data//paragraphs))">
                    <g transform="translate(0, (20 * current()))">
                        <xsl:variable name="yPos" as="xs:integer" select=". * -20"/>
                        <line x1="0" y1="0" x2="600" y2="0" stroke="black" stroke-width="1"/>
                    </g>
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

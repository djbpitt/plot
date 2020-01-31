<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Converts plain-text Saxon EE log file to SVG sparklines
    Input: log.txt
    Assumes schema-aware proceessing (relies on @xsl:type)
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="#all" version="3.0" default-validation="preserve">
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
                <paragraphs xsl:type="xs:integer">
                    <xsl:sequence select="xs:integer($meta_parts[1])"/>
                </paragraphs>
                <threads xsl:type="xs:integer">
                    <xsl:sequence select="xs:integer($meta_parts[4])"/>
                </threads>
                <xsl:variable name="timing_parts" as="xs:string+"
                    select="tokenize(current(), '\s+')"/>
                <time xsl:type="xs:double">
                    <xsl:sequence
                        select="$timing_parts[contains(., 'ms')] => replace('[^\d\.]', '') => xs:double()"
                    />
                </time>
            </measurement>
        </xsl:for-each>
    </xsl:variable>

    <!-- ========================================================== -->
    <!-- local function                                             -->
    <!-- ========================================================== -->
    <!-- djb:create-sparkline                                       -->
    <!-- Params:                                                    -->
    <!--   $in as element(measurement)+                             -->
    <!-- Return: <g> with paragraph count, sparkline, and pct range -->
    <!-- ========================================================== -->
    <xsl:function name="djb:create-sparkline" as="element(svg:g)">
        <xsl:param name="in" as="element(measurement)+"/>
        <xsl:variable name="pCount" as="xs:integer" select="$in[2]/paragraphs"/>
        <xsl:variable name="xScale" as="xs:integer" select="20"/>
        <xsl:variable name="max_time" select="max($in/time)"/>
        <xsl:variable name="min_time" select="min($in/time)"/>
        <xsl:variable name="time_range_raw" as="xs:double" select="$max_time - $min_time"/>
        <xsl:variable name="time_range_pct" as="xs:double"
            select="100 * $time_range_raw div $max_time"/>
        <xsl:variable name="row" as="xs:integer" select="($pCount - 1) mod 5 + 1"/>
        <xsl:variable name="col" as="xs:integer" select="($pCount - 1) idiv 5 + 1"/>
        <g xmlns="http://www.w3.org/2000/svg"
            transform="translate({($col - 1) * 300}, {$row * 29})">
            <rect x="-8" y="-5" width="300" height="29" fill="none" stroke="lightgray" stroke-width="1"/>
            <xsl:variable name="values" as="xs:string+">
                <xsl:for-each select="min($in/threads) to max($in/threads)">
                    <xsl:sequence
                        select="
                            string-join(
                            (
                            current() * $xScale,
                            20 - (20 * ($in[threads eq current()]/time - $min_time) div $time_range_raw)
                            ),
                            ',')"
                    />
                </xsl:for-each>
            </xsl:variable>
            <text x="10" y="14" text-anchor="end">
                <xsl:sequence select="$pCount"/>
            </text>
            <polyline points="{$values}" stroke="black" stroke-width="1" fill="none"/>
            <text x="{(count($in) + 1) * $xScale + 50}" y="14" text-anchor="end">
                <xsl:sequence select="format-number($time_range_pct, '###.00') || '%'"/>
            </text>
        </g>
    </xsl:function>

    <!-- ========================================================== -->
    <!-- main                                                       -->
    <!-- ========================================================== -->
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg">
            <g transform="translate(20)">
                <xsl:for-each-group select="$data" group-by="paragraphs">
                    <xsl:sort select="current-grouping-key()" data-type="number"/>
                    <xsl:sequence select="djb:create-sparkline(current-group())"/>
                </xsl:for-each-group>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

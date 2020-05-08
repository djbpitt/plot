<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- ================================================================ -->
    <!-- djb:random_sequence()                                            -->
    <!-- Create a specified number of random numbers -100 < n < 0         -->
    <!-- Adapted from the XPath 3.1 functions spec                        -->
    <!-- ================================================================ -->
    <xsl:function name="djb:random-sequence" as="xs:double*">
        <xsl:param name="length" as="xs:integer"/>
        <xsl:sequence select="djb:random-sequence($length, random-number-generator())"/>
    </xsl:function>
    <xsl:function name="djb:random-sequence">
        <xsl:param name="length" as="xs:integer"/>
        <xsl:param name="G" as="map(xs:string, item())"/>
        <xsl:choose>
            <xsl:when test="$length eq 0"/>
            <xsl:otherwise>
                <xsl:sequence select="$G?number, djb:random-sequence($length - 1, $G?next())"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:variable name="allY" as="xs:double+"
        select="
            (for $i in djb:random-sequence(100)
            return
                $i * -100) => sort() => reverse()"/>
    <xsl:variable name="n" as="xs:integer" select="count($allY)"/>
    <xsl:variable name="mean" as="xs:double" select="avg($allY)"/>

    <!-- stddev of population equation -->
    <!-- σ = ([Σ(x - u)^2]/N)1/2 -->
    <xsl:variable name="stddev" as="xs:double"
        select="
            avg(for $y in $allY
            return
                math:pow($y - $mean, 2)) => math:sqrt()"/>

    <!-- Gaussian kernel equation -->
    <!--
        g(x) = (1 / σ√2π) . (e^-1/2 . ((x - μ)/σ)^2) 
    -->
    <xsl:function name="djb:gauss" as="xs:double">
        <xsl:param name="x" as="xs:double"/>
        <xsl:param name="mean" as="xs:double"/>
        <xsl:param name="stddev" as="xs:double"/>
        <!-- Invert for negative values, scale by n, scale again by n/2-->
        <xsl:sequence
            select="
                -1 * $n * ($n div 2) * (1 div ($stddev * math:sqrt(2 * math:pi()))) *
                math:exp(-0.5 * math:pow(($x - $mean) div $stddev, 2))
                "/>

    </xsl:function>
    <xsl:variable name="xScale" as="xs:integer" select="2"/>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-10 -110 {120 * $xScale} 150">
            <g>
                <xsl:for-each select="0 to 10">
                    <line x1="0" y1="{current() * -10}" x2="{100 * $xScale}" y2="{current() * -10}"
                        stroke="lightgray" stroke-width="0.5"/>
                    <text x="-2" y="{current() * -10}" text-anchor="end"
                        alignment-baseline="central" font-size="6">
                        <xsl:value-of select="current() * 10"/>
                    </text>
                </xsl:for-each>
                <xsl:for-each select="0 to 100">
                    <xsl:if test="current() mod 5 eq 0">
                        <line x1="{current() * $xScale}" y1="0" x2="{current() * $xScale}" y2="-100"
                            stroke="lightgray" stroke-width="0.5"/>
                        <text x="{current() * $xScale}" y="6" text-anchor="middle" font-size="6">
                            <xsl:value-of select="current()"/>
                        </text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="1 to $n">
                    <circle cx="{position() * $xScale}" cy="{$allY[current()]}" r="1" fill="black"/>
                    <circle cx="{position() * $xScale}"
                        cy="{djb:gauss($allY[current()], $mean, $stddev)}" r="1" fill="red"/>
                </xsl:for-each>
                <text x="{$n * $xScale div 2}" y="15" text-anchor="middle" font-size="6">
                    <xsl:value-of
                        select="'mean: ' || ($mean * -1) ! round(., 2) || '; stddev: ' || $stddev ! round(., 2)"
                    />
                </text>
            </g>
        </svg>
        <xsl:message select="count($allY)"/>
        <xsl:message select="$mean"/>
        <xsl:message select="$stddev"/>
    </xsl:template>
</xsl:stylesheet>

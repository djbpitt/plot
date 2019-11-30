<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/2000/svg"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="#all" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="total_tokens" as="xs:integer+"
        select="
            387,
            465,
            1362,
            1549,
            1625,
            1889,
            2380,
            2732,
            3172,
            3358,
            3820,
            4472,
            5322,
            5940,
            6273"/>
    <xsl:variable name="ee_times" as="xs:double+"
        select="
            579.78,
            726.72,
            4909.34,
            6649.46,
            7113.30,
            9839.23,
            16045.75,
            22128.54,
            30649.80,
            34737.72,
            45419.14,
            67714.14,
            96157.29,
            126676.50,
            145853.59"/>
    <xsl:variable name="he_times" as="xs:double+"
        select="
            456.13,
            593.15,
            5576.78,
            7907.39,
            7934.86,
            10877.44,
            18487.85,
            25354.76,
            36941.59,
            39240.80,
            53596.64,
            70821.35,
            103138.17,
            138079.87,
            146487.75"/>
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="maxX" as="xs:double" select="max($total_tokens)"/>
        <xsl:variable name="maxY" as="xs:double" select="max(($ee_times, $he_times))"/>
        <xsl:variable name="xScale" as="xs:double" select="500 div $maxX"/>
        <xsl:variable name="yScale" as="xs:double" select="500 div $maxY"/>
        <!--<xsl:variable name="xScale" as="xs:double" select="$maxY div $maxX"/>-->
        <svg width="{$maxX}" height="{$maxY}">
            <g transform="translate(60, 520)">
                <line x1="0" y1="0" x2="{$maxX * $xScale}" y2="0" stroke="lightgray"
                    stroke-width="1" stroke-linecap="square"/>
                <line x1="0" y1="0" x2="0" y2="-{$maxY * $yScale}" stroke="lightgray"
                    stroke-width="1" stroke-linecap="square"/>
                <text x="250" y="30" color="black" font-size="8pt" text-anchor="middle">Total
                    number of items in both sequences</text>
                <text x="-40" y="-250" fill="red" font-size="10px" text-anchor="middle"
                    writing-mode="tb">EE time in mSec</text>
                <text x="540" y="-250" fill="blue" font-size="10px" text-anchor="middle"
                    writing-mode="tb">HE time in mSec</text>
                <xsl:iterate select="1 to count($total_tokens)">
                    <!-- draw all ruling lines first -->
                    <xsl:param name="lastX" as="xs:double" select="0"/>
                    <xsl:param name="lastEeY" as="xs:double" select="0"/>
                    <xsl:param name="lastHeY" as="xs:double" select="0"/>
                    <!-- new item: token count, ee msec, he msec-->
                    <xsl:variable name="newX" as="xs:double"
                        select="$total_tokens[current()] * $xScale"/>
                    <xsl:variable name="newEeY" as="xs:double"
                        select="$ee_times[current()] * $yScale"/>
                    <xsl:variable name="newHeY" as="xs:double"
                        select="$he_times[current()] * $yScale"/>
                    <!-- label x axis with token count and draw ruling line -->
                    <text x="{$newX}" y="12" text-anchor="middle" color="black" font-size="7px"
                        writing-mode="tb">
                        <xsl:value-of select="$total_tokens[current()]"/>
                    </text>
                    <line x1="{$newX}" y1="0" x2="{$newX}" y2="-{$maxY * $yScale}"
                        stroke="lightgray" stroke-width="1"/>
                    <!-- label y axis for ee and draw ruling line -->
                    <text x="-5" y="-{$newEeY}" dy="2px" text-anchor="end" fill="red"
                        font-size="7px">
                        <xsl:value-of select="xs:integer($ee_times[current()])"/>
                    </text>
                    <line x1="0" y1="-{$newEeY}" x2="{$maxX * $xScale}" y2="-{$newEeY}"
                        stroke="pink" stroke-width="1"/>
                    <!-- label y axis for he and draw ruling line -->
                    <text x="505" y="-{$newHeY}" dy="2px" text-anchor="start" fill="blue"
                        font-size="7px">
                        <xsl:value-of select="xs:integer($he_times[current()])"/>
                    </text>
                    <line x1="0" y1="-{$newHeY}" x2="{$maxX * $xScale}" y2="-{$newHeY}"
                        stroke="lightblue" stroke-width="1"/>
                    <xsl:next-iteration>
                        <xsl:with-param name="lastX" as="xs:double" select="$newX"/>
                        <xsl:with-param name="lastEeY" as="xs:double" select="$newEeY"/>
                        <xsl:with-param name="lastHeY" as="xs:double" select="$newHeY"/>
                    </xsl:next-iteration>
                </xsl:iterate>
                <xsl:iterate select="1 to count($total_tokens)">
                    <!-- now plot actual points and lines -->
                    <xsl:param name="lastX" as="xs:double" select="0"/>
                    <xsl:param name="lastEeY" as="xs:double" select="0"/>
                    <xsl:param name="lastHeY" as="xs:double" select="0"/>
                    <!-- new item: token count, ee msec, he msec-->
                    <xsl:variable name="newX" as="xs:double"
                        select="$total_tokens[current()] * $xScale"/>
                    <xsl:variable name="newEeY" as="xs:double"
                        select="$ee_times[current()] * $yScale"/>
                    <xsl:variable name="newHeY" as="xs:double"
                        select="$he_times[current()] * $yScale"/>
                    <!-- plot ee circle and line-->
                    <circle r="2" cx="{$newX}" cy="-{$newEeY}" fill="red"/>
                    <line x1="{$lastX}" y1="-{$lastEeY}" x2="{$newX}" y2="-{$newEeY}" stroke="red"
                        stroke-width="1"/>
                    <!-- plot he circle and line -->
                    <circle r="2" cx="{$newX}" cy="-{$newHeY}" fill="blue"/>

                    <line x1="{$lastX}" y1="-{$lastHeY}" x2="{$newX}" y2="-{$newHeY}" stroke="blue"
                        stroke-width="1"/>
                    <xsl:next-iteration>
                        <xsl:with-param name="lastX" as="xs:double" select="$newX"/>
                        <xsl:with-param name="lastEeY" as="xs:double" select="$newEeY"/>
                        <xsl:with-param name="lastHeY" as="xs:double" select="$newHeY"/>
                    </xsl:next-iteration>
                </xsl:iterate>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

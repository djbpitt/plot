<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- packages -->
    <xsl:use-package name="http://www.obdurodon.org/smoothing"/>
    <xsl:use-package name="http://www.obdurodon.org/plot_lib"/>
    <xsl:use-package name="http://www.obdurodon.org/regression"/>

    <!-- ================================================================ -->
    <!-- Test input data of different sizes, values range from 1 to 200   -->
    <!-- ================================================================ -->
    <!-- 200 points                                                       -->
    <!-- <xsl:variable name="initialPoints" as="xs:string"
        select="'1,83 2,70 3,52 4,46 5,93 6,21 7,19 8,36 9,88 10,76 11,73 12,85 13,59 14,18 15,33 16,9 17,14 18,6 19,68 20,45 21,18 22,27 23,16 24,12 25,5 26,52 27,68 28,61 29,42 30,8 31,77 32,4 33,11 34,89 35,17 36,87 37,51 38,10 39,88 40,98 41,16 42,45 43,49 44,28 45,44 46,31 47,11 48,39 49,72 50,97 51,61 52,53 53,4 54,29 55,6 56,15 57,33 58,57 59,32 60,7 61,51 62,68 63,37 64,57 65,2 66,55 67,54 68,94 69,5 70,88 71,5 72,40 73,43 74,34 75,36 76,45 77,77 78,20 79,43 80,82 81,29 82,98 83,86 84,94 85,18 86,81 87,20 88,96 89,30 90,20 91,88 92,25 93,83 94,41 95,10 96,93 97,11 98,49 99,3 100,97 101,11 102,25 103,20 104,4 105,92 106,5 107,65 108,86 109,29 110,70 111,8 112,58 113,42 114,96 115,74 116,86 117,90 118,25 119,47 120,49 121,43 122,24 123,86 124,80 125,43 126,23 127,42 128,33 129,56 130,55 131,77 132,86 133,4 134,91 135,57 136,65 137,23 138,67 139,89 140,75 141,70 142,25 143,28 144,40 145,67 146,58 147,12 148,22 149,69 150,28 151,52 152,36 153,98 154,9 155,90 156,23 157,34 158,52 159,32 160,41 161,27 162,57 163,58 164,17 165,50 166,90 167,85 168,92 169,52 170,26 171,45 172,16 173,44 174,86 175,33 176,99 177,14 178,37 179,69 180,61 181,19 182,52 183,81 184,55 185,1 186,54 187,2 188,62 189,15 190,62 191,57 192,62 193,31 194,81 195,9 196,19 197,16 198,96 199,36 200,2'"/>-->
    <!-- 100 points                                                       -->
    <!-- <xsl:variable name="initialPoints" as="xs:string"
        select="'1,145 2,14 3,61 4,135 5,16 6,15 7,24 8,149 9,36 10,74 11,29 12,183 13,107 14,189 15,153 16,190 17,169 18,79 19,20 20,143 21,124 22,119 23,117 24,74 25,177 26,142 27,187 28,145 29,81 30,74 31,143 32,87 33,144 34,146 35,109 36,32 37,54 38,47 39,193 40,53 41,128 42,124 43,119 44,105 45,124 46,63 47,72 48,171 49,97 50,125 51,139 52,62 53,48 54,116 55,21 56,133 57,8 58,115 59,131 60,94 61,164 62,72 63,47 64,157 65,57 66,180 67,171 68,123 69,80 70,14 71,86 72,78 73,160 74,71 75,70 76,50 77,197 78,132 79,37 80,85 81,92 82,184 83,60 84,41 85,181 86,108 87,22 88,61 89,141 90,191 91,195 92,59 93,144 94,93 95,138 96,195 97,154 98,46 99,55 100,36'"/>-->
    <!-- 20 points                                                        -->
    <xsl:variable name="initialPoints" as="xs:string"
        select="'1,145 2,14 3,61 4,135 5,16 6,15 7,24 8,149 9,36 10,74 11,29 12,183 13,107 14,189 15,153 16,190 17,169 18,79 19,20 20,143'"/>

    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!--                                                                  -->
    <!-- xSpacing as xs:integer : spread out X values                     -->
    <!-- $splitPoints as xs:string+ : break input into point pairs        -->
    <!--   negate $ values to draw in upper right                         -->
    <!-- $stretchedPoints as xs:string :                                  -->
    <!--   input with Y values averaged, centered within window           -->
    <!-- ================================================================ -->
    <xsl:variable name="xSpacing" as="xs:integer" select="25"/>
    <xsl:variable name="splitPoints" as="xs:string+" select="djb:split_points($initialPoints)"/>
    <xsl:variable name="stretchedPoints" as="xs:string"
        select="
            (for $i in $splitPoints
            return
                substring-before($i, ',') ! number() * $xSpacing
                || ',' ||
                substring-after($i, ',') ! number() * -1)
            => string-join(' ')
            "/>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Initial template                                                 -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg"
            viewBox="0 -210 {(count($splitPoints) + 1) * $xSpacing} 300">
            <g>
                <!-- ruling lines first, for overlap -->
                <xsl:for-each select="1 to 20">
                    <line x1="{1 * $xSpacing}" y1="-{current() * 10}"
                        x2="{count($splitPoints) * $xSpacing}" y2="-{current() * 10}"
                        stroke="lightgray" stroke-width=".5"/>
                    <text x="{0.9 * $xSpacing}" y="-{current() * 10}" text-anchor="end"
                        font-size="6" alignment-baseline="central">
                        <xsl:value-of select="current() * 10"/>
                    </text>
                </xsl:for-each>
                <xsl:for-each select="1 to count($splitPoints)">
                    <xsl:variable name="xPos" as="xs:integer" select="current() * $xSpacing"/>
                    <line x1="{$xPos}" y1="0" x2="{$xPos}" y2="-200" stroke="lightgray"
                        stroke-width=".5"/>
                    <text x="{$xPos}" y="5" font-size="6" text-anchor="middle">
                        <xsl:value-of select="$splitPoints[current()]"/>
                    </text>
                </xsl:for-each>
                <polyline points="{$stretchedPoints}" stroke="black" stroke-width="1" fill="none"/>
                <!-- default window is 3 -->
                <polyline points="{djb:smoothing($stretchedPoints)}" stroke="orange"
                    stroke-width=".5" fill="none"/>
                <polyline points="{djb:smoothing($stretchedPoints, 5)}" stroke="blue"
                    stroke-width=".5" fill="none"/>
                <polyline points="{djb:smoothing($stretchedPoints, 7)}" stroke="green"
                    stroke-width=".5" fill="none"/>
                <polyline points="{djb:smoothing($stretchedPoints, 9)}" stroke="fuchsia"
                    stroke-width=".5" fill="none"/>
                <xsl:sequence select="djb:regression_line($stretchedPoints)"/>
                <text x="{count($splitPoints) * $xSpacing div 2}" y="25" text-anchor="middle"
                    font-size="8">black = actual, <tspan fill="orange">orange = 3</tspan>, <tspan
                        fill="blue">blue = 5</tspan>, <tspan fill="green">green = 7</tspan>, <tspan
                        fill="fuchsia">fuchsia = 9</tspan>, <tspan fill="red">red =
                        regression</tspan></text>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:f="http://www.obdurodon.org/function"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <!-- indent set to no to avoid adding whitespace between <tspan> elements -->
    <xsl:output method="xml" indent="no"/>

    <xsl:function name="djb:uniform" as="xs:boolean">
        <!-- ============================================================ -->
        <!-- djb:uniform                                                  -->
        <!--                                                              -->
        <!-- Returns True iff all items in sequence are equal             -->
        <!--                                                              -->
        <!-- Parameter                                                    -->
        <!--   $seq as item()+ : sequence of any datatype                 -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   xs:boolean : True iff all items in $seq are equal          -->
        <!--                                                              -->
        <!-- Note: O(n) counterpart to O(n^2) not($seq != $seq)           -->
        <!-- ============================================================ -->
        <xsl:param name="seq" as="item()+"/>
        <xsl:sequence select="not(head($seq) != tail($seq))"/>
    </xsl:function>

    <xsl:function name="djb:monotonic" as="xs:boolean">
        <!-- ============================================================ -->
        <!-- djb:monotonic                                                -->
        <!--                                                              -->
        <!-- Returns True iff sequence is monotonic (in either direction) -->
        <!--                                                              -->
        <!-- Parameter                                                    -->
        <!--   $seq as xs:double+ : sequence of numerical values          -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   True iff $seq is monotonically non-increasing or           -->
        <!--   non-decreasing                                             -->
        <!-- ============================================================ -->
        <xsl:param name="seq" as="xs:double+"/>
        <xsl:sequence
            select="
                (for $i in 2 to count($seq)
                return
                    $seq[$i] ge $seq[$i - 1]) => djb:uniform()"
        />
    </xsl:function>

    <xsl:function name="djb:expand-to-tenths" as="xs:double+">
        <!-- ============================================================ -->
        <!-- djb:expand-to-tenths                                         -->
        <!--                                                              -->
        <!-- Converts integer range to range of tenths                    -->
        <!--                                                              -->
        <!-- Parameter                                                    -->
        <!--   $half as xs:integer : upper bound of symmetrical range     -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   xs:double+ : symmetrical range in tenths                   -->
        <!-- ============================================================ -->
        <xsl:param name="half" as="xs:integer"/>
        <xsl:if test="$half le 0">
            <xsl:message terminate="yes">Input must be a positive integer</xsl:message>
        </xsl:if>
        <xsl:sequence
            select="
                for $i in (-10 * $half to 10 * $half)
                return
                    $i div 10"
        />
    </xsl:function>

    <!--    <xsl:function name="djb:normal" as="xs:double+">
        <!-\- ============================================================ -\->
        <!-\- djb:normal                                                   -\->
        <!-\-                                                              -\->
        <!-\- Returns Y values of normal curve with X values in tenths     -\->
        <!-\-                                                              -\->
        <!-\- Parameter                                                    -\->
        <!-\-   $x as xs:double : X coordinate of point on normal curve    -\->
        <!-\-                                                              -\->
        <!-\- Returns                                                      -\->
        <!-\-   xs:double : Y value of point on normal curve               -\->
        <!-\-                                                              -\->
        <!-\- Notes:                                                       -\->
        <!-\-   Assume μ = 0 and σ = 1                                     -\->
        <!-\- ============================================================ -\->
        <xsl:param name="x" as="xs:double"/>
        <xsl:param name="mean" as="xs:double"/>
        <xsl:param name="stddev" as="xs:double"/>
        <xsl:if test="$stddev le 0">
            <xsl:message terminate="yes">Stddev must be greater than 0</xsl:message>
        </xsl:if>
        <xsl:sequence
            select="
                100 * math:exp(-1 * (math:pow($x - $mean, 2)) div (2 * math:pow($stddev, 2)))
                div
                ($stddev * math:sqrt(2 * math:pi()))"
        />
    </xsl:function>-->

    <xsl:function name="djb:gaussian" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:gaussian() as xs:double                                  -->
        <!--                                                              -->
        <!-- $peak as xs:double : height of curve’s peak                  -->
        <!-- $center as xs:double : X position of center of peak          -->
        <!-- $stddev as xs:double : stddev (controls width of curve)      -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   xs:double, representing Y value corresponding to X         -->
        <!--                                                              -->
        <!-- https://en.wikipedia.org/wiki/Gaussian_function:             -->
        <!-- "The parameter a is the height of the curve's peak, b is the -->
        <!--   position of the center of the peak and c (the standard     -->
        <!--   deviation, sometimes called the Gaussian RMS width)        -->
        <!--   controls the width of the "bell".                          -->
        <!-- ============================================================ -->
        <xsl:param name="x" as="xs:double"/>
        <xsl:param name="peak" as="xs:double"/>
        <xsl:param name="center" as="xs:double"/>
        <xsl:param name="stddev" as="xs:double"/>
        <xsl:if test="$stddev le 0">
            <xsl:message terminate="yes">Stddev must be greater than 0</xsl:message>
        </xsl:if>
        <xsl:sequence
            select="$peak * math:exp(-1 * (math:pow(($x - $center), 2)) div (2 * math:pow($stddev, 2)))"
        />
    </xsl:function>

    <xsl:variable name="half" as="xs:integer" select="4"/>
    <xsl:variable name="mean" as="xs:double" select="0"/>
    <xsl:variable name="stddev" as="xs:double" select="1"/>
    <xsl:variable name="xScale" as="xs:double" select="10"/>
    <xsl:variable name="peak" as="xs:double" select="100"/>
    <xsl:variable name="allX" as="xs:double+" select="djb:expand-to-tenths($half)"/>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-50 -110 110 130">
            <style type="text/css">
                <!-- stroke specified on lines, since can't apply to text -->
                .stddev {
                    fill: mediumturquoise;
                    font-size: 3px;
                    stroke-width: 0.5;
                    stroke-linecap: square;
                    text-anchor: middle;
                }
                .mean {
                    fill: tomato;
                    font-size: 3px;
                    stroke-width: 0.5;
                    stroke-linecap: square;
                    text-anchor: middle;
                }
                .h_ruling {
                    fill: lightgray;
                    font-size: 3px;
                    stroke-width: 0.5;
                    stroke-linecap: square;
                    text-anchor: end;
                }</style>
            <!--            <g>
                <xsl:for-each select="0 to 10">
                    <!-\- horizontal ruling and Y labels-\->
                    <xsl:variable name="xEnd" as="xs:double" select="$xScale * $half"/>
                    <xsl:variable name="yPos" as="xs:double" select="$yScale * current() div -10"/>
                    <line x1="{-1 * $xEnd}" y1="{$yPos}" x2="{$xEnd}" y2="{$yPos}"
                        stroke="lightgray" stroke-width="0.5" stroke-linecap="square"/>
                    <text x="{(-1 * $xEnd) - 1}" y="{$yPos}" text-anchor="end"
                        alignment-baseline="central" font-size="3">
                        <xsl:value-of select="(current() div 10) => format-number('0.0')"/>
                    </text>
                </xsl:for-each>
                <xsl:for-each select="$half * -1 to $half">
                    <!-\- vertical ruling and X labels -\->
                    <xsl:variable name="xPos" as="xs:double" select="current() * $xScale"/>
                    <line x1="{$xPos}" y1="0" x2="{$xPos}" y2="{-1 * $yScale}" stroke="lightgray"
                        stroke-width="0.5" stroke-linecap="square"/>
                    <text x="{$xPos}" y="5" text-anchor="middle" font-size="3">
                        <xsl:value-of
                            select="
                                if (current() eq 0) then
                                    'μ'
                                else
                                    concat('σ', abs(current()))"
                        />
                    </text>
                </xsl:for-each>
                <!-\- plot curve-\->
                <polyline
                    points="{for $x in ($allX) return string-join(($x * $xScale, -1 * djb:normal($x, $mean, $stddev)), ',')}"
                    stroke="black" stroke-width="1" fill="none"/>
            </g>-->
            <g>
                <g class="h_ruling">
                    <xsl:for-each select="0 to 10">
                        <!-- horizontal ruling lines and Y labels -->
                        <xsl:variable name="yPos" as="xs:double" select="-1 * current() * 10"/>
                        <line x1="{-5 * $xScale}" y1="{$yPos}" x2="{5 * $xScale}" y2="{$yPos}"
                            stroke="lightgray"/>
                        <text x="{-5 * $xScale - 2}" y="{$yPos}" alignment-baseline="central">
                            <xsl:value-of select="(current() * 10)"/>
                        </text>
                    </xsl:for-each>
                </g>
                <g class="stddev">
                    <xsl:for-each select="-3 to -1, 1 to 3">
                        <!-- vertical stddev lines and labels -->
                        <xsl:variable name="xPos" as="xs:double"
                            select="$stddev * current() * $xScale"/>
                        <line x1="{$xPos}" y1="0" x2="{$xPos}" y2="-100" stroke="mediumturquoise"/>
                        <text x="{$xPos}" y="4">
                            <xsl:value-of select="
                                    ($mean + (current() * $stddev))
                                    => format-number('0.0')"/>
                        </text>
                        <text x="{$xPos}" y="8">
                            <xsl:value-of select="current() || 'σ'"/>
                        </text>
                    </xsl:for-each>
                </g>
                <!-- vertical mean line and labels -->
                <g class="mean">
                    <line x1="{$mean}" y1="0" x2="{$mean}" y2="-100" stroke="tomato"/>
                    <text x="{$mean}" y="4" text-anchor="middle">
                        <xsl:value-of select="$mean"/>
                    </text>
                </g>
                <text x="{$mean}" y="8" text-anchor="middle" fill="tomato" font-size="3">μ</text>
                <!-- overwrite vertical lines with horizontal at ends -->
                <xsl:for-each select="0, 100">
                    <line x1="-{$half * $xScale}" y1="-{current()}" x2="{$half * $xScale}"
                        y2="-{current()}" class="h_ruling" stroke="lightgray"/>
                </xsl:for-each>
                <polyline
                    points="{
                    for $x in ($allX) return string-join(($x * $xScale, -1 * djb:gaussian($x, $peak, $mean, $stddev)), ',')
                    }"
                    stroke="black" stroke-width="1" fill="none"/>
                <text x="0" y="15" text-anchor="middle" fill="black" font-size="5">
                    <tspan>
                        <xsl:value-of select="'Peak =' || $peak || '; '"/>
                    </tspan>
                    <tspan fill="tomato">
                        <xsl:value-of select="
                                'μ = ' ||
                                $mean ! format-number(., '0.0')"/>
                    </tspan><tspan>; </tspan>
                    <tspan fill="mediumturquoise">
                        <xsl:value-of select="
                                'σ = ' ||
                                $stddev ! format-number(., '0.0')
                                "/>
                    </tspan>
                </text>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:function name="djb:plot-parabola-Y" as="xs:double">
        <!--
            y = x^2 / 4*p, where focus = (0,p)
        -->
        <xsl:param name="x" as="xs:double"/>
        <xsl:param name="a" as="xs:double"/>
        <xsl:param name="b" as="xs:double"/>
        <xsl:param name="c" as="xs:double"/>
        <!-- invert a to accommodate SVG inverted Y -->
        <xsl:sequence select="-1 * $a * math:pow($x, 2) - $c"/>
    </xsl:function>
    <xsl:template name="xsl:initial-template">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="-110 -110 220 220">
            <!-- X axis and horizontal ruling -->
            <xsl:for-each select="-100 to 100">
                <xsl:if test="current() mod 5 eq 0">
                    <line x1="-100" y1="{current()}" x2="100" y2="{current()}" stroke="lightgray"
                        stroke-width="0.5"/>
                    <text x="-1" y="{current()}" font-size="3" fill="cornflowerblue"
                        text-anchor="end">
                        <xsl:value-of select="current()"/>
                    </text>
                </xsl:if>
            </xsl:for-each>
            <line x1="-100" y1="0" x2="100" y2="0" stroke="gray" stroke-width="0.5"/>
            <!-- Y axis and vertical ruling-->
            <xsl:for-each select="-100 to 100">
                <xsl:if test="current() mod 5 eq 0">
                    <line x1="{current()}" y1="-100" x2="{current()}" y2="100" stroke="lightgray"
                        stroke-width="0.5"/>
                    <text x="{current()}" y="3" font-size="3" fill="cornflowerblue"
                        text-anchor="middle">
                        <xsl:value-of select="current()"/>
                    </text>
                </xsl:if>
            </xsl:for-each>
            <line x1="0" y1="-100" x2="0" y2="100" stroke="gray" stroke-width="0.5"/>
            <!-- plot downward parabola points with vertex at (0,maxY)-->
            <xsl:variable name="maxX" as="xs:integer" select="100"/>
            <xsl:variable name="minX" as="xs:integer" select="0"/>
            <xsl:for-each select="$minX to $maxX">
                <!--
                    assume symmetry across the Y axis
                    SVG Y values are inverted by function, so plat as if in normal Cartesian space
                    $x: X value of point to plot; subtract full value to shift vertex horizontally
                        (may need to adjust range, since plots from original minX to maxX)
                    $a: 1 div $maxX to spread over full range horizontally
                    $c: shift vertically (per normal Cartesian Y)
                -->
                <xsl:variable name="x"/>
                <circle cx="{current()}"
                    cy="{djb:plot-parabola-Y(current(), -1 div $maxX, 0, $maxX)}" r="0.75"
                    stroke="green" stroke-width="0.5" fill="none"/>
                <path d="M-100,0 Q0,-200 100,0" stroke="green" stroke-width="0.25" fill="none"/>
            </xsl:for-each>
            <!-- plot upward parabola points with vertex at (maxX,0) -->
            <xsl:for-each select="$minX to $maxX">
                <circle cx="{current()}"
                    cy="{djb:plot-parabola-Y(current() - $maxX, 1 div $maxX, 0, 0)}" r="0.75"
                    fill="none" stroke="red" stroke-width="0.25"/>
                <path d="M0,-100 Q100,100 200,-100" stroke="red" stroke-width="0.25" fill="none"/>
            </xsl:for-each>
        </svg>
    </xsl:template>
</xsl:stylesheet>

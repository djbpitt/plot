<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <xsl:output method="xml" indent="no"/>

    <!-- ================================================================ -->
    <!-- Packages                                                         -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot_lib"/>
    <xsl:use-package name="http://www.obdurodon.org/smoothing"/>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <xsl:function name="djb:gaussian_weights" as="xs:double+">
        <!-- ============================================================ -->
        <!-- djb:gaussian_weights                                         -->
        <!--                                                              -->
        <!-- Returns sequence of values for Gaussian weighting            -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   window_size as xs:integer : width of window (odd, > 3)     -->
        <!--   stddev as xs:integer : controls width of bell              -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double+ : weights to be applied in scaling              -->
        <!--                                                              -->
        <!-- Notes:                                                       -->
        <!--   Mean - 0, peak = 1                                         -->
        <!--   Return full width of window (for end values)               -->
        <!-- ============================================================ -->
        <xsl:param name="window_size" as="xs:integer"/>
        <xsl:param name="stddev" as="xs:double"/>
        <xsl:if test="$window_size mod 2 eq 0 or $window_size lt 3">
            <xsl:message terminate="yes">Window size must be odd integer greater than
                3</xsl:message>
        </xsl:if>
        <xsl:for-each select="0 to ($window_size - 1)">
            <xsl:sequence select="djb:gaussian(current(), 1, 0, $stddev)"/>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:weighted_average">
        <!-- ============================================================ -->
        <!-- djb:weighted_average                                         -->
        <!--                                                              -->
        <!-- Returns weighted value for current point                     -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $focus as xs:integer : offset of focus point               -->
        <!--   $input_values as xs:double+ : all Y values                 -->
        <!--   $window_size as xs:integer : width of window (odd, > 3)    -->
        <!--   $weights as xs:double : weights to be applied to window    -->
        <!--                                                              -->
        <!-- Returns:                                                     -->
        <!--   xs:double : weighted value for focus point                 -->
        <!--                                                              -->
        <!-- Notes:                                                       -->
        <!--   Mean - 0, peak = 1                                         -->
        <!--   Return full width of window for end values                 -->
        <!--                                                              -->
        <!-- XQuery mockup:
            let $sum_of_weights := sum($weights)
            let $sum_of_weighted_scores as xs:double := 
                (for $i in 1 to count($weights)
                return $weights[$i] * $scores[$i]) => sum()
            return $sum_of_weighted_scores div $sum_of_weights -->
        <!-- ============================================================ -->
        <xsl:param name="focus" as="xs:integer"/>
        <xsl:param name="input_values" as="xs:double+"/>
        <xsl:param name="window_size" as="xs:integer"/>
        <xsl:param name="weights" as="xs:double+"/>
        <xsl:variable name="n" as="xs:integer" select="count($input_values)"/>
        <xsl:if test="$window_size mod 2 eq 0 or $window_size lt 3 or $window_size gt $n">
            <xsl:message terminate="yes">Window size must be 1) an odd integer, 2) greater than 3,
                and 3) not greater than the count of the input values</xsl:message>
        </xsl:if>
        <!-- adjust window for end cases -->
        <xsl:variable name="half_window" as="xs:integer" select="$window_size idiv 2"/>
        <xsl:variable name="short_left" as="xs:boolean" select="$focus - $half_window lt 1"/>
        <xsl:variable name="short_right" as="xs:boolean" select="$focus + $half_window gt $n"/>
        <xsl:variable name="left" as="xs:integer*">
            <xsl:choose>
                <xsl:when test="$focus eq 1">
                    <!-- no left -->
                </xsl:when>
                <xsl:when test="$short_left">
                    <!-- left side is short, but not empty -->
                    <xsl:sequence select="1 to ($focus - $half_window + 1)"/>
                </xsl:when>
                <xsl:when test="$focus eq $n">
                    <!-- no right, compensate on left -->
                    <xsl:sequence select="($focus - (2 * $half_window)) to ($focus - 1)"/>
                </xsl:when>
                <xsl:when test="$short_right">
                    <!-- short right, compensate on left -->
                    <xsl:sequence select="($focus - $half_window - ($n - $focus)) to ($focus - 1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="($focus - $half_window) to ($focus - 1)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="right" as="xs:integer*">25</xsl:variable>
        <xsl:sequence select="'Left: ' || string-join($left, ',')"/>
        <xsl:sequence select="'Focus: ' || $focus"/>
        <xsl:sequence select="'Total length: ' || count($left) + count($focus)"/>
    </xsl:function>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Create fake data, for testing, with a bit of jitter              -->
    <!-- ================================================================ -->
    <xsl:variable name="allY" as="xs:double+"
        select="
            djb:random-sequence(100) ! (. * 100)"/>
    <xsl:variable name="points" as="xs:string+"
        select="
            for-each-pair(1 to 100, $allY, function ($a, $b) {
                string-join(($a, -1 * $b), ',')
            })"/>

    <!-- ================================================================ -->
    <!-- Create list of weights the length of the window                  -->
    <!-- $stddev needed only for Gaussian                                 -->
    <!-- ================================================================ -->
    <xsl:variable name="window" as="xs:integer" select="15"/>
    <xsl:variable name="stddev" as="xs:double" select="5"/>
    <xsl:variable name="weights" as="xs:double+" select="djb:gaussian_weights($window, $stddev)"/>

    <xsl:template name="xsl:initial-template">
        <xsl:for-each select="1 to 10">
            <xsl:value-of select="'&#x0a;'"/>
            <xsl:sequence select="djb:weighted_average(current(), (1 to 10), 5, 0)"/>
        </xsl:for-each>
        <xsl:value-of select="'&#x0a;'"/>
        <!--<svg xmlns="http://www.w3.org/2000/svg" viewBox="-10 -110 120 120" width="50%">
            <xsl:for-each select="$points">
                <circle cx="{substring-before(current(), ',')}"
                    cy="{substring-after(current(), ',')}" r="0.5"/>
            </xsl:for-each>
            <polyline points="{$points}" stroke="black" stroke-width="0.5" fill="none"/>
        </svg>-->
    </xsl:template>
</xsl:stylesheet>

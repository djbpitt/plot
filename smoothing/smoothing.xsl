<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/smoothing" xmlns:djb="http://www.obdurodon.org"
    xmlns:f="http://www.obdurodon.org/function-variables"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <!-- ================================================================ -->
    <!-- djb:smoothing                                                    -->
    <!--                                                                  -->
    <!-- Linear smoothing of Y values by $window size (default 3)         -->
    <!--   Window is centered on current point                            -->
    <!--   Include extra points from other side if one is too short       -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>
    <xsl:expose component="function" visibility="final"
        names="
        djb:smoothing#2
        djb:smoothing#1
        "/>
    <xsl:function name="djb:smoothing" as="xs:string+">
        <!-- ============================================================ -->
        <!-- djb:smoothing#2                                              -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $f:points as xs:string+ : X,Y points as strings            -->
        <!--   $f:window as xs:integer : odd-valued window size           -->
        <!--                                                              -->
        <!-- Return: xs:string+ : adjusted X,Y points as strings          -->
        <!-- ============================================================ -->
        <xsl:param name="f:points" as="xs:string+"/>
        <xsl:param name="f:window" as="xs:integer"/>
        <!-- ============================================================ -->
        <!-- Raise an error if points are bad or $window is even          -->
        <!-- ============================================================ -->
        <xsl:if test="not(djb:validate-points($f:points))">
            <xsl:sequence
                select="error((),
                normalize-space(concat('Invalid point values: ', string-join(
                for $i in $f:points return concat('&quot;', $i, '&quot;')
                , ', '))))"
            />
        </xsl:if>
        <xsl:if test="$f:window mod 2 = 0 and $f:window gt 0">
            <xsl:sequence
                select="error((),
                normalize-space(concat('Invalid window size (', $f:window, '); must be odd')))"
            />
        </xsl:if>
        <!-- ============================================================ -->
        <!-- $f:windowSide as xs:double: points to either side of center  -->
        <!-- $f:n as xs:integer : count of points                         -->
        <!-- $f:allX as xs:double+ : all X values                         -->
        <!-- $f:allY as xs:double+ : all Y values                         -->
        <!-- $f:scaledYs as xs:double+ : average within window            -->
        <!--   centered on current point                                  -->
        <!--   include extra points from other side if one is too short   -->
        <!-- ============================================================ -->
        <xsl:variable name="f:windowSide" as="xs:double" select="($f:window - 1) div 2"/>
        <xsl:variable name="f:n" as="xs:integer" select="count($f:points)"/>
        <xsl:variable name="f:allX" as="xs:double+"
            select="$f:points ! substring-before(.,',') ! number(.)"/>
        <xsl:variable name="f:allY" as="xs:double+"
            select="$f:points ! substring-after(.,',') ! number(.)"/>
        <xsl:variable name="f:scaledYs" as="xs:double+">
            <xsl:for-each select="$f:allY">
                <xsl:variable name="f:pos" as="xs:integer" select="position()"/>
                <xsl:choose>
                    <xsl:when test="position() lt $f:windowSide">
                        <xsl:value-of select="avg($f:allY[position() lt $f:window])"/>
                    </xsl:when>
                    <xsl:when test="position() gt $f:n - $f:windowSide">
                        <xsl:value-of select="avg($f:allY[position() ge ($f:n - $f:window)])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="avg($f:allY[position() ge $f:pos - $f:windowSide and position() le $f:pos + $f:windowSide])"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <!-- ============================================================ -->
        <!-- Return all points                                            -->
        <!-- ============================================================ -->
        <xsl:sequence
            select="for $i in 1 to $f:n return string-join(($f:allX[$i], $f:scaledYs[$i]), ',')"/>
    </xsl:function>
    <xsl:function name="djb:smoothing" as="xs:string+">
        <xsl:param name="f:points"/>
        <xsl:sequence select="djb:smoothing($f:points, 3)"/>
    </xsl:function>
</xsl:package>

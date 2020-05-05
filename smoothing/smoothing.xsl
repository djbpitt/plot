<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/smoothing" xmlns:djb="http://www.obdurodon.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <!-- ================================================================ -->
    <!-- djb:smoothing                                                    -->
    <!--                                                                  -->
    <!-- Linear smoothing of Y values by $window size (default 3)         -->
    <!--   Window is centered on current point                            -->
    <!--   Include extra points from other side if one is too short       -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot_lib"/>
    <xsl:expose component="function" visibility="final"
        names="
        djb:smoothing#2
        djb:smoothing#1
        "/>
    <xsl:function name="djb:smoothing">
        <!-- ============================================================ -->
        <!-- djb:smoothing#2                                              -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $inputPoints as xs:string : whitespace delimited X,Y       -->
        <!--   $window as xs:integer : odd-valued window size             -->
        <!--                                                              -->
        <!-- Return: xs:string : whitespace delimited adjusted X,Y        -->
        <!-- ============================================================ -->
        <xsl:param name="inputPoints" as="xs:string"/>
        <xsl:param name="window" as="xs:integer"/>
        <!-- ============================================================ -->
        <!-- Raise an error if points are bad or $window is even          -->
        <!-- ============================================================ -->
        <xsl:variable name="points" select="djb:split_points($inputPoints)"/>
        <xsl:if test="not(djb:validate_points($points))">
            <xsl:message terminate="yes">Bad $points value: <xsl:value-of select="$points"
                /></xsl:message>
        </xsl:if>
        <xsl:if test="$window mod 2 = 0 and $window gt 0">
            <xsl:message terminate="yes">$window value must be a positive odd number</xsl:message>
        </xsl:if>
        <!-- ============================================================ -->
        <!-- $windowSide as xs:double: points to either side of center    -->
        <!-- $n as xs:integer : count of points                           -->
        <!-- $allX as xs:double+ : all X values                           -->
        <!-- $allY as xs:double+ : all Y values                           -->
        <!-- $scaledYs as xs:double+ : average within window              -->
        <!--   centered on current point                                  -->
        <!--   include extra points from other side if one is too short   -->
        <!-- ============================================================ -->
        <xsl:variable name="windowSide" as="xs:double" select="($window - 1) div 2"/>
        <xsl:variable name="n" as="xs:integer" select="count($points)"/>
        <xsl:variable name="allX" as="xs:double+"
            select="$points ! substring-before(.,',') ! number(.)"/>
        <xsl:variable name="allY" as="xs:double+"
            select="$points ! substring-after(.,',') ! number(.)"/>
        <xsl:variable name="scaledYs" as="xs:double+">
            <xsl:for-each select="$allY">
                <xsl:variable name="currentPos" as="xs:integer" select="position()"/>
                <xsl:choose>
                    <xsl:when test="position() lt $windowSide">
                        <xsl:value-of select="avg($allY[position() lt $window])"/>
                    </xsl:when>
                    <xsl:when test="position() gt $n - $windowSide">
                        <xsl:value-of select="avg($allY[position() ge ($n - $window)])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="avg($allY[position() ge $currentPos - $windowSide and position() le $currentPos + $windowSide])"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <!-- ============================================================ -->
        <!-- Sew the points back together and return since string         -->
        <!-- ============================================================ -->
        <xsl:sequence
            select="(for $i in 1 to $n return string-join(($allX[$i], $scaledYs[$i]), ',')) => string-join(' ')"
        />
    </xsl:function>
    <xsl:function name="djb:smoothing" as="xs:string">
        <xsl:param name="points"/>
        <xsl:sequence select="djb:smoothing($points, 3)"/>
    </xsl:function>
</xsl:package>

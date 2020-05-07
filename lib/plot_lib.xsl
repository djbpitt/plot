<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/plot_lib"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">
    <!-- ================================================================= -->
    <!-- Public (final) functions                                          -->
    <!-- ================================================================= -->
    <xsl:expose component="function" visibility="final"
        names="
        djb:validate_points#1 
        djb:split_points#1
        "/>
    <!-- ================================================================= -->
    <!-- validate_points (nb: plural)                                      -->
    <!--                                                                   -->
    <!-- Validates cardinality and lexical form of input points            -->
    <!--                                                                   -->
    <!-- Parameters:                                                       -->
    <!--   $pointPairs as xs:string+ : sequence of SVG coordinate points   -->
    <!--                                                                   -->
    <!-- Return:                                                           -->
    <!--   True iff                                                        -->
    <!--     1. There are at least three points                            -->
    <!--     2. Each point matches regex "X,Y" where                       -->
    <!--        a. X and Y are doubles with optional leading sign)         -->
    <!--        b. there are no spaces                                     -->
    <!-- ================================================================= -->
    <xsl:function name="djb:validate_points" as="xs:boolean">
        <xsl:param name="pointPairs" as="xs:string+"/>
        <!-- https://stackoverflow.com/questions/12643009/regular-expression-for-floating-point-numbers -->
        <xsl:sequence
            select="
            (count($pointPairs) ge 3)
            and
            (every $pointPair in $pointPairs
            satisfies djb:validate_point($pointPair))
            "
        />
    </xsl:function>

    <!-- ================================================================= -->
    <!-- split_points                                                      -->
    <!--                                                                   -->
    <!-- Splits SVG @points format into individual strings for each point  -->
    <!--                                                                   -->
    <!-- Parameters:                                                       -->
    <!--   $all_points as xs:string :                                      -->
    <!--      whitespace-delimited coordinate pairs                        -->
    <!--                                                                   -->
    <!-- Return:                                                           -->
    <!--   xs:string+ : one string for each point pair                     -->
    <!-- ================================================================= -->
    <xsl:function name="djb:split_points" as="xs:string+">
        <xsl:param name="all_points" as="xs:string"/>
        <xsl:sequence select="tokenize(normalize-space($all_points), ' ')"/>
    </xsl:function>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- Private functions                                                 -->
    <!-- ================================================================= -->
    <!-- validate_point (nb: singular)                                     -->
    <!--                                                                   -->
    <!-- Tests a single point and returns True if it matches regex         -->
    <!-- Regex: "X,Y" where                                                -->
    <!--   X and Y are doubles in canonic notation (optional leading sign) -->
    <!--   and there are no spaces                                         -->
    <!--                                                                   -->
    <!-- Parameters:                                                       -->
    <!--   $inputPoint as xs:string : point in X,Y format                  -->
    <!--                                                                   -->
    <!-- Return:                                                           -->
    <!--   True iff point matches regex                                    -->
    <!-- ================================================================= -->
    <xsl:function name="djb:validate_point" as="xs:boolean">
        <xsl:param name="inputPoint" as="xs:string"/>
        <!-- https://stackoverflow.com/questions/12643009/regular-expression-for-floating-point-numbers -->
        <xsl:variable name="float_regex" as="xs:string"
            select="'[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)'"/>
        <xsl:variable name="point_regex" as="xs:string" select="$float_regex || ',' || $float_regex"/>
        <xsl:sequence select="matches($inputPoint, $point_regex)"/>
    </xsl:function>
</xsl:package>

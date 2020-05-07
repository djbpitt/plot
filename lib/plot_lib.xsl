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
    <!--     3. X values are arranged monotonically                        -->
    <!-- ================================================================= -->
    <xsl:function name="djb:validate_points" as="xs:boolean">
        <xsl:param name="pointPairs" as="xs:string+"/>
        <!-- https://stackoverflow.com/questions/12643009/regular-expression-for-floating-point-numbers -->
        <xsl:sequence
            select="
            (count($pointPairs) ge 3)
            and
            (every $pointPair in $pointPairs
            satisfies djb:validate_point_regex($pointPair))
            and
            djb:validate_monotonic_X($pointPairs)
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
    <!-- validate_point_regex (nb: singular)                               -->
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
    <xsl:function name="djb:validate_point_regex" as="xs:boolean">
        <xsl:param name="inputPoint" as="xs:string"/>
        <!-- https://stackoverflow.com/questions/12643009/regular-expression-for-floating-point-numbers -->
        <xsl:variable name="float_regex" as="xs:string"
            select="'[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)'"/>
        <xsl:variable name="point_regex" as="xs:string" select="$float_regex || ',' || $float_regex"/>
        <xsl:sequence select="matches($inputPoint, $point_regex)"/>
    </xsl:function>
    <!-- ================================================================= -->
    <!-- validate_monotonic_X                                              -->
    <!--                                                                   -->
    <!-- Tests input a sequence and returns True if X values are monotonic -->
    <!--                                                                   -->
    <!-- Parameters:                                                       -->
    <!--   $inputPoints as xs:string+ : all points in X,Y format           -->
    <!--                                                                   -->
    <!-- Return:                                                           -->
    <!--   True iff X is monotonic                                         -->
    <!--                                                                   -->
    <!-- Note: not($list != $list) returns true iff all values agree       -->
    <!--   (thanks, Liam!)                                                 -->
    <!-- ================================================================= -->
    <xsl:function name="djb:validate_monotonic_X" as="xs:boolean">
        <xsl:param name="pointPairs" as="xs:string+"/>
        <xsl:variable name="allX" as="xs:double+"
            select="$pointPairs ! tokenize(., ',')[1] ! number(.)"/>
        <xsl:variable name="pointCount" as="xs:integer" select="count($pointPairs)"/>
        <xsl:variable name="test_for_ge" as="xs:boolean+"
            select="for $i in 2 to $pointCount return $allX[$i] ge $allX[$i - 1]"/>
        <xsl:sequence select="not($test_for_ge != $test_for_ge)"/>
    </xsl:function>
</xsl:package>

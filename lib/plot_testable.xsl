<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns:djb="http://www.obdurodon.org" version="3.0">

    <!-- ================================================================= -->
    <!-- validate_points                                                   -->
    <!--                                                                   -->
    <!-- Return true if matches regex and at least 3 points                -->
    <!-- Regex: "X,Y" where                                                -->
    <!--   X and Y are doubles in canonic notation (optional leading sign) -->
    <!--   and there are no spaces                                         -->
    <!-- ================================================================= -->
    <xsl:function name="djb:validate_points" as="xs:boolean">
        <xsl:param name="pointPairs" as="xs:string+"/>
        <!-- https://stackoverflow.com/questions/12643009/regular-expression-for-floating-point-numbers -->
        <xsl:variable name="float_regex" as="xs:string"
            select="'[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)'"/>
        <xsl:variable name="pair_regex" as="xs:string"
            select="concat('^', $float_regex, ',', $float_regex, '$')"/>
        <xsl:sequence
            select="
                every $pointPair in $pointPairs
                    satisfies matches($pointPair, $pair_regex) and (count($pointPairs) ge 3)"
        />
    </xsl:function>
    <!-- ================================================================= -->
    <!-- split_points                                                      -->
    <!-- Input is single string with whitespace-delimited coordinate paris -->
    <!-- ================================================================= -->
    <xsl:function name="djb:split_points" as="xs:string+">
        <xsl:param name="all_points" as="xs:string"/>
        <xsl:sequence select="tokenize(normalize-space($all_points), ' ')"/>
    </xsl:function>
</xsl:stylesheet>

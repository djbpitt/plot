<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:djb="http://www.obdurodon.org" version="2.0">
    <xsl:output method="text"/>
    <xsl:template name="test">
        <!-- 
            Intended for import into other XSLT stylesheets
            May be tested against itself by running with a named template
        -->
        <xsl:value-of
            select="concat('0101 AND 0011 should equal 0001: ', djb:and('0101', '0011'), concat(' (', djb:and('0101', '0011') eq '0001'), ')&#x0a;')"/>
        <xsl:value-of
            select="concat('0101 OR  0011 should equal 0111: ', djb:or('0101', '0011'), concat(' (', djb:or('0101', '0011') eq '0111'), ')&#x0a;')"/>
        <xsl:value-of
            select="concat('0101 XOR 0011 should equal 0110: ', djb:xor('0101', '0011'), concat(' (', djb:xor('0101', '0011') eq '0110'), ')&#x0a;')"/>
        <xsl:value-of
            select="concat('NOT 0111      should equal 1000: ', djb:not('0111'), concat(' (', djb:not('0111') eq '1000'), ')&#x0a;')"
        />
    </xsl:template>
    <!-- 
        Title: bitmask.xsl
        Author: djb (2016-05-19)
        Repo: https://github.com/xstuff
        Synopsis: bitmask operators djb:and(), djb:or(), djb:xor(), djb:not()
        Notes:
            Input and output are strings (not number types)
            djb:lpad() is a supporting function that left pads with 0
    -->
    <xsl:function name="djb:lpad" as="xs:string">
        <xsl:param name="input" as="xs:string" required="yes"/>
        <xsl:param name="places" as="xs:integer" required="yes"/>
        <xsl:choose>
            <xsl:when test="string-length($input) lt $places">
                <xsl:sequence select="concat('0', $input)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="djb:and" as="xs:string">
        <!-- 
            0 AND 0 = 0
            0 AND 1 = 0
            1 AND 1 = 1
        -->
        <xsl:param name="input1" as="xs:string" required="yes"/>
        <xsl:param name="input2" as="xs:string" required="yes"/>
        <xsl:sequence
            select="djb:lpad(translate(xs:string(xs:integer($input1) + xs:integer($input2)), '12', '01'), string-length($input1))"
        />
    </xsl:function>
    <xsl:function name="djb:or" as="xs:string">
        <!-- 
            0 OR 0 = 0
            0 OR 1 = 1
            1 OR 1 = 1
        -->
        <xsl:param name="input1" as="xs:string" required="yes"/>
        <xsl:param name="input2" as="xs:string" required="yes"/>
        <xsl:sequence
            select="djb:lpad(translate(xs:string(xs:integer($input1) + xs:integer($input2)), '2', '1'), string-length($input1))"
        />
    </xsl:function>
    <xsl:function name="djb:xor" as="xs:string">
        <!-- 
            0 XOR 0 = 0
            0 XOR 1 = 1
            1 XOR 1 = 0
        -->
        <xsl:param name="input1" as="xs:string" required="yes"/>
        <xsl:param name="input2" as="xs:string" required="yes"/>
        <xsl:sequence
            select="djb:lpad(translate(xs:string(xs:integer($input1) + xs:integer($input2)), '2', '0'), string-length($input1))"
        />
    </xsl:function>
    <xsl:function name="djb:not" as="xs:string">
        <!-- 
            NOT 0 = 1
            NOT 1 = 0
        -->
        <xsl:param name="input" as="xs:string" required="yes"/>
        <xsl:sequence select="translate($input, '01', '10')"/>
    </xsl:function>
</xsl:stylesheet>

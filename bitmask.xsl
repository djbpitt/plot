<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:djb="http://www.obdurodon.org" version="2.0">
    <!-- 
        Title: bitmask.xsl
        Author: djb (2016-05-19)
        Repo: https://github.com/xstuff
        Synopsis: B
            Bitmask operators djb:and(), djb:or(), djb:xor(), djb:not()
            djb:rhymeComp() returns a sequence of three values:
                bits (string; 0 indicates agreement, 1 indicates disagreement)
                positions of correspondence (string-join of integer positions of agreement across hyphen)
                amount of correspondence (double, varies between 0 and 1)
        Notes:
            Input and output are strings (not number types)
            djb:lpad() is a supporting function that left pads with 0
            Intended for import into other stylesheets; may be run without input with it="name"
    -->
    <xsl:template name="test">
        <xsl:value-of
            select="concat('0101 AND 0011 should equal 0001: ', djb:and('0101', '0011'), concat(' (', djb:and('0101', '0011') eq '0001'), ')&#x0a;')"/>
        <xsl:value-of
            select="concat('0101 OR  0011 should equal 0111: ', djb:or('0101', '0011'), concat(' (', djb:or('0101', '0011') eq '0111'), ')&#x0a;')"/>
        <xsl:value-of
            select="concat('0101 XOR 0011 should equal 0110: ', djb:xor('0101', '0011'), concat(' (', djb:xor('0101', '0011') eq '0110'), ')&#x0a;')"/>
        <xsl:value-of
            select="concat('NOT 1000      should equal 0111: ', djb:not('1000'), concat(' (', djb:not('1000') eq '0001'), ')&#x0a;')"/>
        <xsl:variable name="results" as="item()+" select="djb:rhymeComp('010110', '001110')"/>
        <xsl:value-of
            select='"djb:rhymeComp(&apos;010110&apos;,&apos;001110&apos;) should equal 011000, 2-3, 0.6666666666666666:&#x0a;"'/>
        <xsl:value-of
            select="concat('    Bits:      ', $results[1], ' (', $results[1] eq '011000', ')&#x0a;')"/>
        <xsl:value-of
            select="concat('    Positions: ', $results[2], '  (', $results[2] eq '1-4-5-6', ')&#x0a;')"/>
        <xsl:value-of
            select="concat('    Percent:   ', $results[3], '  (', $results[3] eq 2 div 3, ')&#x0a;')"
        />
    </xsl:template>
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
        <xsl:choose>
            <xsl:when test="string-length($input1) eq string-length($input2)">
                <xsl:sequence
                    select="djb:lpad(translate(xs:string(xs:integer($input1) + xs:integer($input2)), '12', '01'), string-length($input1))"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">Comparison strings are not the same
                    length</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="djb:or" as="xs:string">
        <!-- 
            0 OR 0 = 0
            0 OR 1 = 1
            1 OR 1 = 1
        -->
        <xsl:param name="input1" as="xs:string" required="yes"/>
        <xsl:param name="input2" as="xs:string" required="yes"/>
        <xsl:choose>
            <xsl:when test="string-length($input1) eq string-length($input2)">
                <xsl:sequence
                    select="djb:lpad(translate(xs:string(xs:integer($input1) + xs:integer($input2)), '2', '1'), string-length($input1))"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">Comparison strings are not the same
                    length</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="djb:xor" as="xs:string">
        <!-- 
            0 XOR 0 = 0
            0 XOR 1 = 1
            1 XOR 1 = 0
        -->
        <xsl:param name="input1" as="xs:string" required="yes"/>
        <xsl:param name="input2" as="xs:string" required="yes"/>
        <xsl:choose>
            <xsl:when test="string-length($input1) eq string-length($input2)">
                <xsl:sequence
                    select="djb:lpad(translate(xs:string(xs:integer($input1) + xs:integer($input2)), '2', '0'), string-length($input1))"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">Comparison strings are not the same
                    length</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="djb:not" as="xs:string">
        <!-- 
            NOT 0 = 1
            NOT 1 = 0
        -->
        <xsl:param name="input" as="xs:string" required="yes"/>
        <xsl:sequence select="translate($input, '01', '10')"/>
    </xsl:function>
    <xsl:function name="djb:rhymeComp" as="item()+">
        <xsl:param name="input1" as="xs:string"/>
        <xsl:param name="input2" as="xs:string"/>
        <xsl:variable name="bits" as="xs:string" select="djb:xor($input1, $input2)"/>
        <xsl:variable name="positions" as="xs:integer*"
            select="index-of(string-to-codepoints($bits), string-to-codepoints('0'))"/>
        <xsl:variable name="pct" as="xs:double" select="count($positions) div string-length($bits)"/>
        <xsl:sequence
            select="
                $bits,
                string-join(for $position in $positions
                return
                    string($position), '-'), $pct"
        />
    </xsl:function>
</xsl:stylesheet>

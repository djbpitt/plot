<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- Mickael Kay on xsl-list, 2019-11-26
        
        Firstly, it's important to remember that (conceptually at least) tree construction is bottom up. 
        You successfully create an an attribute typed as attribute(*, xs:integer); then you create a <cell> 
        element, and attach a copy of the attribute to this element; then you create a <test> element, and 
        attach a copy of the <cell> element to this.

        There is no validation attribute on the <cell> element, and no containing element with a 
        default-validation attribute, so the effect is as if you specified validation="strip", which drops 
        the type annotation on the attribute when it is copied. To prevent this, I would suggest specifying 

            <xsl:variable name="test" default-validation="preserve"/>

        which then also means you don't need the validation attribute on the <test> element.

        What you've got here is a sort of degenerate form of schema-aware processing in which your schema 
        only contains the built-in types. I haven't tried doing that myself but it should work in theory.

        Note also, (@row instance of xs:integer) is always going to be false: @row is an attribute node, 
        not an integer. What you want here is either (data(@row) instance of xs:integer), or (@row 
        instance of attribute(*, xs:integer)).
    -->
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="test" default-validation="preserve" as="element(test)">
            <test>
                <xsl:for-each select="1 to 5">
                    <cell>
                        <xsl:attribute name="row" type="xs:integer" select="."/>
                        <xsl:text>Hi!</xsl:text>
                    </cell>
                </xsl:for-each>
            </test>
        </xsl:variable>
        <xsl:for-each select="$test//cell">
            <xsl:message select="@row, @row instance of attribute(row,xs:integer)"/>
        </xsl:for-each>
        <root>
            <xsl:sequence select="$test"/>
        </root>
    </xsl:template>
</xsl:stylesheet>

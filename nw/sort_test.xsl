<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <!--
        Scratch work
        Return <score> with highest value, but only one, 
            in order from d -> l -> u
        Work around unavailability of sort() with higher-order
            functions in Saxon HE with clumsier <xsl:sort>        
    -->
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="scores" as="element(score)+">
        <!-- Sample data, with tie between u and d, and u listed first -->
        <score xml:id="'u'" value="30"/>
        <score xml:id="'l'" value="10"/>
        <score xml:id="'d'" value="30"/>
    </xsl:variable>
    <xsl:variable name="best_scores" as="element(score)+">
        <xsl:for-each select="$scores[@value = max($scores/@value)]">
            <!-- Select by value, then sort by @xml:id 
                (conveniently, preference corresponds to alphabetical)
            -->
            <xsl:sort select="@xml:id"/>
            <xsl:sequence select="."/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:template name="xsl:initial-template">
        <root>
            <!-- Keep only the first alphabetically -->
            <xsl:sequence select="$best_scores[1]"/>
        </root>
    </xsl:template>
</xsl:stylesheet>

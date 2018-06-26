<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    exclude-result-prefixes="#all">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:template match="/*" priority="1">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*[@type eq 'start'][following-sibling::*[1][@n eq current()/@n]]">
        <xsl:message select="concat('Start: ', name())"/>
        <xsl:element name="{name()}">
            <!-- textual content of raised element-->
            <xsl:copy-of
                select="following-sibling::node()[. &lt;&lt; following-sibling::*[@n eq current()/@n]]"
            />
        </xsl:element>
    </xsl:template>
    <xsl:template match="node()[preceding-sibling::node()[1]/@n eq following-sibling::node()[1]/@n]"/>
    <xsl:template match="node()[preceding-sibling::node()[2]/@n eq current()/@n]"/>
</xsl:stylesheet>

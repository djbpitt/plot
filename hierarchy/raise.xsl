<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    exclude-result-prefixes="#all">
    <xsl:output method="xml" indent="no"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:mode on-no-match="shallow-copy" name="loop"/>
    <xsl:function name="djb:raise">
        <xsl:param name="input" as="document-node()"/>
        <xsl:choose>
            <xsl:when test="exists($input//@type)">
                <xsl:variable name="result" as="document-node()">
                    <xsl:document>
                        <xsl:apply-templates select="$input" mode="loop"/>
                    </xsl:document>
                </xsl:variable>
                <xsl:sequence select="djb:raise($result)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:template match="/">
        <xsl:sequence select="djb:raise(.)"/>
    </xsl:template>
    <xsl:template match="/" mode="loop">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="*[@type eq 'start'][@n eq following-sibling::*[@type eq 'end'][1]/@n]">
        <!-- innermost start-tag -->
        <xsl:element name="{name()}">
            <!-- textual content of raised element-->
            <xsl:copy-of
                select="following-sibling::node()[following-sibling::*[@n eq current()/@n]]"
            />
        </xsl:element>
    </xsl:template>
    <!-- nodes inside new wrapper -->
    <xsl:template
        match="node()[preceding-sibling::*[@type eq 'start'][1]/@n eq following-sibling::*[@type eq 'end'][1]/@n]"/>
    <!-- end-tag for new wrapper -->
    <xsl:template
        match="*[@type eq 'end'][preceding-sibling::*[@type eq 'start'][1]/@n eq current()/@n]"/>
</xsl:stylesheet>

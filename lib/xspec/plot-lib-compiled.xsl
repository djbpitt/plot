<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:djb="http://www.obdurodon.org"
                xmlns:f="http://www.obdurodon.org/function-variables"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0"><!-- an XSpec stylesheet providing tools -->
   <xsl:import href="file:/Users/djb/repos/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:include href="file:/Users/djb/repos/xspec/src/common/xspec-utils.xsl"/>
   <xsl:output name="Q{http://www.jenitennison.com/xslt/xspec}report"
               method="xml"
               indent="yes"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/djb/repos/plot/lib/plot-lib.xspec</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                 as="empty-sequence()"/>
   <!-- the main template to run the suite -->
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}main">
      <!-- info message -->
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <!-- set up the result document (the report) -->
      <xsl:result-document format="Q{{http://www.jenitennison.com/xslt/xspec}}report">
         <x:report stylesheet="file:/Users/djb/repos/plot/lib/plot-lib.xsl"
                   date="{current-dateTime()}"
                   xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
            <!-- a call instruction for each top-level scenario -->
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario6"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario8"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario9"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario11"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1">
      <xsl:message>Scenarios for testing function validate-points</xsl:message>
      <x:scenario id="scenario1" xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>Scenarios for testing function validate-points</x:label>
         <x:call>
            <xsl:attribute name="function">djb:validate-points</xsl:attribute>
         </x:call>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario1"/>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2"/>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario3"/>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario4"/>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario1">
      <xsl:message>..with valid input (at least three, no white-space, monotonic X)</xsl:message>
      <x:scenario id="scenario1-scenario1"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with valid input (at least three, no white-space, monotonic X)</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:point-pairs</xsl:attribute>
               <xsl:attribute name="select">'1,2', '3,4', '5,6'</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}point-pairs"
                          select="'1,2', '3,4', '5,6'"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}point-pairs]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:validate-points')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario1-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario1-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>Valid points (at least three, correct format, no white-space) should pass</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e7" select="true()"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e7, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario1-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Valid points (at least three, correct format, no white-space) should pass</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e7"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2">
      <xsl:message>..with too few points</xsl:message>
      <x:scenario id="scenario1-scenario2"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with too few points</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:point-pairs</xsl:attribute>
               <xsl:attribute name="select">'1,2', '3,4'</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}point-pairs"
                          select="'1,2', '3,4'"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}point-pairs]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:validate-points')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>Fewer than three points should fail</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e11" select="false()"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e11, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario2-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Fewer than three points should fail</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e11"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario3">
      <xsl:message>..with non-monotonic X</xsl:message>
      <x:scenario id="scenario1-scenario3"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with non-monotonic X</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:point-pairs</xsl:attribute>
               <xsl:attribute name="select">'1,2', '5,4', '3,6'</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}point-pairs"
                          select="'1,2', '5,4', '3,6'"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}point-pairs]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:validate-points')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario3-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario3-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>Non-monotonic X should fail</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e15" select="false()"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e15, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario3-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Non-monotonic X should fail</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e15"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario4">
      <xsl:message>..with incorrect white-space</xsl:message>
      <x:scenario id="scenario1-scenario4"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with incorrect white-space</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:point-pairs</xsl:attribute>
               <xsl:attribute name="select">'1, 2', '3,4', '5,6'</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}point-pairs"
                          select="'1, 2', '3,4', '5,6'"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}point-pairs]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:validate-points')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario4-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario4-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>White space inside point should fail</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e19" select="false()"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e19, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario4-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>White space inside point should fail</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e19"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2">
      <xsl:message>Scenario for testing function random-sequence</xsl:message>
      <x:scenario id="scenario2" xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>Scenario for testing function random-sequence</x:label>
         <x:call>
            <xsl:attribute name="function">djb:random-sequence</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">count</xsl:attribute>
               <xsl:attribute name="select">100</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{}count" select="100"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'" select="[$Q{}count]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:random-sequence')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>Count should equal 100, ranging between 0 and 1</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e23" select="()"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-items" as="item()*">
         <xsl:choose>
            <xsl:when test="exists($Q{http://www.jenitennison.com/xslt/xspec}result) and Q{http://www.jenitennison.com/xslt/unit-test}wrappable-sequence($Q{http://www.jenitennison.com/xslt/xspec}result)">
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/unit-test}wrap-nodes($Q{http://www.jenitennison.com/xslt/xspec}result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-result" as="item()*">
         <xsl:choose>
            <xsl:when test="count($Q{urn:x-xspec:compile:impl}test-items) eq 1">
               <xsl:for-each select="$Q{urn:x-xspec:compile:impl}test-items">
                  <xsl:sequence select="count($x:result) eq 100 and min($x:result) gt 0 and max($x:result) lt 1"
                                version="3"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="count($x:result) eq 100 and min($x:result) gt 0 and max($x:result) lt 1"
                             version="3"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}boolean-test"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="$Q{urn:x-xspec:compile:impl}test-result instance of Q{http://www.w3.org/2001/XMLSchema}boolean"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean">
         <xsl:choose>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}boolean-test">
               <xsl:sequence select="boolean($Q{urn:x-xspec:compile:impl}test-result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e23, $Q{urn:x-xspec:compile:impl}test-result, '')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario2-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Count should equal 100, ranging between 0 and 1</x:label>
         <xsl:if test="not($Q{urn:x-xspec:compile:impl}boolean-test)">
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
               <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}test-result"/>
               <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
            </xsl:call-template>
         </xsl:if>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e23"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?">
               <xsl:attribute name="test">count($x:result) eq 100 and min($x:result) gt 0 and max($x:result) lt 1</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3">
      <xsl:message>Scenarios for testing function get-weights-scale#3</xsl:message>
      <x:scenario id="scenario3" xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>Scenarios for testing function get-weights-scale#3</x:label>
         <xsl:variable name="Q{http://www.obdurodon.org}window-size"
                       as="xs:integer"
                       select="17"/>
         <x:call>
            <xsl:attribute name="function">djb:get-weights-scale</xsl:attribute>
         </x:call>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario1">
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario2">
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario3">
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario4">
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario5">
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario6">
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario7">
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario1">
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>..with Gaussian kernel</xsl:message>
      <x:scenario id="scenario3-scenario1"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with Gaussian kernel</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:kernel</xsl:attribute>
               <xsl:attribute name="select">'gaussian'</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:window-size</xsl:attribute>
               <xsl:attribute name="select">$djb:window-size</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:stddev</xsl:attribute>
               <xsl:attribute name="select">5</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}kernel"
                          select="'gaussian'"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}window-size"
                          select="$djb:window-size"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}stddev" select="5"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}kernel, $Q{http://www.obdurodon.org/function-variables}window-size, $Q{http://www.obdurodon.org/function-variables}stddev]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:get-weights-scale')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario1-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario1-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>desending Gaussian values (n = window-size + 1)</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e32"
                    select="                 1,                  0.9801986733067553,                  0.9231163463866358,                  0.835270211411272,                  0.7261490370736909,                  0.6065306597126334,                  0.4867522559599717,                  0.37531109885139957,                  0.27803730045319414,                  0.19789869908361465,                  0.1353352832366127,                  0.08892161745938634,                  0.056134762834133725,                  0.034047454734599344,                  0.019841094744370288,                  0.011108996538242306,                  0.005976022895005943,                  0.0030887154082367687                 "/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e32, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario3-scenario1-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>desending Gaussian values (n = window-size + 1)</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e32"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario2">
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>..with rectangular kernel</xsl:message>
      <x:scenario id="scenario3-scenario2"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with rectangular kernel</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:kernel</xsl:attribute>
               <xsl:attribute name="select">'rectangular'</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:window-size</xsl:attribute>
               <xsl:attribute name="select">$djb:window-size</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:stddev</xsl:attribute>
               <xsl:attribute name="select">5</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}kernel"
                          select="'rectangular'"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}window-size"
                          select="$djb:window-size"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}stddev" select="5"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}kernel, $Q{http://www.obdurodon.org/function-variables}window-size, $Q{http://www.obdurodon.org/function-variables}stddev]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:get-weights-scale')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario2-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario2-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>rectangular values (n = window-size + 1)</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e38"
                    select="                 1,                 1,                 1,                 1,                 1,                 1,                 1,                 1,                 1,                 1,                 1,                 1,                 1,                 1,                 1,                 1,                 1,                 1                 "/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e38, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario3-scenario2-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>rectangular values (n = window-size + 1)</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e38"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario3">
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>..with exponential kernel</xsl:message>
      <x:scenario id="scenario3-scenario3"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with exponential kernel</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:kernel</xsl:attribute>
               <xsl:attribute name="select">'exponential'</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:window-size</xsl:attribute>
               <xsl:attribute name="select">$djb:window-size</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:stddev</xsl:attribute>
               <xsl:attribute name="select">5</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}kernel"
                          select="'exponential'"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}window-size"
                          select="$djb:window-size"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}stddev" select="5"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}kernel, $Q{http://www.obdurodon.org/function-variables}window-size, $Q{http://www.obdurodon.org/function-variables}stddev]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:get-weights-scale')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario3-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario3-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>exponential values</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e44"
                    select="                     1,                     0.5,                     0.25,                     0.125,                     0.0625,                     0.03125,                     0.015625,                     0.0078125,                     0.00390625,                     0.001953125,                     0.0009765625,                     0.00048828125,                     0.000244140625,                     0.0001220703125,                     0.00006103515625,                     0.000030517578125,                     0.0000152587890625,                     0.00000762939453125                     "/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e44, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario3-scenario3-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>exponential values</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e44"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario4">
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>..with parabolic-up kernel</xsl:message>
      <x:scenario id="scenario3-scenario4"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with parabolic-up kernel</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:kernel</xsl:attribute>
               <xsl:attribute name="select">'parabolic-up'</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:window-size</xsl:attribute>
               <xsl:attribute name="select">$djb:window-size</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:stddev</xsl:attribute>
               <xsl:attribute name="select">5</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}kernel"
                          select="'parabolic-up'"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}window-size"
                          select="$djb:window-size"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}stddev" select="5"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}kernel, $Q{http://www.obdurodon.org/function-variables}window-size, $Q{http://www.obdurodon.org/function-variables}stddev]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:get-weights-scale')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario4-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario4-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>parabolic values, opening up</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e50"
                    select="                 1,                 0.8858131487889274,                 0.7785467128027681,                 0.6782006920415224,                 0.5847750865051903,                 0.4982698961937717,                 0.41868512110726647,                 0.34602076124567477,                 0.28027681660899656,                 0.22145328719723184,                 0.1695501730103806,                 0.12456747404844293,                 0.08650519031141869,                 0.05536332179930796,                 0.031141868512110732,                 0.01384083044982699,                 0.0034602076124567475,                 0                 "/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e50, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario3-scenario4-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>parabolic values, opening up</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e50"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario5">
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>..with parabolic-down kernel</xsl:message>
      <x:scenario id="scenario3-scenario5"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with parabolic-down kernel</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:kernel</xsl:attribute>
               <xsl:attribute name="select">'parabolic-down'</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:window-size</xsl:attribute>
               <xsl:attribute name="select">$djb:window-size</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:stddev</xsl:attribute>
               <xsl:attribute name="select">5</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}kernel"
                          select="'parabolic-down'"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}window-size"
                          select="$djb:window-size"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}stddev" select="5"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}kernel, $Q{http://www.obdurodon.org/function-variables}window-size, $Q{http://www.obdurodon.org/function-variables}stddev]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:get-weights-scale')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario5-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario5-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>parabolic values, opening down</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e56"
                    select="                 1,                 0.9965397923875432,                 0.986159169550173,                 0.9688581314878892,                 0.9446366782006921,                 0.9134948096885813,                 0.8754325259515571,                 0.8304498269896194,                 0.7785467128027681,                 0.7197231833910034,                 0.6539792387543253,                 0.5813148788927336,                 0.5017301038062283,                 0.4152249134948097,                 0.32179930795847755,                 0.2214532871972319,                 0.11418685121107264,                 0                 "/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e56, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario3-scenario5-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>parabolic values, opening down</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e56"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario6">
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>..with invalid kernel</xsl:message>
      <x:scenario id="scenario3-scenario6"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with invalid kernel</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:kernel</xsl:attribute>
               <xsl:attribute name="select">'dummy'</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:window-size</xsl:attribute>
               <xsl:attribute name="select">$djb:window-size</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:stddev</xsl:attribute>
               <xsl:attribute name="select">5</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}kernel"
                          select="'dummy'"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}window-size"
                          select="$djb:window-size"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}stddev" select="5"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}kernel, $Q{http://www.obdurodon.org/function-variables}window-size, $Q{http://www.obdurodon.org/function-variables}stddev]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:get-weights-scale')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:try>
               <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
               <xsl:catch>
                  <xsl:map>
                     <xsl:map-entry key="'err'">
                        <xsl:map>
                           <xsl:map-entry key="'code'" select="$Q{http://www.w3.org/2005/xqt-errors}code"/>
                           <xsl:map-entry key="'description'"
                                          select="$Q{http://www.w3.org/2005/xqt-errors}description"/>
                           <xsl:map-entry key="'value'" select="$Q{http://www.w3.org/2005/xqt-errors}value"/>
                           <xsl:map-entry key="'module'" select="$Q{http://www.w3.org/2005/xqt-errors}module"/>
                           <xsl:map-entry key="'line-number'"
                                          select="$Q{http://www.w3.org/2005/xqt-errors}line-number"/>
                           <xsl:map-entry key="'column-number'"
                                          select="$Q{http://www.w3.org/2005/xqt-errors}column-number"/>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:map>
               </xsl:catch>
            </xsl:try>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario6-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario6-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>err:description</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e63"
                    select="'Invalid kernel type: dummy; must be one of: gaussian, rectangular, exponential, parabolic-up, or parabolic-down'"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-items" as="item()*">
         <xsl:choose>
            <xsl:when test="exists($Q{http://www.jenitennison.com/xslt/xspec}result) and Q{http://www.jenitennison.com/xslt/unit-test}wrappable-sequence($Q{http://www.jenitennison.com/xslt/xspec}result)">
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/unit-test}wrap-nodes($Q{http://www.jenitennison.com/xslt/xspec}result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-result" as="item()*">
         <xsl:choose>
            <xsl:when test="count($Q{urn:x-xspec:compile:impl}test-items) eq 1">
               <xsl:for-each select="$Q{urn:x-xspec:compile:impl}test-items">
                  <xsl:sequence select="$x:result?err?description" version="3"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$x:result?err?description" version="3"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}boolean-test"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="$Q{urn:x-xspec:compile:impl}test-result instance of Q{http://www.w3.org/2001/XMLSchema}boolean"/>
      <xsl:if test="$Q{urn:x-xspec:compile:impl}boolean-test">
         <xsl:message>
            <xsl:text>WARNING: x:expect has boolean @test (i.e. assertion) along with @href, @select or child node (i.e. comparison). Comparison factors will be ignored.</xsl:text>
         </xsl:message>
      </xsl:if>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean">
         <xsl:choose>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}boolean-test">
               <xsl:sequence select="boolean($Q{urn:x-xspec:compile:impl}test-result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e63, $Q{urn:x-xspec:compile:impl}test-result, '')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario3-scenario6-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>err:description</x:label>
         <xsl:if test="not($Q{urn:x-xspec:compile:impl}boolean-test)">
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
               <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}test-result"/>
               <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
            </xsl:call-template>
         </xsl:if>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e63"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?">
               <xsl:attribute name="test">$x:result?err?description</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario7">
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>..with invalid window-size</xsl:message>
      <x:scenario id="scenario3-scenario7"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with invalid window-size</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:kernel</xsl:attribute>
               <xsl:attribute name="select">'gaussian'</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:window-size</xsl:attribute>
               <xsl:attribute name="select">10</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:stddev</xsl:attribute>
               <xsl:attribute name="select">5</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}kernel"
                          select="'gaussian'"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}window-size"
                          select="10"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}stddev" select="5"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}kernel, $Q{http://www.obdurodon.org/function-variables}window-size, $Q{http://www.obdurodon.org/function-variables}stddev]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:get-weights-scale')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:try>
               <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
               <xsl:catch>
                  <xsl:map>
                     <xsl:map-entry key="'err'">
                        <xsl:map>
                           <xsl:map-entry key="'code'" select="$Q{http://www.w3.org/2005/xqt-errors}code"/>
                           <xsl:map-entry key="'description'"
                                          select="$Q{http://www.w3.org/2005/xqt-errors}description"/>
                           <xsl:map-entry key="'value'" select="$Q{http://www.w3.org/2005/xqt-errors}value"/>
                           <xsl:map-entry key="'module'" select="$Q{http://www.w3.org/2005/xqt-errors}module"/>
                           <xsl:map-entry key="'line-number'"
                                          select="$Q{http://www.w3.org/2005/xqt-errors}line-number"/>
                           <xsl:map-entry key="'column-number'"
                                          select="$Q{http://www.w3.org/2005/xqt-errors}column-number"/>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:map>
               </xsl:catch>
            </xsl:try>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario7-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-scenario7-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>err:description</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e70"
                    select="'Invalid window size: 10; window size must be odd integer greater than 3'"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-items" as="item()*">
         <xsl:choose>
            <xsl:when test="exists($Q{http://www.jenitennison.com/xslt/xspec}result) and Q{http://www.jenitennison.com/xslt/unit-test}wrappable-sequence($Q{http://www.jenitennison.com/xslt/xspec}result)">
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/unit-test}wrap-nodes($Q{http://www.jenitennison.com/xslt/xspec}result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-result" as="item()*">
         <xsl:choose>
            <xsl:when test="count($Q{urn:x-xspec:compile:impl}test-items) eq 1">
               <xsl:for-each select="$Q{urn:x-xspec:compile:impl}test-items">
                  <xsl:sequence select="$x:result?err?description" version="3"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$x:result?err?description" version="3"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}boolean-test"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="$Q{urn:x-xspec:compile:impl}test-result instance of Q{http://www.w3.org/2001/XMLSchema}boolean"/>
      <xsl:if test="$Q{urn:x-xspec:compile:impl}boolean-test">
         <xsl:message>
            <xsl:text>WARNING: x:expect has boolean @test (i.e. assertion) along with @href, @select or child node (i.e. comparison). Comparison factors will be ignored.</xsl:text>
         </xsl:message>
      </xsl:if>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean">
         <xsl:choose>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}boolean-test">
               <xsl:sequence select="boolean($Q{urn:x-xspec:compile:impl}test-result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e70, $Q{urn:x-xspec:compile:impl}test-result, '')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario3-scenario7-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>err:description</x:label>
         <xsl:if test="not($Q{urn:x-xspec:compile:impl}boolean-test)">
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
               <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}test-result"/>
               <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
            </xsl:call-template>
         </xsl:if>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e70"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?">
               <xsl:attribute name="test">$x:result?err?description</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4">
      <xsl:message>Scenario for testing function get-weights-scale#2 with Gaussian kernel</xsl:message>
      <x:scenario id="scenario4" xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>Scenario for testing function get-weights-scale#2 with Gaussian kernel</x:label>
         <xsl:variable name="Q{http://www.obdurodon.org}window-size"
                       as="xs:integer"
                       select="17"/>
         <x:call>
            <xsl:attribute name="function">djb:get-weights-scale</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">f:kernel</xsl:attribute>
               <xsl:attribute name="select">'gaussian'</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:window-size</xsl:attribute>
               <xsl:attribute name="select">$djb:window-size</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}kernel"
                          select="'gaussian'"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}window-size"
                          select="$djb:window-size"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}kernel, $Q{http://www.obdurodon.org/function-variables}window-size]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:get-weights-scale')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:message>desending Gaussian values (n = window-size + 1)</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e76"
                    select="                 1,                  0.9801986733067553,                  0.9231163463866358,                  0.835270211411272,                  0.7261490370736909,                  0.6065306597126334,                  0.4867522559599717,                  0.37531109885139957,                  0.27803730045319414,                  0.19789869908361465,                  0.1353352832366127,                  0.08892161745938634,                  0.056134762834133725,                  0.034047454734599344,                  0.019841094744370288,                  0.011108996538242306,                  0.005976022895005943,                  0.0030887154082367687                 "/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e76, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario4-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>desending Gaussian values (n = window-size + 1)</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e76"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5">
      <xsl:message>Scenarios for testing function weighted-average</xsl:message>
      <x:scenario id="scenario5" xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>Scenarios for testing function weighted-average</x:label>
         <xsl:variable name="Q{http://www.obdurodon.org}window-size"
                       as="xs:integer"
                       select="3"/>
         <xsl:variable name="Q{http://www.obdurodon.org}input-values"
                       as="xs:double+"
                       select="1, 2, 3, 4, 5"/>
         <xsl:variable name="Q{http://www.obdurodon.org}weights"
                       as="xs:double+"
                       select="             1,              0.9801986733067553,              0.9231163463866358,              0.835270211411272,              0.7261490370736909,              0.6065306597126334,              0.4867522559599717,              0.37531109885139957,              0.27803730045319414,              0.19789869908361465,              0.1353352832366127,              0.08892161745938634,              0.056134762834133725,              0.034047454734599344,              0.019841094744370288,              0.011108996538242306,              0.005976022895005943,              0.0030887154082367687             "/>
         <x:call>
            <xsl:attribute name="function">djb:weighted-average</xsl:attribute>
         </x:call>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5-scenario1">
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
            <xsl:with-param name="djb:input-values" select="$djb:input-values"/>
            <xsl:with-param name="djb:weights" select="$djb:weights"/>
         </xsl:call-template>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5-scenario2">
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
            <xsl:with-param name="djb:input-values" select="$djb:input-values"/>
            <xsl:with-param name="djb:weights" select="$djb:weights"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5-scenario1">
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:param name="djb:input-values" required="yes"/>
      <xsl:param name="djb:weights" required="yes"/>
      <xsl:message>..at right edge of sequence</xsl:message>
      <x:scenario id="scenario5-scenario1"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>at right edge of sequence</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:focus</xsl:attribute>
               <xsl:attribute name="select">5</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:window-size</xsl:attribute>
               <xsl:attribute name="select">$djb:window-size</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:input-values</xsl:attribute>
               <xsl:attribute name="select">$djb:input-values</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:weights</xsl:attribute>
               <xsl:attribute name="select">$djb:weights</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}focus" select="5"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}window-size"
                          select="$djb:window-size"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}input-values"
                          select="$djb:input-values"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}weights"
                          select="$djb:weights"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}focus, $Q{http://www.obdurodon.org/function-variables}window-size, $Q{http://www.obdurodon.org/function-variables}input-values, $Q{http://www.obdurodon.org/function-variables}weights]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:weighted-average')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5-scenario1-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
            <xsl:with-param name="djb:input-values" select="$djb:input-values"/>
            <xsl:with-param name="djb:weights" select="$djb:weights"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5-scenario1-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:param name="djb:input-values" required="yes"/>
      <xsl:param name="djb:weights" required="yes"/>
      <xsl:message>Weighted values as xs:double</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e88"
                    select="4.026481333610668"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e88, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario5-scenario1-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Weighted values as xs:double</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e88"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5-scenario2">
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:param name="djb:input-values" required="yes"/>
      <xsl:param name="djb:weights" required="yes"/>
      <xsl:message>..in middle of sequence</xsl:message>
      <x:scenario id="scenario5-scenario2"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>in middle of sequence</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:focus</xsl:attribute>
               <xsl:attribute name="select">3</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:window-size</xsl:attribute>
               <xsl:attribute name="select">$djb:window-size</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:input-values</xsl:attribute>
               <xsl:attribute name="select">$djb:input-values</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:weights</xsl:attribute>
               <xsl:attribute name="select">$djb:weights</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}focus" select="3"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}window-size"
                          select="$djb:window-size"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}input-values"
                          select="$djb:input-values"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}weights"
                          select="$djb:weights"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}focus, $Q{http://www.obdurodon.org/function-variables}window-size, $Q{http://www.obdurodon.org/function-variables}input-values, $Q{http://www.obdurodon.org/function-variables}weights]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:weighted-average')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5-scenario2-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="djb:window-size" select="$djb:window-size"/>
            <xsl:with-param name="djb:input-values" select="$djb:input-values"/>
            <xsl:with-param name="djb:weights" select="$djb:weights"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5-scenario2-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:window-size" required="yes"/>
      <xsl:param name="djb:input-values" required="yes"/>
      <xsl:param name="djb:weights" required="yes"/>
      <xsl:message>Weighted values as xs:double</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e95"
                    select="2.9999999999999996"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e95, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario5-scenario2-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Weighted values as xs:double</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e95"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario6">
      <xsl:message>Scenario for testing function gaussian</xsl:message>
      <x:scenario id="scenario6" xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>Scenario for testing function gaussian</x:label>
         <x:call>
            <xsl:attribute name="function">djb:gaussian</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">f:x</xsl:attribute>
               <xsl:attribute name="select">5</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:peak</xsl:attribute>
               <xsl:attribute name="select">1</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:mean</xsl:attribute>
               <xsl:attribute name="select">1</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:stddev</xsl:attribute>
               <xsl:attribute name="select">5</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}x" select="5"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}peak" select="1"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}mean" select="1"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}stddev" select="5"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}x, $Q{http://www.obdurodon.org/function-variables}peak, $Q{http://www.obdurodon.org/function-variables}mean, $Q{http://www.obdurodon.org/function-variables}stddev]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:gaussian')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario6-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario6-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>Gaussian value for input with parameters</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e102"
                    select="0.7261490370736909"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e102, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario6-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Gaussian value for input with parameters</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e102"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7">
      <xsl:message>Scenarios for testing function round-to-odd</xsl:message>
      <x:scenario id="scenario7" xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>Scenarios for testing function round-to-odd</x:label>
         <x:call>
            <xsl:attribute name="function">djb:round-to-odd</xsl:attribute>
         </x:call>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7-scenario1"/>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7-scenario2"/>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7-scenario1">
      <xsl:message>..with odd value</xsl:message>
      <x:scenario id="scenario7-scenario1"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with odd value</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:attribute name="select">5</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{}input" select="5"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'" select="[$Q{}input]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:round-to-odd')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7-scenario1-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7-scenario1-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>Return unchanged</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e108" select="5"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e108, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario7-scenario1-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Return unchanged</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e108"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7-scenario2">
      <xsl:message>..with even value</xsl:message>
      <x:scenario id="scenario7-scenario2"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with even value</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:attribute name="select">4</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{}input" select="4"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'" select="[$Q{}input]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:round-to-odd')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7-scenario2-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7-scenario2-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>Round up to odd</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e112" select="5"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e112, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario7-scenario2-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Round up to odd</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e112"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario8">
      <xsl:message>Scenario for testing function recenter</xsl:message>
      <x:scenario id="scenario8" xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>Scenario for testing function recenter</x:label>
         <x:call>
            <xsl:attribute name="function">djb:recenter</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">f:input-values</xsl:attribute>
               <xsl:attribute name="select">1, 2, 3, 4, 5</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:new-min</xsl:attribute>
               <xsl:attribute name="select">1</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:new-max</xsl:attribute>
               <xsl:attribute name="select">10</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}input-values"
                          select="1, 2, 3, 4, 5"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}new-min" select="1"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}new-max"
                          select="10"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}input-values, $Q{http://www.obdurodon.org/function-variables}new-min, $Q{http://www.obdurodon.org/function-variables}new-max]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:recenter')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario8-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario8-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>Recenters input range</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e118"
                    select="1, 3.25, 5.5, 7.75, 10"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e118, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario8-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Recenters input range</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e118"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario9">
      <xsl:message>Scenario for testing function expand-to-tenths</xsl:message>
      <x:scenario id="scenario9" xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>Scenario for testing function expand-to-tenths</x:label>
         <x:call>
            <xsl:attribute name="function">djb:expand-to-tenths</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">f:half</xsl:attribute>
               <xsl:attribute name="select">2</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}half" select="2"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}half]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:expand-to-tenths')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario9-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario9-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>-2 to 2 by tenths</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e122"
                    select="-2, -1.9, -1.8, -1.7, -1.6, -1.5, -1.4, -1.3, -1.2, -1.1, -1, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e122, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario9-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>-2 to 2 by tenths</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e122"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10">
      <xsl:message>Scenarios for testing function uniform</xsl:message>
      <x:scenario id="scenario10" xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>Scenarios for testing function uniform</x:label>
         <x:call>
            <xsl:attribute name="function">djb:uniform</xsl:attribute>
         </x:call>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-scenario1"/>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-scenario2"/>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-scenario3"/>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-scenario1">
      <xsl:message>..with uniform true values</xsl:message>
      <x:scenario id="scenario10-scenario1"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with uniform true values</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:seq</xsl:attribute>
               <xsl:attribute name="select">true(), true(), true()</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}seq"
                          select="true(), true(), true()"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}seq]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:uniform')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-scenario1-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-scenario1-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>Uniform true Booleans return true</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e128" select="true()"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e128, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario10-scenario1-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Uniform true Booleans return true</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e128"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-scenario2">
      <xsl:message>..with uniform false values</xsl:message>
      <x:scenario id="scenario10-scenario2"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with uniform false values</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:seq</xsl:attribute>
               <xsl:attribute name="select">false(), false(), false()</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}seq"
                          select="false(), false(), false()"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}seq]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:uniform')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-scenario2-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-scenario2-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>Uniform false Booleans return true</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e132" select="true()"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e132, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario10-scenario2-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Uniform false Booleans return true</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e132"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-scenario3">
      <xsl:message>..with mixed values</xsl:message>
      <x:scenario id="scenario10-scenario3"
                  xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>with mixed values</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:seq</xsl:attribute>
               <xsl:attribute name="select">false(), true(), false()</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}seq"
                          select="false(), true(), false()"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}seq]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:uniform')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-scenario3-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-scenario3-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>Mixed Booleans return false</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e136" select="false()"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e136, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario10-scenario3-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Mixed Booleans return false</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e136"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario11">
      <xsl:message>Scenario for testing function validate-point-regex</xsl:message>
      <x:scenario id="scenario11" xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>Scenario for testing function validate-point-regex</x:label>
         <x:call>
            <xsl:attribute name="function">djb:validate-point-regex</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">f:input-point</xsl:attribute>
               <xsl:attribute name="select">'1,2'</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}input-point"
                          select="'1,2'"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/lib/plot-lib.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map/>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; Q{http://www.jenitennison.com/xslt/unit-test}is-saxon-config() =&gt; not()">
                        <xsl:message terminate="yes">ERROR: $x:saxon-config does not appear to be a Saxon configuration</xsl:message>
                     </xsl:if>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')">
                              <xsl:choose>
                                 <xsl:when test="Q{http://www.jenitennison.com/xslt/xspec}saxon-version() le Q{http://www.jenitennison.com/xslt/xspec}pack-version((9, 9, 1, 6))">
                                    <xsl:apply-templates select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                                                         mode="Q{http://www.jenitennison.com/xslt/unit-test}fixup-saxon-config"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:map-entry>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="'function-params'"
                                 select="[$Q{http://www.obdurodon.org/function-variables}input-point]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:validate-point-regex')"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
         </xsl:call-template>
         <!-- a call instruction for each x:expect element -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario11-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario11-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>Not yet implemented</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e140" select="true()"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e140, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario11-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Not yet implemented</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e140"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>

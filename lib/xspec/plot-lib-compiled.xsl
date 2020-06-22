<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:djb="http://www.obdurodon.org"
                xmlns:f="http://www.obdurodon.org/function-variables"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
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
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1">
      <xsl:message>Scenario for testing function validate-points</xsl:message>
      <x:scenario id="scenario1" xspec="file:/Users/djb/repos/plot/lib/plot-lib.xspec">
         <x:label>Scenario for testing function validate-points</x:label>
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
</xsl:stylesheet>

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
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/djb/repos/plot/smoothing/smoothing.xspec</xsl:variable>
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
         <x:report stylesheet="file:/Users/djb/repos/plot/smoothing/smoothing.xsl"
                   date="{current-dateTime()}"
                   xspec="file:/Users/djb/repos/plot/smoothing/smoothing.xspec">
            <!-- a call instruction for each top-level scenario -->
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1">
      <xsl:message>Scenarios for testing function smoothing</xsl:message>
      <x:scenario id="scenario1"
                  xspec="file:/Users/djb/repos/plot/smoothing/smoothing.xspec">
         <x:label>Scenarios for testing function smoothing</x:label>
         <xsl:variable name="Q{http://www.obdurodon.org}points"
                       as="xs:string+"
                       select="'1,2', '3,4', '5,6', '7,8', '9,10', '11,12', '13,14', '15,17'"/>
         <x:call>
            <xsl:attribute name="function">djb:smoothing</xsl:attribute>
         </x:call>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario1">
            <xsl:with-param name="djb:points" select="$djb:points"/>
         </xsl:call-template>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2">
            <xsl:with-param name="djb:points" select="$djb:points"/>
         </xsl:call-template>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario3">
            <xsl:with-param name="djb:points" select="$djb:points"/>
         </xsl:call-template>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario4">
            <xsl:with-param name="djb:points" select="$djb:points"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario1">
      <xsl:param name="djb:points" required="yes"/>
      <xsl:message>..with user-specified window size</xsl:message>
      <x:scenario id="scenario1-scenario1"
                  xspec="file:/Users/djb/repos/plot/smoothing/smoothing.xspec">
         <x:label>with user-specified window size</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:points</xsl:attribute>
               <xsl:attribute name="select">$djb:points</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:window</xsl:attribute>
               <xsl:attribute name="select">5</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}points"
                          select="$djb:points"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}window" select="5"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/smoothing/smoothing.xsl</xsl:map-entry>
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
                                 select="[$Q{http://www.obdurodon.org/function-variables}points, $Q{http://www.obdurodon.org/function-variables}window]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:smoothing')"/>
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
            <xsl:with-param name="djb:points" select="$djb:points"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario1-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:points" required="yes"/>
      <xsl:message>Returns adjusted points, rectangular kernel</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e9"
                    select="'1,5', '3,5', '5,6', '7,8', '9,10', '11,12.2', '13,11.166666666666666', '15,11.166666666666666'"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e9, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario1-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Returns adjusted points, rectangular kernel</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e9"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2">
      <xsl:param name="djb:points" required="yes"/>
      <xsl:message>..with default window size</xsl:message>
      <x:scenario id="scenario1-scenario2"
                  xspec="file:/Users/djb/repos/plot/smoothing/smoothing.xspec">
         <x:label>with default window size</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:points</xsl:attribute>
               <xsl:attribute name="select">$djb:points</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}points"
                          select="$djb:points"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/smoothing/smoothing.xsl</xsl:map-entry>
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
                                 select="[$Q{http://www.obdurodon.org/function-variables}points]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:smoothing')"/>
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
            <xsl:with-param name="djb:points" select="$djb:points"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:points" required="yes"/>
      <xsl:message>Returns adjusted points, rectangular kernel</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e13"
                    select="'1,3', '3,4', '5,6', '7,8', '9,10', '11,12', '13,14.333333333333334', '15,13.25'"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e13, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario2-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Returns adjusted points, rectangular kernel</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e13"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario3">
      <xsl:param name="djb:points" required="yes"/>
      <xsl:message>..with (invalid) even window size</xsl:message>
      <x:scenario id="scenario1-scenario3"
                  xspec="file:/Users/djb/repos/plot/smoothing/smoothing.xspec">
         <x:label>with (invalid) even window size</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:points</xsl:attribute>
               <xsl:attribute name="select">$djb:points</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:window</xsl:attribute>
               <xsl:attribute name="select">4</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}points"
                          select="$djb:points"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}window" select="4"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/smoothing/smoothing.xsl</xsl:map-entry>
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
                                 select="[$Q{http://www.obdurodon.org/function-variables}points, $Q{http://www.obdurodon.org/function-variables}window]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:smoothing')"/>
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
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario3-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="djb:points" select="$djb:points"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario3-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:points" required="yes"/>
      <xsl:message>err:description</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e18"
                    select="'Invalid window size (4); must be odd'"/>
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
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e18, $Q{urn:x-xspec:compile:impl}test-result, '')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario3-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>err:description</x:label>
         <xsl:if test="not($Q{urn:x-xspec:compile:impl}boolean-test)">
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
               <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}test-result"/>
               <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:result</xsl:with-param>
            </xsl:call-template>
         </xsl:if>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e18"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?">
               <xsl:attribute name="test">$x:result?err?description</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario4">
      <xsl:param name="djb:points" required="yes"/>
      <xsl:message>..with (invalid) points</xsl:message>
      <x:scenario id="scenario1-scenario4"
                  xspec="file:/Users/djb/repos/plot/smoothing/smoothing.xspec">
         <x:label>with (invalid) points</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:points</xsl:attribute>
               <xsl:attribute name="select">'1, 2', '3,4', '5,6', '7,8', '9,10'</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:window</xsl:attribute>
               <xsl:attribute name="select">3</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}points"
                          select="'1, 2', '3,4', '5,6', '7,8', '9,10'"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}window" select="3"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/smoothing/smoothing.xsl</xsl:map-entry>
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
                                 select="[$Q{http://www.obdurodon.org/function-variables}points, $Q{http://www.obdurodon.org/function-variables}window]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:smoothing')"/>
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
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario4-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="djb:points" select="$djb:points"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario4-expect1">
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:param name="djb:points" required="yes"/>
      <xsl:message>err:description</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e23"
                    select="'Invalid point values: &#34;1, 2&#34;, &#34;3,4&#34;, &#34;5,6&#34;, &#34;7,8&#34;, &#34;9,10&#34;'"/>
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
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e23, $Q{urn:x-xspec:compile:impl}test-result, '')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario4-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>err:description</x:label>
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
               <xsl:attribute name="test">$x:result?err?description</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>

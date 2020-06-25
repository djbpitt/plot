<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:djb="http://www.obdurodon.org"
                xmlns:f="http://www.obdurodon.org/function-variables"
                xmlns:svg="http://www.w3.org/2000/svg"
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
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/djb/repos/plot/spline/spline.xspec</xsl:variable>
   <xsl:variable name="Q{http://www.obdurodon.org}points"
                 as="xs:string+"
                 select="for-each-pair(         (50, 100, 150, 200, 250, 300, 350, 400, 450),          (182, 166, 87, 191, 106, 73, 60, 186, 118),         function ($a, $b) {string-join(($a,$b), ',')}         )"/>
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
         <x:report stylesheet="file:/Users/djb/repos/plot/spline/spline.xsl"
                   date="{current-dateTime()}"
                   xspec="file:/Users/djb/repos/plot/spline/spline.xspec">
            <!-- a call instruction for each top-level scenario -->
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1">
      <xsl:message>Scenarios for testing function spline</xsl:message>
      <x:scenario id="scenario1" xspec="file:/Users/djb/repos/plot/spline/spline.xspec">
         <x:label>Scenarios for testing function spline</x:label>
         <x:call>
            <xsl:attribute name="function">djb:spline</xsl:attribute>
         </x:call>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario1"/>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2"/>
      </x:scenario>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario1">
      <xsl:message>..with 0.3 scaling</xsl:message>
      <x:scenario id="scenario1-scenario1"
                  xspec="file:/Users/djb/repos/plot/spline/spline.xspec">
         <x:label>with 0.3 scaling</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:point-pairs</xsl:attribute>
               <xsl:attribute name="select">$djb:points</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:scaling</xsl:attribute>
               <xsl:attribute name="select">0.3</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:debug</xsl:attribute>
               <xsl:attribute name="select">false()</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}point-pairs"
                          select="$djb:points"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}scaling"
                          select="0.3"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}debug"
                          select="false()"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/spline/spline.xsl</xsl:map-entry>
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
                                 select="[$Q{http://www.obdurodon.org/function-variables}point-pairs, $Q{http://www.obdurodon.org/function-variables}scaling, $Q{http://www.obdurodon.org/function-variables}debug]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:spline')"/>
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
      <xsl:message>Should return SVG &lt;g&gt; element</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e11-doc" as="document-node()">
         <xsl:document>
            <g xmlns="http://www.w3.org/2000/svg">
               <path>
                  <xsl:attribute name="d"
                                 select="'', ''"
                                 separator="M50,182 Q89.21214815315199,176.24845925450563 100,166 C119.21214815315197,147.74845925450563 136.57273000171787,83.64318250042948 150,87 C166.57273000171787,91.14318250042948 183.8239197596287,187.92654475432946 200,191 C213.8239197596287,193.62654475432944 231.33740978515215,128.02185645352048 250,106 C261.33740978515215,92.62185645352048 283.891388635211,80.40996122780294 300,73 C313.891388635211,66.60996122780294 341.72168003956693,50.64549844471065 350,60 C371.72168003956693,84.54549844471065 381.5116016727397,175.27672897018903 400,186 Q411.5116016727397,192.676728970189 450,118"/>
                  <xsl:attribute name="class" select="'', ''" separator="spline"/>
                  <xsl:attribute name="fill" select="'', ''" separator="none"/>
               </path>
            </g>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e11"
                    select="$Q{urn:x-xspec:compile:impl}expect-d7e11-doc ! ( node() )"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e11, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario1-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Should return SVG &lt;g&gt; element</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e11"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2">
      <xsl:message>..with debugging output</xsl:message>
      <x:scenario id="scenario1-scenario2"
                  xspec="file:/Users/djb/repos/plot/spline/spline.xspec">
         <x:label>with debugging output</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">f:point-pairs</xsl:attribute>
               <xsl:attribute name="select">$djb:points</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:scaling</xsl:attribute>
               <xsl:attribute name="select">0.3</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">f:debug</xsl:attribute>
               <xsl:attribute name="select">true()</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}point-pairs"
                          select="$djb:points"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}scaling"
                          select="0.3"/>
            <xsl:variable name="Q{http://www.obdurodon.org/function-variables}debug"
                          select="true()"/>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'cache'" select="false()"/>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/djb/repos/plot/spline/spline.xsl</xsl:map-entry>
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
                                 select="[$Q{http://www.obdurodon.org/function-variables}point-pairs, $Q{http://www.obdurodon.org/function-variables}scaling, $Q{http://www.obdurodon.org/function-variables}debug]"/>
                  <xsl:map-entry key="'initial-function'"
                                 select="QName('http://www.obdurodon.org', 'djb:spline')"/>
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
      <xsl:message>Should return debugging information</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e19-doc" as="document-node()">
         <xsl:document>
            <g xmlns="http://www.w3.org/2000/svg">
               <style>
                  <xsl:attribute name="type" select="'', ''" separator="text/css"/>
                  <xsl:text>
            .backgroundColor {
                fill: papayawhip;
            }
            .mainLine {
                fill: none;
                stroke: silver;
                stroke-width: 1;
            }
            .mainCircle {
                fill: silver;
            }
            .alternatingLine {
                fill: none;
                stroke: lightblue;
                stroke-width: 1;
                stroke-dasharray: 3 3;
            }
            .anchorLine {
                stroke: magenta;
                stroke-width: 1;
            }
            .anchorCircle1 {
                stroke: mediumseagreen;
                stroke-width: 1;
                fill: papayawhip;
            }
            .anchorCircle2 {
                stroke: red;
                stroke-width: 1;
                fill: papayawhip;
            }</xsl:text>
               </style>
               <rect>
                  <xsl:attribute name="x" select="'', ''" separator="0"/>
                  <xsl:attribute name="y" select="'', ''" separator="0"/>
                  <xsl:attribute name="height" select="'', ''" separator="300"/>
                  <xsl:attribute name="stroke" select="'', ''" separator="black"/>
                  <xsl:attribute name="class" select="'', ''" separator="backgroundColor"/>
                  <xsl:attribute name="width" select="'', ''" separator="500"/>
                  <xsl:attribute name="stroke-width" select="'', ''" separator="1"/>
               </rect>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="mainCircle"/>
                  <xsl:attribute name="cx" select="'', ''" separator="50"/>
                  <xsl:attribute name="cy" select="'', ''" separator="182"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="mainCircle"/>
                  <xsl:attribute name="cx" select="'', ''" separator="100"/>
                  <xsl:attribute name="cy" select="'', ''" separator="166"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="mainCircle"/>
                  <xsl:attribute name="cx" select="'', ''" separator="150"/>
                  <xsl:attribute name="cy" select="'', ''" separator="87"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="mainCircle"/>
                  <xsl:attribute name="cx" select="'', ''" separator="200"/>
                  <xsl:attribute name="cy" select="'', ''" separator="191"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="mainCircle"/>
                  <xsl:attribute name="cx" select="'', ''" separator="250"/>
                  <xsl:attribute name="cy" select="'', ''" separator="106"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="mainCircle"/>
                  <xsl:attribute name="cx" select="'', ''" separator="300"/>
                  <xsl:attribute name="cy" select="'', ''" separator="73"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="mainCircle"/>
                  <xsl:attribute name="cx" select="'', ''" separator="350"/>
                  <xsl:attribute name="cy" select="'', ''" separator="60"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="mainCircle"/>
                  <xsl:attribute name="cx" select="'', ''" separator="400"/>
                  <xsl:attribute name="cy" select="'', ''" separator="186"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="mainCircle"/>
                  <xsl:attribute name="cx" select="'', ''" separator="450"/>
                  <xsl:attribute name="cy" select="'', ''" separator="118"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <polyline>
                  <xsl:attribute name="class" select="'', ''" separator="mainLine"/>
                  <xsl:attribute name="points"
                                 select="'', ''"
                                 separator="50,182 100,166 150,87 200,191 250,106 300,73 350,60 400,186 450,118"/>
               </polyline>
               <polyline>
                  <xsl:attribute name="class" select="'', ''" separator="alternatingLine"/>
                  <xsl:attribute name="points"
                                 select="'', ''"
                                 separator="100,166 200,191 300,73 400,186"/>
               </polyline>
               <polyline>
                  <xsl:attribute name="class" select="'', ''" separator="alternatingLine"/>
                  <xsl:attribute name="points"
                                 select="'', ''"
                                 separator="50,182 150,87 250,106 350,60 450,118"/>
               </polyline>
               <line>
                  <xsl:attribute name="class" select="'', ''" separator="anchorLine"/>
                  <xsl:attribute name="x1" select="'', ''" separator="89.21214815315199"/>
                  <xsl:attribute name="y1" select="'', ''" separator="176.24845925450563"/>
                  <xsl:attribute name="x2" select="'', ''" separator="119.21214815315197"/>
                  <xsl:attribute name="y2" select="'', ''" separator="147.74845925450563"/>
               </line>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle1"/>
                  <xsl:attribute name="cx" select="'', ''" separator="89.21214815315199"/>
                  <xsl:attribute name="cy" select="'', ''" separator="176.24845925450563"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle2"/>
                  <xsl:attribute name="cx" select="'', ''" separator="119.21214815315197"/>
                  <xsl:attribute name="cy" select="'', ''" separator="147.74845925450563"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <line>
                  <xsl:attribute name="class" select="'', ''" separator="anchorLine"/>
                  <xsl:attribute name="x1" select="'', ''" separator="136.57273000171787"/>
                  <xsl:attribute name="y1" select="'', ''" separator="83.64318250042948"/>
                  <xsl:attribute name="x2" select="'', ''" separator="166.57273000171787"/>
                  <xsl:attribute name="y2" select="'', ''" separator="91.14318250042948"/>
               </line>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle1"/>
                  <xsl:attribute name="cx" select="'', ''" separator="136.57273000171787"/>
                  <xsl:attribute name="cy" select="'', ''" separator="83.64318250042948"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle2"/>
                  <xsl:attribute name="cx" select="'', ''" separator="166.57273000171787"/>
                  <xsl:attribute name="cy" select="'', ''" separator="91.14318250042948"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <line>
                  <xsl:attribute name="class" select="'', ''" separator="anchorLine"/>
                  <xsl:attribute name="x1" select="'', ''" separator="183.8239197596287"/>
                  <xsl:attribute name="y1" select="'', ''" separator="187.92654475432946"/>
                  <xsl:attribute name="x2" select="'', ''" separator="213.8239197596287"/>
                  <xsl:attribute name="y2" select="'', ''" separator="193.62654475432944"/>
               </line>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle1"/>
                  <xsl:attribute name="cx" select="'', ''" separator="183.8239197596287"/>
                  <xsl:attribute name="cy" select="'', ''" separator="187.92654475432946"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle2"/>
                  <xsl:attribute name="cx" select="'', ''" separator="213.8239197596287"/>
                  <xsl:attribute name="cy" select="'', ''" separator="193.62654475432944"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <line>
                  <xsl:attribute name="class" select="'', ''" separator="anchorLine"/>
                  <xsl:attribute name="x1" select="'', ''" separator="231.33740978515215"/>
                  <xsl:attribute name="y1" select="'', ''" separator="128.02185645352048"/>
                  <xsl:attribute name="x2" select="'', ''" separator="261.33740978515215"/>
                  <xsl:attribute name="y2" select="'', ''" separator="92.62185645352048"/>
               </line>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle1"/>
                  <xsl:attribute name="cx" select="'', ''" separator="231.33740978515215"/>
                  <xsl:attribute name="cy" select="'', ''" separator="128.02185645352048"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle2"/>
                  <xsl:attribute name="cx" select="'', ''" separator="261.33740978515215"/>
                  <xsl:attribute name="cy" select="'', ''" separator="92.62185645352048"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <line>
                  <xsl:attribute name="class" select="'', ''" separator="anchorLine"/>
                  <xsl:attribute name="x1" select="'', ''" separator="283.891388635211"/>
                  <xsl:attribute name="y1" select="'', ''" separator="80.40996122780294"/>
                  <xsl:attribute name="x2" select="'', ''" separator="313.891388635211"/>
                  <xsl:attribute name="y2" select="'', ''" separator="66.60996122780294"/>
               </line>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle1"/>
                  <xsl:attribute name="cx" select="'', ''" separator="283.891388635211"/>
                  <xsl:attribute name="cy" select="'', ''" separator="80.40996122780294"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle2"/>
                  <xsl:attribute name="cx" select="'', ''" separator="313.891388635211"/>
                  <xsl:attribute name="cy" select="'', ''" separator="66.60996122780294"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <line>
                  <xsl:attribute name="class" select="'', ''" separator="anchorLine"/>
                  <xsl:attribute name="x1" select="'', ''" separator="341.72168003956693"/>
                  <xsl:attribute name="y1" select="'', ''" separator="50.64549844471065"/>
                  <xsl:attribute name="x2" select="'', ''" separator="371.72168003956693"/>
                  <xsl:attribute name="y2" select="'', ''" separator="84.54549844471065"/>
               </line>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle1"/>
                  <xsl:attribute name="cx" select="'', ''" separator="341.72168003956693"/>
                  <xsl:attribute name="cy" select="'', ''" separator="50.64549844471065"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle2"/>
                  <xsl:attribute name="cx" select="'', ''" separator="371.72168003956693"/>
                  <xsl:attribute name="cy" select="'', ''" separator="84.54549844471065"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <line>
                  <xsl:attribute name="class" select="'', ''" separator="anchorLine"/>
                  <xsl:attribute name="x1" select="'', ''" separator="381.5116016727397"/>
                  <xsl:attribute name="y1" select="'', ''" separator="175.27672897018903"/>
                  <xsl:attribute name="x2" select="'', ''" separator="411.5116016727397"/>
                  <xsl:attribute name="y2" select="'', ''" separator="192.676728970189"/>
               </line>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle1"/>
                  <xsl:attribute name="cx" select="'', ''" separator="381.5116016727397"/>
                  <xsl:attribute name="cy" select="'', ''" separator="175.27672897018903"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <circle>
                  <xsl:attribute name="class" select="'', ''" separator="anchorCircle2"/>
                  <xsl:attribute name="cx" select="'', ''" separator="411.5116016727397"/>
                  <xsl:attribute name="cy" select="'', ''" separator="192.676728970189"/>
                  <xsl:attribute name="r" select="'', ''" separator="2"/>
               </circle>
               <path>
                  <xsl:attribute name="d"
                                 select="'', ''"
                                 separator="M50,182 Q89.21214815315199,176.24845925450563 100,166 C119.21214815315197,147.74845925450563 136.57273000171787,83.64318250042948 150,87 C166.57273000171787,91.14318250042948 183.8239197596287,187.92654475432946 200,191 C213.8239197596287,193.62654475432944 231.33740978515215,128.02185645352048 250,106 C261.33740978515215,92.62185645352048 283.891388635211,80.40996122780294 300,73 C313.891388635211,66.60996122780294 341.72168003956693,50.64549844471065 350,60 C371.72168003956693,84.54549844471065 381.5116016727397,175.27672897018903 400,186 Q411.5116016727397,192.676728970189 450,118"/>
                  <xsl:attribute name="class" select="'', ''" separator="spline"/>
                  <xsl:attribute name="fill" select="'', ''" separator="none"/>
               </path>
            </g>
            <html xmlns="http://www.w3.org/1999/xhtml">
               <head>
                  <title>
                     <xsl:text>Diagnostics</xsl:text>
                  </title>
                  <style>
                     <xsl:attribute name="type" select="'', ''" separator="text/css"/>
                     <xsl:text>
                    table, tr, th, td { 
                        border: 1px black solid;
                    } 
                    table { 
                        border-collapse: collapse;
                    } 
                    tr:nth-child(even) { 
                        background-color: lightgray;
                    }
                    th, td {
                        padding: 4px; 
                    }</xsl:text>
                  </style>
               </head>
               <body>
                  <table>
                     <xsl:attribute name="style" select="'', ''" separator="text-align: right;"/>
                     <tr>
                        <xsl:attribute name="style" select="'', ''" separator="text-align: center;"/>
                        <th>
                           <xsl:text>#</xsl:text>
                        </th>
                        <th>
                           <xsl:text>dirX</xsl:text>
                        </th>
                        <th>
                           <xsl:text>dirY</xsl:text>
                        </th>
                        <th>
                           <xsl:text>joining</xsl:text>
                           <br/>
                           <xsl:text>length</xsl:text>
                        </th>
                        <th>
                           <xsl:text>unitX</xsl:text>
                        </th>
                        <th>
                           <xsl:text>unitY</xsl:text>
                        </th>
                        <th>
                           <xsl:text>normal1</xsl:text>
                        </th>
                        <th>
                           <xsl:text>normal2</xsl:text>
                        </th>
                        <th>
                           <xsl:text>angle1</xsl:text>
                        </th>
                        <th>
                           <xsl:text>angle2</xsl:text>
                        </th>
                        <th>
                           <xsl:text>anchor1X</xsl:text>
                        </th>
                        <th>
                           <xsl:text>anchor1Y</xsl:text>
                        </th>
                        <th>
                           <xsl:text>anchor2X</xsl:text>
                        </th>
                        <th>
                           <xsl:text>anchor2Y</xsl:text>
                        </th>
                        <th>
                           <xsl:text>scaling</xsl:text>
                           <br/>
                           <xsl:text>(constant)</xsl:text>
                        </th>
                        <th>
                           <xsl:text>total anchor</xsl:text>
                           <br/>
                           <xsl:text>length</xsl:text>
                        </th>
                        <th>
                           <xsl:text>anchorLength1</xsl:text>
                           <br/>
                           <xsl:text>(in)</xsl:text>
                        </th>
                        <th>
                           <xsl:text>anchorLength2</xsl:text>
                           <br/>
                           <xsl:text>(out)</xsl:text>
                        </th>
                     </tr>
                     <tr>
                        <td>
                           <xsl:text>1</xsl:text>
                        </td>
                        <td>
                           <xsl:text>100</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-95</xsl:text>
                        </td>
                        <td>
                           <xsl:text>137.93</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.72</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-0.69</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.69, 0.72</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-0.69, -0.72</xsl:text>
                        </td>
                        <td>
                           <xsl:text>2.38</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-0.76</xsl:text>
                        </td>
                        <td>
                           <xsl:text>89.21</xsl:text>
                        </td>
                        <td>
                           <xsl:text>176.25</xsl:text>
                        </td>
                        <td>
                           <xsl:text>119.21</xsl:text>
                        </td>
                        <td>
                           <xsl:text>147.75</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.3</xsl:text>
                        </td>
                        <td>
                           <xsl:text>41.38</xsl:text>
                        </td>
                        <td>
                           <xsl:text>14.88</xsl:text>
                        </td>
                        <td>
                           <xsl:text>26.50</xsl:text>
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <xsl:text>2</xsl:text>
                        </td>
                        <td>
                           <xsl:text>100</xsl:text>
                        </td>
                        <td>
                           <xsl:text>25</xsl:text>
                        </td>
                        <td>
                           <xsl:text>103.08</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.97</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.24</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-0.24, 0.97</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.24, -0.97</xsl:text>
                        </td>
                        <td>
                           <xsl:text>3.39</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.24</xsl:text>
                        </td>
                        <td>
                           <xsl:text>136.57</xsl:text>
                        </td>
                        <td>
                           <xsl:text>83.64</xsl:text>
                        </td>
                        <td>
                           <xsl:text>166.57</xsl:text>
                        </td>
                        <td>
                           <xsl:text>91.14</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.3</xsl:text>
                        </td>
                        <td>
                           <xsl:text>30.92</xsl:text>
                        </td>
                        <td>
                           <xsl:text>13.84</xsl:text>
                        </td>
                        <td>
                           <xsl:text>17.08</xsl:text>
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <xsl:text>3</xsl:text>
                        </td>
                        <td>
                           <xsl:text>100</xsl:text>
                        </td>
                        <td>
                           <xsl:text>19</xsl:text>
                        </td>
                        <td>
                           <xsl:text>101.79</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.98</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.19</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-0.19, 0.98</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.19, -0.98</xsl:text>
                        </td>
                        <td>
                           <xsl:text>3.33</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.19</xsl:text>
                        </td>
                        <td>
                           <xsl:text>183.82</xsl:text>
                        </td>
                        <td>
                           <xsl:text>187.93</xsl:text>
                        </td>
                        <td>
                           <xsl:text>213.82</xsl:text>
                        </td>
                        <td>
                           <xsl:text>193.63</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.3</xsl:text>
                        </td>
                        <td>
                           <xsl:text>30.54</xsl:text>
                        </td>
                        <td>
                           <xsl:text>16.47</xsl:text>
                        </td>
                        <td>
                           <xsl:text>14.07</xsl:text>
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <xsl:text>4</xsl:text>
                        </td>
                        <td>
                           <xsl:text>100</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-118</xsl:text>
                        </td>
                        <td>
                           <xsl:text>154.67</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.65</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-0.76</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.76, 0.65</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-0.76, -0.65</xsl:text>
                        </td>
                        <td>
                           <xsl:text>2.27</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-0.87</xsl:text>
                        </td>
                        <td>
                           <xsl:text>231.34</xsl:text>
                        </td>
                        <td>
                           <xsl:text>128.02</xsl:text>
                        </td>
                        <td>
                           <xsl:text>261.34</xsl:text>
                        </td>
                        <td>
                           <xsl:text>92.62</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.3</xsl:text>
                        </td>
                        <td>
                           <xsl:text>46.40</xsl:text>
                        </td>
                        <td>
                           <xsl:text>28.87</xsl:text>
                        </td>
                        <td>
                           <xsl:text>17.54</xsl:text>
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <xsl:text>5</xsl:text>
                        </td>
                        <td>
                           <xsl:text>100</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-46</xsl:text>
                        </td>
                        <td>
                           <xsl:text>110.07</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.91</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-0.42</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.42, 0.91</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-0.42, -0.91</xsl:text>
                        </td>
                        <td>
                           <xsl:text>2.71</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-0.43</xsl:text>
                        </td>
                        <td>
                           <xsl:text>283.89</xsl:text>
                        </td>
                        <td>
                           <xsl:text>80.41</xsl:text>
                        </td>
                        <td>
                           <xsl:text>313.89</xsl:text>
                        </td>
                        <td>
                           <xsl:text>66.61</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.3</xsl:text>
                        </td>
                        <td>
                           <xsl:text>33.02</xsl:text>
                        </td>
                        <td>
                           <xsl:text>17.73</xsl:text>
                        </td>
                        <td>
                           <xsl:text>15.29</xsl:text>
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <xsl:text>6</xsl:text>
                        </td>
                        <td>
                           <xsl:text>100</xsl:text>
                        </td>
                        <td>
                           <xsl:text>113</xsl:text>
                        </td>
                        <td>
                           <xsl:text>150.89</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.66</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.75</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-0.75, 0.66</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.75, -0.66</xsl:text>
                        </td>
                        <td>
                           <xsl:text>3.99</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.85</xsl:text>
                        </td>
                        <td>
                           <xsl:text>341.72</xsl:text>
                        </td>
                        <td>
                           <xsl:text>50.65</xsl:text>
                        </td>
                        <td>
                           <xsl:text>371.72</xsl:text>
                        </td>
                        <td>
                           <xsl:text>84.55</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.3</xsl:text>
                        </td>
                        <td>
                           <xsl:text>45.27</xsl:text>
                        </td>
                        <td>
                           <xsl:text>12.49</xsl:text>
                        </td>
                        <td>
                           <xsl:text>32.78</xsl:text>
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <xsl:text>7</xsl:text>
                        </td>
                        <td>
                           <xsl:text>100</xsl:text>
                        </td>
                        <td>
                           <xsl:text>58</xsl:text>
                        </td>
                        <td>
                           <xsl:text>115.60</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.87</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.50</xsl:text>
                        </td>
                        <td>
                           <xsl:text>-0.50, 0.87</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.50, -0.87</xsl:text>
                        </td>
                        <td>
                           <xsl:text>3.67</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.53</xsl:text>
                        </td>
                        <td>
                           <xsl:text>381.51</xsl:text>
                        </td>
                        <td>
                           <xsl:text>175.28</xsl:text>
                        </td>
                        <td>
                           <xsl:text>411.51</xsl:text>
                        </td>
                        <td>
                           <xsl:text>192.68</xsl:text>
                        </td>
                        <td>
                           <xsl:text>0.3</xsl:text>
                        </td>
                        <td>
                           <xsl:text>34.68</xsl:text>
                        </td>
                        <td>
                           <xsl:text>21.37</xsl:text>
                        </td>
                        <td>
                           <xsl:text>13.31</xsl:text>
                        </td>
                     </tr>
                  </table>
               </body>
            </html>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d7e19"
                    select="$Q{urn:x-xspec:compile:impl}expect-d7e19-doc ! ( node() )"/>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{http://www.jenitennison.com/xslt/unit-test}deep-equal($Q{urn:x-xspec:compile:impl}expect-d7e19, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario2-expect1"
              successful="{$Q{urn:x-xspec:compile:impl}successful}">
         <x:label>Should return debugging information</x:label>
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/unit-test}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d7e19"/>
            <xsl:with-param name="wrapper-name" as="Q{http://www.w3.org/2001/XMLSchema}string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>

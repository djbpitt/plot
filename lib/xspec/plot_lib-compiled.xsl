<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:djb="http://www.obdurodon.org"
                xmlns:impl="urn:x-xspec:compile:xslt:impl"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                exclude-result-prefixes="impl">
   <xsl:import href="file:/Users/djb/repos/plot/lib/plot_testable.xsl"/>
   <xsl:import href="file:/Users/djb/repos/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:include href="file:/Users/djb/repos/xspec/src/common/xspec-utils.xsl"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:variable name="x:xspec-uri" as="xs:anyURI">file:/Users/djb/repos/plot/lib/plot_lib.xspec</xsl:variable>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <x:report stylesheet="file:/Users/djb/repos/plot/lib/plot_testable.xsl"
                   date="{current-dateTime()}"
                   xspec="file:/Users/djb/repos/plot/lib/plot_lib.xspec">
            <xsl:call-template name="x:scenario1"/>
            <xsl:call-template name="x:scenario2"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:scenario1">
      <xsl:message>Scenario for testing function validate_points</xsl:message>
      <x:scenario id="scenario1" xspec="file:/Users/djb/repos/plot/lib/plot_lib.xspec">
         <x:label>Scenario for testing function validate_points</x:label>
         <x:call>
            <xsl:attribute name="function">djb:validate_points</xsl:attribute>
         </x:call>
         <xsl:call-template name="x:scenario1-scenario1"/>
         <xsl:call-template name="x:scenario1-scenario2"/>
         <xsl:call-template name="x:scenario1-scenario3"/>
         <xsl:call-template name="x:scenario1-scenario4"/>
         <xsl:call-template name="x:scenario1-scenario5"/>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario1-scenario1">
      <xsl:message>..Point coordinates (X and Y) are doubles: good input</xsl:message>
      <x:scenario id="scenario1-scenario1"
                  xspec="file:/Users/djb/repos/plot/lib/plot_lib.xspec">
         <x:label>Point coordinates (X and Y) are doubles: good input</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">split_points</xsl:attribute>
               <xsl:attribute name="select">(                     '50,182',                      '100.0,166.0',                      '150.0,.87',                      '.200,191',                      '-250,-.106',                      '300,73',                      '350,60',                      '400,186',                      '450,118'                     )</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="split_points"
                          select="(                     '50,182',                      '100.0,166.0',                      '150.0,.87',                      '.200,191',                      '-250,-.106',                      '300,73',                      '350,60',                      '400,186',                      '450,118'                     )"/>
            <xsl:sequence select="djb:validate_points($split_points)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario1-scenario1-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario1-scenario1-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Succeed if all X and Y match a regex for doubles</xsl:message>
      <xsl:variable name="impl:expect-d7e10" select="xs:boolean('true')"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e10, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario1-expect1" successful="{$impl:successful}">
         <x:label>Succeed if all X and Y match a regex for doubles</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e10"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario1-scenario2">
      <xsl:message>..Point coordinates (X and Y) are doubles: string</xsl:message>
      <x:scenario id="scenario1-scenario2"
                  xspec="file:/Users/djb/repos/plot/lib/plot_lib.xspec">
         <x:label>Point coordinates (X and Y) are doubles: string</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">split_points</xsl:attribute>
               <xsl:attribute name="select">(                     '50,182',                      '100.0,166.0',                      '150.0,.87',                      '.200,191',                      '-250,-.106',                      '300,73',                      '350,x',                      '400,186',                      '450,118'                     )</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="split_points"
                          select="(                     '50,182',                      '100.0,166.0',                      '150.0,.87',                      '.200,191',                      '-250,-.106',                      '300,73',                      '350,x',                      '400,186',                      '450,118'                     )"/>
            <xsl:sequence select="djb:validate_points($split_points)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario1-scenario2-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario1-scenario2-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Fail if any X or Y contains an alphabetic</xsl:message>
      <xsl:variable name="impl:expect-d7e14" select="xs:boolean('false')"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e14, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario2-expect1" successful="{$impl:successful}">
         <x:label>Fail if any X or Y contains an alphabetic</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e14"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario1-scenario3">
      <xsl:message>..Point coordinates (X and Y) are doubles: dot, but no digits</xsl:message>
      <x:scenario id="scenario1-scenario3"
                  xspec="file:/Users/djb/repos/plot/lib/plot_lib.xspec">
         <x:label>Point coordinates (X and Y) are doubles: dot, but no digits</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">split_points</xsl:attribute>
               <xsl:attribute name="select">(                     '50,182',                      '.,166.0',                      '150.0,.87',                      '.200,191',                      '-250,-.106',                      '300,73',                      '350,60',                      '400,186',                      '450,118'                     )</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="split_points"
                          select="(                     '50,182',                      '.,166.0',                      '150.0,.87',                      '.200,191',                      '-250,-.106',                      '300,73',                      '350,60',                      '400,186',                      '450,118'                     )"/>
            <xsl:sequence select="djb:validate_points($split_points)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario1-scenario3-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario1-scenario3-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Fail if any X or Y contains a dot but not digits</xsl:message>
      <xsl:variable name="impl:expect-d7e18" select="xs:boolean('false')"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e18, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario3-expect1" successful="{$impl:successful}">
         <x:label>Fail if any X or Y contains a dot but not digits</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e18"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario1-scenario4">
      <xsl:message>..Point coordinates (X and Y) are doubles: missing value</xsl:message>
      <x:scenario id="scenario1-scenario4"
                  xspec="file:/Users/djb/repos/plot/lib/plot_lib.xspec">
         <x:label>Point coordinates (X and Y) are doubles: missing value</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">split_points</xsl:attribute>
               <xsl:attribute name="select">                     '50,182',                      '100.0,166.0',                      '150.0,.87',                      '.200,191',                      '-250,-.106',                      '300,',                      '350,60',                      '400,186',                      '450,118'                                          </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="split_points"
                          select="                     '50,182',                      '100.0,166.0',                      '150.0,.87',                      '.200,191',                      '-250,-.106',                      '300,',                      '350,60',                      '400,186',                      '450,118'                                          "/>
            <xsl:sequence select="djb:validate_points($split_points)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario1-scenario4-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario1-scenario4-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Fail if any X or Y is missing</xsl:message>
      <xsl:variable name="impl:expect-d7e22" select="false()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e22, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario4-expect1" successful="{$impl:successful}">
         <x:label>Fail if any X or Y is missing</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e22"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario1-scenario5">
      <xsl:message>..Fewer than 3 points</xsl:message>
      <x:scenario id="scenario1-scenario5"
                  xspec="file:/Users/djb/repos/plot/lib/plot_lib.xspec">
         <x:label>Fewer than 3 points</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">split_points</xsl:attribute>
               <xsl:attribute name="select">'1,50 2,100'</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="split_points" select="'1,50 2,100'"/>
            <xsl:sequence select="djb:validate_points($split_points)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario1-scenario5-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario1-scenario5-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Fail if fewer than 3 points</xsl:message>
      <xsl:variable name="impl:expect-d7e26" select="false()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e26, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario5-expect1" successful="{$impl:successful}">
         <x:label>Fail if fewer than 3 points</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e26"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario2">
      <xsl:message>Scenario for testing function split_points</xsl:message>
      <x:scenario id="scenario2" xspec="file:/Users/djb/repos/plot/lib/plot_lib.xspec">
         <x:label>Scenario for testing function split_points</x:label>
         <x:call>
            <xsl:attribute name="function">djb:split_points</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">all_points</xsl:attribute>
               <xsl:attribute name="select">'50,182 100,166 150,87 200,191 250,106 300,73 350,60 400,186 450,118'</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="all_points"
                          select="'50,182 100,166 150,87 200,191 250,106 300,73 350,60 400,186 450,118'"/>
            <xsl:sequence select="djb:split_points($all_points)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario2-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario2-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Tokenize string with all points into pairs of X,Y values</xsl:message>
      <xsl:variable name="impl:expect-d7e33"
                    select="'50,182', '100,166', '150,87', '200,191', '250,106', '300,73', '350,60', '400,186', '450,118'"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e33, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario2-expect1" successful="{$impl:successful}">
         <x:label>Tokenize string with all points into pairs of X,Y values</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e33"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>

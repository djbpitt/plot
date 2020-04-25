<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:djb="http://www.obdurodon.org"
                xmlns:impl="urn:x-xspec:compile:xslt:impl"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                exclude-result-prefixes="impl">
   <xsl:import href="file:/Users/djb/repos/xstuff/bezier/sample-11.xsl"/>
   <xsl:import href="file:/Users/djb/repos/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:include href="file:/Users/djb/repos/xspec/src/common/xspec-utils.xsl"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:variable name="x:xspec-uri" as="xs:anyURI">file:/Users/djb/repos/xstuff/bezier/sample-11.xspec</xsl:variable>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <x:report stylesheet="file:/Users/djb/repos/xstuff/bezier/sample-11.xsl"
                   date="{current-dateTime()}"
                   xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
            <xsl:call-template name="x:scenario1"/>
            <xsl:call-template name="x:scenario2"/>
            <xsl:call-template name="x:scenario3"/>
            <xsl:call-template name="x:scenario4"/>
            <xsl:call-template name="x:scenario5"/>
            <xsl:call-template name="x:scenario6"/>
            <xsl:call-template name="x:scenario7"/>
            <xsl:call-template name="x:scenario8"/>
            <xsl:call-template name="x:scenario9"/>
            <xsl:call-template name="x:scenario10"/>
            <xsl:call-template name="x:scenario11"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:scenario1">
      <xsl:message>Scenario for testing function validate_points</xsl:message>
      <x:scenario id="scenario1"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function validate_points</x:label>
         <x:call>
            <xsl:attribute name="function">djb:validate_points</xsl:attribute>
         </x:call>
         <xsl:call-template name="x:scenario1-scenario1"/>
         <xsl:call-template name="x:scenario1-scenario2"/>
         <xsl:call-template name="x:scenario1-scenario3"/>
         <xsl:call-template name="x:scenario1-scenario4"/>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario1-scenario1">
      <xsl:message>..Point coordinates (X and Y) are doubles: good input</xsl:message>
      <x:scenario id="scenario1-scenario1"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Point coordinates (X and Y) are doubles: good input</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">split_points</xsl:attribute>
               <xsl:attribute name="select">('50,182.3', '.6,166.')</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="split_points" select="('50,182.3', '.6,166.')"/>
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
      <xsl:message>Succeed if all X and Y are castable as xs:double</xsl:message>
      <xsl:variable name="impl:expect-d7e10" select="xs:boolean('true')"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e10, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario1-scenario1-expect1" successful="{$impl:successful}">
         <x:label>Succeed if all X and Y are castable as xs:double</x:label>
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
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Point coordinates (X and Y) are doubles: string</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">split_points</xsl:attribute>
               <xsl:attribute name="select">'50,x'</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="split_points" select="'50,x'"/>
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
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Point coordinates (X and Y) are doubles: dot, but no digits</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">split_points</xsl:attribute>
               <xsl:attribute name="select">'50,.'</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="split_points" select="'50,.'"/>
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
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Point coordinates (X and Y) are doubles: missing value</x:label>
         <x:call>
            <x:param>
               <xsl:attribute name="name">split_points</xsl:attribute>
               <xsl:attribute name="select">',50'</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="split_points" select="',50'"/>
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
      <xsl:variable name="impl:expect-d7e22" select="xs:boolean('false')"/>
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
   <xsl:template name="x:scenario2">
      <xsl:message>Scenario for testing function split_points</xsl:message>
      <x:scenario id="scenario2"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
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
      <xsl:variable name="impl:expect-d7e29"
                    select="'50,182', '100,166', '150,87', '200,191', '250,106', '300,73', '350,60', '400,186', '450,118'"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e29, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario2-expect1" successful="{$impl:successful}">
         <x:label>Tokenize string with all points into pairs of X,Y values</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e29"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario3">
      <xsl:message>Scenario for testing function extract_xPoints</xsl:message>
      <x:scenario id="scenario3"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function extract_xPoints</x:label>
         <x:call>
            <xsl:attribute name="function">djb:extract_xPoints</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">pointPairs</xsl:attribute>
               <xsl:attribute name="select">('50,182', '100,166', '150,87', '200,191', '250,106', '300,73', '350,60', '400,186', '450,118')</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="pointPairs"
                          select="('50,182', '100,166', '150,87', '200,191', '250,106', '300,73', '350,60', '400,186', '450,118')"/>
            <xsl:sequence select="djb:extract_xPoints($pointPairs)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario3-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario3-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Extract X values from point pairs</xsl:message>
      <xsl:variable name="impl:expect-d7e37"
                    select="50, 100, 150, 200, 250, 300, 350, 400, 450"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e37, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario3-expect1" successful="{$impl:successful}">
         <x:label>Extract X values from point pairs</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e37"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario4">
      <xsl:message>Scenario for testing function extract_yPoints</xsl:message>
      <x:scenario id="scenario4"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function extract_yPoints</x:label>
         <x:call>
            <xsl:attribute name="function">djb:extract_yPoints</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">pointPairs</xsl:attribute>
               <xsl:attribute name="select">('50,182', '100,166', '150,87', '200,191', '250,106', '300,73', '350,60', '400,186', '450,118')</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="pointPairs"
                          select="('50,182', '100,166', '150,87', '200,191', '250,106', '300,73', '350,60', '400,186', '450,118')"/>
            <xsl:sequence select="djb:extract_yPoints($pointPairs)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario4-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario4-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Extract Y values from point pairs</xsl:message>
      <xsl:variable name="impl:expect-d7e44"
                    select="182, 166, 87, 191, 106, 73, 60, 186, 118"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e44, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario4-expect1" successful="{$impl:successful}">
         <x:label>Extract Y values from point pairs</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e44"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario5">
      <xsl:message>Scenario for testing function create_dirX2</xsl:message>
      <x:scenario id="scenario5"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_dirX2</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_dirXs</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">xPoints</xsl:attribute>
               <xsl:attribute name="select">(50, 100, 150, 200, 250, 300, 350, 400, 450)</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="xPoints" select="(50, 100, 150, 200, 250, 300, 350, 400, 450)"/>
            <xsl:sequence select="djb:create_dirXs($xPoints)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario5-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario5-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute distance between alternating X values of input points</xsl:message>
      <xsl:variable name="impl:expect-d7e51" select="100, 100, 100, 100, 100, 100, 100"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e51, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario5-expect1" successful="{$impl:successful}">
         <x:label>Compute distance between alternating X values of input points</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e51"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario6">
      <xsl:message>Scenario for testing function create_dirY2</xsl:message>
      <x:scenario id="scenario6"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_dirY2</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_dirYs</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">xPoints</xsl:attribute>
               <xsl:attribute name="select">(182, 166, 87, 191, 106, 73, 60, 186, 118)</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="xPoints" select="(182, 166, 87, 191, 106, 73, 60, 186, 118)"/>
            <xsl:sequence select="djb:create_dirYs($xPoints)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario6-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario6-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute distance between alternating Y values of input points</xsl:message>
      <xsl:variable name="impl:expect-d7e59" select="-95, 25, 19, -118, -46, 113, 58"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e59, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario6-expect1" successful="{$impl:successful}">
         <x:label>Compute distance between alternating Y values of input points</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e59"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario7">
      <xsl:message>Scenario for testing function create_lengths</xsl:message>
      <x:scenario id="scenario7"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_lengths</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_lengths</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">dirXs</xsl:attribute>
               <xsl:attribute name="select">(100, 100, 100, 100, 100, 100, 100)</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">dirYs</xsl:attribute>
               <xsl:attribute name="select">(-95, 25, 19, -118, -46, 113, 58)</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="dirXs" select="(100, 100, 100, 100, 100, 100, 100)"/>
            <xsl:variable name="dirYs" select="(-95, 25, 19, -118, -46, 113, 58)"/>
            <xsl:sequence select="djb:create_lengths($dirXs, $dirYs)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario7-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario7-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute lengths of joining lines between alternating knots</xsl:message>
      <xsl:variable name="impl:expect-d7e67"
                    select="             xs:double('137.93114224133723'),              xs:double('103.07764064044152'),              xs:double('101.78899744078434'),              xs:double('154.67385040788247'),              xs:double('110.07270324653611'),              xs:double('150.89400253157845'),              xs:double('115.6027681329474')                         "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e67, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario7-expect1" successful="{$impl:successful}">
         <x:label>Compute lengths of joining lines between alternating knots</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e67"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario8">
      <xsl:message>Scenario for testing function create_unitXs</xsl:message>
      <x:scenario id="scenario8"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_unitXs</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_unitXs</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">dirXs</xsl:attribute>
               <xsl:attribute name="select">(100, 100, 100, 100, 100, 100, 100)</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">lengths</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('137.93114224133723'),                  xs:double('103.07764064044152'),                  xs:double('101.78899744078434'),                  xs:double('154.67385040788247'),                  xs:double('110.07270324653611'),                  xs:double('150.89400253157845'),                  xs:double('115.6027681329474')                             </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="dirXs" select="(100, 100, 100, 100, 100, 100, 100)"/>
            <xsl:variable name="lengths"
                          select="                 xs:double('137.93114224133723'),                  xs:double('103.07764064044152'),                  xs:double('101.78899744078434'),                  xs:double('154.67385040788247'),                  xs:double('110.07270324653611'),                  xs:double('150.89400253157845'),                  xs:double('115.6027681329474')                             "/>
            <xsl:sequence select="djb:create_unitXs($dirXs, $lengths)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario8-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario8-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute unit value of Xs</xsl:message>
      <xsl:variable name="impl:expect-d7e75"
                    select="             xs:double('0.7249994335944137'),              xs:double('0.9701425001453319'),              xs:double('0.9824244517014219'),              xs:double('0.6465216954016153'),              xs:double('0.9084904526785746'),              xs:double('0.6627168629785165'),              xs:double('0.8650311892618034')                         "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e75, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario8-expect1" successful="{$impl:successful}">
         <x:label>Compute unit value of Xs</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e75"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario9">
      <xsl:message>Scenario for testing function create_unitYs</xsl:message>
      <x:scenario id="scenario9"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_unitYs</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_unitYs</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">dirYs</xsl:attribute>
               <xsl:attribute name="select">(-95, 25, 19, -118, -46, 113, 58)</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">lengths</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('137.93114224133723'),                  xs:double('103.07764064044152'),                  xs:double('101.78899744078434'),                  xs:double('154.67385040788247'),                  xs:double('110.07270324653611'),                  xs:double('150.89400253157845'),                  xs:double('115.6027681329474')                             </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="dirYs" select="(-95, 25, 19, -118, -46, 113, 58)"/>
            <xsl:variable name="lengths"
                          select="                 xs:double('137.93114224133723'),                  xs:double('103.07764064044152'),                  xs:double('101.78899744078434'),                  xs:double('154.67385040788247'),                  xs:double('110.07270324653611'),                  xs:double('150.89400253157845'),                  xs:double('115.6027681329474')                             "/>
            <xsl:sequence select="djb:create_unitYs($dirYs, $lengths)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario9-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario9-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute unit value of Ys</xsl:message>
      <xsl:variable name="impl:expect-d7e84"
                    select="             xs:double('-0.688749461914693'),              xs:double('0.24253562503633297'),              xs:double('0.18666064582327016'),              xs:double('-0.762895600573906'),              xs:double('-0.41790560823214434'),              xs:double('0.7488700551657237'),              xs:double('0.501718089771846')                     "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e84, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario9-expect1" successful="{$impl:successful}">
         <x:label>Compute unit value of Ys</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e84"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario10">
      <xsl:message>Scenario for testing function create_normal1Xs</xsl:message>
      <x:scenario id="scenario10"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_normal1Xs</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_normal1Xs</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">unitYs</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('-0.688749461914693'),                  xs:double('0.24253562503633297'),                  xs:double('0.18666064582327016'),                  xs:double('-0.762895600573906'),                  xs:double('-0.41790560823214434'),                  xs:double('0.7488700551657237'),                  xs:double('0.501718089771846')                 </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="unitYs"
                          select="                 xs:double('-0.688749461914693'),                  xs:double('0.24253562503633297'),                  xs:double('0.18666064582327016'),                  xs:double('-0.762895600573906'),                  xs:double('-0.41790560823214434'),                  xs:double('0.7488700551657237'),                  xs:double('0.501718089771846')                 "/>
            <xsl:sequence select="djb:create_normal1Xs($unitYs)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario10-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario10-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute X coordinates for endpoint 1 of normals</xsl:message>
      <xsl:variable name="impl:expect-d7e91"
                    select="             xs:double('0.688749461914693'),              xs:double('-0.24253562503633297'),              xs:double('-0.18666064582327016'),              xs:double('0.762895600573906'),              xs:double('0.41790560823214434'),              xs:double('-0.7488700551657237'),              xs:double('-0.501718089771846')              "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e91, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario10-expect1" successful="{$impl:successful}">
         <x:label>Compute X coordinates for endpoint 1 of normals</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e91"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario11">
      <xsl:message>Scenario for testing function create_normal1Ys</xsl:message>
      <x:scenario id="scenario11"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_normal1Ys</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_normal1Ys</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">unitXs</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('0.7249994335944137'),                  xs:double('0.9701425001453319'),                  xs:double('0.9824244517014219'),                  xs:double('0.6465216954016153'),                  xs:double('0.9084904526785746'),                  xs:double('0.6627168629785165'),                  xs:double('0.8650311892618034')                             </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="unitXs"
                          select="                 xs:double('0.7249994335944137'),                  xs:double('0.9701425001453319'),                  xs:double('0.9824244517014219'),                  xs:double('0.6465216954016153'),                  xs:double('0.9084904526785746'),                  xs:double('0.6627168629785165'),                  xs:double('0.8650311892618034')                             "/>
            <xsl:sequence select="djb:create_normal1Ys($unitXs)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario11-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario11-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute Y coordinates for endpoint 1 of normals</xsl:message>
      <xsl:variable name="impl:expect-d7e98"
                    select="             xs:double('0.7249994335944137'),              xs:double('0.9701425001453319'),              xs:double('0.9824244517014219'),              xs:double('0.6465216954016153'),              xs:double('0.9084904526785746'),              xs:double('0.6627168629785165'),              xs:double('0.8650311892618034')                         "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e98, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario11-expect1" successful="{$impl:successful}">
         <x:label>Compute Y coordinates for endpoint 1 of normals</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e98"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>

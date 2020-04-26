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
            <xsl:call-template name="x:scenario12"/>
            <xsl:call-template name="x:scenario13"/>
            <xsl:call-template name="x:scenario14"/>
            <xsl:call-template name="x:scenario15"/>
            <xsl:call-template name="x:scenario16"/>
            <xsl:call-template name="x:scenario17"/>
            <xsl:call-template name="x:scenario18"/>
            <xsl:call-template name="x:scenario19"/>
            <xsl:call-template name="x:scenario20"/>
            <xsl:call-template name="x:scenario21"/>
            <xsl:call-template name="x:scenario22"/>
            <xsl:call-template name="x:scenario23"/>
            <xsl:call-template name="x:scenario24"/>
            <xsl:call-template name="x:scenario25"/>
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
   <xsl:template name="x:scenario12">
      <xsl:message>Scenario for testing function create_normal2Xs</xsl:message>
      <x:scenario id="scenario12"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_normal2Xs</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_normal2Xs</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">unitYs</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('-0.688749461914693'),                  xs:double('0.24253562503633297'),                  xs:double('0.18666064582327016'),                  xs:double('-0.762895600573906'),                  xs:double('-0.41790560823214434'),                  xs:double('0.7488700551657237'),                  xs:double('0.501718089771846')                 </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="unitYs"
                          select="                 xs:double('-0.688749461914693'),                  xs:double('0.24253562503633297'),                  xs:double('0.18666064582327016'),                  xs:double('-0.762895600573906'),                  xs:double('-0.41790560823214434'),                  xs:double('0.7488700551657237'),                  xs:double('0.501718089771846')                 "/>
            <xsl:sequence select="djb:create_normal2Xs($unitYs)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario12-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario12-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute X coordinates for endpoint 2 of normals</xsl:message>
      <xsl:variable name="impl:expect-d7e106"
                    select="             xs:double('-0.688749461914693'),              xs:double('0.24253562503633297'),              xs:double('0.18666064582327016'),              xs:double('-0.762895600573906'),              xs:double('-0.41790560823214434'),              xs:double('0.7488700551657237'),              xs:double('0.501718089771846')              "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e106, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario12-expect1" successful="{$impl:successful}">
         <x:label>Compute X coordinates for endpoint 2 of normals</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e106"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario13">
      <xsl:message>Scenario for testing function create_normal2Ys</xsl:message>
      <x:scenario id="scenario13"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_normal2Ys</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_normal2Ys</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">unitXs</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('0.7249994335944137'),                  xs:double('0.9701425001453319'),                  xs:double('0.9824244517014219'),                  xs:double('0.6465216954016153'),                  xs:double('0.9084904526785746'),                  xs:double('0.6627168629785165'),                  xs:double('0.8650311892618034')                             </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="unitXs"
                          select="                 xs:double('0.7249994335944137'),                  xs:double('0.9701425001453319'),                  xs:double('0.9824244517014219'),                  xs:double('0.6465216954016153'),                  xs:double('0.9084904526785746'),                  xs:double('0.6627168629785165'),                  xs:double('0.8650311892618034')                             "/>
            <xsl:sequence select="djb:create_normal2Ys($unitXs)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario13-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario13-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute Y coordinates for endpoint 2 of normals</xsl:message>
      <xsl:variable name="impl:expect-d7e113"
                    select="             xs:double('-0.7249994335944137'),              xs:double('-0.9701425001453319'),              xs:double('-0.9824244517014219'),              xs:double('-0.6465216954016153'),              xs:double('-0.9084904526785746'),              xs:double('-0.6627168629785165'),              xs:double('-0.8650311892618034')             "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e113, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario13-expect1" successful="{$impl:successful}">
         <x:label>Compute Y coordinates for endpoint 2 of normals</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e113"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario14">
      <xsl:message>Scenario for testing function create_angle1s</xsl:message>
      <x:scenario id="scenario14"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_angle1s</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_angle1s</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">normal1Ys</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('0.7249994335944137'),                  xs:double('0.9701425001453319'),                  xs:double('0.9824244517014219'),                  xs:double('0.6465216954016153'),                  xs:double('0.9084904526785746'),                  xs:double('0.6627168629785165'),                  xs:double('0.8650311892618034')                                </xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">normal1Xs</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('0.688749461914693'),                  xs:double('-0.24253562503633297'),                  xs:double('-0.18666064582327016'),                  xs:double('0.762895600573906'),                  xs:double('0.41790560823214434'),                  xs:double('-0.7488700551657237'),                  xs:double('-0.501718089771846')                 </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="normal1Ys"
                          select="                 xs:double('0.7249994335944137'),                  xs:double('0.9701425001453319'),                  xs:double('0.9824244517014219'),                  xs:double('0.6465216954016153'),                  xs:double('0.9084904526785746'),                  xs:double('0.6627168629785165'),                  xs:double('0.8650311892618034')                                "/>
            <xsl:variable name="normal1Xs"
                          select="                 xs:double('0.688749461914693'),                  xs:double('-0.24253562503633297'),                  xs:double('-0.18666064582327016'),                  xs:double('0.762895600573906'),                  xs:double('0.41790560823214434'),                  xs:double('-0.7488700551657237'),                  xs:double('-0.501718089771846')                 "/>
            <xsl:sequence select="djb:create_angle1s($normal1Ys, $normal1Xs)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario14-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario14-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute angle for normal 1</xsl:message>
      <xsl:variable name="impl:expect-d7e121"
                    select="             xs:double('2.381829898714022'),              xs:double('3.3865713167166573'),              xs:double('3.329354600103387'),              xs:double('2.273812559600654'),              xs:double('2.710453912871011'),              xs:double('3.9879480670768155'),              xs:double('3.6671764471414035')             "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e121, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario14-expect1" successful="{$impl:successful}">
         <x:label>Compute angle for normal 1</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e121"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario15">
      <xsl:message>Scenario for testing function create_angle2s</xsl:message>
      <x:scenario id="scenario15"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_angle2s</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_angle2s</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">normal2Ys</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('-0.7249994335944137'),                  xs:double('-0.9701425001453319'),                  xs:double('-0.9824244517014219'),                  xs:double('-0.6465216954016153'),                  xs:double('-0.9084904526785746'),                  xs:double('-0.6627168629785165'),                  xs:double('-0.8650311892618034')                 </xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">normal2Xs</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('-0.688749461914693'),                  xs:double('0.24253562503633297'),                  xs:double('0.18666064582327016'),                  xs:double('-0.762895600573906'),                  xs:double('-0.41790560823214434'),                  xs:double('0.7488700551657237'),                  xs:double('0.501718089771846')                  </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="normal2Ys"
                          select="                 xs:double('-0.7249994335944137'),                  xs:double('-0.9701425001453319'),                  xs:double('-0.9824244517014219'),                  xs:double('-0.6465216954016153'),                  xs:double('-0.9084904526785746'),                  xs:double('-0.6627168629785165'),                  xs:double('-0.8650311892618034')                 "/>
            <xsl:variable name="normal2Xs"
                          select="                 xs:double('-0.688749461914693'),                  xs:double('0.24253562503633297'),                  xs:double('0.18666064582327016'),                  xs:double('-0.762895600573906'),                  xs:double('-0.41790560823214434'),                  xs:double('0.7488700551657237'),                  xs:double('0.501718089771846')                  "/>
            <xsl:sequence select="djb:create_angle2s($normal2Ys, $normal2Xs)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario15-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario15-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute angle for normal 2</xsl:message>
      <xsl:variable name="impl:expect-d7e130"
                    select="             xs:double('-0.759762754875771'),              xs:double('0.244978663126864'),              xs:double('0.18776194651359335'),              xs:double('-0.8677800939891389'),              xs:double('-0.4311387407187821'),              xs:double('0.8463554134870224'),              xs:double('0.5255837935516101')             "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e130, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario15-expect1" successful="{$impl:successful}">
         <x:label>Compute angle for normal 2</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e130"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario16">
      <xsl:message>Scenario for testing function create_xLengths</xsl:message>
      <x:scenario id="scenario16"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_xLengths</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_xLengths</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">xPoints</xsl:attribute>
               <xsl:attribute name="select">(50, 100, 150, 200, 250, 300, 350, 400, 450)</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="xPoints" select="(50, 100, 150, 200, 250, 300, 350, 400, 450)"/>
            <xsl:sequence select="djb:create_xLengths($xPoints)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario16-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario16-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute x distance between adjacent knots</xsl:message>
      <xsl:variable name="impl:expect-d7e137" select="50, 50, 50, 50, 50, 50, 50, 50"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e137, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario16-expect1" successful="{$impl:successful}">
         <x:label>Compute x distance between adjacent knots</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e137"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario17">
      <xsl:message>Scenario for testing function create_yLengths</xsl:message>
      <x:scenario id="scenario17"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_yLengths</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_yLengths</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">yPoints</xsl:attribute>
               <xsl:attribute name="select">(182, 166, 87, 191, 106, 73, 60, 186, 118)</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="yPoints" select="(182, 166, 87, 191, 106, 73, 60, 186, 118)"/>
            <xsl:sequence select="djb:create_yLengths($yPoints)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario17-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario17-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute y distance between adjacent knots</xsl:message>
      <xsl:variable name="impl:expect-d7e144"
                    select="-16, -79, 104, -85, -33, -13, 126, -68"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e144, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario17-expect1" successful="{$impl:successful}">
         <x:label>Compute y distance between adjacent knots</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e144"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario18">
      <xsl:message>Scenario for testing function create_segLengths</xsl:message>
      <x:scenario id="scenario18"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_segLengths</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_segLengths</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">xLengths</xsl:attribute>
               <xsl:attribute name="select">(50, 50, 50, 50, 50, 50, 50, 50)</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">yLengths</xsl:attribute>
               <xsl:attribute name="select">(-16, -79, 104, -85, -33, -13, 126, -68)</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="xLengths" select="(50, 50, 50, 50, 50, 50, 50, 50)"/>
            <xsl:variable name="yLengths" select="(-16, -79, 104, -85, -33, -13, 126, -68)"/>
            <xsl:sequence select="djb:create_segLengths($xLengths, $yLengths)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario18-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario18-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute diagonal distance between adjacent knots</xsl:message>
      <xsl:variable name="impl:expect-d7e153"
                    select="             xs:double('52.49761899362675'),              xs:double('93.49331526906082'),              xs:double('115.39497389401325'),              xs:double('98.6154146165801'),              xs:double('59.90826320300064'),              xs:double('51.66236541235796'),              xs:double('135.55810562264435'),              xs:double('84.40379138403677')             "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e153, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario18-expect1" successful="{$impl:successful}">
         <x:label>Compute diagonal distance between adjacent knots</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e153"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario19">
      <xsl:message>Scenario for testing function create_totalAnchorLengths</xsl:message>
      <x:scenario id="scenario19"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_totalAnchorLengths</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_totalAnchorLengths</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">lengths</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('137.93114224133723'),                  xs:double('103.07764064044152'),                  xs:double('101.78899744078434'),                  xs:double('154.67385040788247'),                  xs:double('110.07270324653611'),                  xs:double('150.89400253157845'),                  xs:double('115.6027681329474') </xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">scaling</xsl:attribute>
               <xsl:attribute name="select">.4</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="lengths"
                          select="                 xs:double('137.93114224133723'),                  xs:double('103.07764064044152'),                  xs:double('101.78899744078434'),                  xs:double('154.67385040788247'),                  xs:double('110.07270324653611'),                  xs:double('150.89400253157845'),                  xs:double('115.6027681329474') "/>
            <xsl:variable name="scaling" select=".4"/>
            <xsl:sequence select="djb:create_totalAnchorLengths($lengths, $scaling)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario19-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario19-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute total distance between control points</xsl:message>
      <xsl:variable name="impl:expect-d7e161"
                    select="             xs:double('55.1724568965349'),              xs:double('41.23105625617661'),              xs:double('40.71559897631374'),              xs:double('61.86954016315299'),              xs:double('44.02908129861444'),              xs:double('60.357601012631385'),              xs:double('46.24110725317897')             "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e161, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario19-expect1" successful="{$impl:successful}">
         <x:label>Compute total distance between control points</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e161"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario20">
      <xsl:message>Scenario for testing function create_inAnchorLengths</xsl:message>
      <x:scenario id="scenario20"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_inAnchorLengths</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_inAnchorLengths</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">totalAnchorLengths</xsl:attribute>
               <xsl:attribute name="select">xs:double('55.1724568965349'),                  xs:double('41.23105625617661'),                  xs:double('40.71559897631374'),                  xs:double('61.86954016315299'),                  xs:double('44.02908129861444'),                  xs:double('60.357601012631385'),                  xs:double('46.24110725317897')</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">segLengths</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('52.49761899362675'),                  xs:double('93.49331526906082'),                  xs:double('115.39497389401325'),                  xs:double('98.6154146165801'),                  xs:double('59.90826320300064'),                  xs:double('51.66236541235796'),                  xs:double('135.55810562264435'),                  xs:double('84.40379138403677')                                 </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="totalAnchorLengths"
                          select="xs:double('55.1724568965349'),                  xs:double('41.23105625617661'),                  xs:double('40.71559897631374'),                  xs:double('61.86954016315299'),                  xs:double('44.02908129861444'),                  xs:double('60.357601012631385'),                  xs:double('46.24110725317897')"/>
            <xsl:variable name="segLengths"
                          select="                 xs:double('52.49761899362675'),                  xs:double('93.49331526906082'),                  xs:double('115.39497389401325'),                  xs:double('98.6154146165801'),                  xs:double('59.90826320300064'),                  xs:double('51.66236541235796'),                  xs:double('135.55810562264435'),                  xs:double('84.40379138403677')                                 "/>
            <xsl:sequence select="djb:create_inAnchorLengths($totalAnchorLengths, $segLengths)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario20-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario20-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute length of incoming handle</xsl:message>
      <xsl:variable name="impl:expect-d7e169"
                    select="             xs:double('19.83974303421423'),              xs:double('18.454017488868082'),              xs:double('21.953959869187713'),              xs:double('38.48819582819986'),              xs:double('23.641578646269323'),              xs:double('16.65531777422403'),              xs:double('28.49746699967797')             "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e169, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario20-expect1" successful="{$impl:successful}">
         <x:label>Compute length of incoming handle</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e169"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario21">
      <xsl:message>Scenario for testing function create_outAnchorLengths</xsl:message>
      <x:scenario id="scenario21"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_outAnchorLengths</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_outAnchorLengths</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">totalAnchorLengths</xsl:attribute>
               <xsl:attribute name="select">xs:double('55.1724568965349'),                  xs:double('41.23105625617661'),                  xs:double('40.71559897631374'),                  xs:double('61.86954016315299'),                  xs:double('44.02908129861444'),                  xs:double('60.357601012631385'),                  xs:double('46.24110725317897')</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">segLengths</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('52.49761899362675'),                  xs:double('93.49331526906082'),                  xs:double('115.39497389401325'),                  xs:double('98.6154146165801'),                  xs:double('59.90826320300064'),                  xs:double('51.66236541235796'),                  xs:double('135.55810562264435'),                  xs:double('84.40379138403677')                                 </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="totalAnchorLengths"
                          select="xs:double('55.1724568965349'),                  xs:double('41.23105625617661'),                  xs:double('40.71559897631374'),                  xs:double('61.86954016315299'),                  xs:double('44.02908129861444'),                  xs:double('60.357601012631385'),                  xs:double('46.24110725317897')"/>
            <xsl:variable name="segLengths"
                          select="                 xs:double('52.49761899362675'),                  xs:double('93.49331526906082'),                  xs:double('115.39497389401325'),                  xs:double('98.6154146165801'),                  xs:double('59.90826320300064'),                  xs:double('51.66236541235796'),                  xs:double('135.55810562264435'),                  xs:double('84.40379138403677')                                 "/>
            <xsl:sequence select="djb:create_outAnchorLengths($totalAnchorLengths, $segLengths)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario21-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario21-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute length of outgoing handle</xsl:message>
      <xsl:variable name="impl:expect-d7e178"
                    select="             xs:double('35.33271386232066'),              xs:double('22.77703876730852'),              xs:double('18.761639107126033'),              xs:double('23.381344334953123'),              xs:double('20.387502652345116'),              xs:double('43.702283238407354'),              xs:double('17.743640253500995')             "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e178, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario21-expect1" successful="{$impl:successful}">
         <x:label>Compute length of outgoing handle</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e178"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario22">
      <xsl:message>Scenario for testing function create_anchor1Xs</xsl:message>
      <x:scenario id="scenario22"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_anchor1Xs</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_anchor1Xs</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">xPoints</xsl:attribute>
               <xsl:attribute name="select">(50, 100, 150, 200, 250, 300, 350, 400, 450)</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">angle1s</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('2.381829898714022'),                  xs:double('3.3865713167166573'),                  xs:double('3.329354600103387'),                  xs:double('2.273812559600654'),                  xs:double('2.710453912871011'),                  xs:double('3.9879480670768155'),                  xs:double('3.6671764471414035')                 </xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">inAnchorLengths</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('19.83974303421423'),                  xs:double('18.454017488868082'),                  xs:double('21.953959869187713'),                  xs:double('38.48819582819986'),                  xs:double('23.641578646269323'),                  xs:double('16.65531777422403'),                  xs:double('28.49746699967797')                 </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="xPoints" select="(50, 100, 150, 200, 250, 300, 350, 400, 450)"/>
            <xsl:variable name="angle1s"
                          select="                 xs:double('2.381829898714022'),                  xs:double('3.3865713167166573'),                  xs:double('3.329354600103387'),                  xs:double('2.273812559600654'),                  xs:double('2.710453912871011'),                  xs:double('3.9879480670768155'),                  xs:double('3.6671764471414035')                 "/>
            <xsl:variable name="inAnchorLengths"
                          select="                 xs:double('19.83974303421423'),                  xs:double('18.454017488868082'),                  xs:double('21.953959869187713'),                  xs:double('38.48819582819986'),                  xs:double('23.641578646269323'),                  xs:double('16.65531777422403'),                  xs:double('28.49746699967797')                 "/>
            <xsl:sequence select="djb:create_anchor1Xs($xPoints, $angle1s, $inAnchorLengths)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario22-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario22-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute X coordinates of incoming handles</xsl:message>
      <xsl:variable name="impl:expect-d7e187"
                    select="             xs:double('85.61619753753597'),              xs:double('132.09697333562383'),              xs:double('178.43189301283823'),              xs:double('225.11654638020286'),              xs:double('278.52185151361465'),              xs:double('338.96224005275593'),              xs:double('375.34880223031956')             "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e187, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario22-expect1" successful="{$impl:successful}">
         <x:label>Compute X coordinates of incoming handles</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e187"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario23">
      <xsl:message>Scenario for testing function create_anchor1Ys</xsl:message>
      <x:scenario id="scenario23"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_anchor1Ys</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_anchor1Ys</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">yPoints</xsl:attribute>
               <xsl:attribute name="select">(182, 166, 87, 191, 106, 73, 60, 186, 118)</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">angle1s</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('2.381829898714022'),                  xs:double('3.3865713167166573'),                  xs:double('3.329354600103387'),                  xs:double('2.273812559600654'),                  xs:double('2.710453912871011'),                  xs:double('3.9879480670768155'),                  xs:double('3.6671764471414035')                 </xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">inAnchorLengths</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('19.83974303421423'),                  xs:double('18.454017488868082'),                  xs:double('21.953959869187713'),                  xs:double('38.48819582819986'),                  xs:double('23.641578646269323'),                  xs:double('16.65531777422403'),                  xs:double('28.49746699967797')                 </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="yPoints" select="(182, 166, 87, 191, 106, 73, 60, 186, 118)"/>
            <xsl:variable name="angle1s"
                          select="                 xs:double('2.381829898714022'),                  xs:double('3.3865713167166573'),                  xs:double('3.329354600103387'),                  xs:double('2.273812559600654'),                  xs:double('2.710453912871011'),                  xs:double('3.9879480670768155'),                  xs:double('3.6671764471414035')                 "/>
            <xsl:variable name="inAnchorLengths"
                          select="                 xs:double('19.83974303421423'),                  xs:double('18.454017488868082'),                  xs:double('21.953959869187713'),                  xs:double('38.48819582819986'),                  xs:double('23.641578646269323'),                  xs:double('16.65531777422403'),                  xs:double('28.49746699967797')                 "/>
            <xsl:sequence select="djb:create_anchor1Ys($yPoints, $angle1s, $inAnchorLengths)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario23-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario23-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute Y coordinates of incoming handles</xsl:message>
      <xsl:variable name="impl:expect-d7e196"
                    select="             xs:double('179.66461233934083'),              xs:double('82.52424333390596'),              xs:double('186.90205967243926'),              xs:double('135.36247527136064'),              xs:double('82.87994830373725'),              xs:double('47.52733125961419'),              xs:double('171.70230529358534')             "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e196, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario23-expect1" successful="{$impl:successful}">
         <x:label>Compute Y coordinates of incoming handles</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e196"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario24">
      <xsl:message>Scenario for testing function create_anchor2Xs</xsl:message>
      <x:scenario id="scenario24"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_anchor2Xs</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_anchor2Xs</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">xPoints</xsl:attribute>
               <xsl:attribute name="select">50, 100, 150, 200, 250, 300, 350, 400, 450</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">angle2s</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('-0.759762754875771'),                  xs:double('0.244978663126864'),                  xs:double('0.18776194651359335'),                  xs:double('-0.8677800939891389'),                  xs:double('-0.4311387407187821'),                  xs:double('0.8463554134870224'),                  xs:double('0.5255837935516101')                 </xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">outAnchorLengths</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('35.33271386232066'),                  xs:double('22.77703876730852'),                  xs:double('18.761639107126033'),                  xs:double('23.381344334953123'),                  xs:double('20.387502652345116'),                  xs:double('43.702283238407354'),                  xs:double('17.743640253500995')                                 </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="xPoints" select="50, 100, 150, 200, 250, 300, 350, 400, 450"/>
            <xsl:variable name="angle2s"
                          select="                 xs:double('-0.759762754875771'),                  xs:double('0.244978663126864'),                  xs:double('0.18776194651359335'),                  xs:double('-0.8677800939891389'),                  xs:double('-0.4311387407187821'),                  xs:double('0.8463554134870224'),                  xs:double('0.5255837935516101')                 "/>
            <xsl:variable name="outAnchorLengths"
                          select="                 xs:double('35.33271386232066'),                  xs:double('22.77703876730852'),                  xs:double('18.761639107126033'),                  xs:double('23.381344334953123'),                  xs:double('20.387502652345116'),                  xs:double('43.702283238407354'),                  xs:double('17.743640253500995')                                 "/>
            <xsl:sequence select="djb:create_anchor2Xs($xPoints, $angle2s, $outAnchorLengths)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario24-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario24-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute X coordinates of outgoing handles</xsl:message>
      <xsl:variable name="impl:expect-d7e206"
                    select="             xs:double('125.61619753753597'),              xs:double('172.09697333562383'),              xs:double('218.43189301283826'),              xs:double('265.11654638020286'),              xs:double('318.52185151361465'),              xs:double('378.96224005275593'),              xs:double('415.34880223031956')             "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e206, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario24-expect1" successful="{$impl:successful}">
         <x:label>Compute X coordinates of outgoing handles</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e206"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:scenario25">
      <xsl:message>Scenario for testing function create_anchor2Ys</xsl:message>
      <x:scenario id="scenario25"
                  xspec="file:/Users/djb/repos/xstuff/bezier/sample-11.xspec">
         <x:label>Scenario for testing function create_anchor2Ys</x:label>
         <x:call>
            <xsl:attribute name="function">djb:create_anchor2Ys</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">yPoints</xsl:attribute>
               <xsl:attribute name="select">182, 166, 87, 191, 106, 73, 60, 186, 118</xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">angle2s</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('-0.759762754875771'),                  xs:double('0.244978663126864'),                  xs:double('0.18776194651359335'),                  xs:double('-0.8677800939891389'),                  xs:double('-0.4311387407187821'),                  xs:double('0.8463554134870224'),                  xs:double('0.5255837935516101')                 </xsl:attribute>
            </x:param>
            <x:param>
               <xsl:attribute name="name">outAnchorLengths</xsl:attribute>
               <xsl:attribute name="select">                 xs:double('35.33271386232066'),                  xs:double('22.77703876730852'),                  xs:double('18.761639107126033'),                  xs:double('23.381344334953123'),                  xs:double('20.387502652345116'),                  xs:double('43.702283238407354'),                  xs:double('17.743640253500995')                                 </xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="yPoints" select="182, 166, 87, 191, 106, 73, 60, 186, 118"/>
            <xsl:variable name="angle2s"
                          select="                 xs:double('-0.759762754875771'),                  xs:double('0.244978663126864'),                  xs:double('0.18776194651359335'),                  xs:double('-0.8677800939891389'),                  xs:double('-0.4311387407187821'),                  xs:double('0.8463554134870224'),                  xs:double('0.5255837935516101')                 "/>
            <xsl:variable name="outAnchorLengths"
                          select="                 xs:double('35.33271386232066'),                  xs:double('22.77703876730852'),                  xs:double('18.761639107126033'),                  xs:double('23.381344334953123'),                  xs:double('20.387502652345116'),                  xs:double('43.702283238407354'),                  xs:double('17.743640253500995')                                 "/>
            <xsl:sequence select="djb:create_anchor2Ys($yPoints, $angle2s, $outAnchorLengths)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:scenario25-expect1">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:scenario25-expect1">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Compute Y coordinates of outgoing handles</xsl:message>
      <xsl:variable name="impl:expect-d7e215"
                    select="             xs:double('141.66461233934083'),              xs:double('92.52424333390596'),              xs:double('194.50205967243926'),              xs:double('88.16247527136065'),              xs:double('64.47994830373726'),              xs:double('92.7273312596142'),              xs:double('194.90230529358536')             "/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expect-d7e215, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test id="scenario25-expect1" successful="{$impl:successful}">
         <x:label>Compute Y coordinates of outgoing handles</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expect-d7e215"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>

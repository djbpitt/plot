<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:__x="http://www.w3.org/1999/XSL/TransformAliasAlias"
                xmlns:pkg="http://expath.org/ns/pkg"
                xmlns:impl="urn:x-xspec:compile:xslt:impl"
                xmlns:djb="http://www.obdurodon.org"
                version="2.0"
                exclude-result-prefixes="pkg impl">
   <xsl:import href="file:/Users/djb/repos/xspec-ulation/potato.xsl"/>
   <xsl:import href="file:/Users/djb/repos/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:import href="file:/Users/djb/repos/xspec/src/schematron/sch-location-compare.xsl"/>
   <xsl:namespace-alias stylesheet-prefix="__x" result-prefix="xsl"/>
   <xsl:variable name="x:stylesheet-uri"
                 as="xs:string"
                 select="'file:/Users/djb/repos/xspec-ulation/potato.xsl'"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="file:/Users/djb/repos/xspec/src/compiler/format-xspec-report.xsl"</xsl:processing-instruction>
         <x:report stylesheet="{$x:stylesheet-uri}"
                   date="{current-dateTime()}"
                   xspec="file:/Users/djb/repos/xspec-ulation/potato.xspec">
            <xsl:call-template name="x:d5e2"/>
            <xsl:call-template name="x:d5e15"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:d5e2">
      <xsl:message>Test potato() with sequences</xsl:message>
      <x:scenario>
         <x:label>Test potato() with sequences</x:label>
         <x:call function="djb:sequence">
            <x:param>
               <xsl:text>potato</xsl:text>
            </x:param>
            <x:param>
               <xsl:text>4</xsl:text>
            </x:param>
            <x:param>
               <xsl:text>es</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="d6e1-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>potato</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="d6e1" select="$d6e1-doc/node()"/>
            <xsl:variable name="d6e3-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>4</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="d6e3" select="$d6e3-doc/node()"/>
            <xsl:variable name="d6e5-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>es</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="d6e5" select="$d6e5-doc/node()"/>
            <xsl:sequence select="djb:sequence($d6e1, $d6e3, $d6e5)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e10">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e10">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Expect stress on the middle vowel of 'potato' using sequences for the strings</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>pot</xsl:text>
            <stress>
               <xsl:text>a</xsl:text>
            </stress>
            <xsl:text>toes</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>Expect stress on the middle vowel of 'potato' using sequences for the strings</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e15">
      <xsl:message>Test potato() with variables</xsl:message>
      <x:scenario>
         <x:label>Test potato() with variables</x:label>
         <x:call function="djb:variable">
            <x:param>
               <xsl:text>potato</xsl:text>
            </x:param>
            <x:param>
               <xsl:text>4</xsl:text>
            </x:param>
            <x:param>
               <xsl:text>es</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="d11e1-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>potato</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="d11e1" select="$d11e1-doc/node()"/>
            <xsl:variable name="d11e3-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>4</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="d11e3" select="$d11e3-doc/node()"/>
            <xsl:variable name="d11e5-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>es</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="d11e5" select="$d11e5-doc/node()"/>
            <xsl:sequence select="djb:variable($d11e1, $d11e3, $d11e5)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e23">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e23">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Expect stress on the middle vowel of 'potato' using variables for the strings</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>pot</xsl:text>
            <stress>
               <xsl:text>a</xsl:text>
            </stress>
            <xsl:text>toes</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>Expect stress on the middle vowel of 'potato' using variables for the strings</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>

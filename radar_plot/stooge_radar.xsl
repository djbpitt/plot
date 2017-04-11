<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns="http://www.w3.org/2000/svg" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:djb="http://www.obdurodon.org" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="#all">
  <!--
    filename: stooge_radar.xsl
    author: djb 2017-04-11
    input: from stooges.xml
    synopsis: draws radar plot
  -->
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  <xsl:variable name="root" as="document-node()" select="/"/>
  <!-- $scaleFactor scales entire SVG image -->
  <xsl:variable name="scaleFactor" select="5"/>
  <!-- $true1 evaluates to 1 after scaling, used to keep thin lines after large scaling -->
  <xsl:variable name="true1" as="xs:double" select="1 div $scaleFactor"/>
  <xsl:variable name="xShift" as="xs:integer" select="200"/>
  <xsl:variable name="radius" as="xs:double" select="100"/>
  <xsl:variable name="spokeCount" as="xs:integer" select="5"/>
  <xsl:variable name="maxValue" as="xs:double" select="max(//stooge/*)"/>
  <xsl:variable name="colors" as="xs:string+" select="'red', 'green', 'blue'"/>
  <xsl:function name="djb:fractionToRadians" as="xs:double">
    <xsl:param name="fraction"/>
    <xsl:sequence select="$fraction * 2 * math:pi()"/>
  </xsl:function>
  <xsl:function name="djb:coordinates" as="xs:string">
    <xsl:param name="propPosition" as="xs:integer"/>
    <xsl:param name="propValue" as="xs:integer"/>
    <xsl:variable name="fraction" as="xs:double" select="$propPosition div $spokeCount"/>
    <xsl:variable name="radians" as="xs:double" select="djb:fractionToRadians($fraction)"/>
    <xsl:variable name="cosine" as="xs:double" select="math:cos($radians)"/>
    <xsl:variable name="sine" as="xs:double" select="math:sin($radians)"/>
    <xsl:variable name="percentage" as="xs:double"
      select="($propValue + 1) div ($maxValue + 1) * $radius"/>
    <xsl:variable name="xPos" as="xs:double" select="$cosine * $percentage"/>
    <xsl:variable name="yPos" as="xs:double" select="$sine * $percentage"/>
    <xsl:sequence select="concat('L ', $xPos, ' ', $yPos)"/>
  </xsl:function>
  <xsl:template match="/">
    <svg width="{$radius * $scaleFactor + $xShift}" height="{$radius * $scaleFactor}"
      viewBox="-{$radius} -{$radius} {2 * $radius} {2 * $radius}">
      <g transform="translate(-{$xShift div $scaleFactor},0)">
        <!-- perimeter -->
        <circle r="{$radius}" cx="0" cy="0" stroke="gray" stroke-width="{1 div $scaleFactor}"
          fill-opacity="0"/>
        <!-- 0 values -->
        <circle r="{$radius * 1 div ($maxValue + 1)}" cx="0" cy="0" stroke="gray"
          stroke-width="{1 div $scaleFactor}" fill-opacity="0"/>
        <!-- axes -->
        <xsl:for-each select="1 to $spokeCount">
          <xsl:variable name="fraction" as="xs:double" select=". div $spokeCount"/>
          <xsl:variable name="radians" as="xs:double" select="djb:fractionToRadians($fraction)"/>
          <xsl:variable name="cosine" as="xs:double" select="math:cos($radians)"/>
          <xsl:variable name="sine" as="xs:double" select="math:sin($radians)"/>
          <xsl:variable name="x2Pos" as="xs:double" select="$cosine * $radius"/>
          <xsl:variable name="y2Pos" as="xs:double" select="$sine * $radius"/>
          <line x1="0" y1="0" x2="{$x2Pos}" y2="{$y2Pos}" stroke-width="{$true1}" stroke="gray"/>
          <!-- move text slightly left and down from point it labels -->
          <text x="{$x2Pos + 1}" y="{$y2Pos + 3}" font-size="10">
            <xsl:value-of select="$root//stooge[1]/*[current()]/name()"/>
          </text>
        </xsl:for-each>
        <xsl:apply-templates select="//stooge"/>
      </g>
    </svg>
  </xsl:template>
  <xsl:template match="stooge">
    <xsl:variable name="stoogeName" as="xs:string" select="@name"/>
    <xsl:variable name="stoogePosition" select="position()"/>
    <xsl:variable name="color" as="xs:string" select="$colors[$stoogePosition]"/>
    <!-- polygon formed by joining all values for a stooge -->
    <xsl:variable name="path" as="xs:string"
      select="
        replace(concat(string-join(for $number in 1 to count(*)
        return
          djb:coordinates($number, current()/*[$number]), ' '), ' Z'), '^L', 'M')"/>
    <path id="{@name}" d="{$path}" stroke="{$color}" stroke-width="{$true1}" fill="{$color}"
      fill-opacity=".25"/>
    <!-- legend entry -->
    <g class="legend" id="{concat(@name,'_rect')}"
      transform="translate({$radius},{-100 + $stoogePosition * 12})">
      <rect x="0" y="0" width="10" height="10" fill="{$color}"/>
      <text x="12" y="8.5" font-size="10" fill="{$color}">
        <xsl:value-of select="@name"/>
      </text>
    </g>
  </xsl:template>
</xsl:stylesheet>

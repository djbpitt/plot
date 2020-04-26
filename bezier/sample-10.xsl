<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- ================================================================= -->
    <!-- Stylesheet variables                                              -->
    <!-- ================================================================= -->
    <!-- Line points: X values evenly spaced, Y values random              -->
    <!-- $xPoints as xs:integer+ : X coordinates of points                 -->
    <!-- $yPoints as xs:integer+ : Y coordinates of points                 -->
    <!-- $points as element(point)+ : comma separated X,Y values of points -->
    <!-- $scaling as xs:double : scaling of Bézier curves (range 0–1)      -->
    <!-- ================================================================= -->
    <xsl:variable name="xPoints" as="xs:integer+"
        select="50, 100, 150, 200, 250, 300, 350, 400, 450"/>
    <xsl:variable name="yPoints" as="xs:integer+" select="182, 166, 87, 191, 106, 73, 60, 186, 118"/>
    <xsl:variable name="points" as="element(point)+">
        <xsl:for-each select="1 to count($xPoints)">
            <xsl:element name="point" xmlns="">
                <xsl:value-of select="string-join(($xPoints[current()], $yPoints[current()]), ',')"
                />
            </xsl:element>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="scaling" as="xs:double" select=".4"/>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- Computed values                                                   -->
    <!--                                                                   -->
    <!-- Each is a sequence of values, one for each Bézier curve           -->
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- $dirXs as xs:double+ : X coordinates of joining line              -->
    <!-- $dirYs as xs:double+ : Y coordinates of joining line              -->
    <!-- $lengths as xs:double+ : length of joining line                   -->
    <!-- ================================================================= -->
    <xsl:variable name="dirXs" as="xs:integer+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:variable name="x1" as="xs:integer" select="$xPoints[position() eq current()]"/>
            <xsl:variable name="x2" as="xs:integer" select="$xPoints[position() eq current() + 2]"/>
            <xsl:sequence select="$x2 - $x1"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="dirYs" as="xs:integer+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:variable name="y1" as="xs:integer" select="$yPoints[position() eq current()]"/>
            <xsl:variable name="y2" as="xs:integer" select="$yPoints[position() eq current() + 2]"/>
            <xsl:sequence select="$y2 - $y1"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="lengths" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:variable name="xDistance" as="xs:integer" select="$dirXs[current()]"/>
            <xsl:variable name="yDistance" as="xs:integer" select="$dirYs[current()]"/>
            <xsl:sequence
                select="(math:pow($xDistance, 2) + math:pow($yDistance, 2)) => math:sqrt()"/>
        </xsl:for-each>
    </xsl:variable>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- $unitXs as xs:double+ : X coordinates of unit vector              -->
    <!-- $unitYs as xs:double+ : Y coordinates of unit vector              -->
    <!-- ================================================================= -->
    <xsl:variable name="unitXs" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence select="$dirXs[current()] div $lengths[current()]"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="unitYs" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence select="$dirYs[current()] div $lengths[current()]"/>
        </xsl:for-each>
    </xsl:variable>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- $normal1Xs as xs:double+ : X coordinates of endpoint 1 of normal  -->
    <!-- $normal1Ys as xs:double+ : Y coordinates of endpoint 1 of normal  -->
    <!-- $normal2Xs as xs:double+ : X coordinates of endpoint 2 of normal  -->
    <!-- $normal2Ys as xs:double+ : Y coordinates of endpoint 2 of normal  -->
    <!-- ================================================================= -->
    <xsl:variable name="normal1Xs" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence select="-$unitYs[current()]"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="normal1Ys" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence select="$unitXs[current()]"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="normal2Xs" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence select="$unitYs[current()]"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="normal2Ys" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence select="-$unitXs[current()]"/>
        </xsl:for-each>
    </xsl:variable>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- $angle1s as xs:double+ : angle for normal1                        -->
    <!-- $angle2s as xs:double+ : angle for normal2                        -->
    <!-- ================================================================= -->
    <xsl:variable name="angle1s" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence
                select="math:atan2($normal1Ys[current()], $normal1Xs[current()]) + math:pi() div 2"
            />
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="angle2s" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence
                select="math:atan2($normal2Ys[current()], $normal2Xs[current()]) + math:pi() div 2"
            />
        </xsl:for-each>
    </xsl:variable>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- One more than count of inner knots                                -->
    <!--                                                                   -->
    <!-- $xLengths as xs:double+ : x distance between adjacent points      -->
    <!-- $yLengths as xs:double+ : y distance between adjacent points      -->
    <!-- $segLengths as xs:double+ :                                       -->
    <!--   diagonal distance between adjacent points                       -->
    <!-- ================================================================= -->
    <xsl:variable name="xLengths" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 1">
            <xsl:sequence select="$xPoints[current() + 1] - $xPoints[current()]"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="yLengths" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 1">
            <xsl:sequence select="$yPoints[current() + 1] - $yPoints[current()]"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="segLengths" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 1">
            <xsl:sequence
                select="(math:pow($xLengths[current()], 2) + math:pow($yLengths[current()], 2)) => math:sqrt()"
            />
        </xsl:for-each>
    </xsl:variable>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- $totalAnchorLengths as xs:double : length of control line         -->
    <!-- $inAnchorLengths as xs:double+ : length of incoming handles       -->
    <!-- $outAnchorLengths as xs:double+ : length of outgoing handles      -->
    <!-- ================================================================= -->
    <xsl:variable name="totalAnchorLengths" as="xs:double+">
        <xsl:for-each select="1 to count($lengths)">
            <xsl:sequence select="$scaling * $lengths[current()]"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="inAnchorLengths" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence
                select="
                    $totalAnchorLengths[current()] *
                    $segLengths[current()] div
                    ($segLengths[current()] + $segLengths[current() + 1])"
            />
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="outAnchorLengths" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence
                select="
                    $totalAnchorLengths[current()] *
                    $segLengths[current() + 1] div
                    ($segLengths[current()] + $segLengths[current() + 1])"
            />
        </xsl:for-each>
    </xsl:variable>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- $anchor1Xs as xs:double+ : X for endpoint 1 of anchor1            -->
    <!-- $anchor1Ys as xs:double+ : Y for endpoint 1 of anchor1            -->
    <!-- $anchor2Xs as xs:double+ : X for endpoint 1 of anchor2            -->
    <!-- $anchor2Ys as xs:double+ : Y for endpoint 1 of anchor2            -->
    <!-- ================================================================= -->
    <xsl:variable name="anchor1Xs" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence
                select="$xPoints[current() + 1] + math:cos($angle1s[current()]) * ($inAnchorLengths[current()])"
            />
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="anchor1Ys" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence
                select="$yPoints[current() + 1] + math:sin($angle1s[current()]) * ($inAnchorLengths[current()])"
            />
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="anchor2Xs" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence
                select="$xPoints[current() + 1] + math:cos($angle2s[current()]) * ($outAnchorLengths[current()])"
            />
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="anchor2Ys" as="xs:double+">
        <xsl:for-each select="1 to count($points) - 2">
            <xsl:sequence
                select="$yPoints[current() + 1] + math:sin($angle2s[current()]) * ($outAnchorLengths[current()])"
            />
        </xsl:for-each>
    </xsl:variable>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- SVG constants                                                     -->
    <!--                                                                   -->
    <!-- $svgWidth as xs:integer : width of viewport                       -->
    <!-- $svgHeight as xs:integer : height of viewport                     -->
    <!--   Note: halve these values in viewBox to scale up to 200%         -->
    <!-- $cRadius as xs:integer : radius of main and anchor points         -->
    <!-- $bcColor as xs:string : background color                          -->
    <!-- $css as element(svg:style) : convenience variable                 -->
    <!-- ================================================================= -->
    <xsl:variable name="svgWidth" as="xs:integer" select="1000"/>
    <xsl:variable name="svgHeight" as="xs:integer" select="600"/>
    <xsl:variable name="cRadius" as="xs:integer" select="2"/>
    <xsl:variable name="css" as="element(svg:style)">
        <style type="text/css"><![CDATA[
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
            }]]></style>
    </xsl:variable>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- Main                                                              -->
    <!-- ================================================================= -->
    <xsl:template name="xsl:initial-template">
        <xsl:message select="$points"/>
        <!-- ============================================================= -->
        <!-- Diagnostics                                                   -->
        <!--                                                               -->
        <!-- $dirXs, $dirYs, $connectingLineLengths                        -->
        <!-- ============================================================= -->
        <xsl:result-document href="diagnostics.xhtml" omit-xml-declaration="yes" indent="yes"
            doctype-system="about:legacy-compat" method="xml">
            <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <title>Diagnostics</title>
                    <style type="text/css">
                        table,
                        tr,
                        th,
                        td {
                            border: 1px black solid;
                        }
                        table {
                            border-collapse: collapse;
                        }
                        tr:nth-child(even) {
                            background-color: lightgray;
                        }
                        th,
                        td {
                            padding: 4px;
                        }</style>
                </head>
                <body>
                    <table style="text-align: right;">
                        <tr style="text-align: center;">
                            <th>#</th>
                            <th>dirX</th>
                            <th>dirY</th>
                            <th>joining<br/>length</th>
                            <th>unitX</th>
                            <th>unitY</th>
                            <th>normal1</th>
                            <th>normal2</th>
                            <th>angle1</th>
                            <th>angle2</th>
                            <th>anchor1X</th>
                            <th>anchor1Y</th>
                            <th>anchor2X</th>
                            <th>anchor2Y</th>
                            <th>scaling<br/>(constant)</th>
                            <th>total anchor<br/>length</th>
                            <th>anchorLength1<br/>(in)</th>
                            <th>anchorLength2<br/>(out)</th>
                        </tr>
                        <xsl:for-each select="1 to count($points) - 2">
                            <tr>
                                <!-- Bézier number -->
                                <td>
                                    <xsl:sequence select="."/>
                                </td>
                                <!-- dir X -->
                                <td>
                                    <xsl:sequence select="$dirXs[current()]"/>
                                </td>
                                <!-- dir Y -->
                                <td>
                                    <xsl:sequence select="$dirYs[current()]"/>
                                </td>
                                <!-- length of joining line -->
                                <td>
                                    <xsl:sequence
                                        select="$lengths[current()] ! format-number(., '#.00')"/>
                                </td>
                                <!-- unit X -->
                                <td>
                                    <xsl:sequence
                                        select="$unitXs[current()] ! format-number(., '0.00')"/>
                                </td>
                                <!-- unit Y -->
                                <td>
                                    <xsl:sequence
                                        select="$unitYs[current()] ! format-number(., '0.00')"/>
                                </td>
                                <!-- normal 1 -->
                                <td>
                                    <xsl:sequence
                                        select="
                                            string-join(
                                            (
                                            $normal1Xs[current()] ! format-number(., '0.00'),
                                            $normal1Ys[current()] ! format-number(., '0.00')
                                            ),
                                            ', ')"
                                    />
                                </td>
                                <!-- normal 2 -->
                                <td>
                                    <xsl:sequence
                                        select="
                                            string-join(
                                            (
                                            $normal2Xs[current()] ! format-number(., '0.00'),
                                            $normal2Ys[current()] ! format-number(., '0.00')
                                            ),
                                            ', ')"
                                    />
                                </td>
                                <!-- angle 1 -->
                                <td>
                                    <xsl:sequence
                                        select="$angle1s[current()] ! format-number(., '0.00')"/>
                                </td>
                                <!-- angle 2 -->
                                <td>
                                    <xsl:sequence
                                        select="$angle2s[current()] ! format-number(., '0.00')"/>
                                </td>
                                <!-- anchor 1 X -->
                                <td>
                                    <xsl:sequence
                                        select="$anchor1Xs[current()] ! format-number(., '0.00')"/>
                                </td>
                                <!-- anchor 1 Y-->
                                <td>
                                    <xsl:sequence
                                        select="$anchor1Ys[current()] ! format-number(., '0.00')"/>
                                </td>
                                <!-- anchor 2 X -->
                                <td>
                                    <xsl:sequence
                                        select="$anchor2Xs[current()] ! format-number(., '0.00')"/>
                                </td>
                                <!-- anchor 2 Y -->
                                <td>
                                    <xsl:sequence
                                        select="$anchor2Ys[current()] ! format-number(., '0.00')"/>
                                </td>
                                <!-- scaling factor (constant) -->
                                <td>
                                    <xsl:sequence select="$scaling"/>
                                </td>
                                <!-- total length of control line -->
                                <td>
                                    <xsl:sequence
                                        select="$totalAnchorLengths[current()] ! format-number(., '0.00')"
                                    />
                                </td>
                                <!-- in handle length -->
                                <td>
                                    <xsl:sequence
                                        select="$inAnchorLengths[current()] ! format-number(., '0.00')"
                                    />
                                </td>
                                <!-- out handle length -->
                                <td>
                                    <xsl:sequence
                                        select="$outAnchorLengths[current()] ! format-number(., '0.00')"
                                    />
                                </td>
                            </tr>
                        </xsl:for-each>
                    </table>
                </body>
            </html>
        </xsl:result-document>

        <!-- ============================================================= -->
        <!-- Now draw the SVG image                                        -->
        <!-- ============================================================= -->
        <svg width="{$svgWidth}" height="{$svgHeight}"
            viewBox="0 0 {$svgWidth div 2} {$svgHeight div 2}">
            <xsl:sequence select="$css"/>
            <g>
                <!-- ===================================================== -->
                <!-- Background                                            -->
                <!-- ===================================================== -->
                <rect x="0" y="0" width="500" height="300" stroke="black" stroke-width="1"
                    fill="papayawhip"/>
                <!-- ===================================================== -->
                <!-- Data points and connecting lines                      -->
                <!-- ===================================================== -->
                <xsl:for-each select="1 to count($xPoints)">
                    <circle class="mainCircle" cx="{$xPoints[current()]}" cy="{$yPoints[current()]}"
                        r="{$cRadius}"/>
                </xsl:for-each>
                <polyline class="mainLine" points="{string-join($points, ' ')}"/>
                <!-- ===================================================== -->
                <!-- Alternating (hypotenuse) lines                        -->
                <!-- ===================================================== -->
                <xsl:for-each select="0, 1">
                    <polyline class="alternatingLine"
                        points="{$points[position() mod 2 eq current()]}"/>
                </xsl:for-each>
                <!-- ===================================================== -->
                <!-- Anchor points and lines                               -->
                <!-- ===================================================== -->
                <xsl:for-each select="1 to count($points) - 2">
                    <line class="anchorLine" x1="{$anchor1Xs[current()]}"
                        y1="{$anchor1Ys[current()]}" x2="{$anchor2Xs[current()]}"
                        y2="{$anchor2Ys[current()]}"/>
                    <circle class="anchorCircle1" cx="{$anchor1Xs[current()]}"
                        cy="{$anchor1Ys[current()]}" r="{$cRadius}"/>
                    <circle class="anchorCircle2" cx="{$anchor2Xs[current()]}"
                        cy="{$anchor2Ys[current()]}" r="{$cRadius}"/>
                </xsl:for-each>
                <!-- ===================================================== -->
                <!-- Plot the spline                                       -->
                <!-- ===================================================== -->
                <xsl:variable name="bezierPath" as="xs:string+">
                    <!-- start at first point -->
                    <xsl:sequence
                        select="
                            concat(
                            'M',
                            $xPoints[1],
                            ',',
                            $yPoints[1])"/>
                    <!-- first curve has only one control point -->
                    <xsl:sequence
                        select="
                            concat(
                            'Q',
                            $anchor1Xs[1],
                            ',',
                            $anchor1Ys[1],
                            ' ',
                            $xPoints[2],
                            ',',
                            $yPoints[2])
                            "/>
                    <!-- all but first and last curves have two control points -->
                    <xsl:for-each select="2 to (count($points) - 2)">
                        <xsl:variable name="c1" as="xs:string"
                            select="$anchor2Xs[current() - 1] || ',' || $anchor2Ys[current() - 1]"/>
                        <xsl:variable name="c2" as="xs:string"
                            select="$anchor1Xs[current()] || ',' || $anchor1Ys[current()]"/>
                        <xsl:variable name="endPoint" as="xs:string"
                            select="$xPoints[current() + 1] || ',' || $yPoints[current() + 1]"/>
                        <xsl:value-of select="'C' || string-join(($c1, $c2, $endPoint), ' ')"/>
                    </xsl:for-each>
                    <!-- last curve has one control point-->
                    <xsl:sequence
                        select="
                            concat(
                            'Q',
                            $anchor2Xs[last()],
                            ',',
                            $anchor2Ys[last()],
                            ' ',
                            $xPoints[last()],
                            ',',
                            $yPoints[last()])
                            "
                    />
                </xsl:variable>
                <path d="{string-join($bezierPath, ' ')}" stroke="black" stroke-width="1"
                    fill="none"/>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>

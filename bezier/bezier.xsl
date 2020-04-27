<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/bezier" package-version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:djb="http://www.obdurodon.org" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="#all" xmlns="http://www.w3.org/2000/svg"
    xmlns:html="http://www.w3.org/1999/xhtml" xmlns:svg="http://www.w3.org/2000/svg" version="3.0">

    <!-- ================================================================= -->
    <!-- Visibility                                                        -->
    <!--                                                                   -->
    <!-- Helper fuctions are all private                                   -->
    <!-- djb:bezier() (all three arities) are final                        -->
    <!-- $css and $cRadius are public                                      -->
    <!-- initial template is a fake to satisfy EE compiler                 -->
    <!-- ================================================================= -->
    <xsl:expose visibility="final" component="function"
        names="djb:bezier#3 djb:bezier#2 djb:bezier#1"/>
    <xsl:expose visibility="public" component="variable" names="css cRadius"/>

    <!-- ================================================================= -->
    <!-- Private functions                                                 -->
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- validate_points                                                   -->
    <!--                                                                   -->
    <!-- Return true if matches regex and at least 3 points                -->
    <!-- ================================================================= -->
    <xsl:function name="djb:validate_points" as="xs:boolean">
        <xsl:param name="pointPairs" as="xs:string+"/>
        <!-- https://stackoverflow.com/questions/12643009/regular-expression-for-floating-point-numbers -->
        <xsl:variable name="float_regex" as="xs:string"
            select="'[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)'"/>
        <xsl:variable name="pair_regex" as="xs:string"
            select="concat('^', $float_regex, ',', $float_regex, '$')"/>
        <xsl:sequence
            select="
                every $pointPair in $pointPairs
                    satisfies matches($pointPair, $pair_regex) and (count($pointPairs) ge 3)"
        />
    </xsl:function>

    <!-- ================================================================= -->
    <!-- split_points                                                      -->
    <!-- ================================================================= -->
    <xsl:function name="djb:split_points" as="xs:string+">
        <xsl:param name="all_points" as="xs:string"/>
        <xsl:sequence select="tokenize(normalize-space($all_points), ' ')"/>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- extract_xPoints                                                   -->
    <!-- ================================================================= -->
    <xsl:function name="djb:extract_xPoints" as="xs:double+">
        <xsl:param name="pointPairs" as="xs:string+"/>
        <xsl:sequence select="$pointPairs ! substring-before(., ',') ! xs:double(.)"/>
    </xsl:function>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- extract_yPoints                                                   -->
    <!-- ================================================================= -->
    <xsl:function name="djb:extract_yPoints" as="xs:double+">
        <xsl:param name="pointPairs" as="xs:string+"/>
        <xsl:sequence select="$pointPairs ! substring-after(., ',') ! xs:double(.)"/>
    </xsl:function>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- create_dirXs                                                      -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_dirXs" as="xs:double+">
        <xsl:param name="xPoints" as="xs:double+"/>
        <xsl:for-each select="1 to count($xPoints) - 2">
            <xsl:variable name="x1" as="xs:double" select="$xPoints[position() eq current()]"/>
            <xsl:variable name="x2" as="xs:double" select="$xPoints[position() eq current() + 2]"/>
            <xsl:sequence select="$x2 - $x1"/>
        </xsl:for-each>
    </xsl:function>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- create_dirYs                                                      -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_dirYs" as="xs:double+">
        <xsl:param name="yPoints" as="xs:double+"/>
        <xsl:for-each select="1 to count($yPoints) - 2">
            <xsl:variable name="y1" as="xs:double" select="$yPoints[position() eq current()]"/>
            <xsl:variable name="y2" as="xs:double" select="$yPoints[position() eq current() + 2]"/>
            <xsl:sequence select="$y2 - $y1"/>
        </xsl:for-each>
    </xsl:function>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- create_lengths                                                    -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_lengths" as="xs:double+">
        <xsl:param name="dirXs" as="xs:double+"/>
        <xsl:param name="dirYs" as="xs:double+"/>
        <xsl:for-each select="1 to count($dirXs)">
            <xsl:variable name="xDistance" as="xs:double" select="$dirXs[current()]"/>
            <xsl:variable name="yDistance" as="xs:double" select="$dirYs[current()]"/>
            <xsl:sequence
                select="(math:pow($xDistance, 2) + math:pow($yDistance, 2)) => math:sqrt()"/>
        </xsl:for-each>
    </xsl:function>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- create_unitXs                                                     -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_unitXs" as="xs:double+">
        <xsl:param name="dirXs" as="xs:double+"/>
        <xsl:param name="lengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($dirXs)">
            <xsl:sequence select="$dirXs[current()] div $lengths[current()]"/>
        </xsl:for-each>
    </xsl:function>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- create_unitYs                                                     -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_unitYs" as="xs:double+">
        <xsl:param name="dirYs" as="xs:double+"/>
        <xsl:param name="lengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($dirYs)">
            <xsl:sequence select="$dirYs[current()] div $lengths[current()]"/>
        </xsl:for-each>
    </xsl:function>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- create_normal1Xs : X coordinates of endpoint 1 of normals         -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_normal1Xs" as="xs:double+">
        <xsl:param name="unitYs" as="xs:double+"/>
        <xsl:sequence select="$unitYs ! (-1 * .)"/>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_normal1Ys : Y coordinates of endpoint 1 of normals         -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_normal1Ys" as="xs:double+">
        <xsl:param name="unitXs" as="xs:double+"/>
        <xsl:sequence select="$unitXs"/>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_normal2Xs : X coordinates of endpoint 2 of normals         -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_normal2Xs" as="xs:double+">
        <xsl:param name="unitYs" as="xs:double+"/>
        <xsl:sequence select="$unitYs"/>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_normal2Ys : Y coordinates of endpoint 2 of normals         -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_normal2Ys" as="xs:double+">
        <xsl:param name="unitXs" as="xs:double+"/>
        <xsl:sequence select="$unitXs ! (-1 * .)"/>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_angle1s : angle for normal1                                -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_angle1s" as="xs:double+">
        <xsl:param name="normal1Ys" as="xs:double+"/>
        <xsl:param name="normal1Xs" as="xs:double+"/>
        <xsl:for-each select="1 to count($normal1Ys)">
            <xsl:sequence
                select="math:atan2($normal1Ys[current()], $normal1Xs[current()]) + math:pi() div 2"
            />
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_angle2s : angle for normal2                                -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_angle2s" as="xs:double+">
        <xsl:param name="normal2Ys" as="xs:double+"/>
        <xsl:param name="normal2Xs" as="xs:double+"/>
        <xsl:for-each select="1 to count($normal2Ys)">
            <xsl:sequence
                select="math:atan2($normal2Ys[current()], $normal2Xs[current()]) + math:pi() div 2"
            />
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- $segLengths as xs:double+ :                                       -->
    <!--   diagonal distance between adjacent points                       -->
    <!-- ================================================================= -->
    <!-- ================================================================= -->
    <!-- create_xLengths : x distance between adjacent knots               -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_xLengths" as="xs:double+">
        <xsl:param name="xPoints" as="xs:double+"/>
        <xsl:for-each select="1 to count($xPoints) - 1">
            <xsl:sequence select="$xPoints[current() + 1] - $xPoints[current()]"/>
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_yLengths : y distance between adjacent knots               -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_yLengths" as="xs:double+">
        <xsl:param name="yPoints" as="xs:double+"/>
        <xsl:for-each select="1 to count($yPoints) - 1">
            <xsl:sequence select="$yPoints[current() + 1] - $yPoints[current()]"/>
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_segLengths : diagonal distance between adjacent knots      -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_segLengths" as="xs:double+">
        <xsl:param name="xLengths" as="xs:double+"/>
        <xsl:param name="yLengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($xLengths)">
            <xsl:sequence
                select="(math:pow($xLengths[current()], 2) + math:pow($yLengths[current()], 2)) => math:sqrt()"
            />
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_totalAnchorLengths : length of control line                -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_totalAnchorLengths" as="xs:double+">
        <xsl:param name="lengths" as="xs:double+"/>
        <xsl:param name="scaling" as="xs:double"/>
        <xsl:for-each select="1 to count($lengths)">
            <xsl:sequence select="$scaling * $lengths[current()]"/>
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_inAnchorLengths : lengths of incoming handles              -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_inAnchorLengths" as="xs:double+">
        <xsl:param name="totalAnchorLengths" as="xs:double+"/>
        <xsl:param name="segLengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($totalAnchorLengths)">
            <xsl:sequence
                select="
                    $totalAnchorLengths[current()] *
                    $segLengths[current()] div
                    ($segLengths[current()] + $segLengths[current() + 1])"
            />
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_outAnchorLengths : lengths of outgoing handles             -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_outAnchorLengths" as="xs:double+">
        <xsl:param name="totalAnchorLengths" as="xs:double+"/>
        <xsl:param name="segLengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($totalAnchorLengths)">
            <xsl:sequence
                select="
                    $totalAnchorLengths[current()] *
                    $segLengths[current() + 1] div
                    ($segLengths[current()] + $segLengths[current() + 1])"
            />
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_anchor1Xs : X for endpoint 1 of incoming handle            -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_anchor1Xs" as="xs:double+">
        <xsl:param name="xPoints" as="xs:double+"/>
        <xsl:param name="angle1s" as="xs:double+"/>
        <xsl:param name="inAnchorLengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($angle1s)">
            <xsl:sequence
                select="
                    $xPoints[current() + 1] +
                    math:cos($angle1s[current()]) * ($inAnchorLengths[current()])"
            />
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_anchor1Ys : Y for endpoint 1 of incoming handle            -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_anchor1Ys" as="xs:double+">
        <xsl:param name="yPoints" as="xs:double+"/>
        <xsl:param name="angle1s" as="xs:double+"/>
        <xsl:param name="inAnchorLengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($angle1s)">
            <xsl:sequence
                select="
                    $yPoints[current() + 1] +
                    math:sin($angle1s[current()]) * ($inAnchorLengths[current()])"
            />
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_anchor2Xs : X for endpoint 2 of incoming handle            -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_anchor2Xs" as="xs:double+">
        <xsl:param name="xPoints" as="xs:double+"/>
        <xsl:param name="angle2s" as="xs:double+"/>
        <xsl:param name="outAnchorLengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($angle2s)">
            <xsl:sequence
                select="
                    $xPoints[current() + 1] +
                    math:cos($angle2s[current()]) * ($outAnchorLengths[current()])"
            />
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_anchor2Ys : Y for endpoint 2 of incoming handle            -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_anchor2Ys" as="xs:double+">
        <xsl:param name="yPoints" as="xs:double+"/>
        <xsl:param name="angle2s" as="xs:double+"/>
        <xsl:param name="outAnchorLengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($angle2s)">
            <xsl:sequence
                select="
                    $yPoints[current() + 1] +
                    math:sin($angle2s[current()]) * ($outAnchorLengths[current()])"
            />
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- create_diagnostics : output diagnostics if $debug                 -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create_diagnostics" as="element(html:html)">
        <xsl:param name="dirXs" as="xs:double+"/>
        <xsl:param name="dirYs" as="xs:double+"/>
        <xsl:param name="lengths" as="xs:double+"/>
        <xsl:param name="unitXs" as="xs:double+"/>
        <xsl:param name="unitYs" as="xs:double+"/>
        <xsl:param name="normal1Xs" as="xs:double+"/>
        <xsl:param name="normal1Ys" as="xs:double+"/>
        <xsl:param name="normal2Xs" as="xs:double+"/>
        <xsl:param name="normal2Ys" as="xs:double+"/>
        <xsl:param name="angle1s" as="xs:double+"/>
        <xsl:param name="angle2s" as="xs:double+"/>
        <xsl:param name="anchor1Xs" as="xs:double+"/>
        <xsl:param name="anchor1Ys" as="xs:double+"/>
        <xsl:param name="anchor2Xs" as="xs:double+"/>
        <xsl:param name="anchor2Ys" as="xs:double+"/>
        <xsl:param name="totalAnchorLengths" as="xs:double+"/>
        <xsl:param name="inAnchorLengths" as="xs:double+"/>
        <xsl:param name="outAnchorLengths" as="xs:double+"/>
        <xsl:param name="scaling" as="xs:double"/>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Diagnostics</title>
                <style type="text/css"> table, tr, th, td { border: 1px black solid; } table {
                    border-collapse: collapse; } tr:nth-child(even) { background-color: lightgray; }
                    th, td { padding: 4px; }</style>
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
                    <xsl:for-each select="1 to count($dirXs) - 2">
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
                                <xsl:sequence select="$unitXs[current()] ! format-number(., '0.00')"
                                />
                            </td>
                            <!-- unit Y -->
                            <td>
                                <xsl:sequence select="$unitYs[current()] ! format-number(., '0.00')"
                                />
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
    </xsl:function>

    <!-- ================================================================= -->
    <!-- End of private functions                                          -->
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- SVG constants (public, may be overridden by caller)               -->
    <!--                                                                   -->
    <!-- $cRadius as xs:integer : radius of main and anchor points         -->
    <!-- $css as element(svg:style) : convenience variable                 -->
    <!-- ================================================================= -->
    <xsl:variable name="cRadius" as="xs:integer" select="2"/>
    <xsl:variable name="css" as="element(svg:style)">
        <style type="text/css"><![CDATA[
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
            }]]></style>
    </xsl:variable>
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- bezier#3                                                          -->
    <!-- ================================================================= -->
    <xsl:function name="djb:bezier" as="element()+">
        <!-- ============================================================= -->
        <!-- Function is called with points, scaling, and debug values     -->
        <!-- ============================================================= -->
        <xsl:param name="inputPoints" as="xs:string"/>
        <xsl:param name="scaling" as="xs:double"/>
        <xsl:param name="debug" as="xs:boolean"/>
        <!-- ============================================================= -->
        <!-- Get point pairs and validate points and scaling               -->
        <!-- ============================================================= -->
        <xsl:variable name="pointPairs" as="xs:string+" select="djb:split_points($inputPoints)"/>
        <xsl:if test="not(djb:validate_points($pointPairs))">
            <xsl:message terminate="yes" select="'Invalid points: ' || $inputPoints"/>
        </xsl:if>
        <xsl:if test="not($scaling ge 0 and $scaling le 1 and $scaling castable as xs:double)">
            <xsl:message terminate="yes" select="'Invalid scaling value: ' || $scaling"/>
        </xsl:if>

        <!-- ============================================================= -->
        <!-- Helper functions compute variables from parameters            -->
        <!-- ============================================================= -->
        <xsl:variable name="xPoints" as="xs:double+" select="djb:extract_xPoints($pointPairs)"/>
        <xsl:variable name="yPoints" as="xs:double+" select="djb:extract_yPoints($pointPairs)"/>
        <xsl:variable name="dirXs" as="xs:double+" select="djb:create_dirXs($xPoints)"/>
        <xsl:variable name="dirYs" as="xs:double+" select="djb:create_dirYs($yPoints)"/>
        <xsl:variable name="lengths" as="xs:double+" select="djb:create_lengths($dirXs, $dirYs)"/>
        <xsl:variable name="unitXs" as="xs:double+" select="djb:create_unitXs($dirXs, $lengths)"/>
        <xsl:variable name="unitYs" as="xs:double+" select="djb:create_unitYs($dirYs, $lengths)"/>
        <xsl:variable name="normal1Xs" as="xs:double+" select="djb:create_normal1Xs($unitYs)"/>
        <xsl:variable name="normal1Ys" as="xs:double+" select="djb:create_normal1Ys($unitXs)"/>
        <xsl:variable name="normal2Xs" as="xs:double+" select="djb:create_normal2Xs($unitYs)"/>
        <xsl:variable name="normal2Ys" as="xs:double+" select="djb:create_normal2Ys($unitXs)"/>
        <xsl:variable name="angle1s" as="xs:double+"
            select="djb:create_angle1s($normal1Ys, $normal1Xs)"/>
        <xsl:variable name="angle2s" as="xs:double+"
            select="djb:create_angle2s($normal2Ys, $normal2Xs)"/>
        <xsl:variable name="xLengths" as="xs:double+" select="djb:create_xLengths($xPoints)"/>
        <xsl:variable name="yLengths" as="xs:double+" select="djb:create_yLengths($yPoints)"/>
        <xsl:variable name="segLengths" as="xs:double+"
            select="djb:create_segLengths($xLengths, $yLengths)"/>
        <xsl:variable name="totalAnchorLengths" as="xs:double+"
            select="djb:create_totalAnchorLengths($lengths, $scaling)"/>
        <xsl:variable name="inAnchorLengths" as="xs:double+"
            select="djb:create_inAnchorLengths($totalAnchorLengths, $segLengths)"/>
        <xsl:variable name="outAnchorLengths" as="xs:double+"
            select="djb:create_outAnchorLengths($totalAnchorLengths, $segLengths)"/>
        <xsl:variable name="anchor1Xs" as="xs:double+"
            select="djb:create_anchor1Xs($xPoints, $angle1s, $inAnchorLengths)"/>
        <xsl:variable name="anchor1Ys" as="xs:double+"
            select="djb:create_anchor1Ys($yPoints, $angle1s, $inAnchorLengths)"/>
        <xsl:variable name="anchor2Xs" as="xs:double+"
            select="djb:create_anchor2Xs($xPoints, $angle2s, $outAnchorLengths)"/>
        <xsl:variable name="anchor2Ys" as="xs:double+"
            select="djb:create_anchor2Ys($yPoints, $angle2s, $outAnchorLengths)"/>
        <!-- ============================================================= -->
        <!-- Draw the graph                                                -->
        <!-- ============================================================= -->
        <g>
            <!-- ===================================================== -->
            <!-- CSS (public variable, may be overridden)              -->
            <!-- ===================================================== -->
            <xsl:sequence select="$css"/>
            <!-- ===================================================== -->
            <!-- Background                                            -->
            <!-- ===================================================== -->
            <rect x="0" y="0" width="500" height="300" stroke="black" stroke-width="1"
                class="backgroundColor"/>
            <!-- ===================================================== -->
            <!-- Data points and connecting lines                      -->
            <!-- ===================================================== -->
            <xsl:for-each select="1 to count($xPoints)">
                <circle class="mainCircle" cx="{$xPoints[current()]}" cy="{$yPoints[current()]}"
                    r="{$cRadius}"/>
            </xsl:for-each>
            <xsl:if test="$debug">
                <polyline class="mainLine" points="{$inputPoints}"/>
            </xsl:if>
            <!-- ===================================================== -->
            <!-- Alternating (hypotenuse) lines                        -->
            <!-- ===================================================== -->
            <xsl:if test="$debug">
                <xsl:for-each select="0, 1">
                    <polyline class="alternatingLine"
                        points="{$pointPairs[position() mod 2 eq current()]}"/>
                </xsl:for-each>
            </xsl:if>
            <!-- ===================================================== -->
            <!-- Anchor points and lines                               -->
            <!-- ===================================================== -->
            <xsl:if test="$debug">
                <xsl:for-each select="1 to count($xPoints)">
                    <line class="anchorLine" x1="{$anchor1Xs[current()]}"
                        y1="{$anchor1Ys[current()]}" x2="{$anchor2Xs[current()]}"
                        y2="{$anchor2Ys[current()]}"/>
                    <circle class="anchorCircle1" cx="{$anchor1Xs[current()]}"
                        cy="{$anchor1Ys[current()]}" r="{$cRadius}"/>
                    <circle class="anchorCircle2" cx="{$anchor2Xs[current()]}"
                        cy="{$anchor2Ys[current()]}" r="{$cRadius}"/>
                </xsl:for-each>
            </xsl:if>
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
                <xsl:for-each select="2 to (count($xPoints) - 2)">
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
            <path d="{string-join($bezierPath, ' ')}" stroke="black" stroke-width="1" fill="none"/>
        </g>
        <xsl:if test="$debug">
            <xsl:sequence
                select="djb:create_diagnostics($dirXs, $dirYs, $lengths, $unitXs, $unitYs, $normal1Xs, $normal1Ys, $normal2Xs, $normal2Ys, $angle1s, $angle2s, $anchor1Xs, $anchor1Ys, $anchor2Xs, $anchor2Ys, $totalAnchorLengths, $inAnchorLengths, $outAnchorLengths, $scaling)"
            />
        </xsl:if>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- bezier#2                                                          -->
    <!-- ================================================================= -->
    <xsl:function name="djb:bezier" as="element()+">
        <!-- ============================================================= -->
        <!-- Function is called with points, scaling, but not debug        -->
        <!-- ============================================================= -->
        <xsl:param name="inputPoints" as="xs:string"/>
        <xsl:param name="scaling" as="xs:double"/>
        <xsl:sequence select="djb:bezier($inputPoints, $scaling, false())"/>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- bezier#1                                                          -->
    <!-- ================================================================= -->
    <xsl:function name="djb:bezier" as="element()+">
        <!-- ============================================================= -->
        <!-- Function is called with points, scaling, but not debug        -->
        <!-- ============================================================= -->
        <xsl:param name="inputPoints" as="xs:string"/>
        <xsl:sequence select="djb:bezier($inputPoints, 0.4, false())"/>
    </xsl:function>

    <xsl:template name="fake" visibility="public"/>
</xsl:package>

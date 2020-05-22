<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/spline" package-version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:djb="http://www.obdurodon.org" xmlns:f="http://www.obdurodon.org/function-variables"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/2000/svg" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:svg="http://www.w3.org/2000/svg" version="3.0">

    <!-- ================================================================ -->
    <!-- Package dependencies                                             -->
    <!-- ================================================================ -->
    <xsl:use-package name="http://www.obdurodon.org/plot-lib"/>
    <!-- ================================================================ -->

    <!-- ================================================================= -->
    <!-- Visibility                                                        -->
    <!--                                                                   -->
    <!-- Helper fuctions are all private                                   -->
    <!-- djb:spline() (all three arities) are final                        -->
    <!-- $css and $cRadius are public                                      -->
    <!-- ================================================================= -->
    <xsl:expose visibility="final" component="function"
        names="
        djb:spline#3
        djb:spline#2
        djb:spline#1"/>
    <xsl:expose visibility="public" component="variable" names="css cRadius"/>

    <!-- ================================================================= -->
    <!-- Private functions                                                 -->
    <!-- ================================================================= -->

    <xsl:function name="djb:extract-Xs" as="xs:double+">
        <!-- ============================================================= -->
        <!-- extract-Xs                                                    -->
        <!-- ============================================================= -->
        <xsl:param name="f:point-pairs" as="xs:string+"/>
        <xsl:sequence select="$f:point-pairs ! substring-before(., ',') ! xs:double(.)"/>
    </xsl:function>

    <xsl:function name="djb:extract-yS" as="xs:double+">
        <!-- ============================================================= -->
        <!-- extract-Ys                                                    -->
        <!-- ============================================================= -->
        <xsl:param name="f:point-pairs" as="xs:string+"/>
        <xsl:sequence select="$f:point-pairs ! substring-after(., ',') ! xs:double(.)"/>
    </xsl:function>

    <xsl:function name="djb:create-dir-Xs" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-dir-Xs                                                 -->
        <!-- ============================================================= -->
        <xsl:param name="f:Xs" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:Xs) - 2">
            <xsl:variable name="f:x1" as="xs:double" select="$f:Xs[position() eq current()]"/>
            <xsl:variable name="f:x2" as="xs:double" select="$f:Xs[position() eq current() + 2]"/>
            <xsl:sequence select="$f:x2 - $f:x1"/>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-dir-Ys" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-dir-Ys                                                 -->
        <!-- ============================================================= -->
        <xsl:param name="f:Ys" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:Ys) - 2">
            <xsl:variable name="f:y1" as="xs:double" select="$f:Ys[position() eq current()]"/>
            <xsl:variable name="f:y2" as="xs:double" select="$f:Ys[position() eq current() + 2]"/>
            <xsl:sequence select="$f:y2 - $f:y1"/>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-lengths" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-lengths                                                -->
        <!-- ============================================================= -->
        <xsl:param name="f:dir-Xs" as="xs:double+"/>
        <xsl:param name="f:dir-Ys" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:dir-Xs)">
            <xsl:variable name="f:x-distance" as="xs:double" select="$f:dir-Xs[current()]"/>
            <xsl:variable name="f:y-distance" as="xs:double" select="$f:dir-Ys[current()]"/>
            <xsl:sequence
                select="(math:pow($f:x-distance, 2) + math:pow($f:y-distance, 2)) => math:sqrt()"/>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-unit-Xs" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-unit-Xs                                                -->
        <!-- ============================================================= -->
        <xsl:param name="f:dir-Xs" as="xs:double+"/>
        <xsl:param name="f:lengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:dir-Xs)">
            <xsl:sequence select="$f:dir-Xs[current()] div $f:lengths[current()]"/>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-unit-Ys" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-unit-Ys                                                -->
        <!-- ============================================================= -->
        <xsl:param name="f:dir-Ys" as="xs:double+"/>
        <xsl:param name="f:lengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:dir-Ys)">
            <xsl:sequence select="$f:dir-Ys[current()] div $f:lengths[current()]"/>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-normal1-Xs" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-normal1-Xs : X coordinates of endpoint 1 of normals    -->
        <!-- ============================================================= -->
        <xsl:param name="f:unit-Ys" as="xs:double+"/>
        <xsl:sequence select="$f:unit-Ys ! (-1 * .)"/>
    </xsl:function>

    <xsl:function name="djb:create-normal1-Ys" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-normal1-Ys : Y coordinates of endpoint 1 of normals    -->
        <!-- ============================================================= -->
        <xsl:param name="f:unit-Xs" as="xs:double+"/>
        <xsl:sequence select="$f:unit-Xs"/>
    </xsl:function>

    <xsl:function name="djb:create-normal2-Xs" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-normal2-Xs : X coordinates of endpoint 2 of normals    -->
        <!-- ============================================================= -->
        <xsl:param name="f:unit-Ys" as="xs:double+"/>
        <xsl:sequence select="$f:unit-Ys"/>
    </xsl:function>

    <xsl:function name="djb:create-normal2-Ys" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-normal2-Ys : Y coordinates of endpoint 2 of normals    -->
        <!-- ============================================================= -->
        <xsl:param name="f:unit-Xs" as="xs:double+"/>
        <xsl:sequence select="$f:unit-Xs ! (-1 * .)"/>
    </xsl:function>

    <xsl:function name="djb:create-angle1s" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-angle1s : angle for normal1                            -->
        <!-- ============================================================= -->
        <xsl:param name="f:normal1-Ys" as="xs:double+"/>
        <xsl:param name="f:normal1-Xs" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:normal1-Ys)">
            <xsl:sequence
                select="math:atan2($f:normal1-Ys[current()], $f:normal1-Xs[current()]) + math:pi() div 2"
            />
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-angle2s" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create_angle2s : angle for normal2                            -->
        <!-- ============================================================= -->
        <xsl:param name="f:normal2-Ys" as="xs:double+"/>
        <xsl:param name="f:normal2-Xs" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:normal2-Ys)">
            <xsl:sequence
                select="math:atan2($f:normal2-Ys[current()], $f:normal2-Xs[current()]) + math:pi() div 2"
            />
        </xsl:for-each>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- $seg-lengths as xs:double+ :                                      -->
    <!--   diagonal distance between adjacent points                       -->
    <!-- ================================================================= -->
    <xsl:function name="djb:create-xLengths" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-xLengths : x distance between adjacent knots           -->
        <!-- ============================================================= -->
        <xsl:param name="f:xPoints" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:xPoints) - 1">
            <xsl:sequence select="$f:xPoints[current() + 1] - $f:xPoints[current()]"/>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-yLengths" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-yLengths : y distance between adjacent knots           -->
        <!-- ============================================================= -->
        <xsl:param name="f:yPoints" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:yPoints) - 1">
            <xsl:sequence select="$f:yPoints[current() + 1] - $f:yPoints[current()]"/>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-seg-lengths" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-seg-lengths : diagonal distance between adjacent knots -->
        <!-- ============================================================= -->
        <xsl:param name="f:xLengths" as="xs:double+"/>
        <xsl:param name="f:yLengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:xLengths)">
            <xsl:sequence
                select="(math:pow($f:xLengths[current()], 2) + math:pow($f:yLengths[current()], 2)) => math:sqrt()"
            />
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-total-anchor-lengths" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-total-anchor=lengths : length of control line          -->
        <!-- ============================================================= -->
        <xsl:param name="f:lengths" as="xs:double+"/>
        <xsl:param name="f:scaling" as="xs:double"/>
        <xsl:for-each select="1 to count($f:lengths)">
            <xsl:sequence select="$f:scaling * $f:lengths[current()]"/>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-in-anchor-lengths" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-in-anchor-lengths : lengths of incoming handles        -->
        <!-- ============================================================= -->
        <xsl:param name="f:total-anchor-lengths" as="xs:double+"/>
        <xsl:param name="f:seg-lengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:total-anchor-lengths)">
            <xsl:sequence
                select="
                    $f:total-anchor-lengths[current()] *
                    $f:seg-lengths[current()] div
                    ($f:seg-lengths[current()] + $f:seg-lengths[current() + 1])"
            />
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-out-anchor-lengths" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-out-anchor-lengths : lengths of outgoing handles       -->
        <!-- ============================================================= -->
        <xsl:param name="f:total-anchor-lengths" as="xs:double+"/>
        <xsl:param name="f:seg-lengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:total-anchor-lengths)">
            <xsl:sequence
                select="
                    $f:total-anchor-lengths[current()] *
                    $f:seg-lengths[current() + 1] div
                    ($f:seg-lengths[current()] + $f:seg-lengths[current() + 1])"
            />
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-anchor1-Xs" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-anchor1-Xs : X for endpoint 1 of incoming handle       -->
        <!-- ============================================================= -->
        <xsl:param name="f:xPoints" as="xs:double+"/>
        <xsl:param name="f:angle1s" as="xs:double+"/>
        <xsl:param name="fin-anchor-lengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:angle1s)">
            <xsl:sequence
                select="
                    $f:xPoints[current() + 1] +
                    math:cos($f:angle1s[current()]) * ($fin-anchor-lengths[current()])"
            />
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-anchor1-Ys" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-anchor1-Ys : Y for endpoint 1 of incoming handle       -->
        <!-- ============================================================= -->
        <xsl:param name="f:yPoints" as="xs:double+"/>
        <xsl:param name="f:angle1s" as="xs:double+"/>
        <xsl:param name="f:in-anchor-lengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:angle1s)">
            <xsl:sequence
                select="
                    $f:yPoints[current() + 1] +
                    math:sin($f:angle1s[current()]) * ($f:in-anchor-lengths[current()])"
            />
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-anchor2-Xs" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-anchor2-Xs : X for endpoint 2 of incoming handle       -->
        <!-- ============================================================= -->
        <xsl:param name="f:xPoints" as="xs:double+"/>
        <xsl:param name="f:angle2s" as="xs:double+"/>
        <xsl:param name="f:out-anchor-lengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:angle2s)">
            <xsl:sequence
                select="
                    $f:xPoints[current() + 1] +
                    math:cos($f:angle2s[current()]) * ($f:out-anchor-lengths[current()])"
            />
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-anchor2-Ys" as="xs:double+">
        <!-- ============================================================= -->
        <!-- create-anchor2-Ys : Y for endpoint 2 of incoming handle       -->
        <!-- ============================================================= -->
        <xsl:param name="f:yPoints" as="xs:double+"/>
        <xsl:param name="f:angle2s" as="xs:double+"/>
        <xsl:param name="f:out-anchor-lengths" as="xs:double+"/>
        <xsl:for-each select="1 to count($f:angle2s)">
            <xsl:sequence
                select="
                    $f:yPoints[current() + 1] +
                    math:sin($f:angle2s[current()]) * ($f:out-anchor-lengths[current()])"
            />
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="djb:create-diagnostics" as="element(html:html)">
        <!-- ============================================================= -->
        <!-- create-diagnostics : output diagnostics if $debug             -->
        <!-- ============================================================= -->
        <xsl:param name="f:dir-Xs" as="xs:double+"/>
        <xsl:param name="f:dir-Ys" as="xs:double+"/>
        <xsl:param name="f:lengths" as="xs:double+"/>
        <xsl:param name="f:unit-Xs" as="xs:double+"/>
        <xsl:param name="f:unit-Ys" as="xs:double+"/>
        <xsl:param name="f:normal1-Xs" as="xs:double+"/>
        <xsl:param name="f:normal1-Ys" as="xs:double+"/>
        <xsl:param name="f:normal2-Xs" as="xs:double+"/>
        <xsl:param name="f:normal2-Ys" as="xs:double+"/>
        <xsl:param name="f:angle1s" as="xs:double+"/>
        <xsl:param name="f:angle2s" as="xs:double+"/>
        <xsl:param name="f:anchor1-Xs" as="xs:double+"/>
        <xsl:param name="f:anchor1-Ys" as="xs:double+"/>
        <xsl:param name="f:anchor2-Xs" as="xs:double+"/>
        <xsl:param name="f:anchor2-Ys" as="xs:double+"/>
        <xsl:param name="f:total-anchorlengths" as="xs:double+"/>
        <xsl:param name="f:in-anchor-lengths" as="xs:double+"/>
        <xsl:param name="f:out-anchor-lengths" as="xs:double+"/>
        <xsl:param name="f:scaling" as="xs:double"/>
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
                    <xsl:for-each select="1 to count($f:dir-Xs)">
                        <tr>
                            <!-- Bézier number -->
                            <td>
                                <xsl:sequence select="."/>
                            </td>
                            <!-- dir X -->
                            <td>
                                <xsl:sequence select="$f:dir-Xs[current()]"/>
                            </td>
                            <!-- dir Y -->
                            <td>
                                <xsl:sequence select="$f:dir-Ys[current()]"/>
                            </td>
                            <!-- length of joining line -->
                            <td>
                                <xsl:sequence
                                    select="$f:lengths[current()] ! format-number(., '#.00')"/>
                            </td>
                            <!-- unit X -->
                            <td>
                                <xsl:sequence
                                    select="$f:unit-Xs[current()] ! format-number(., '0.00')"/>
                            </td>
                            <!-- unit Y -->
                            <td>
                                <xsl:sequence
                                    select="$f:unit-Ys[current()] ! format-number(., '0.00')"/>
                            </td>
                            <!-- normal 1 -->
                            <td>
                                <xsl:sequence
                                    select="
                                        string-join(
                                        (
                                        $f:normal1-Xs[current()] ! format-number(., '0.00'),
                                        $f:normal1-Ys[current()] ! format-number(., '0.00')
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
                                        $f:normal2-Xs[current()] ! format-number(., '0.00'),
                                        $f:normal2-Ys[current()] ! format-number(., '0.00')
                                        ),
                                        ', ')"
                                />
                            </td>
                            <!-- angle 1 -->
                            <td>
                                <xsl:sequence
                                    select="$f:angle1s[current()] ! format-number(., '0.00')"/>
                            </td>
                            <!-- angle 2 -->
                            <td>
                                <xsl:sequence
                                    select="$f:angle2s[current()] ! format-number(., '0.00')"/>
                            </td>
                            <!-- anchor 1 X -->
                            <td>
                                <xsl:sequence
                                    select="$f:anchor1-Xs[current()] ! format-number(., '0.00')"/>
                            </td>
                            <!-- anchor 1 Y-->
                            <td>
                                <xsl:sequence
                                    select="$f:anchor1-Ys[current()] ! format-number(., '0.00')"/>
                            </td>
                            <!-- anchor 2 X -->
                            <td>
                                <xsl:sequence
                                    select="$f:anchor2-Xs[current()] ! format-number(., '0.00')"/>
                            </td>
                            <!-- anchor 2 Y -->
                            <td>
                                <xsl:sequence
                                    select="$f:anchor2-Ys[current()] ! format-number(., '0.00')"/>
                            </td>
                            <!-- scaling factor (constant) -->
                            <td>
                                <xsl:sequence select="$f:scaling"/>
                            </td>
                            <!-- total length of control line -->
                            <td>
                                <xsl:sequence
                                    select="$f:total-anchorlengths[current()] ! format-number(., '0.00')"
                                />
                            </td>
                            <!-- in handle length -->
                            <td>
                                <xsl:sequence
                                    select="$f:in-anchor-lengths[current()] ! format-number(., '0.00')"
                                />
                            </td>
                            <!-- out handle length -->
                            <td>
                                <xsl:sequence
                                    select="$f:out-anchor-lengths[current()] ! format-number(., '0.00')"
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
    <!-- $css as element(svg:style) : style for debug output               -->
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
    <!-- spline#3                                                          -->
    <!-- ================================================================= -->
    <xsl:function name="djb:spline" as="element()+">
        <!-- ============================================================= -->
        <!-- Function is called with points, scaling, and debug values     -->
        <!-- ============================================================= -->
        <xsl:param name="f:point-pairs" as="xs:string+"/>
        <xsl:param name="f:scaling" as="xs:double"/>
        <xsl:param name="f:debug" as="xs:boolean"/>
        <!-- ============================================================= -->
        <!-- Get point pairs and validate points and scaling               -->
        <!-- ============================================================= -->
        <xsl:if test="not(djb:validate-points($f:point-pairs))">
            <xsl:message terminate="yes"
                select="'Invalid points: ' || string-join($f:point-pairs, ' : ')"/>
        </xsl:if>
        <xsl:if test="not($f:scaling ge 0 and $f:scaling le 1 and $f:scaling castable as xs:double)">
            <xsl:message terminate="yes" select="'Invalid scaling value: ' || $f:scaling"/>
        </xsl:if>

        <!-- ============================================================= -->
        <!-- Helper functions compute variables from parameters            -->
        <!-- ============================================================= -->
        <xsl:variable name="f:xPoints" as="xs:double+" select="djb:extract-Xs($f:point-pairs)"/>
        <xsl:variable name="f:yPoints" as="xs:double+" select="djb:extract-yS($f:point-pairs)"/>
        <xsl:variable name="f:dir-Xs" as="xs:double+" select="djb:create-dir-Xs($f:xPoints)"/>
        <xsl:variable name="f:dir-Ys" as="xs:double+" select="djb:create-dir-Ys($f:yPoints)"/>
        <xsl:variable name="f:lengths" as="xs:double+"
            select="djb:create-lengths($f:dir-Xs, $f:dir-Ys)"/>
        <xsl:variable name="f:unit-Xs" as="xs:double+"
            select="djb:create-unit-Xs($f:dir-Xs, $f:lengths)"/>
        <xsl:variable name="f:unit-Ys" as="xs:double+"
            select="djb:create-unit-Ys($f:dir-Ys, $f:lengths)"/>
        <xsl:variable name="f:normal1-Xs" as="xs:double+" select="djb:create-normal1-Xs($f:unit-Ys)"/>
        <xsl:variable name="f:normal1-Ys" as="xs:double+" select="djb:create-normal1-Ys($f:unit-Xs)"/>
        <xsl:variable name="f:normal2-Xs" as="xs:double+" select="djb:create-normal2-Xs($f:unit-Ys)"/>
        <xsl:variable name="f:normal2-Ys" as="xs:double+" select="djb:create-normal2-Ys($f:unit-Xs)"/>
        <xsl:variable name="f:angle1s" as="xs:double+"
            select="djb:create-angle1s($f:normal1-Ys, $f:normal1-Xs)"/>
        <xsl:variable name="f:angle2s" as="xs:double+"
            select="djb:create-angle2s($f:normal2-Ys, $f:normal2-Xs)"/>
        <xsl:variable name="f:xLengths" as="xs:double+" select="djb:create-xLengths($f:xPoints)"/>
        <xsl:variable name="f:yLengths" as="xs:double+" select="djb:create-yLengths($f:yPoints)"/>
        <xsl:variable name="f:seg-lengths" as="xs:double+"
            select="djb:create-seg-lengths($f:xLengths, $f:yLengths)"/>
        <xsl:variable name="f:total-anchor-lengths" as="xs:double+"
            select="djb:create-total-anchor-lengths($f:lengths, $f:scaling)"/>
        <xsl:variable name="f:in-anchor-lengths" as="xs:double+"
            select="djb:create-in-anchor-lengths($f:total-anchor-lengths, $f:seg-lengths)"/>
        <xsl:variable name="f:out-anchor-lengths" as="xs:double+"
            select="djb:create-out-anchor-lengths($f:total-anchor-lengths, $f:seg-lengths)"/>
        <xsl:variable name="f:anchor1-Xs" as="xs:double+"
            select="djb:create-anchor1-Xs($f:xPoints, $f:angle1s, $f:in-anchor-lengths)"/>
        <xsl:variable name="f:anchor1-Ys" as="xs:double+"
            select="djb:create-anchor1-Ys($f:yPoints, $f:angle1s, $f:in-anchor-lengths)"/>
        <xsl:variable name="f:anchor2-Xs" as="xs:double+"
            select="djb:create-anchor2-Xs($f:xPoints, $f:angle2s, $f:out-anchor-lengths)"/>
        <xsl:variable name="f:anchor2-Ys" as="xs:double+"
            select="djb:create-anchor2-Ys($f:yPoints, $f:angle2s, $f:out-anchor-lengths)"/>
        <!-- ============================================================= -->
        <!-- Draw the graph                                                -->
        <!-- ============================================================= -->
        <g>
            <!-- ===================================================== -->
            <!-- CSS (public variable, may be overridden) : debug only -->
            <!-- ===================================================== -->
            <xsl:if test="$f:debug">
                <xsl:sequence select="$css"/>
            </xsl:if>
            <!-- ===================================================== -->
            <!-- Background : debug only                               -->
            <!-- ===================================================== -->
            <xsl:if test="$f:debug">
                <rect x="0" y="0" width="500" height="300" stroke="black" stroke-width="1"
                    class="backgroundColor"/>
            </xsl:if>
            <!-- ===================================================== -->
            <!-- Data points and connecting lines : debug only         -->
            <!-- ===================================================== -->
            <xsl:if test="$f:debug">
                <xsl:for-each select="1 to count($f:xPoints)">
                    <circle class="mainCircle" cx="{$f:xPoints[current()]}"
                        cy="{$f:yPoints[current()]}" r="{$cRadius}"/>
                </xsl:for-each>
                <polyline class="mainLine" points="{$f:point-pairs}"/>
            </xsl:if>
            <!-- ===================================================== -->
            <!-- Alternating (hypotenuse) lines : debug only           -->
            <!-- ===================================================== -->
            <xsl:if test="$f:debug">
                <xsl:for-each select="0, 1">
                    <polyline class="alternatingLine"
                        points="{$f:point-pairs[position() mod 2 eq current()]}"/>
                </xsl:for-each>
            </xsl:if>
            <!-- ===================================================== -->
            <!-- Anchor points and lines : debug only                  -->
            <!-- ===================================================== -->
            <xsl:if test="$f:debug">
                <xsl:for-each select="1 to count($f:xPoints) - 2">
                    <line class="anchorLine" x1="{$f:anchor1-Xs[current()]}"
                        y1="{$f:anchor1-Ys[current()]}" x2="{$f:anchor2-Xs[current()]}"
                        y2="{$f:anchor2-Ys[current()]}"/>
                    <circle class="anchorCircle1" cx="{$f:anchor1-Xs[current()]}"
                        cy="{$f:anchor1-Ys[current()]}" r="{$cRadius}"/>
                    <circle class="anchorCircle2" cx="{$f:anchor2-Xs[current()]}"
                        cy="{$f:anchor2-Ys[current()]}" r="{$cRadius}"/>
                </xsl:for-each>
            </xsl:if>
            <!-- ===================================================== -->
            <!-- Plot the spline                                       -->
            <!-- ===================================================== -->
            <xsl:variable name="f:spline-path" as="xs:string+">
                <!-- ================================================= -->
                <!-- Start by moving to first point                    -->
                <!-- ================================================= -->
                <xsl:sequence
                    select="
                        concat(
                        'M',
                        $f:xPoints[1],
                        ',',
                        $f:yPoints[1])"/>
                <!-- ================================================= -->
                <!-- First curve is quadratic, with one control point  -->
                <!-- ================================================= -->
                <xsl:sequence
                    select="
                        concat(
                        'Q',
                        $f:anchor1-Xs[1],
                        ',',
                        $f:anchor1-Ys[1],
                        ' ',
                        $f:xPoints[2],
                        ',',
                        $f:yPoints[2])
                        "/>
                <!-- ================================================= -->
                <!-- All but first and last are cubic, with two        -->
                <!--   control points                                  -->
                <!-- ================================================= -->
                <xsl:for-each select="2 to (count($f:xPoints) - 2)">
                    <xsl:variable name="f:c1" as="xs:string"
                        select="$f:anchor2-Xs[current() - 1] || ',' || $f:anchor2-Ys[current() - 1]"/>
                    <xsl:variable name="f:c2" as="xs:string"
                        select="$f:anchor1-Xs[current()] || ',' || $f:anchor1-Ys[current()]"/>
                    <xsl:variable name="f:endP-point" as="xs:string"
                        select="$f:xPoints[current() + 1] || ',' || $f:yPoints[current() + 1]"/>
                    <xsl:value-of select="'C' || string-join(($f:c1, $f:c2, $f:endP-point), ' ')"/>
                </xsl:for-each>
                <!-- ================================================= -->
                <!-- Last curve is quadratic, with one control point   -->
                <!-- ================================================= -->
                <xsl:sequence
                    select="
                        concat(
                        'Q',
                        $f:anchor2-Xs[last()],
                        ',',
                        $f:anchor2-Ys[last()],
                        ' ',
                        $f:xPoints[last()],
                        ',',
                        $f:yPoints[last()])
                        "
                />
            </xsl:variable>
            <path d="{string-join($f:spline-path, ' ')}" class="spline" fill="none"/>
        </g>
        <xsl:if test="$f:debug">
            <xsl:sequence
                select="djb:create-diagnostics(
                $f:dir-Xs, 
                $f:dir-Ys, 
                $f:lengths, 
                $f:unit-Xs, 
                $f:unit-Ys, 
                $f:normal1-Xs, 
                $f:normal1-Ys, 
                $f:normal2-Xs, 
                $f:normal2-Ys, 
                $f:angle1s, 
                $f:angle2s, 
                $f:anchor1-Xs, 
                $f:anchor1-Ys, 
                $f:anchor2-Xs, 
                $f:anchor2-Ys, 
                $f:total-anchor-lengths, 
                $f:in-anchor-lengths, 
                $f:out-anchor-lengths, 
                $f:scaling)"
            />
        </xsl:if>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- spline#2                                                          -->
    <!-- ================================================================= -->
    <xsl:function name="djb:spline" as="element()+">
        <!-- ============================================================= -->
        <!-- Function is called with points, scaling, but not debug        -->
        <!-- ============================================================= -->
        <xsl:param name="f:point-pairs" as="xs:string+"/>
        <xsl:param name="f:scaling" as="xs:double"/>
        <xsl:sequence select="djb:spline($f:point-pairs, $f:scaling, false())"/>
    </xsl:function>

    <!-- ================================================================= -->
    <!-- spline#1                                                          -->
    <!-- ================================================================= -->
    <xsl:function name="djb:spline" as="element()+">
        <!-- ============================================================= -->
        <!-- Function is called with points, scaling, but not debug        -->
        <!-- ============================================================= -->
        <xsl:param name="f:point-pairs" as="xs:string+"/>
        <xsl:sequence select="djb:spline($f:point-pairs, 0.4, false())"/>
    </xsl:function>
</xsl:package>

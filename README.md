# plot

XSLT and SVG support for plotting

## To use

1. Clone the repo.
2. Edit *ee_config.xml* or *he_config.xml* to adapt for your filesystem locations.
3. The *regression*, *lowess*, *smoothing*. and *spline* packages can be incorporating into your code with `<xsl:use-package>`. The *lib* package is used by the others, and does not have to be imported directly.

## *regression functions*

The *regression* package draws a regression line. Support for drawing a parabola is under development.

```xpath
djb:regression_line($points as xs:string, $debug as xs:boolean) as (element(svg:g), map(*))
```

Argument | Type | Default | Meaning
----|----|----|----
`$points` | xs:string | *(required)* | A string that conforms to a subset of the syntax of the `@points` attribute of an SVG `<polyline>`, specifically, a whitespace-delimited sequence of `X,Y` coordinates, where the `X` and `Y` values are separated by a comma without intervening whitespace. For example, the string `"50,182 100,166 150,87 200,191 250,106"` describes five points. Each point may include a decimal point and may be preceded by `+` or `-`. `$debug` | xs:boolean | `False` | If set to `True`, the function returns debugging information along with the result.
*Result* | xs:string | *(none)* | If `$debug` is `False`, an SVG `<g>` element that contains just an SVG `<line>` element representing a regression line through the data points. The `<line>` element has on `@x1`, `@y1`, `x2`, and `@y2` attributes, plus a `@class` attribute with the value "regression", which can be used by the classing program to control the rendering (specifying values for `@stroke`, `stroke-width`, etc.). If `$debug` is `True`, the `<g>` also plots the original points and a connecting SVG `<polyline>` and specifies CSS for `@stroke` and `@stroke-width`.
*Result* | map(*) | *(none)* | A `map(*)` with `xs:double` values for "m" (slope) and "b" (intercept).

```xpath
djb:regression_line($points as xs:string) as element(svg:g)
```

Argument | Type | Default | Meaning
----|----|----|----
`$points` | xs:string | *(required)* | A string that conforms to a subset of the syntax of the `@points` attribute of an SVG `<polyline>`, specifically, a whitespace-delimited sequence of `X,Y` coordinates, where the `X` and `Y` values are separated by a comma without intervening whitespace. For example, the string `"50,182 100,166 150,87 200,191 250,106"` describes five points. Each point may include a decimal point and may be preceded by `+` or `-`. [Note: The syntax of the `$points` argument to our function is stricter than the syntax of the `@points` attribute for an SVG `<polyline>`, about which see <https://www.w3.org/TR/SVG11/shapes.html#PointsBNF>. The function raises a fatal error if `$points` does not match this pattern or if it includes fewer than three points.]
*Result* | xs:string | *(none)* | An SVG `<g>` element that contains just an SVG `<line>` element representing a regression line through the data points. The `<line>` element has on `@x1`, `@y1`, `x2`, and `@y2` attributes, plus a `@class` attribute with the value "regression", which can be used by the classing program to control the rendering (specifying values for `@stroke`, `stroke-width`, etc.). 

**Note:** The syntax of the `$points` argument is stricter than the syntax of the `@points` attribute for an SVG `<polyline>`, about which see <https://www.w3.org/TR/SVG11/shapes.html#PointsBNF>. The function raises a fatal error if `$points` does not match this pattern or if it includes fewer than three points.

## *smoothing functions*

The *smoothing* package implements a *simple moving average* by returning each input point with the `X` value unchanged, while the `Y` value is replaced by the average of the points within a window of size `$window` (default value is `3`) centered on the point at `X`. The windows is always the same size; if there are not enough points (toward the beginning and end of the sequence of points) to center the current point, missing points are made up on the other side. For example, with a window size of `3`, both the first and second points return the average of the first three points, and the fourth returns the average of the second, third, and fourth.

Smoothing reduces the extent of the impact of outliers, making it easier to see a trend. But because the average is not weighted, it is possible for the smoothed line to invert the trend locally, showing a peak where the original data shows a trough, and vice versa. The local weighted average provided by the *lowess* package reduces the impact of this artifact.

Argument | Type | Default | Meaning
----|----|----|----
`$points` | xs:string | *(required)* | A string that conforms to a subset of the syntax of the `@points` attribute of an SVG `<polyline>`, specifically, a whitespace-delimited sequence of `X,Y` coordinates, where the `X` and `Y` values are separated by a comma without intervening whitespace. For example, the string `"50,182 100,166 150,87 200,191 250,106"` describes five points. Each point may include a decimal point and may be preceded by `+` or `-`. [Note: The syntax of the `$points` argument to our function is stricter than the syntax of the `@points` attribute for an SVG `<polyline>`, about which see <https://www.w3.org/TR/SVG11/shapes.html#PointsBNF>. The function raises a fatal error if `$points` does not match this pattern or if it includes fewer than three points.]
`$window` | xs:integer | 3 | The number of points whose `Y` value is incorporated into the simple moving average returned for each input point. `$window` must be a positive odd number.
*Result* | xs:string | *(none)* | A string in the same format as `$points`, but with the `Y` values modified by smoothing.

**Notes:** The syntax of the `$points` argument is stricter than the syntax of the `@points` attribute for an SVG `<polyline>`, about which see <https://www.w3.org/TR/SVG11/shapes.html#PointsBNF>. The function raises a fatal error if `$points` does not match this pattern or if it includes fewer than three points. It also raises a fatal error if a value of `$window` is specified that is not a positive odd integer.
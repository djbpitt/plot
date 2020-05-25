# plot

**[NB: Documentation is out of sync with development]**

## Summary

XSLT functions for SVG plotting

### Functions for computing new points

* Linear smoothing
* [In progress] Weighted smoothing
* [In progress] LOWESS smoothing

### Functions for drawing SVG

* Linear regression lines
* [In progress] Linear regression parabolas
* Bézier splines

## Metadata

**Author:** David J. Birnbaum  
**Email:** djbpitt@gmail.com  
**URL:** <http://www.obdurodon.org>  
**Repo:** https://github.com/djbpitt/plot

## To use

1. Clone the repo.
2. Edit *ee_config.xml* or *he_config.xml* to adapt for your filesystem locations.
3. The *regression*, *lowess*, *smoothing*. and *spline* packages can be incorporating into your code with `<xsl:use-package>`. The *lib* package is used by the others, and does not have to be imported directly.

### Notes

1. All point data is assumed to be in SVG coordinates, that is, with negative Y pointing up and positive Y pointing down. Input data in regular Cartesian coordinates must be preprocessed accordingly.
2. Debug versions of the functions are intended to be run on their own. The subdirectories include driver XSLT stylesheets that generate sample output. Run with `saxon -config:path_to_config -it -xsl:driver_filename.xsl`.

## Regression line functions

### Synopsis

The `regression_line()` functions draw a regression line. Support for drawing a parabola is under development.

### Functions

```xpath
djb:regression_line($points as xs:string+, $debug as xs:boolean) as (element(svg:g), map(*))
```

Argument | Type | Default | Meaning
----|----|----|----
`$points` | xs:string+ | *(required)* | A sequence of at least three strings, representing points in SVG coordinate space, each of which has the form `X,Y`, so that the `X` and `Y` values are separated by a comma without intervening whitespace. For example, the input `"50,182", "100,166", "150,87", "200,191", "250,106"` describes five points. Each `X` and `Y` value may include a decimal point and may be preceded by `+` or `-`.
`$debug` | xs:boolean | `False` | If set to `True`, the function returns debugging information, in the form of a map, along with the primary SVG `<g>` result.
*Result* | element(svg:g) | *(none)* | If `$debug` is `False`, an SVG `<g>` element that contains just an SVG `<line>` element representing a regression line through the data points. The `<line>` element has on `@x1`, `@y1`, `x2`, and `@y2` attributes, plus a `@class` attribute with the value "regression", which can be used by the classing program to control the rendering (specifying values for `@stroke`, `stroke-width`, etc.). If `$debug` is `True`, the `<g>` also plots the original points and a connecting SVG `<polyline>`, includes a background SVG `<rect>`, and specifies CSS for `@stroke` and `@stroke-width`.
*Result* | map(*) | *(none)* | If `$debug` is `True`, in addition to the SVG `<g>` element, a `map(*)` with `xs:double` values for "m" (slope) and "b" (intercept) is returned. If `$debug` is `False`, this map is not returned.

#### Note

The function raises a fatal error if:

1. `$points` contains fewer than three strings, each representing a point, or
2. any point does not match the pattern `X,Y`, with no whitespace and where `X` and `Y` are doubles with optional leading `+` or `-` signs, or
3. X is not ordered monotonically (consecutive equal values are allowed).

____

```xpath
djb:regression_line($points as xs:string+) as element(svg:g)
```

Argument | Type | Default | Meaning
----|----|----|----
`$points` | xs:string+ | *(required)* | A sequence of at least three strings, representing points in SVG coordinate space, each of which has the form `X,Y`, so that the `X` and `Y` values are separated by a comma without intervening whitespace. For example, the input `"50,182", "100,166", "150,87", "200,191", "250,106"` describes five points. Each `X` and `Y` value may include a decimal point and may be preceded by `+` or `-`.
*Result* | element(svg:g) | *(none)* | An SVG `<g>` element that contains just an SVG `<line>` element representing a regression line through the data points. The `<line>` element has on `@x1`, `@y1`, `x2`, and `@y2` attributes, plus a `@class` attribute with the value "regression", which can be used by the classing program to control the rendering (specifying values for `@stroke`, `stroke-width`, etc.). 

#### Notes

1. The function raises a fatal error if:
	1. `$points` contains fewer than three strings, each representing a point, or
	2. any point does not match the pattern `X,Y`, with no whitespace and where `X` and `Y` are doubles with optional leading `+` or `-` signs, or
	3. X is not ordered monotonically (consecutive equal values are allowed).
2. The arity-1 version of `djb:regression_line()` is equivalent to calling the arity-2 version and specifying `False` as the value of the `$debug` argument.

## Smoothing functions

### Synopsis

The *smoothing* package implements a *simple moving average* by returning each input point with the `X` value unchanged, while the `Y` value is replaced by the average of the points within a window of size `$window` (default value is `3`) centered on the point at `X`. The windows is always the same size; if there are not enough points (toward the beginning and end of the sequence of points) to center the current point, missing points are made up on the other side. For example, with a window size of `3`, both the first and second points return the average of the first three points, and the fourth returns the average of the second, third, and fourth.

Smoothing reduces the extent of the impact of outliers, making it easier to see a trend. But because the neighboring points carry as much weight as the central one, a local peak or trough does not mean the correspnding original data point is necessarily higher (resp. lower) than its immediate neighors.

### Functions

```xpath
djb:smoothing($points as xs:string+, $window as xs:integer) as xs:string+
```

Argument | Type | Default | Meaning
----|----|----|----
`$points` | xs:string | *(required)* | A sequence of at least three strings, representing points in SVG coordinate space, each of which has the form `X,Y`, so that the `X` and `Y` values are separated by a comma without intervening whitespace. For example, the input `"50,182", "100,166", "150,87", "200,191", "250,106"` describes five points. Each `X` and `Y` value may include a decimal point and may be preceded by `+` or `-`.
`$window` | xs:integer | 3 | The number of points whose `Y` value is incorporated into the simple moving average returned for each input point. `$window` must be a positive odd number.
*Result* | xs:string+ | *(none)* | A sequence of strings in the same format as `$points`, but with the `Y` values modified by smoothing.

#### Notes

The function raises a fatal error if:

1. `$points` contains fewer than three strings, each representing a point, or
2. any point does not match the pattern `X,Y`, with no whitespace and where `X` and `Y` are doubles with optional leading `+` or `-` signs, or
3. X is not ordered monotonically (consecutive equal values are allowed), or
4. `$window` is not an odd positive integer.

```xpath
djb:smoothing($points as xs:string+) as xs:string+
```

Argument | Type | Default | Meaning
----|----|----|----
`$points` | xs:string | *(required)* | A sequence of at least three strings, representing points in SVG coordinate space, each of which has the form `X,Y`, so that the `X` and `Y` values are separated by a comma without intervening whitespace. For example, the input `"50,182", "100,166", "150,87", "200,191", "250,106"` describes five points. Each `X` and `Y` value may include a decimal point and may be preceded by `+` or `-`.
*Result* | xs:string+ | *(none)* | A sequence of strings in the same format as `$points`, but with the `Y` values modified by smoothing.

#### Notes

1. The function raises a fatal error if:
	1. `$points` contains fewer than three strings, each representing a point, or
	2. any point does not match the pattern `X,Y`, with no whitespace and where `X` and `Y` are doubles with optional leading `+` or `-` signs, or
	3. X is not ordered monotonically (consecutive equal values are allowed).
2. The arity-1 version of `djb:smoothing()` is equivalent to calling the arity-2 version and specifying `3` as the value of the `$window` argument.

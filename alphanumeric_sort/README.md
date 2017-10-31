# Alphanumeric sorting

Helena Bermúdez Sabel and David J. Birnbaum (<mailto:djbpitt@gmail.com>)  
2017-10-30  
<https://github.com/djbpitt/xstuff/alphanumeric_sort>

## Abstract

This report describes a strategy for sorting, in an XQuery environment, data that mixes letters, digits and other characters in an unpredictable way. The [accompanying sample code](alphanumeric_sort.xquery) includes sample input data, and can be run in eXist-db (<http://exist-db.org>).

## The problem

The _Repertorium of Old Bulgarian literature and letters_ (<http://repertorium.obdurodon.org>) renders lists of article titles that may combine letters, digits, punctuation, and space characters in unpredictable ways. These titles must be sorted for rendering, but:

* Alphabetic sorting would fail to sort numeric data correctly. For example, “Andriantis: homily 11” would sort before “Andriantis: homily 2”.
* Numeric sorting is inappropriate for alphabetic data because, using `order by number($title)`, all `$title` values that contain non-digits would be converted, identically, to NaN. 
* Tokenizing the titles and then sorting and subsorting on the parts is inappropriate because the order of numeric and non-numeric parts is unpredictable (see the data set included in the [accompanying sample code](alphanumeric_sort.xquery)). For that matter, some whitespace-separated tokens combine digits and non-digits, e.g., “Interpretation of the 129th psalm”.

An adequate solution should be sort any titles of the sort that occur in the _Repertorium_ in a culturally sensible way, regardless of the Unicode character properties (letter, number [digit], punctuation, separator [space]) of the individual characters. The largest number currently found in the _Repertorium_ titles is the Byzantine year 7000 (representing the Julian/Gregorian year 1492), and it is unlikely that larger numbers will be found. Supporting arbitrary extended data (such as examples with very large numbers, or in writing systems not used in the _Repertorium_) is not a goal.

## Normalization strategy

This strategy adopted here creates a normalized _shadow_ copy of each title, which it uses for sorting. The shadow copy also incorporates other useful normalizations: specifically, it converts all text to lower case, it normalizes whitespace, and it treats all sequences of punctuation as equivalent to any single punctuation character. The code depends on the Unicode character classes `\p{L}` (alphabetic), `\d` (digits), `\p{P}` (punctuation), and `\s` (whitespace), which are normalized as follows:

* **Whitespace** is normalized using the XPath `normalize-space()` function, so that leading and trailing whitespace is stripped and internal sequences of whitespace characters are represented by a single U+0020 (decimal 32) character.
* **Numbers**, no matter how many digits they include, are converted to single Unicode characters equal to the decimal value of the number plus x21 (decimal 33), so that their values will begin at U+0021. The resulting characters lie within registered part of the BMP.
* **Letters** are lower-cased and then have their code point value added to xE000 (decimal 57344), so that their values will begin at U+E000. This is within the BMP PUA.
* **Series of punctuation characters** are collapsed into a single instance of U+F8FF (decimal 63743), which is at the top of the BMP PUA.

The key to this strategy is that any number that occurs in the titles, regardless of the number of digits it contains, is converted to a single Unicode character. This means that all sorting, even of numbers, can be treated as if alphabetic. White space sorts first, after which all numbers sort before all letters (as in ASCII), and punctuation sorts last. 

The use of analyze-string() is based on  
<http://www.biglist.com/lists/lists.mulberrytech.com/xsl-list/archives/201710/msg00032.html>.
The sample data in the [accompanying sample code](alphanumeric_sort.xquery) are from <http://repertorium.obdurodon.org>.

## How it works

The main code is a simple FLWOR:

```xquery
for $i in $data
let $shadow := local:shadow($i)
order by $shadow
return $i
```

The normalization is performed by the following `local:shadow()` function:

```xquery
declare function local:shadow($in) {
    let $norm as xs:string := lower-case(normalize-space($in))
    return
        string-join(analyze-string($norm, '\d+|\p{P}+|\p{L}')/* ! (
        if (. instance of element(fn:match) and matches(., '\d+')) then
            codepoints-to-string(number(.) + 32)
        else
            if (. instance of element(fn:match) and matches(., '\p{P}+')) then
                codepoints-to-string(63743)
            else
                if (. instance of element(fn:match) and matches(., '\p{L}')) then
                    codepoints-to-string(string-to-codepoints(.) + 57344)
                else
                    if (. eq ' ') then
                        .
                    else
                        if (. instance of element(fn:non-match)) then
                            'NON-MATCH ERROR'
                        else
                            ()))
};
```

After lower-casing the input and normalizing whitespace, we use the XPath `analyze-string()` function (<https://www.w3.org/TR/xpath-functions-31/#func-analyze-string>) to match sequences of digits, sequences of punctuation characters, and single letters. This returns a wrapper element that contains a sequence of `<match>` and `<non-match>` elements in the “http://www.w3.org/2005/xpath-functions” namespace, which in eXist-db is bound by default to the prefix `fn:`. We use the result of the `analyze-string()` function as the beginning of an XPath expression, navigate to its (`<match>` and `<non-match>`) children, and use the XPath simple map operator (`!`; <https://www.w3.org/TR/xpath-31/#id-map-operator>) to handle different types of matches and non-matches correctly. The treatment of sequences of digits, sequences of punctuation, individual letters, and space characters is described above, under “Normalization strategy”.

## Example

The [accompanying sample code](alphanumeric_sort.xquery) can be executed in eXist-db to demonstrate the implementation.
____

Tested in eXist-db 3.4.1 (<http://exist-db.org>). We are grateful to Martin Honnen for pointing us in the right direction in <http://www.biglist.com/lists/lists.mulberrytech.com/xsl-list/archives/201710/msg00032.html>.


# Flattening and raising XML hierarchies

## Files

* `original.xml`: the original XML test file
* `flatten.xsl`: converts `original.xml` to `flattened.xml` by flattening all elements except the root
* `flattened.xml`: the result of the flattening operation
* `raise.xsl`: converts the flattened markup of `flattened.xml` to `raised.xml`, which has regular hierarchical markup, with wrapper elements
* `raised.xml`: the result of the raising operation

## How it works

### Original input

`original.xml` is a sample XML file with four levels of element hierarchy. At its deepest, `<root>` contains `<p>`, which contains `<phrase>`, which contains `<word>`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<root>
    <p>This is a <word>paragraph</word> that contains some stuff.</p>
    <p>This is another paragraph <phrase><word>that</word>
            <word>contains</word>
            <word>more</word></phrase> stuff.</p>
</root>
```

### Flattening the XML

Generate a flattened version of `original.xml` with:

```bash
saxon -xsl:flatten.xsl -s:original.xml -o:flattened.xml
```

The flattening process involves converting all start-tags and end-tags (except those for the root element) to empty elements with two new attributes:

* `@djb:n` is a unique identifier associated with the original input element. The new empty elements that replace start- and end-tags for the same original input element have the same `@djb:n` value. The raising routine matches the `@djb:n` values in order to pair up the flattened start- and end-tags correctly.
* `@djb:type` has the value `'start'` for original start-tags and `'end'` for original end tags. 

The `@djb:n` and `@djb:type` attributes are namespaced to avoid conflicts with non-namespaced `@n` or `@type` attributes that may already be present in the source document.

The `flatten.xsl` stylesheet looks as follows:

```xslt
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="no"/>
    <xsl:template match="/*">
        <xsl:copy>
            <xsl:namespace name="djb" select="'http://www.obdurodon.org'"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:attribute name="djb:n" select="generate-id()"/>
            <xsl:attribute name="djb:type" select="'start'"/>
        </xsl:element>
        <xsl:apply-templates/>
        <xsl:element name="{name()}">
            <xsl:attribute name="djb:n" select="generate-id()"/>
            <xsl:attribute name="djb:type" select="'end'"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
```

We turn off indentation (line 6, `<xsl:output method="xml" indent="no">`) to ensure that flattening and raising do not impose whitespace changes. We let the built-in templates take care of the document node and `text()` nodes. In this demo we ignore attribute nodes; in Real Life you’ll want to copy them. 

The only two templates are for element nodes. The first (lines 7–12) matches the root node and returns it without flattening; this is necessary to ensure that the output XML is well formed, that is, that it has a single element that wraps the entire content. We add the `djb` namespace node to the root for cosmetic reasons; if it isn’t present on the root element, it winds up getting specified multiple times internally, which makes the document harder to read. The other template (lines 12–23) matches all other elements; creates the new empty elements, with their `@djb:n` and `@djb:type` attributes, as replacements for the original start- and end-tags; and, between those new empty elements, applies templates to the children of the input element.

The output (`flattened.xml`) looks like the following (newline characters have been introduced manually in this report for legibility):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<root xmlns:djb="http://www.obdurodon.org">
    <p djb:n="d1e3" djb:type="start"/>This is a <word djb:n="d1e5" djb:type="start"/>paragraph<word
        djb:n="d1e5" djb:type="end"/> that contains some stuff.<p djb:n="d1e3" djb:type="end"/>
    <p djb:n="d1e9" djb:type="start"/>This is another paragraph <phrase djb:n="d1e11"
        djb:type="start"/><word djb:n="d1e12" djb:type="start"/>that<word djb:n="d1e12"
        djb:type="end"/>
    <word djb:n="d1e15" djb:type="start"/>contains<word djb:n="d1e15" djb:type="end"/>
    <word djb:n="d1e18" djb:type="start"/>more<word djb:n="d1e18" djb:type="end"/><phrase
        djb:n="d1e11" djb:type="end"/> stuff.<p djb:n="d1e9" djb:type="end"/>
</root>
```

### Raising a hierarchy

Raise a real hierarchy from the flattened file with:

```bash
saxon -xsl:raise.xsl -s:flattened.xml -o:raised.xml
```

The result of raising looks identical to the original (`original.xml`) input, except for insignificant whitespace. The raising process works from the inside out, that is, it first finds pairs of corresponding flattened start- and end-tags that do not contain any other flattened start- and end-tags, and it reforms them into a wrapper element with real start- and end-tags. The process is then applied recursively to the result of that first transformation, and again until there are no more elements with `@djb:type` attributes.

The `raise.xsl` file looks as follows:

```xslt
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    exclude-result-prefixes="#all">
    <xsl:output method="xml" indent="no"/>
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:function name="djb:raise">
        <xsl:param name="input" as="document-node()"/>
        <xsl:choose>
            <xsl:when test="exists($input//@djb:type)">
                <xsl:variable name="result" as="document-node()">
                    <xsl:document>
                        <xsl:apply-templates select="$input" mode="loop"/>
                    </xsl:document>
                </xsl:variable>
                <xsl:sequence select="djb:raise($result)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:template match="/">
        <xsl:sequence select="djb:raise(.)"/>
    </xsl:template>
    <xsl:template match="/" mode="loop">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template
        match="*[@djb:type eq 'start'][@djb:n eq following-sibling::*[@djb:type eq 'end'][1]/@djb:n]">
        <!-- innermost start-tag -->
        <xsl:element name="{name()}">
            <!-- textual content of raised element-->
            <xsl:copy-of
                select="following-sibling::node()[following-sibling::*[@djb:n eq current()/@djb:n]]"
            />
        </xsl:element>
    </xsl:template>
    <!-- nodes inside new wrapper -->
    <xsl:template
        match="node()[preceding-sibling::*[@djb:type eq 'start'][1]/@djb:n eq following-sibling::*[@djb:type eq 'end'][1]/@djb:n]"/>
    <!-- end-tag for new wrapper -->
    <xsl:template
        match="*[@djb:type eq 'end'][preceding-sibling::*[@djb:type eq 'start'][1]/@djb:n eq current()/@djb:n]"
    />
</xsl:stylesheet>
```

We turn off indentation (line 5) to avoid deforming the whitespace. `@exclude-result-prefixes="#all"` is not enough to avoid writing the `djb` namespace onto the root element of the output, even though the namespace in question is not used the output. An unused namespace declaration is informationally harmless, but also needlessly distracting, so we suppress it by spelling out the identity template (for all modes) and specifying `@copy-namespaces="no"` on `<xsl:copy>`inside it (lines 6–10).

Our recursive raising operation (the `djb:raise()` function, lines 11–26) operates on document nodes, and we need to process the original document node of the input file differently from the new document nodes that we create on each pass through the recursive function. For that reason, we match the original document node in no mode (`<xsl:template match="/">`, lines 27–29) and pass it into the raising function (`<xsl:sequence select="djb:raise(.)"/>`, line 28).

The raising function checks for the presence of `@djb:type` attributes in the input (`<xsl:when test="exists($input//@djb:type)">`, line 14). If there aren’t any (`<xsl:otherwise>`, lines 22–24), the recursion is finished, and the function returns the result (`<xsl:sequence select="$input"/>`, line 23). If there are still `@djb:type` attributes in the text, we create a variable `$result` (lines 15–19) of type `document` and apply templates inside the newly created document node (line 17). After the application of templates is finished, we recurse and pass the result into another invocation of `djb:raise()` (`<xsl:sequence select="djb:raise($result)"/>`, line 20).

The application of templates within the recursive function begins by applying templates to the (newly created) document node in `loop` mode (`<xsl:apply-templates select="$input" mode="loop"/>`, line 17). The matching template (lines 30–32) simply applies templates to its children, unlike the template that matches the original document node (in no mode, lines 27–29), which passes the document into the `djb:raise()` function (line 28), a difference in mode that is needed to avoid an endless loop. All other processing is the same for both the original document and the interim documents created inside `djb:raise()`, so `<xsl:template match="/" mode="loop">` (lines 30–32) is the only modal template, and it applies templates to its children in no mode.

There are three templates that do the actual processing of the innermost elements to be raised on each recursion: one that processes the start-tag, one that processes the content of the newly raised element, and one that processes the corresponding end-tag:

* **start-tag:** We match elements with a `@djb:type` value of `'start'` that have an `@djb:n` value equal to the `@djb:n` value of their first following sibling element that has a `@djb:type` value of `'end'` (line 34). This, then, matches only start-tags that contain nothing but `text()` nodes and elements that have already been raised (from which the `@djb:type` attributes that were present in the input have been discarded). In other words, it matches only the innermost flattened elements, those that do not contain any other empty flattened elements. We process these hits by creating a wrapper element with the same generic identifier as the start-tag and copying all following-sibling nodes that precede the end-tag that matches the start-tag we’re processing at the moment (lines 36–41). In other words, we copy the content of the newly raised element into it.
* **nodes inside the new wrapper:** Since we have already copied the content of the newly raised element inside it, we don’t want to process those nodes again, since that would create duplicates. For that reason, we match all nodes between the start- and end-tags that we’re processing at the moment and suppress them by matching them inside an empty `<xsl:template>` element (lines 44–45).
* **end-tag:** Since we create real start- and end-tags when we match the flattened start-tag, we have no more use for the flattened end-tag, so we suppress it by matching it, too, inside an empty `<xsl:template>` element (lines 47–48).

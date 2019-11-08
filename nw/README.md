# Needleman Wunsch in XSLT 3.0

Needleman Wunsch dynamic programming sequence alignment using XSLT 3.0 `<xsl:iterate>`.

* [nw_01.xsl](./nw_01.xsl) Naïve implementation. Uses `<xsl:iterate>` to avoid recursive overflow, but fails to use `<xsl:for-each>` where possible. Constructs grid from left to right and top to bottom, instead of on diagonal. Traverses grid to retrieve optimal path only after completion.
* [nw_02.xsl]() Iterates on the diagonal, but uses `<xsl:for-each>` within each diagonal, including `@saxon:threads` to parallelize (only in Saxon EE). Still traverses grid to retrieve optimal pathh only after completion.
* [nw_03.xsl]() Augments [nw_02.xsl]() by writing full path into each cell, avoiding backward traversal and making it possible to discard diagonals once they are no longer needed.

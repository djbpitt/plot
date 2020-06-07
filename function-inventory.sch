<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:pattern>
        <sch:p>Elements, but not text() nodes</sch:p>
        <sch:rule context="description | arity">
            <sch:report
                test="count(index-of(string-to-codepoints(.) ! codepoints-to-string(.), '.')) eq 1"
                    ><sch:value-of select="name()"/> should not end in a period unless it consists
                of more than one sentence.</sch:report>
        </sch:rule>
        <sch:rule context="arity/code">
            <sch:assert test="starts-with(., '$f:')">FUnction names must have a $f: namespace
                prefix</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:p>text() nodes in separate pattern to avoid clashes</sch:p>
        <sch:rule context="text()[not(parent::code)]">
            <sch:report test="contains(., '$')">Dollar signs should not appear except inside code
                elements</sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>

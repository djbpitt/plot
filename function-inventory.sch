<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:pattern>
        <sch:rule context="description | arity">
            <sch:report
                test="count(index-of(string-to-codepoints(.) ! codepoints-to-string(.), '.')) eq 1"
                    ><sch:value-of select="name()"/> should not end in a period unless it consists
                of more than one sentence.</sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>

(: Alphanumeric sort test :)
(:
Helena Bermúdez Sabel and David J. Birnbaum (djbpitt@gmail.com)
2017-10-30
https://github.com/djbpitt/xstuff/alphanumeric_sort

This sample supports the sorting of mixed alphanumeric data irrespective of how the letters and
numbers are combined. It also normalizes whitespace and treats all punctuation as equivalent.
It depends on the Unicode character classes \p{L} (alphabetic), \d (digits), \p{P} (punctuation),
and \s (whitespace).

Whitespace is normalized using normalize-space(), so that sequences of whitespace characters are
represented by a single U+0020 (decimal 32) character.

Numbers, no matter how many digits they include, are converted to single Unicode characters equal 
to their decimal value plus x21 (decimal 33), so that their values will begin at U+0021. This is 
within registered parts of the BMP.

Letters are lower-cased and then have their code point value added to xE000 (decimal 57344), so that 
their values will begin at U+E000. This is within the BMP PUA.

Series of punctuation characters are collapsed into a single instance of U+F8FF (decimal 63743),
which is at the top of the BMP PUA.

In this way, white space sorts first, after which all numbers sort before all letters (as in 
ASCII), and all sorting, even of numbers, can be treated as if alphabetic. 

The use of analyze-string() is based on  
http://www.biglist.com/lists/lists.mulberrytech.com/xsl-list/archives/201710/msg00032.html.
The included sample data are from http://repertorium.obdurodon.org.
:)
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
                            'UNKNOWN ERROR'))
};

declare variable $data as element(option)+ :=
(<option>Acts of the Apostles</option>,
<option>Acts of the Apostles 1: 1-15</option>,
<option>Acts of the Apostles 12: 1–11</option>,
<option>Acts of the Apostles 14: 6–18</option>,
<option>Acts of the Apostles 20: 7–12</option>,
<option>Acts of the Apostles 23: 9–11</option>,
<option>Acts of the Apostles 28: 1–31</option>,
<option>Acts of the Apostles 10: 21–33</option>,
<option>Acts of the Apostles 12: 12–17</option>,
<option>Acts of the Apostles 13: 13–17</option>,
<option>Acts of the Apostles 17: 23–27</option>,
<option>Acts of the Apostles 18: 22–28</option>,
<option>Acts of the Apostles 25: 13–19</option>,
<option>Acts of the Apostles 27: 1–44, 28: 1</option>,
<option>Acts of the Apostles 10: 44–48, 11: 1–10</option>,
<option>Acts of the Apostles 19: 1–4, 6–8</option>,
<option>Acts of the Apostles 10: 34–39, 39–43</option>,
<option>Acts of the Apostles 11: 19–22, 22–30</option>,
<option>Acts of the Apostles 20: 16–18, 28–31</option>,
<option>Acts of the Apostles 12: 25–13: 12</option>,
<option>Acts of the Apostles Andrew and Matthew</option>,
<option>Andriantis: homily 1</option>,
<option>Andriantis: homily 2</option>,
<option>Andriantis: homily 3</option>,
<option>Andriantis: homily 4</option>,
<option>Andriantis: homily 5</option>,
<option>Andriantis: homily 6</option>,
<option>Andriantis: homily 7</option>,
<option>Andriantis: homily 8</option>,
<option>Andriantis: homily 9</option>,
<option>Andriantis: homily 10</option>,
<option>Andriantis: homily 11</option>,
<option>Andriantis: homily 12</option>,
<option>Andriantis: homily 13</option>,
<option>Andriantis: homily 14</option>,
<option>Andriantis: homily 15</option>,
<option>Andriantis: homily 16</option>,
<option>Andriantis: homily 17</option>,
<option>Andriantis: homily 18</option>,
<option>Andriantis: homily 19</option>,
<option>Andriantis: homily 20</option>,
<option>Andriantis: homily 21</option>,
<option>Andriantis: homily 22</option>,
<option>Epistles. 1 J 3: 21–4: 11</option>,
<option>Epistles. 1 J 4: 20–5: 16</option>,
<option>Epistles. Acts of the Apostles 13: 25–29</option>,
<option>Epistles. E 5: 6</option>,
<option>Epistles. E 5: 8-20</option>,
<option>Epistles. E 1: 3–12</option>,
<option>Epistles. E 5: 8–19</option>,
<option>Epistles. E 1: 16–23</option>,
<option>Epistles. E 2: 11–13</option>,
<option>Epistles. E 6: 10–17</option>,
<option>Epistles. G 4: 4-7</option>,
<option>Epistles. G 5: 22–26, 6: 1–2</option>,
<option>Epistles. H 12: 1-10</option>,
<option>Epistles. H 2: 11-18</option>,
<option>Epistles. H 7: 1–6</option>,
<option>Epistles. H 4: 1–13</option>,
<option>Epistles. H 3: 15–19</option>,
<option>Epistles. H 7: 18–25</option>,
<option>Epistles. H 5: 11–14, H 5: 14–6: 8</option>,
<option>Epistles. H 9: 9–10: 11</option>,
<option>Epistles. 1J 3: 18–22</option>,
<option>Epistles. Jc 5: 16</option>,
<option>Epistles. Jud 1: 16–25</option>,
<option>Epistles. 2K 6: 16 - 7: 1</option>,
<option>Epistles. 2K 4: 6-16</option>,
<option>Epistles. 2K 9: 6-11</option>,
<option>Epistles. 1K 15: 39-45</option>,
<option>Epistles. Kol 3: 4–11</option>,
<option>Epistles. Kol 1: 12–18</option>,
<option>Epistles. 2P 1: 10–19</option>,
<option>Epistles. R 5: 20</option>,
<option>Epistles. R 12: 1 - 3: 1</option>,
<option>Epistles. R 7: 1–7</option>,
<option>Epistles. R 7: 6–7</option>,
<option>Epistles. R 1: 1–17</option>,
<option>Epistles. R 3: 7–18</option>,
<option>Epistles. R 4: 4–12</option>,
<option>Epistles. R 1: 18–24</option>,
<option>Epistles. R 2: 10–16</option>,
<option>Epistles. R 2: 14–21</option>,
<option>Epistles. R 3: 19–26</option>,
<option>Epistles. R 4: 13–25</option>,
<option>Epistles. R 5: 10–16</option>,
<option>Epistles. R 1: 28–2: 9</option>,
<option>Epistles. R 5: 17–6: 2</option>,
<option>Epistles. R 13: 11–14: 4</option>,
<option>Epistles. R 11: 3–??</option>,
<option>Epistles. 1T 1: 15-17</option>,
<option>Epistles. 1T 4: 8–16</option>,
<option>Epistles. 2T 4: 9–22</option>,
<option>Epistles. 1T 6: 17–21</option>,
<option>Epistles. 2T 2: 20–26</option>,
<option>Epistles. 2T 3: 16–17, 4: 1–4</option>,
<option>Epistles. 1T 5: 22–23, 1T 5: 25, 6: 1–2 (?)</option>,
<option>Epistles. 2T 1–9</option>,
<option>Epistles. Tt 2: 11-15, 3: 1-7</option>,
<option>Epistles. Tt 1: 5–16, 2: 1</option>,
<option>Epistles. Tt 1: 5–16, 2: 1–10</option>,
<option>Epistles. Tt 1: 4–5, 3: 1–2, 12–15</option>,
<option>Erotapokriseis</option>,
<option>Interpretation of the 5th psalm</option>,
<option>Interpretation of the 7th psalm</option>,
<option>Interpretation of the 129th psalm</option>,
<option>Interpretation of the 139th psalm</option>,
<option>Interpretation of the true faith</option>,
<option>The Gospel according to John</option>,
<option>The Gospel according to John. J 6: 40-44</option>,
<option>The Gospel according to Luke</option>,
<option>The Gospel according to Luke. L 6: 1-10</option>,
<option>The Gospel according to Luke. L 11: 1-13</option>,
<option>The Gospel according to Luke. L 1: 24-38</option>,
<option>The Gospel according to Luke. L 6: 31-35</option>,
<option>The Gospel according to Luke. L 12: 32-40</option>,
<option>The Gospel according to Luke. L 18: 10-14</option>,
<option>The Gospel according to Mark</option>,
<option>The Gospel according to Mark. Mk 10: 32-45</option>,
<option>The Gospel according to Mark. Mk 5:1-20</option>,
<option>The Gospel according to Mark. Mk 4:12-23</option>,
<option>The Gospel according to Mark. Mk 4:24-34</option>,
<option>The Gospel according to Mark. Mk 4:35-41</option>,
<option>The Gospel according to Mark. Mk 5:22-6:1</option>,
<option>The Gospel according to Matthew</option>,
<option>The Gospel according to Matthew. Mt 2: 1-12</option>,
<option>The Gospel according to Matthew. Mt 9: 9-13</option>,
<option>The Gospel according to Matthew. Mt 20: 1-16</option>,
<option>The Gospel according to Matthew. Mt 23: 1-12</option>,
<option>The Gospel according to Matthew. Mt 3: 13-17</option>,
<option>The Gospel according to Matthew. Mt 15: 21-28</option>);
for $i in $data
let $shadow := local:shadow($i)
order by $shadow
return
    $i
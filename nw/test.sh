#!/usr/bin/env bash
for i in {1..15}
do
  echo "$i paragraph(s)"
  java -Xms24G -Xmx24G -jar /Users/djb/bin/saxon_ee/saxon9ee.jar -sa -it -o:/dev/null -repeat:10 nw_ee.xsl paragraph_count=$i output_grid=true
done


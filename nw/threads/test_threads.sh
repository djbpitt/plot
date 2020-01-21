#!/usr/bin/env bash
for j in {7..15}
do
    for i in {1..10}
        do
          echo "$j paragraph(s) with $i thread(s)" >> /dev/stderr
          java -Xms24G -Xmx24G -jar /Users/djb/bin/saxon_ee/saxon9ee.jar -sa -it -o:/dev/null -repeat:10 nw_ee_threads.xsl paragraph_count=$j output_grid=false threads=$i >> /dev/stderr
          # java -Xms24G -Xmx24G -jar /usr/local/Cellar/saxon/9.9.1.4/libexec/saxon9he.jar -it -o:/dev/null -repeat:10 nw_he.xsl paragraph_count=$i output_grid=false
        done
done


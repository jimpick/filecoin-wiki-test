#! /bin/bash

lotus client list-deals -v > tmp/list-deals.txt
for x in *.zip.??.??; do
  if [ -f $x.deal ]; then
    echo $x 1>&2
    echo $x
    cat $x*.deal > tmp/deals.txt
    grep -f tmp/deals.txt tmp/list-deals.txt | sort -k2
    echo
  fi
done

#lotus client list-deals -v | grep -f ~/tmp/deals.txt  | sort -k2 | tee ~/tmp/check.out

#for f in *.zip.*.deal; do
#	echo $f
#	lotus client list-deals -v | grep `cat $f`
#done

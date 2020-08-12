#! /bin/bash

for x in *.zip.??; do
	cat $x*.deal > ~/tmp/deals.txt
	COUNT=$(lotus client list-deals -v | grep -f ~/tmp/deals.txt | sort -k2 | wc -l)
	echo $x $COUNT
done

#lotus client list-deals -v | grep -f ~/tmp/deals.txt  | sort -k2 | tee ~/tmp/check.out

#for f in *.zip.*.deal; do
#	echo $f
#	lotus client list-deals -v | grep `cat $f`
#done

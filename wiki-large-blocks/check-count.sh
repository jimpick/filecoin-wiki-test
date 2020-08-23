#! /bin/bash

lotus client list-deals -v > tmp/list-deals.txt
for x in *.zip.??; do
	cat $x*.deal > ~/tmp/deals.txt
	COUNT=$(cat tmp/list-deals.txt | grep -f ~/tmp/deals.txt | wc -l)
	ACTIVE_COUNT=$(cat tmp/list-deals.txt | grep -f ~/tmp/deals.txt | grep Active | wc -l)
	SEALING_COUNT=$(cat tmp/list-deals.txt | grep -f ~/tmp/deals.txt | grep Sealing | wc -l)
	TRANSFERRING_COUNT=$(cat tmp/list-deals.txt | grep -f ~/tmp/deals.txt | grep Transferring | wc -l)
	ERROR_COUNT=$(cat tmp/list-deals.txt -v | grep -f ~/tmp/deals.txt | grep Error | wc -l)
	echo $x $COUNT Active: $ACTIVE_COUNT Sealing: $SEALING_COUNT Xfr: $TRANSFERRING_COUNT Error: $ERROR_COUNT
done

#lotus client list-deals -v | grep -f ~/tmp/deals.txt  | sort -k2 | tee ~/tmp/check.out

#for f in *.zip.*.deal; do
#	echo $f
#	lotus client list-deals -v | grep `cat $f`
#done

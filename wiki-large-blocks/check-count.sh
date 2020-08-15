#! /bin/bash

for x in *.zip.??; do
	cat $x*.deal > ~/tmp/deals.txt
	COUNT=$(lotus client list-deals -v | grep -f ~/tmp/deals.txt | wc -l)
	ACTIVE_COUNT=$(lotus client list-deals -v | grep -f ~/tmp/deals.txt | grep Active | wc -l)
	SEALING_COUNT=$(lotus client list-deals -v | grep -f ~/tmp/deals.txt | grep Sealing | wc -l)
	TRANSFERRING_COUNT=$(lotus client list-deals -v | grep -f ~/tmp/deals.txt | grep Transferring | wc -l)
	ERROR_COUNT=$(lotus client list-deals -v | grep -f ~/tmp/deals.txt | grep Error | wc -l)
	echo $x $COUNT Active: $ACTIVE_COUNT Sealing: $SEALING_COUNT Xfr: $TRANSFERRING_COUNT Error: $ERROR_COUNT
done

#lotus client list-deals -v | grep -f ~/tmp/deals.txt  | sort -k2 | tee ~/tmp/check.out

#for f in *.zip.*.deal; do
#	echo $f
#	lotus client list-deals -v | grep `cat $f`
#done

#! /bin/bash

for x in *.zip.??; do
	echo $x
	cat $x*.deal > ~/tmp/deals.txt
	lotus client list-deals -v | grep -f ~/tmp/deals.txt  | sort -k2 | grep 'Transferring\|CheckForAcceptance'
done


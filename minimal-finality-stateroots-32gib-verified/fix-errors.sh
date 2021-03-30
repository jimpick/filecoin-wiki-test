#! /bin/bash

./check.sh  | grep 'Error' | tee ./tmp/errors.txt
DEALS=$(cat ./tmp/errors.txt | awk '{ print $4 }' | grep ^bafy)

for d in $DEALS; do
	echo $d
	DEAL_FILES=$(grep -l $d *.deal)
	echo $DEAL_FILES
	rm $DEAL_FILES
done

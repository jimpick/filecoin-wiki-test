#! /bin/bash

./check.sh  | grep 'Error' | tee ./tmp/errors.txt
DEALS=$(cat ./tmp/errors.txt | awk '{ print $1 }')

for d in $DEALS; do
	echo $d
	DEAL_FILES=$(grep -l $d wiki*.deal)
	echo $DEAL_FILES
	rm $DEAL_FILES
done

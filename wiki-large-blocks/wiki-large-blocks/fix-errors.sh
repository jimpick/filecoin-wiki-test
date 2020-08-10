#! /bin/bash

DEALS=$(./check.sh  | grep 'Error' | awk '{ print $1 }')

for d in $DEALS; do
	echo $d
	DEAL_FILES=$(grep -l $d wiki*.deal)
	echo $DEAL_FILES
	rm $DEAL_FILES
done

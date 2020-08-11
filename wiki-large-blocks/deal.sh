#! /bin/bash

#set -x
set -e

MINER=$1

if [ -z "$MINER" ]; then
	echo "Need miner"
	exit 1
fi

lotus wallet balance

count=0
total=`ls wiki*.cid | wc -l`
for f in wiki*.cid; do
	echo $f $((++count)) of $total
	DEAL_FILE=$(echo $f | sed 's,\.cid,,').deal
	DEAL_FILE_MINER=$(echo $f | sed 's,\.cid,,').$MINER.deal
	if [ -f "$DEAL_FILE" -o -f "$DEAL_FILE_MINER" ]; then
		echo "$DEAL_FILE" or "$DEAL_FILE_MINER" exists, skipping
	else
		timeout -k 25s 20s lotus client query-ask $MINER
		#lotus client deal `cat $f` $MINER 0.000000000000000006 600000 | tee -a $DEAL_FILE
		lotus client deal `cat $f`  $MINER 0.000000000125000000 600000 | tee -a $DEAL_FILE
		cp $DEAL_FILE $DEAL_FILE_MINER
		lotus wallet balance
		exit
	fi
done

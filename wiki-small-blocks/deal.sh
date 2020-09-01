#! /bin/bash

CLIENT=$(lotus state lookup `lotus wallet default`)
#echo Client: $CLIENT

#set -x
set -e

MINER=$1

if [ -z "$MINER" ]; then
	echo "Need miner"
	exit 1
fi

FREE=$(df -h . | tail -1 | awk '{ print $4 }')
echo $CLIENT: $(lotus wallet balance) "($FREE free)"

count=0
total=`ls wiki*.$CLIENT.import | wc -l`
for IMPORT_FILE in wiki*.$CLIENT.import; do
	#echo $f $((++count)) of $total
	BASE=$(echo $IMPORT_FILE | sed 's,\.t[0-9]*\.import,,')
	if [ ! -f $IMPORT_FILE ]; then
		continue
	fi
	DEAL_FILE=$BASE.$CLIENT.deal
	CID_FILE=$BASE.cid
	DEAL_FILE_MINER=$BASE.$CLIENT.$MINER.deal
	DEAL_FILES=$(ls $BASE.*.$MINER.deal $BASE.$MINER.deal 2> /dev/null || true)
	#echo Jim $BASE $DEAL_FILE_MINER
	if [ -f "$DEAL_FILE" -o -n "$DEAL_FILES" ]; then
		#echo "$DEAL_FILE" or other deals exist, skipping
		echo -n .
		echo $((++count)) > /dev/null
	else
		echo
		echo $BASE $((++count)) of $total
		timeout -k 25s 20s lotus client query-ask $MINER
		#lotus client deal `cat $f` $MINER 0.000000000000000006 600000 | tee -a $DEAL_FILE
		lotus client deal `cat $CID_FILE`  $MINER 0.000000000125000000 600000 | tee -a $DEAL_FILE
		cp $DEAL_FILE $DEAL_FILE_MINER
		#echo $CLIENT: $(lotus wallet balance)
		exit
	fi
done

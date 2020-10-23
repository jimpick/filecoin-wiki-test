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
total=`ls *.cid | wc -l`
for CID_FILE in `ls *.cid | grep -v wiki.aa`; do
	#echo $f $((++count)) of $total
	BASE=$(echo $CID_FILE | sed 's,\.cid,,')
	DEAL_FILE=$BASE.$CLIENT.deal
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
		echo Miner: $MINER
    CID=$(cat $CID_FILE)
		echo CID: $CID
		#lotus client deal # interactive
    echo 'Press enter to start deal'
    read
    ./deal-tool/deal-tool -cid=$CID -miner=$MINER # Expect-style scripting
		lotus client list-deals -v | tail -1 | awk '{ print $4 }' > $DEAL_FILE
		cp $DEAL_FILE $DEAL_FILE_MINER
		#echo $CLIENT: $(lotus wallet balance)
		exit
	fi
done

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

mkdir -p skip-miners
if [ -f "skip-miners/$MINER" ]; then
  echo "Skipping $MINER:" $(cat skip-miners/$MINER)
  exit 0
fi

FREE=$(df -h . | tail -1 | awk '{ print $4 }')
echo $CLIENT: $(lotus wallet balance) "($FREE free)"
lotus state market balance $CLIENT
echo Datacap: $(./check-datacap.sh)

count=0
total=`ls *.cid.store | wc -l`
# for CID_FILE in `ls *.cid | grep -v wiki.02 | grep -v wiki.09 | grep -v wiki.04`; do
for CID_FILE in `ls *.cid.store`; do
  FREE_DISK=$(df . | tail -1 | awk '{ print $4 }')
  if [ "$FREE_DISK" -lt 50000000 ]; then
    echo "Out of disk space"
    df -h .
    touch drain
  fi
  if [ -f drain ]; then
    echo 'Draining, exiting...'
    sleep 5
    exit
  fi

	#echo $f $((++count)) of $total
	BASE=$(echo $CID_FILE | sed 's,\.cid.store,,')
	DEAL_FILE=$BASE.$CLIENT.deal
	DEAL_FILE_MINER=$BASE.$CLIENT.$MINER.deal
	DEAL_FILES=$(ls $BASE.*.$MINER.deal $BASE.$MINER.deal 2> /dev/null || true)
	#echo Jim $BASE $DEAL_FILE_MINER
	if [ -f "$DEAL_FILE" -o -n "$DEAL_FILES" ]; then
		#echo "$DEAL_FILE" or other deals exist, skipping
		echo -n .
		echo $((++count)) > /dev/null
	else
		echo error-ask > skip-miners/$MINER
		echo $BASE $((++count)) of $total
		timeout -k 25s 20s lotus client query-ask $MINER
    rm skip-miners/$MINER
		#lotus client deal `cat $f` $MINER 0.000000000000000006 600000 | tee -a $DEAL_FILE
		echo Miner: $MINER
    CID=$(cat $CID_FILE)
		echo CID: $CID
		#lotus client deal # interactive
    #echo 'Press enter to start deal'
    #read
    timeout -k 905s 900s ../deal-tool/deal-tool -verified -cid=$CID -miner=$MINER -dealfile=$DEAL_FILE # Expect-style scripting
		#lotus client list-deals -v | tail -1 | awk '{ print $4 }' > $DEAL_FILE
		cp $DEAL_FILE $DEAL_FILE_MINER
		#echo $CLIENT: $(lotus wallet balance)
		exit
	fi
done

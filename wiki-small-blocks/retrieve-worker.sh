#! /bin/bash

CLIENT=$(lotus state lookup `lotus wallet default`)
#echo Client: $CLIENT
mkdir -p retrievals/$CLIENT

TARGET=t01976

WORKDIR=$(mktemp -d -t blaster-retrieve.XXXXXXX)
function cleanup {
  if [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

CHECK=$WORKDIR/check.txt
./check.sh $TARGET > $CHECK

grep -l refused retrievals/$CLIENT/wiki*.log | xargs rm -v

COUNTER=1
mkdir -p tmp
for x in $(grep ^wiki $CHECK | shuf); do
	echo $((COUNTER++)) $x
	cat $x*.deal > tmp/deals.txt
	DEALS=$(cat $CHECK | awk "/$x/,/^$/ { print }" | grep Active | awk '{ print $3 "-" $2 }')
	echo $DEALS
  	COUNTER=0
	for d in $DEALS; do
		TIMESTAMP=`date +%s`
		MINER=$(echo $d | sed 's,-.*$,,')
		DEAL=$(echo $d | sed 's,^.*-,,')
		CID=$(cat $x.cid)
   		LOG=$(ls $PWD/retrievals/$CLIENT/$x-$MINER-$DEAL-*.log 2> /dev/null)
		if [ -z "$LOG" ]; then 
		      	echo Retrieving $MINER $DEAL $CID
			/usr/bin/time timeout -k 18m 17m lotus client retrieve --miner=$MINER $CID $PWD/retrievals/$CLIENT/$x-$MINER-$DEAL-$TIMESTAMP.bin 2>&1 | tee -a $PWD/retrievals/$CLIENT/$x-$MINER-$DEAL-$TIMESTAMP.log
			  echo $((++COUNTER)) > /dev/null
			  if [ "$COUNTER" = "1" ]; then
			    echo "Skipping ahead"
			    break
			  fi
		else
		      	echo Already have log for $MINER $DEAL $CID
		fi
		sleep 1
	done
	echo
	sleep 1
done


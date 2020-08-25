#! /bin/bash

CLIENT=$(lotus state lookup `lotus wallet default`)
#echo Client: $CLIENT
mkdir -p retrievals/$CLIENT

TARGET=t03296 # nuc

WORKDIR=$(mktemp -d -t blaster-retrieve.XXXXXXX)
function cleanup {
  if [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

CHECK=$WORKDIR/check.txt
./check.sh $TARGET > $CHECK

TO_DELETE=$(grep -l refused retrievals/$CLIENT/wiki*.log 2> /dev/null)
if [ -n "${TO_DELETE}" ]; then
	echo ${TO_DELETE} | xargs rm
fi

COUNTER=1
mkdir -p tmp
for x in $(grep ^wiki $CHECK | shuf); do
	echo $((COUNTER++)) $x
	#cat $x*.deal > tmp/deals.txt
	#cat $CHECK | awk "/$x/,/^$/ { print }" | grep 'Active\|Sealing'
	DEALS=$(cat $CHECK | awk "/$x/,/^$/ { print }" | grep 'Active\|Sealing' | awk '{ print $6 "-" $5 }')
	#echo $DEALS
	#continue
  	COUNTER=0
	for d in $DEALS; do
		TIMESTAMP=`date +%s`
		MINER=$(echo $d | sed 's,-.*$,,')
		DEAL=$(echo $d | sed 's,^.*-,,')
		CID=$(cat $x.cid)
   		LOG=$(ls $PWD/retrievals/$CLIENT/$x-$MINER-$DEAL-*.log 2> /dev/null)
		if [ -z "$LOG" ]; then 
		      	echo Retrieving $MINER $DEAL $CID
			/usr/bin/time timeout -k 18m 17m lotus client retrieve --miner=$MINER --maxPrice=0.000000000050000000 $CID $PWD/retrievals/$CLIENT/$x-$MINER-$DEAL-$TIMESTAMP.bin 2>&1 | tee -a $PWD/retrievals/$CLIENT/$x-$MINER-$DEAL-$TIMESTAMP.log
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


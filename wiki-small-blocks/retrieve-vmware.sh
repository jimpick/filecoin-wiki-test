#! /bin/bash

CHECK=results/2020-08-22-a/check.txt
mkdir -p tmp
for x in $(grep ^wiki $CHECK); do
	echo $x
	cat $x*.deal > tmp/deals.txt
	DEALS=$(cat $CHECK | awk "/$x/,/^$/ { print }" | grep Active | awk '{ print $3 "-" $2 }')
	echo $DEALS
	mkdir -p retrievals
	for d in $DEALS; do
		TIMESTAMP=`date +%s`
		MINER=$(echo $d | sed 's,-.*$,,')
		DEAL=$(echo $d | sed 's,^.*-,,')
		CID=$(cat $x.cid)
    		LOG=$(ls $PWD/retrievals/$x-$MINER-$DEAL-*.log 2> /dev/null)
		if [ -z "$LOG" ]; then 
		      	echo Retrieving $MINER $DEAL $CID
			/usr/bin/time timeout -k 18m 17m lotus client retrieve --miner=$MINER $CID $PWD/retrievals/$x-$MINER-$DEAL-$TIMESTAMP.bin 2>&1 | tee -a $PWD/retrievals/$x-$MINER-$DEAL-$TIMESTAMP.log
		else
		      	echo Already have log for $MINER $DEAL $CID
		fi
		sleep 1
	done
	echo
	sleep 1
done


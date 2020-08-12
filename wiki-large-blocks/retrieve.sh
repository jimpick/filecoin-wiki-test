#! /bin/bash

for x in *.zip.??; do
	echo $x
	cat $x*.deal > ~/tmp/deals.txt
	DEALS=$(lotus client list-deals -v | grep -f ~/tmp/deals.txt | grep Active | awk '{ print $3 "-" $2 }')
	echo $DEALS
	mkdir -p retrievals
	for d in $DEALS; do
		TIMESTAMP=`date +%s`
		MINER=$(echo $d | sed 's,-.*$,,')
		DEAL=$(echo $d | sed 's,^.*-,,')
		CID=$(cat $x.cid)
		echo $MINER $DEAL $CID
		#/usr/bin/nohup /usr/bin/time timeout -k 11m 10m lotus client retrieve --miner=$MINER $CID $PWD/retrievals/$x-$MINER-$DEAL-$TIMESTAMP.bin &> $PWD/retrievals/$x-$MINER-$DEAL-$TIMESTAMP.log &
		/usr/bin/time timeout -k 16m 15m lotus client retrieve --miner=$MINER $CID $PWD/retrievals/$x-$MINER-$DEAL-$TIMESTAMP.bin 2>&1 | tee -a $PWD/retrievals/$x-$MINER-$DEAL-$TIMESTAMP.log
		sleep 5
	done
	echo
	sleep 1
done


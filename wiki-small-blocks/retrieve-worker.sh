#! /bin/bash

TARGET_DIR=$1
if [ -z "$TARGET_DIR" ]; then
  echo "Need target dir"
  exit 1
fi

CLIENT=$(lotus state lookup `lotus wallet default`)

WORKDIR=$(mktemp -d -t blaster-retrieve.XXXXXXX)
function cleanup {
  if [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

CHECK=$WORKDIR/check.txt
for f in list-deals/*.txt; do
  MINER=$(echo $f | sed 's,^.*/\(.*\)\.txt,\1,')
  echo Loading deals $MINER
  ./check.sh $MINER >> $CHECK 2>&2
done
#cp $CHECK ~/tmp/check.txt

TO_DELETE=$(grep -l refused $TARGET_DIR/wiki*.log 2> /dev/null)
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
	#DEALS=$(cat $CHECK | awk "/$x/,/^$/ { print }" | grep 'Active' | awk '{ print $6 "-" $5 }')
	echo $DEALS
	#continue
	#wiki.zip.ae.an.t08106.import
	if [ -f $x.$CLIENT.import ]; then
		echo Already imported, skipping
		continue
	fi
  	COUNTER=0
	for d in $DEALS; do
		TIMESTAMP=`date +%s`
		MINER=$(echo $d | sed 's,-.*$,,')
		DEAL=$(echo $d | sed 's,^.*-,,')
		CID=$(cat $x.cid)
   		LOG=$(ls $TARGET_DIR/$x-$MINER-$DEAL-*.log 2> /dev/null)
		if [ -z "$LOG" ]; then 
		      	echo Retrieving $MINER $DEAL $CID
			/usr/bin/time timeout -k 18m 17m lotus client retrieve --miner=$MINER --maxPrice=0.000000000050000000 $CID $TARGET_DIR/$x-$MINER-$DEAL-$TIMESTAMP.bin 2>&1 | tee -a $TARGET_DIR/$x-$MINER-$DEAL-$TIMESTAMP.log
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


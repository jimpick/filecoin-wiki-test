#! /bin/bash

PORT=$(lotus auth api-info --perm admin | grep FULLNODE_API_INFO | sed 's,^FULLNODE_API_INFO=.*:,,' | sed 's,/ip4/0.0.0.0/tcp/\([0-9]*\)/http,\1,')
echo $PORT
TOKEN=$(lotus auth api-info --perm admin | grep FULLNODE_API_INFO | sed 's,^FULLNODE_API_INFO=\(.*\):.*,\1,')
echo $TOKEN

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
# for f in list-deals/f0252068.txt; do # skip old deals
  CLIENT2=$(echo $f | sed 's,^.*/\(.*\)\.txt,\1,')
  echo Loading deals $CLIENT2
  ./check.sh $CLIENT2 >> $CHECK 2>&2
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
	DEALS=$(cat $CHECK | awk "/$x/,/^$/ { print }" | grep 'Active\|Sealing\|AwaitingPreCommit' | awk '{ print $6 "-" $5 }')
	#DEALS=$(cat $CHECK | awk "/$x/,/^$/ { print }" | grep 'Active' | awk '{ print $6 "-" $5 }')
	echo $DEALS
	#continue
	#wiki.zip.ae.an.t08106.import
	if [ -f $x.$CLIENT.import ]; then
		echo Already imported, skipping
		continue
	fi
  	COUNTER=0
	for d in $(echo $DEALS | shuf); do
    PENDING=$(lotus mpool pending --local | jq -s length)
    if [ "$PENDING" != "0" ]; then
      echo "Mpool pending $PENDING, skipping + sleeping 30s"
      sleep 30
      continue
    fi
		TIMESTAMP=`date +%s`
		MINER=$(echo $d | sed 's,-.*$,,')
		DEAL=$(echo $d | sed 's,^.*-,,')
		CID=$(cat $x.cid)
   		LOG=$(ls $TARGET_DIR/$x-$MINER-$DEAL-*.log 2> /dev/null)
		if [ -z "$LOG" ]; then 
		      	echo Retrieving $MINER $DEAL $CID
      curl -m 60 -X POST  -H "Content-Type: application/json"  -H "Authorization: Bearer $TOKEN"  --data "{ \"jsonrpc\": \"2.0\", \"method\": \"Filecoin.ClientMinerQueryOffer\", \"params\": [\"$MINER\", { \"/\": \"$CID\" }, null], \"id\": 1 }"  http://127.0.0.1:$PORT/rpc/v0 >> $TARGET_DIR/$x-$MINER-$DEAL-$TIMESTAMP.log
      cat $TARGET_DIR/$x-$MINER-$DEAL-$TIMESTAMP.log
      if [ "$?" != "0" ]; then
        echo Failed CURL check | tee -a $TARGET_DIR/$x-$MINER-$DEAL-$TIMESTAMP.log
        continue
      fi

			/usr/bin/time timeout -k 23m 22m lotus client retrieve --miner=$MINER --maxPrice=0.000000050000000000 $CID $PWD/$TARGET_DIR/$x-$MINER-$DEAL-$TIMESTAMP.bin 2>&1 | tee -a $TARGET_DIR/$x-$MINER-$DEAL-$TIMESTAMP.log
      rm -f $PWD/$TARGET_DIR/$x-$MINER-$DEAL-$TIMESTAMP.bin
        FREE=$(df -h . | tail -1 | awk '{ print $4 }')
        echo $CLIENT: $(lotus wallet balance) "($FREE free)"
        lotus chain list --count 1 --gas-stats | head -1

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


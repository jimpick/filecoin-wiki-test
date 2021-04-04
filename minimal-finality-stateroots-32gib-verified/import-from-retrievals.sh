#! /bin/bash

CLIENT=$(./client.sh)
#echo Client: $CLIENT
mkdir -p retrievals/$CLIENT

EPOCH=$(cat .retrieval-epoch)

if [ -z "$EPOCH" ]; then
  EPOCH=$(date -u +'%s')
  echo $EPOCH > .retrieval-epoch
fi

mkdir -p retrievals/$CLIENT-$EPOCH

TARGET_DIR=retrievals/$CLIENT-$EPOCH

WORKDIR=$(mktemp -d -t blaster-import.XXXXXXX)
function cleanup {
  if [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

count=0

grep -l Success $TARGET_DIR/wiki*.log > $WORKDIR/success.txt
#echo Jim1 $WORKDIR/success.txt
#cat $WORKDIR/success.txt

for logfile in `cat $WORKDIR/success.txt`; do
	binfile=$(echo $logfile | sed 's,\.log,\.bin,')
	#retrievals/t0287838/wiki.zip.an.ae-t02750-12234-1598291073.bin
	if [ -f $binfile ]; then
		#ls -lh $binfile
		CHUNK=$(echo $binfile | sed 's,^.*wiki\.zip\.\(..\...\)-.*$,\1,')
		IMPORT=wiki.zip.$CHUNK.$CLIENT.import
		if [ ! -f "$IMPORT" ]; then
			echo Importing $binfile
			lotus client import $binfile | tee $IMPORT
		fi
	fi
done

echo Imported: $(ls wiki.*.$CLIENT.import | wc -l) of $(ls wiki.*.t03296.import | wc -l)

#total=`ls wiki*.zip.??.?? | wc -l`
#for f in wiki*.zip.??.??; do
#	echo $f $((++count)) of $total
#	lotus client import $f | tee $f.import
#	cat $f.import | sed 's,^.*Root ,,' > $f.cid
#done

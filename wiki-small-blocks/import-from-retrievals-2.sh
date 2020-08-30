#! /bin/bash

CLIENT=$(lotus state lookup `lotus wallet default`)
#echo Client: $CLIENT
mkdir -p retrievals/$CLIENT-b

WORKDIR=$(mktemp -d -t blaster-import.XXXXXXX)
function cleanup {
  if [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

count=0

grep -l Success retrievals/$CLIENT-b/wiki*.log > $WORKDIR/success.txt

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

#total=`ls wiki*.zip.??.?? | wc -l`
#for f in wiki*.zip.??.??; do
#	echo $f $((++count)) of $total
#	lotus client import $f | tee $f.import
#	cat $f.import | sed 's,^.*Root ,,' > $f.cid
#done

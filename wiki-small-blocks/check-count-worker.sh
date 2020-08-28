#! /bin/bash

CLIENT=$1
OUTPUT=list-deals/$CLIENT.txt

if [ -z "$CLIENT" ]; then
  CLIENT=$(lotus state lookup `lotus wallet default`)
  mkdir -p list-deals
  OUTPUT=list-deals/$CLIENT.txt

  lotus client list-deals -v > $OUTPUT
fi

WORKDIR=$(mktemp -d -t blaster-deals-count.XXXXXXX)
function cleanup {
  if [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

COUNTER=1
for x in *.zip.??.??.import; do
  x2=$(echo $x | sed s',\.import,,')
  cat $x2.$CLIENT.*.deal | grep bafy > $WORKDIR/deals.txt 2> /dev/null
  cat $OUTPUT | grep -f $WORKDIR/deals.txt > $WORKDIR/filtered.txt
	COUNT=$(cat $WORKDIR/filtered.txt | wc -l)
	ACTIVE_COUNT=$(cat $WORKDIR/filtered.txt | grep Active | wc -l)
	SEALING_COUNT=$(cat $WORKDIR/filtered.txt | grep Sealing | wc -l)
	TRANSFERRING_COUNT=$(cat $WORKDIR/filtered.txt | grep Transferring | wc -l)
	ERROR_COUNT=$(cat $WORKDIR/filtered.txt | grep Error | wc -l)
	echo $((COUNTER++)) $x2 $COUNT Active: $ACTIVE_COUNT Sealing: $SEALING_COUNT Xfr: $TRANSFERRING_COUNT Error: $ERROR_COUNT
done

#lotus client list-deals -v | grep -f ~/tmp/deals.txt  | sort -k2 | tee ~/tmp/check.out

#for f in *.zip.*.deal; do
#	echo $f
#	lotus client list-deals -v | grep `cat $f`
#done

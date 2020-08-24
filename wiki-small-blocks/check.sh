#! /bin/bash

CLIENT=$1
OUTPUT=list-deals/$CLIENT.txt

if [ -z "$CLIENT" ]; then
  CLIENT=$(lotus state lookup `lotus wallet default`)
  mkdir -p list-deals
  OUTPUT=list-deals/$CLIENT.txt

  lotus client list-deals -v > $OUTPUT
fi

WORKDIR=$(mktemp -d -t blaster-deals.XXXXXXX)
function cleanup {
  if [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT


for x in *.zip.??.??; do
  echo $x 1>&2
  echo $x
  cat $x*.deal > $WORKDIR/deals.txt
  grep -f $WORKDIR/deals.txt $OUTPUT | sort -k2
  echo
done


#lotus client list-deals -v | grep -f ~/tmp/deals.txt  | sort -k2 | tee ~/tmp/check.out

#for f in *.zip.*.deal; do
#	echo $f
#	lotus client list-deals -v | grep `cat $f`
#done

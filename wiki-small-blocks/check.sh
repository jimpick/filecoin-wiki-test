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

COUNTER=1
for x in *.zip.??.??.import; do
  x2=$(echo $x | sed s',\.import,,')
  echo $((COUNTER++)) $x2 1>&2
  echo $x2
  cat $x2*.deal > $WORKDIR/deals.txt
  grep -f $WORKDIR/deals.txt $OUTPUT | sort -k2
  echo
done


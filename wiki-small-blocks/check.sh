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
for x in *.zip.??.??.$CLIENT.import; do
  x2=$(echo $x | sed s',\.t[0-9]*\.import,,')
  echo $((COUNTER++)) $x2 1>&2
  echo $x2
  cat $x2.$CLIENT.*.deal 2> /dev/null | grep ^bafy > $WORKDIR/deals.txt
  #cat $WORKDIR/deals.txt
  grep -f $WORKDIR/deals.txt $OUTPUT 
  echo
done

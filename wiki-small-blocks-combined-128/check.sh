#! /bin/bash

CLIENT=$1
OUTPUT=list-deals/$CLIENT.txt

if [ -z "$CLIENT" ]; then
  CLIENT=$(lotus state lookup `lotus wallet default`)
  mkdir -p list-deals
  OUTPUT=list-deals/$CLIENT.txt

  lotus client list-deals -v --show-failed > $OUTPUT
fi

WORKDIR=$(mktemp -d -t blaster-deals.XXXXXXX)
function cleanup {
  if [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

COUNTER=1
for x in *.cid; do
  if [ -f "$x" ]; then
    x2=$(echo "$x" | sed -n s',\.cid,,p')
    echo $CLIENT $((COUNTER++)) "$x2" 1>&2
    echo $x2
    cat $x2.$CLIENT.*.deal 2> /dev/null | grep ^bafy > $WORKDIR/deals.txt
    #cat $WORKDIR/deals.txt
    grep -f $WORKDIR/deals.txt $OUTPUT 
    echo
  fi
done


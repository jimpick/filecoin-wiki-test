#! /bin/bash

CLIENT=$1
OUTPUT=check-count/$CLIENT.txt

if [ -z "$CLIENT" ]; then
  CLIENT=$(lotus state lookup `lotus wallet default`)
  mkdir -p check-count
  OUTPUT=check-count/$CLIENT.txt
fi

./check-count-worker.sh | tee $OUTPUT

echo 'Active:'
cat $OUTPUT | awk '{ print $5 }' | sort -n | uniq -c

echo
echo 'Sealing:'
cat $OUTPUT | awk '{ print $7 }' | sort -n | uniq -c




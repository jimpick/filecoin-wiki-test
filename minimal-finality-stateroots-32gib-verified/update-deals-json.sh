#! /bin/bash

CLIENT=$(./client.sh)

mkdir -p deals
(for f in `ls *.$CLIENT.*.deal`; do
  #echo $f
  MINER=$(echo $f | sed 's,.*\.\(f0[0-9]*\)\.deal,\1,')
  FILE=$(echo $f | sed 's,\.\(f0[0-9]*\)\.\(f0[0-9]*\)\.deal,,')
  DEAL=$(cat $f)
  CID=$(cat $FILE.cid)
  echo "{\"miner\": \"$MINER\", \"file\": \"$FILE\", \"dealCid\": \"$DEAL\", \"cid\": \"$CID\" }"
done) | jq -s > deals/$CLIENT.json

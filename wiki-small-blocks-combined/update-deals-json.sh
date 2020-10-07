#! /bin/bash

CLIENT=$(./client.sh)

mkdir -p deals
(for f in `ls wiki.*.$CLIENT.*.deal`; do
  #echo $f
  MINER=$(echo $f | sed "s,^wiki.*\.\(f0[0-9]*\)\.deal,\1,")
  WIKIFILE=$(echo $f | sed "s,^\(wiki\.[^.]*\).*,\1,")
  DEAL=$(cat $f)
  echo "{\"miner\": \"$MINER\", \"wikiFile\": \"$WIKIFILE\", \"dealCid\": \"$DEAL\" }"
done) | jq -s > deals/$CLIENT.json

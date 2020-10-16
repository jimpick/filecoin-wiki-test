#! /bin/bash

WORKDIR=$(mktemp -d -t miner-prices.XXXXXXX)
function cleanup {
  if [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT


curl -o $WORKDIR/annotations.js https://raw.githubusercontent.com/jimpick/workshop-client-testnet/spacerace/src/annotations-spacerace-slingshot-medium.js

MINERS=$(cd $WORKDIR; node -e '
const fs = require("fs")

const js = fs.readFileSync("./annotations.js", "utf8")
const fixedJs = js.replace(/export.*/m, "").replace(/^const /m, "var ")

eval(fixedJs)

let filtered = Object.entries(annotations).filter(([miner, text]) => text.match(/^(active,|sealing,)/)).map(([miner]) => miner)

console.log(filtered.join("\n"))
')

for m in $MINERS; do
  echo $m
  lotus client query-ask $m
  sleep 1
done

#! /bin/bash

mkdir -p tmp
curl -o tmp/annotations.js https://raw.githubusercontent.com/jimpick/workshop-client-testnet/spacerace/src/annotations-spacerace.js

MINERS=$(node -e '
const fs = require("fs")

const js = fs.readFileSync("tmp/annotations.js", "utf8")
const fixedJs = js.replace(/export.*/, "").replace(/^const /, "var ")

eval(fixedJs)

let filtered = Object.entries(annotations).filter(([miner, text]) => text.match(/^active,/) || text.match(/^sealing,/)).map(([miner]) => miner)

function shuffle(array) {
  var currentIndex = array.length, temporaryValue, randomIndex;

  // While there remain elements to shuffle...
  while (0 !== currentIndex) {

    // Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex -= 1;

    // And swap it with the current element.
    temporaryValue = array[currentIndex];
    array[currentIndex] = array[randomIndex];
    array[randomIndex] = temporaryValue;
  }

  return array;
}

shuffle(filtered)

console.log(filtered.join("\n"))
')

TRIES=10
for n in $(seq 1 "$TRIES"); do
  for m in $MINERS; do
    echo $m "($n / $TRIES tries)":
    ./deal-0-active.sh $m
    echo
    #read -p pause...
    #echo
    sleep 1
  done
done

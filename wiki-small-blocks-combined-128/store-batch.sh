#! /bin/bash

mkdir -p tmp
#curl -o tmp/annotations.js https://raw.githubusercontent.com/jimpick/workshop-client-testnet/spacerace/src/annotations-spacerace-slingshot-medium.js
cp -f /home/ubuntu/workshop-client-testnet/src/annotations-spacerace-slingshot-medium.js tmp/annotations.js

MINERS=$(node -e '
const fs = require("fs")

const js = fs.readFileSync("tmp/annotations.js", "utf8")
const fixedJs = js.replace(/export.*/m, "").replace(/^const /m, "var ")

eval(fixedJs)

let filtered = Object.entries(annotations).filter(([miner, text]) => text.match(/^(candidate,)/)).map(([miner]) => miner)

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

filtered.length = 5

console.log(filtered.join("\n"))
')

TRIES=1
for n in $(seq 1 "$TRIES"); do
  for m in $MINERS; do
    echo $m "($n / $TRIES tries)":
    ./deal.sh $m
    echo
    #read -p pause...
    #echo
    sleep 1
  done
done

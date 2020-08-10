#! /bin/bash

curl -o ~/tmp/annotations.js https://raw.githubusercontent.com/jimpick/workshop-client-testnet/calibration/src/annotations-calibration.js

MINERS=$(node -e '
const fs = require("fs")

const js = fs.readFileSync("/home/ubuntu/tmp/annotations.js", "utf8")
const fixedJs = js.replace(/export.*/, "").replace(/^const /, "var ")

eval(fixedJs)

let filtered = Object.entries(annotations).filter(([miner, text]) => text.match(/^active,/)).map(([miner]) => miner)

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

for m in $MINERS; do
	echo $m:
	./deal.sh $m
	echo
	read -p pause...
	echo
done


#! /bin/bash

mkdir -p tmp
#curl -o tmp/annotations.js https://raw.githubusercontent.com/jimpick/workshop-client-testnet/spacerace/src/annotations-spacerace-slingshot-medium.js
cp -f /home/ubuntu/workshop-client-testnet/src/annotations-spacerace-slingshot-medium.js tmp/annotations.js

node -e '
const fs = require("fs")

const js = fs.readFileSync("tmp/annotations.js", "utf8")
const fixedJs = js.replace(/export.*/m, "").replace(/^const /m, "var ")

eval(fixedJs)
console.log(fixedJs)
'


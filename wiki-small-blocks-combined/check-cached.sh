#! /bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
  CLIENT=$(lotus state lookup `lotus wallet default`)
fi

./check.sh $CLIENT 2> /dev/null

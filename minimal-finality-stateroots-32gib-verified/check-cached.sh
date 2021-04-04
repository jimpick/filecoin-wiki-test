#! /bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
  CLIENT=$(./client.sh)
fi

./check.sh $CLIENT 2> /dev/null

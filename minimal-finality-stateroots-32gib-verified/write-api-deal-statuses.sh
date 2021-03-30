#! /bin/bash

CLIENT=$(./client.sh)

DEALS=./deals/$CLIENT.json

LENGTH=$(cat $DEALS | jq length)
COUNT=0
for deal in $(cat $DEALS | jq -r '.[].dealCid'); do
  COUNT=$((COUNT + 1))
  echo $deal $COUNT of $LENGTH 1>&2
  ./api-get-deal-info.sh $deal
done | jq -s > ./deals/$CLIENT-api-deal-statuses.json

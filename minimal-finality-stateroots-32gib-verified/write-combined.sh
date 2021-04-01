#! /bin/bash

CLIENT=$(./client.sh)

DEALS=./deals/$CLIENT.json

API=./deals/$CLIENT-api-deal-statuses.json

EPOCH=$(cat .retrieval-epoch)

RETRIEVALS_JSON=retrievals/$CLIENT-$EPOCH/retrieval-deals.json

WORKDIR=$(mktemp -d -t retrieval-summary.XXXXXXX)
function cleanup {
  if [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT


LENGTH=$(cat $DEALS | jq length)
COUNT=0
for deal in $(cat $DEALS | jq -r '.[].dealCid'); do
  COUNT=$((COUNT + 1))
  echo $deal $COUNT of $LENGTH 1>&2

  JSON=$(cat $DEALS | jq ".[] | select(.dealCid==\"$deal\")")
  #echo $JSON1 | jq .

  JSON_DEAL_STATUS=$(cat $API | jq ".[] | select(.result.ProposalCid[\"/\"]==\"$deal\") | .result | { dealStatus: . }")
  #echo $JSON | jq .

  DEAL_ID=$(echo $JSON_DEAL_STATUS | jq '.dealStatus.DealID')
  #echo DEAL_ID: $DEAL_ID

  if [ "$DEAL_ID" != "null" -a "$DEAL_ID" != "0" ]; then
    JSON=$(echo $JSON | jq ". + { dealId: $DEAL_ID }")
  fi

  JSON=$(echo $JSON | jq ". + $JSON_DEAL_STATUS")

  if [ "$DEAL_ID" != "null" -a "$DEAL_ID" != "0" ]; then
    RETRIEVALS="[]"
    for f in $(ls retrievals/*/retrieval-deals.json); do
      NEW_RETRIEVALS=$(cat $f | jq "[.[] | select(.dealId==\"$DEAL_ID\")]")
      if [ -n "$NEW_RETRIEVALS" ]; then
        RETRIEVALS=$(echo $RETRIEVALS | jq ". + $NEW_RETRIEVALS")
      fi
    done
    JSON=$(echo $JSON | jq ". + { retrievals: $RETRIEVALS }")
  fi
  echo $JSON | jq .
  echo $JSON >> $WORKDIR/deals-combined.ndjson
done

cat $WORKDIR/deals-combined.ndjson | jq -s > ./deals/$CLIENT-combined.json

#! /bin/bash

CLIENT=$(lotus state lookup `lotus wallet default`)

EPOCH=$(cat .retrieval-epoch)

TARGET_DIR=retrievals/$CLIENT-$EPOCH

cd $TARGET_DIR

WORKDIR=$(mktemp -d -t retrieval-summary.XXXXXXX)
function cleanup {
  if [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

LOGS=$(ls -t *.log | grep -v ^retrieval)

echo $LOGS

for log in $LOGS; do
  if grep "ERROR: dial tcp 0.0.0.0:1234: connect: connection refused" $log > /dev/null; then
    continue
  fi
  echo $log
  head -5 $log
  echo ...
  tail -5 $log
  echo
  OFFER=$(head -1 $log | jq '.result')
  echo OFFER: $OFFER
  CID=$(echo $OFFER | jq -r '.Root["/"]')
  echo CID: $CID
  SIZE=$(echo $OFFER | jq -r '.Size')
  echo SIZE: $SIZE
  MIN_PRICE=$(echo $OFFER | jq -r '.MinPrice')
  echo MIN_PRICE: $MIN_PRICE
  UNSEAL_PRICE=$(echo $OFFER | jq -r '.UnsealPrice')
  echo UNSEAL_PRICE: $UNSEAL_PRICE
  PAYMENT_INTERVAL=$(echo $OFFER | jq -r '.PaymentInterval')
  echo PAYMENT_INTERVAL: $PAYMENT_INTERVAL
  PAYMENT_INTERVAL_INCREASE=$(echo $OFFER | jq -r '.PaymentIntervalIncrease')
  echo PAYMENT_INTERVAL_INCREASE: $PAYMENT_INTERVAL_INCREASE
  OWNER=$(echo $OFFER | jq -r '.Miner')
  echo OWNER: $OWNER
  MINER=$(echo $OFFER | jq -r '.MinerPeer.Address')
  echo MINER: $MINER
  PEER_ID=$(echo $OFFER | jq -r '.MinerPeer.ID')
  echo PEER_ID: $PEER_ID
  START_RAW=$(head -2 $log | tail -1 | sed 's,>.*,,')
  #echo START_RAW: $START_RAW
  START_TIME=$(date --date="$START_RAW" -Iseconds)
  echo START_TIME: $START_TIME
  FINAL_RECV=$(grep '> Recv' $log | tail -1)
  LAST_RAW=$(echo $FINAL_RECV | sed 's,>.*,,')
  LAST_TIME=$(date --date="$LAST_RAW" -Iseconds)
  echo LAST_TIME: $LAST_TIME
  ELAPSED_TIME=$(grep 'elapsed' $log | awk '{ print $6 }' | sed 's,elapsed,,')
  echo ELAPSED_TIME: $ELAPSED_TIME
  if grep Success $log > /dev/null; then
    SUCCESS=true
  else
    SUCCESS=false
  fi
  ERROR=$(grep 'ERROR' $log | sed 's,^.*ERROR: ,,')
  echo ERROR: $ERROR
  echo FINAL_RECV: $FINAL_RECV
  RECEIVED=$(echo $FINAL_RECV | awk '{ print $6 " " $7 }' | sed 's/,//')
  echo RECEIVED: $RECEIVED
  FIL_PAID=$(echo $FINAL_RECV | awk '{ print $9 }')
  echo FIL_PAID: $FIL_PAID
  LAST_EVENT=$(echo $FINAL_RECV | awk '{ print $11 }')
  echo LAST_EVENT: $LAST_EVENT
  LAST_STATUS=$(echo $FINAL_RECV | awk '{ print $12 }' | sed 's,(\(.*\)),\1,')
  echo LAST_STATUS: $LAST_STATUS
  if [ "$LAST_STATUS" != "DealStatusCompleted" ]; then
    SUCCESS=false
  fi
  LAST_LINE=$(tail -1 $log | grep pagefaults)
  if [ -n "$LAST_LINE" ]; then
    FINAL_STATUS=true
  else
    FINAL_STATUS=false
  fi
  echo FINAL_STATUS: $FINAL_STATUS
  if [ "$FINAL_STATUS" = true ]; then
    echo SUCCESS: $SUCCESS
  fi
  DEAL_ID=$(echo $log | sed 's,-, ,g' | awk '{ print $7 }')
  echo DEAL_ID: $DEAL_ID
  JSON="{ \
    \"startTime\": \"$START_TIME\", \
    \"miner\": \"$MINER\", \
    \"dealId\": \"$DEAL_ID\", \
    \"cid\": \"$CID\", \
    \"size\": \"$SIZE\", \
    \"minPrice\": \"$MIN_PRICE\", \
    \"unsealPrice\": \"$UNSEAL_PRICE\", \
    \"paymentInterval\": \"$PAYMENT_INTERVAL\", \
    \"paymentIntervalIncrease\": \"$PAYMENT_INTERVAL_INCREASE\", \
    \"owner\": \"$OWNER\", \
    \"peerId\": \"$PEER_ID\", \
    \"lastTime\": \"$LAST_TIME\", \
    \"elapsedTime\": \"$ELAPSED_TIME\", \
    \"finalStatus\": $FINAL_STATUS, \
  "
  if [ "$FINAL_STATUS" = true ]; then
    JSON+="\"success\": $SUCCESS, "
  fi
  if [ -n "$ERROR" ]; then
    JSON+="\"error\": \"$ERROR\", "
  fi
  JSON+=" \
    \"received\": \"$RECEIVED\", \
    \"filPaid\": \"$FIL_PAID\", \
    \"lastEvent\": \"$LAST_EVENT\", \
    \"lastStatus\": \"$LAST_STATUS\", \
    \"logFile\": \"$CLIENT-$EPOCH/$log\"
  }"
  JSON=$(echo $JSON | jq .)
  echo $JSON | jq .
  echo $JSON >> $WORKDIR/retrieval-deals.ndjson
done

cat $WORKDIR/retrieval-deals.ndjson | jq -s > retrieval-deals.json

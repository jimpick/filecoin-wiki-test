#! /bin/bash

CLIENT=$(./client.sh)

(while true; do
  EPOCH=$(cat .retrieval-epoch 2> /dev/null)
  COUNT=$(ls retrievals/$CLIENT-$EPOCH/minimal*.log 2> /dev/null | wc -l)
  echo $(date) $(TZ=America/Vancouver date) $EPOCH \
    $(df -h /home/ubuntu/.lotus/datastore/client/ | tail -1 | awk '{ print $5 }') \
    $(df -h / | tail -1 | awk '{ print $5 }') \
    $COUNT
  sleep $((1 * 60 * 60))
done) &
BACKPID=$!

function cleanup {
  kill $BACKPID
}
trap cleanup EXIT

while true; do
  echo $(date) $(TZ=America/Vancouver date)
  echo Current retrieval epoch $(cat .retrieval-epoch)
  echo Sleeping 12 hours...
  sleep $((12 * 60 * 60))
  echo $(date) $(TZ=America/Vancouver date)
  echo Writing retrieval summary
  ./write-retrieval-summary.sh
  echo Cancelling all remaining retrievals
  ./cancel-all-retrievals.sh
  echo Writing retrieval summary again
  ./write-retrieval-summary.sh
  echo Removing .retrieval-epoch
  rm -f .retrieval-epoch
  echo Sleeping 30 minutes
  sleep $((30 * 60))
done

#! /bin/bash

(while true; do
  sleep $((1 * 60 * 60))
  date
done) &
BACKPID=$!

function cleanup {
  kill $BACKPID
}
trap cleanup EXIT

while true; do
  date
  echo Current retrieval epoch $(cat .retrieval-epoch)
  echo Sleeping 12 hours...
  sleep $((12 * 60 * 60))
  echo Cancelling all remaining retrievals
  ./cancel-all-retrievals.sh
  echo Removing .retrieval-epoch
  ./write-retrieval-summary.sh
  rm -f .retrieval-epoch
  echo Sleeping 30 minutes
  sleep $((30 * 60))
done

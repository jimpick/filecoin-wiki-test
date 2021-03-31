#! /bin/bash

while true; do
  if [ -f drain ]; then
    echo 'Draining, exiting...'
    sleep 5
    exit
  fi

  echo 'Starting store iteration...'
  ./store.sh
  echo 'Sleeping 5 minutes'
  sleep 300
done

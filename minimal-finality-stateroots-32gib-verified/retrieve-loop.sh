#! /bin/bash

while true; do
  if [ -f drain ]; then
    echo 'Draining, exiting...'
    sleep 5
    exit
  fi

  echo 'Starting retrieve iteration...'
  ./retrieve.sh
  echo 'Sleeping 15 minutes'
  sleep 900
done

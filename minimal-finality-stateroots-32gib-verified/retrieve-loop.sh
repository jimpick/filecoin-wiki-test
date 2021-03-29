#! /bin/bash

while true; do
  if [ -f drain ]; then
    echo 'Draining, exiting...'
    sleep 5
    exit
  fi

  echo 'Starting retrieve iteration...'
  ./retrieve.sh
  sleep 10
done

#! /bin/bash

FREE_DISK=$(df / | tail -1 | awk '{ print $4 }')
if [ "$FREE_DISK" -lt 50000000 ]; then
  echo "Out of disk space - /"
  df -h .
  touch drain
fi
FREE_DISK=$(df /mnt/client-datastore/ | tail -1 | awk '{ print $4 }')
if [ "$FREE_DISK" -lt 200000000 ]; then
  echo "Out of disk space - /mnt/client-datastore/"
  df -h .
  touch drain
fi

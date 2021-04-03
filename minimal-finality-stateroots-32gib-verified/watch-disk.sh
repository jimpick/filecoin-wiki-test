#! /bin/bash

while true; do echo $(date) $(df -h / | tail -1) $(df -h /mnt/client-datastore/ | tail -1); sleep 60; done

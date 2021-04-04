#! /bin/bash

while true; do echo $(date) $(df -h / | tail -1) $(df -h /home/ubuntu/.lotus/datastore/client/ | tail -1); sleep 60; done

#! /bin/bash

for n in `lotus client list-transfers | awk '{ print $1 }'`; do echo $n; lotus client cancel-transfer $n; done

#! /bin/bash

for n in `lotus client list-transfers | awk '{ print $1 }'`; do echo $n; lotus client cancel-transfer $n; done
#for n in `lotus client list-transfers | awk '{ print $1 }'`; do echo $n; lotus client cancel-retrieval --deal-id $n; done

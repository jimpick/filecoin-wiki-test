#! /bin/bash

#. ~/lotus/SETENV-LITE-9001

./update.sh && git add . && git commit -a -m 'ovh-update' && git push


#! /bin/bash

./check-cached.sh | grep Error | sort -k6 | grep -v activation

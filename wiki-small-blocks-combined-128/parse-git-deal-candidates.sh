#! /bin/bash
git status | grep deal | sed 's,\., ,g' | awk '{ print $4 }' | grep -v deal | cut -c2- | sort -n

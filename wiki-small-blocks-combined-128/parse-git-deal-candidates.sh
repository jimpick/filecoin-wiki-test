#! /bin/bash
git status | grep deal | grep -v 'deleted\|modified' | sed 's,\., ,g' | awk '{ print $4 }' | grep -v deal | cut -c2- | sort -n | uniq

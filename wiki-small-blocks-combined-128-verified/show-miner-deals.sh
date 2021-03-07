#! /bin/sh

ls *.deal | grep -v t021682.deal | sed 's,\., ,g' | awk '{ print $4 }' | cut -c2- | sort -n | uniq -c


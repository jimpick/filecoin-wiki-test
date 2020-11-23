#! /bin/bash

grep -l 'min-ask' skip-miners/f0* | cut -c14- | sort -n | less


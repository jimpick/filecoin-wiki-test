#! /bin/bash

grep -l 'error-ask' skip-miners/f0* | cut -c14- | sort -n | less


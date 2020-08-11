#! /bin/bash

(while true; do date; echo; ls -lh; echo; ps auwx | grep 'lotus daemon' | grep -v grep; echo; free; echo; sleep 60; done) | tee profile.log  

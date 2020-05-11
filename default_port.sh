#!/bin/bash

#wget port file
wget https://github.com/YousafKHamza/others/raw/master/ports.txt 

printf 'x%.0s' {1..75};echo 

#cut the numbers
cat ./ports.txt | cut -d: -f1 > ~/p 

#up ports
netstat -ntlp | awk {'print $4'} | rev |cut -d: -f1| rev| grep -v ^$ | sort | uniq | grep -v "[a-zA-Z]" > ~/up 

#cross match ports

grep -x -f  ~/up ~/p > ~/lp; for i in $(cat ~/lp); do grep $i ports.txt;done;

#remove created files
rm -f ~/p ~/up ~/lp ./ports.txt 

printf 'x%.0s' {1..75};echo

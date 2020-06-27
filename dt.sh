#!/bin/bash

#dig +trace domain
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "Dig +trace result for $1"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
dig +trace @8.8.8.8 $1 | grep $1 | grep -vE '+trace|RRSIG|;;' |sort

#MX Record
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo  "MX Record Result for $1"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
dig mx $1 | grep ^"$1" | grep MX

#TXT Record
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo  "TXT Record Resutl for $1"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
dig txt $1 | grep ^"$1" | grep TXT

IP=`dig $1 | grep ^"$1" | grep A | awk {'print $5'} | head -n1`
#host for IP
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo  "Host Command Result for $IP"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
host $IP | awk {'print $5'}

MX=` dig mx $1 | grep ^"$1" | grep MX | awk {'print $6'} | rev | cut -c2- | rev | head -n1`
#MX Trying IP Resutl
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo  "MX: $MX Telnet trying connect IP Result for the $MX"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "IP: `timeout 1 telnet $MX 587 > ~/Try; timeout 1 telnet $MX 25 >> ~/Try; cat ~/Try | grep -v -e '^$'| grep Trying | head -n1 | awk {'print $2'} | rev | cut -c4- |rev; rm -f ~/Try`"

#Netcatch Result for MX 25 & 587
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo  "Telnet Result for IP: $IP && MX: $MX >> 25 & 587"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "IP: `timeout 2 nc $IP 587 > ~/rre; timeout 2 nc $IP 25 >> ~/rre; cat ~/rre | grep -v -e '^$'| head -n1; rm -f ~/rre`"
echo "          ------"
echo "MX: `timeout 2 nc $MX 587 > ~/rre; timeout 2 nc $MX 25 >> ~/rre; cat ~/rre | grep -v -e '^$'| head -n1; rm -f ~/rre`"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

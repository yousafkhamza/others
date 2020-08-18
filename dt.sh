#!/bin/bash

#dig +trace domain
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "Dig +trace result for $1"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
dig +nocmd $1 a +noall +answer >> ~/digtrace
dig +trace @8.8.8.8 $1 | grep "$1." | grep -vE 'RRSIG|;' >> ~/digtrace
dig +nocmd $1 ns +noall +answer >> ~/digtrace
cat ~/digtrace | sort | sort -u -k 5 && rm -f ~/digtrace

#MX Record
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo  "MX Record Result for $1"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#dig +nocmd $1 txt +noall +answer
dig +nocmd $1 mx +noall +answer | sort -k 5

#TXT Record
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo  "TXT Record Resutl for $1"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#dig txt $1 | grep ^"$1" | grep TXT
dig +nocmd $1 txt +noall +answer

IP=`dig +nocmd $1 a +noall +answer | grep ^"$1" | grep A | awk {'print $5'} | head -n1`
#IP=`dig $1 | grep ^"$1" | grep A | awk {'print $5'} | head -n1`
#host for IP
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo  "PTR record for $IP"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#host $IP | awk {'print $5'}
dig -x $IP +noall +answer | grep -vE ^";|^$"

MX=`dig +nocmd $1 mx +noall +answer | grep ^"$1" | grep MX | awk {'print $6'} | rev | cut -c2- | rev | head -n1`
#MX=`dig mx $1 | grep ^"$1" | grep MX | awk {'print $6'} | rev | cut -c2- | rev | head -n1`
#MX Trying IP Resutl
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo  "Telnet trying connect IP Result for the $MX"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "IP: `timeout 1 telnet $MX 587 > ~/Try; timeout 1 telnet $MX 25 >> ~/Try; cat ~/Try | grep -v -e '^$'| grep Trying | head -n1 | awk {'print $2'} | rev | cut -c4- |rev; rm -f ~/Try`"

#Netcatch Result for MX 25 & 587
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo  "Telnet Result for IP: $IP && MX: $MX >> 25 & 587"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "IP: `timeout 3 nc $IP 587 > ~/rre; timeout 1 nc $IP 25 >> ~/rre; cat ~/rre | grep -v -e '^$'| head -n1; rm -f ~/rre`"
echo "          ------"
echo "MX: `timeout 3 nc $MX 587 > ~/rre; timeout 1 nc $MX 25 >> ~/rre; cat ~/rre | grep -v -e '^$'| head -n1; rm -f ~/rre`"

#WHOIS Result for Domain
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo  "WHOIS Result for the Domain $1"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
whois $1 | grep -E "^Registry Expiry Date:|^Registrar URL:|^Name Server:"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
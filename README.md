# others
1)aibolit scanner 
2)panel finder command line: 
--
wget https://github.com/YousafKHamza/others/raw/master/ports.txt && printf 'x%.0s' {1..75};echo && cat ./ports.txt | cut -d: -f1 > ~/p &&  netstat -ntlp | awk {'print $4'} | rev |cut -d: -f1| rev| grep -v ^$ | sort | uniq | grep -v "[a-zA-Z]" > ~/up && grep -x -f  ~/up ~/p > ~/lp && for i in $(cat ~/lp); do grep $i ports.txt;done;rm -f ~/p ~/up ~/lp ./ports.txt && printf 'x%.0s' {1..75};echo
--

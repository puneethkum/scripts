#!/bin/bash

#time=30
time=60
#time=600
current_dir=`pwd`
hostname=`hostname`
tcpdump -n udp dst port 514 > output-tcpdump & VAR=$! ; sleep $time ; kill $VAR

cat output-tcpdump |awk '{print $3}' |cut -d. -f1,2,3,4  > ips

#This will de duplicate (remove duplicate ips)
awk '!seen[$0]++' ips > ips-de-duped-final

for i in `cat $current_dir/ips-de-duped-final` ;do nslookup $i;done | grep intuit.net |awk '{print $4}' > $current_dir/hosts
cat hosts|cut -d. -f1,2,3,4 > hosts1

cat hosts1 | tr '\n' ',' > $hostname

mv $hostname $hostname.nodegroups

#add the nodegroups: line to the resulting file
sed -i '1 i\nodegroups:'  $hostname.nodegroups



ips=`cat ips |wc -l`
echo "The total number of IPs captured is:  " $ips

#touch ips-de-duped-final
deduped=`cat ips-de-duped-final |wc -l`

echo "The number of unique IPs captured is:  " $deduped

#echo > $current_dir/ips
#echo > $current_dir/ips-de-duped-final
#echo > $current_dir/hosts
#echo > $current_dir/hosts1



echo "##################"
echo "###"
echo "### Resulting file is $hostname.nodegroups "
echo "###"
echo "##################"

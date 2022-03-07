#!/bin/bash

#check if script was run as root. Exit if true.
if [ $UID -eq '0' ];
 then 
  echo "Please do not run this script as root"
fi

#Define Variables
output=$HOME/research/sys_info.txt
ip=$(ip addr | grep inet | tail -2 | head -1)
execs=$(sudo find /home -type f -perm 777 2>/dev/null)

#Check for research dir. Create if needed.
if [ ! -d ~/research ];
 then
  mkdir ~/research 2> /dev/null
fi 

#Check for output file. Clear if needed.
if [ -f $output ];
 then 
  rm $output
fi

echo "quick system audit script" >> $output

date >> $output

echo "" >> $output

echo "Machine Type info:" >> $output
echo $MACHTYPE >> $output

echo -e "Uname info: $(uname -a) \n" >> $output

echo -e "IP info: $(ip addr | grep inet | head -9 | tail -1) \n" >> $output

echo -e "Hostname: $(hostname -s) \n" >> $output

echo "DNS Servers:" >> $output

cat /etc/resolv.conf >> $output

echo -e "\nMemory Info:" >> $output
free >> $output

echo -e "\nCPU info:" >> $output
lscpu | grep CPU >> $output

echo -e "\nDisk Usage:" >> $output
df -H | head -2 >> $output

echo -e "\nWho is logged in: \n $(who -a) \n" >> $output

echo -e "\nexec Files:" >> $output
echo $execs >> $output

echo -e "\nTop 10 Processes" >> $output

ps aux --sort -%mem | awk {'print $1, $2, $3, $4, $11'} | head >> $output

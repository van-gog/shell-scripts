#!/bin/bash

#set -x
progress () {
	if [ $# -eq 3 ]; then
		size=$3
	else
		size=100
	fi
	percentage_bar=`expr $1 \* ${size} / $2`
	percentage_display=`expr $1 \* 100 / $2`
	
	progress_bar=''
	empty_bar=''
	if [ ${percentage_bar} -gt 0 ]; then
		progress_bar=`seq -s "#" ${percentage_bar} | sed 's/[0-9]//g'`
	fi
	if [ ${percentage_bar} -lt ${size} ]; then
		empty_bars=`expr ${size} - ${percentage_bar}`
		empty_bar=`seq -s "." ${empty_bars} | sed 's/[0-9]//g'`
	fi
	bar=${progress_bar}${empty_bar}
	echo -en "[${bar}] ${percentage_display}% $1/$2\r"
	if [ $1 -eq $2 ]; then
		echo ""
	fi
}

for (( i=0; i<=40; i++));
do
	progress $i 100
done

echo ""

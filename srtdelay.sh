#!/bin/bash

#usage
function usage() {
    echo "$0 srtfile {inc|dec} timeSeconds"
    echo "Examples"
    echo "Add 500 miliseconds: $0 srtfile inc 0.5"
    echo "Delay 3 seconds: $0 srtfile dec 3"
    exit 1
}

#check if all arguments were passed
if [ ! $# -ne 3 ]; then
    usage
fi
 
#set operador
OP=""
if [ $2 == "inc" ]; then
    OP="+"
else
    OP="-"
fi

#machine timezone
TZ=`date +%Z`

#Regular expression to match SRT time
EXPR="^[0-9][0-9]:[0-9][0-9]:[0-9][0-9],[0-9][0-9][0-9][[:space:]][-][-][\>][[:space:]][0-9][0-9]:[0-9][0-9]:[0-9][0-9],[0-9][0-9][0-9]"

#Read file and calculate new time
while IFS='' read -u 3 -r line || [[ -n "$line" ]]; do
    if [[ $line =~ $EXPR ]]; then
	T1=$(echo "${line}" | cut -d'>' -f1 | cut -d' ' -f1)
	T2=$(echo "${line}" | cut -d'>' -f2 | cut -c2-)
	T1_N=$(date +%H:%M:%S,%3N --date="1985-08-27 ${T1} ${TZ} ${OP} $3 seconds")
	T2_N=$(date +%H:%M:%S,%3N --date="1985-08-27 ${T2} ${TZ} ${OP} $3 seconds")
	echo "${T1_N} --> ${T2_N}"
    else
	echo "${line}"
    fi
done 3< "$1"

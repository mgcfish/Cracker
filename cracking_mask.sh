#!/bin/bash

################# CUSTOMIZE #################

OCLHASHCAT_PATH="hashcat" # path to hashcat

CUSTOM_CHARSETS="-1 ?l?u -2 ?l?u?d -3 ?d?s" # custom charset (4 max)

#################### END ####################

if [ $# -lt 4 ] 
	then 
		echo "Usage: $0 HASH_TYPE HASH_FILE RECOVERED_FILE MASKS_FILE [HASHCAT_SWITCHES]"
		echo "Common hash types: MD5 - 0, SHA1 - 100, NTLM - 1000, LM - 3000, NetNTLMv2 - 5600"
	 	exit 1
fi

OTHER=""
COUNT=1
for var in "$@"
do
	if [ $COUNT -gt 4 ]
		then
			OTHER+="$var "
	fi
	COUNT=$[$COUNT + 1]
done

################# SHOULD BE LEFT UNMODIFIED #################

HASH_TYPE=$1 # hashcat hash type number
FILE=$2 # hash file
RECOVERED=$3 # password output file
MASKS=$4 # masks file
OCLHASHCAT="$OCLHASHCAT_PATH --remove -o $RECOVERED -m $HASH_TYPE $OTHER" # --force

############################ END ############################

cp $FILE "$FILE".bak # creating backup of hash file (hashes are moved to other file once cracked)

for m in `cat $MASKS`
do
	$OCLHASHCAT -a 3 $CUSTOM_CHARSETS $FILE $m
done


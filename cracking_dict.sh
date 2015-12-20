#!/bin/bash

################# CUSTOMIZE #################

OCLHASHCAT_PATH="hashcat" # path to hashcat
CRACKER_PATH="/root/Desktop/Tools/Cracking"

RULES="$CRACKER_PATH/Dict/Rules/" # rules directory
WORDLISTS="$CRACKER_PATH/Dict/Wordlists/" # wordlists directory
KEYPATTERNS="$CRACKER_PATH/Dict/Patterns/" # keypatterns directory

#################### END ####################

if [ $# -lt 3 ] 
	then 
		echo "Usage: $0 HASH_TYPE HASH_FILE RECOVERED_FILE [HASHCAT_SWITCHES]"
		echo "Common hash types: MD5 - 0, SHA1 - 100, NTLM - 1000, LM - 3000, NetNTLMv2 - 5600"
	 	exit 1
fi

OTHER=""
COUNT=1
for var in "$@"
do
	if [ $COUNT -gt 3 ]
		then
			OTHER+="$var "
	fi
	COUNT=$[$COUNT + 1]
done

################# SHOULD BE LEFT UNMODIFIED #################

HASH_TYPE=$1 # hashcat hash type number (MD5 - 0, SHA1 - 100, NTLM - 1000, LM - 3000, NetNTLMv2 - 5600)
FILE=$2 # hash file
RECOVERED=$3 # password output file
OCLHASHCAT="$OCLHASHCAT_PATH -o $RECOVERED -m $HASH_TYPE --remove $OTHER" # --force

############################ END ############################

cp $FILE "$FILE".bak # creating backup of hash file (hashes are moved to other file once cracked)

for x in `ls -p $WORDLISTS | grep -v /`
do
	$OCLHASHCAT -a 0 $FILE "$WORDLISTS"$x
	
	for r in `ls -p $RULES | grep -v /`
	do
		$OCLHASHCAT -a 0 -r "$RULES"$r $FILE "$WORDLISTS"$x
	done

	$OCLHASHCAT -a 6 $FILE "$WORDLISTS"$x ?a?a
	$OCLHASHCAT -a 7 $FILE ?a?a "$WORDLISTS"$x
	$OCLHASHCAT -a 6 -1 ?d?s $FILE "$WORDLISTS"$x ?1?1?1
	$OCLHASHCAT -a 7 -1 ?d?s $FILE ?1?1?1 "$WORDLISTS"$x

	for f in `ls -p $WORDLISTS | grep -v /`
	do
		for e in `ls -p $KEYPATTERNS | grep -v /`
		do
			$OCLHASHCAT -a 1 $FILE "$WORDLISTS"$f "$KEYPATTERNS"$e
			$OCLHASHCAT -a 1 $FILE "$KEYPATTERNS"$e "$WORDLISTS"$f
		done
	done

	$OCLHASHCAT  -a 1 $FILE "$WORDLISTS"$x "$WORDLISTS"$x
done


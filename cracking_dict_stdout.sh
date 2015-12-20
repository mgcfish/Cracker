#!/bin/bash

################# CUSTOMIZE #################

OCLHASHCAT_PATH="hashcat" # path to hashcat
CRACKER_PATH="/root/Desktop/Tools/Cracking"

RULES="$CRACKER_PATH/Dict/Rules/" # rules directory
WORDLISTS="$CRACKER_PATH/Dict/Wordlists/" # wordlists directory
KEYPATTERNS="$CRACKER_PATH/Dict/Patterns/" # keypatterns directory

#################### END ####################

################# SHOULD BE LEFT UNMODIFIED #################

OCLHASHCAT="$OCLHASHCAT_PATH --stdout" # --force

############################ END ############################

for x in `ls -p $WORDLISTS | grep -v /`
do
	$OCLHASHCAT -a 0 "$WORDLISTS"$x
	
	for r in `ls -p $RULES | grep -v /`
	do
		$OCLHASHCAT -a 0 -r "$RULES"$r "$WORDLISTS"$x
	done

	$OCLHASHCAT -a 6 "$WORDLISTS"$x ?a?a
	$OCLHASHCAT -a 7 ?a?a "$WORDLISTS"$x
	$OCLHASHCAT -a 6 -1 ?d?s "$WORDLISTS"$x ?1?1?1
	$OCLHASHCAT -a 7 -1 ?d?s ?1?1?1 "$WORDLISTS"$x

	for f in `ls -p $WORDLISTS | grep -v /`
	do
		for e in `ls -p $KEYPATTERNS | grep -v /`
		do
			$OCLHASHCAT -a 1 "$WORDLISTS"$f "$KEYPATTERNS"$e
			$OCLHASHCAT -a 1 "$KEYPATTERNS"$e "$WORDLISTS"$f
		done
	done

	$OCLHASHCAT -a 1 "$WORDLISTS"$x "$WORDLISTS"$x
done


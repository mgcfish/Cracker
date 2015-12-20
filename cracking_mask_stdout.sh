#!/bin/bash

################# CUSTOMIZE #################

OCLHASHCAT_PATH="hashcat" # path to hashcat
MASKS="/root/Desktop/Tools/Cracking/Masks/normal.mask" # path to a masks file

CUSTOM_CHARSETS="-1 ?l?u -2 ?l?u?d -3 ?d?s" # custom charset (4 max)

#################### END ####################

################# SHOULD BE LEFT UNMODIFIED #################

OCLHASHCAT="$OCLHASHCAT_PATH --stdout" # --force

############################ END ############################

for m in `cat $MASKS`
do
	$OCLHASHCAT -a 3 $CUSTOM_CHARSETS $m
done


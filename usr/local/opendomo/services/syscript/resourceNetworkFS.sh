#!/bin/sh
#desc: Configure NFS resource
#package:odnetdrives
#type:local

IFS=$'\x0A'$'\x0D'
SERVFILE="/var/opendomo/tmp/avahi.services"
TEMPFILE="/var/opendomo/tmp/avahi.tmp"
FSTBFILE="/etc/fstab"
MOUNTDIR="/media"

NFSOPTIONS="rw,rsize=8192,wsize=8192,timeo=14,intr"

if   [ "$2" == "on" ]; then
    # Configuring resource
    source $TEMPFILE
    NAME=`basename $FOLD`

    # recheck manual service
    avahi-browse -larptc | grep "Network File System;local;$HOST.local;$ADDR" &>/dev/null || MANUAL="added manual"
    echo "$ADDR:$FOLD    $MOUNTDIR/$HOST/$NAME    nfs    $NFSOPTIONS 0 0 # NetworkFS $MANUAL" >>$FSTBFILE

elif [ "$2" = "off" ]; then
    # Deleting resource
    source $TEMPFILE
    NAME=`basename $FOLD`
    OTHERDRIVES=`grep -v "$ADDR:$FOLD" $FSTBFILE`
    echo "$OTHERDRIVES" > $FSTBFILE

elif ! test -z "$3"; then
    # Configuring manual drive
    ADDR="$1"; HOST="$2"; FOLD="$3"
    NAME=`basename $FOLD`
    echo "$ADDR:$FOLD    $MOUNTDIR/$HOST/$NAME    $NFSOPTIONS 0 0 # NetworkFS added manual" >>$FSTBFILE

    # Return to manageResources
    manageNetworkResources.sh

elif [ "$2" = "auto" ]; then
    # Extract information
    NAME=`echo "$1" | cut -f1 -d"-"`
    TYPE=`echo "$1" | cut -f2 -d"-"`
    LINE=`grep "$NAME;$TYPE" $SERVFILE`
    FOLD=`echo $LINE | awk -F";" '{print $10}' | cut -f2 -d= | cut -f1 -d\"`
    echo "HOST=`echo $LINE | awk -F";" '{print $7}' | cut -f1 -d.`"      > $TEMPFILE
    echo "ADDR=`echo $LINE | awk -F";" '{print $8}'`"                   >> $TEMPFILE
    echo "PORT=`echo $LINE | awk -F";" '{print $9}'`"                   >> $TEMPFILE
    echo "NAME=\"$NAME\""                                               >> $TEMPFILE
    echo "TYPE=\"$TYPE\""                                               >> $TEMPFILE
    echo "FOLD=$FOLD"                                                   >> $TEMPFILE
    source $TEMPFILE
    grep $ADDR:$DRIVEPATH $FSTBFILE &>/dev/null && STATUS=on
    grep $ADDR:$DRIVEPATH $FSTBFILE &>/dev/null || STATUS=off

    # See info service
    echo "#> NetworkFS service detailed"
    echo "form:`basename $0`"
    echo "	name	Name	readonly	$NAME"
    echo "	addr	Address	readonly	$ADDR"
    echo "	host	Hostname	readonly	$HOST"
    echo "	fold	Route  	readonly	$FOLD"
    echo "	drive	Mount in opendomo	subcommand[on,off]	$STATUS"
    echo "actions:"
    echo "	goback	Back"
    echo

else
    # You are configuring service manually
    echo "#> Configure NetworkFS service"
    echo "form:`basename $0`"
    echo "	addr	Address	text	$ADDR"
    echo "	host	Hostname	text	$HOST"
    echo "	fold	Route	text	$FOLD"
    echo
fi

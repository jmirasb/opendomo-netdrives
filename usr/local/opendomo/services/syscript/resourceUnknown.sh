#!/bin/sh
#desc: Configure NFS resource
#package:odnetdrives
#type:local

SERVFILE="/var/opendomo/tmp/avahi.services"
TEMPFILE="/var/opendomo/tmp/avahi.tmp"

# This resource is useful, so only extract and see information
NAME=`echo "$1" | cut -f1 -d"-"`
TYPE=`echo "$1" | cut -f2 -d"-"`
LINE=`grep "$NAME;$TYPE" $SERVFILE`
HOST=`echo $LINE | awk -F";" '{print $7}' | cut -f1 -d.`
ADDR=`echo $LINE | awk -F";" '{print $8}'`
OTHE=`echo $LINE | awk -F";" '{print $10}' | sed 's/\"//g'`
echo "$OTHE"

# See info service
echo "#> Service detailed"
echo "form:`basename $0`"
echo "	type	Service Type	readonly	$TYPE"
echo "	name	Service Name	readonly	$NAME"
echo "	addr	Address	readonly	$ADDR"
echo "	host	Hostname	readonly	$HOST"
test -z $OTHE || echo "	other	Other info	readonly	$OTHE"
echo "actions:"
echo "	goback	Back"
echo

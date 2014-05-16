#!/bin/sh
#desc:Add host
#package:odnetdrives
#type:local

CONF="/etc/opendomo/system/hosts.allow"

if test -z $2; then
    echo "#> Add host"
    echo "form:`basename $0`"
    echo "	NAME	Name	text	$1"
    echo "	IP	IP Address	text	$2"
    echo
else
    IP=`grep -c $1 $CONF`
    if test $IP != 0; then
        echo "#ERR This host is already configured"
    else
        echo "portmap: $2	#$1" >> $CONF
        echo "#INFO Server host configuration added."
        echo "#WARN You need reboot service"

        /usr/local/opendomo/manageShared.sh
    fi
fi

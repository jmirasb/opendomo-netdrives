#!/bin/sh
#desc:Delete host
#package:odnetdrives
#type:local

CONF="/etc/opendomo/system/hosts.allow"

if test -z $1; then
    echo "#ERROR You need select host to delete"
    resourceNFSServer.sh
else
    CONFIG=`grep -v $1 $CONF`
    echo "$CONFIG" > "$CONF"
    resourceNFSServer.sh
fi

#!/bin/sh
#desc:Delete host
#package:odnetdrives
#type:local

CONF="/etc/opendomo/system/hosts.allow"

if test -z $1; then
    echo "#ERROR You need select host to delete"
    /usr/local/opendomo/manageHosts.sh
else
    for host in $@; do
        CONFIG=`grep -v $host $CONF`
        echo "$CONFIG" > "$CONF"

        echo "#INFO Server host configuration deleted."
        echo "#WARN You need reboot service"
    done
fi

/usr/local/opendomo/manageShared.sh

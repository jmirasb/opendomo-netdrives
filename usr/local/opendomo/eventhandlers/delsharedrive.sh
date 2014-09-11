#!/bin/sh
#desc: Deleted share device

# As a Event Handler, the first and second parameters are the level and package.
# The third parameter is text and the fourth is a path to a file. In this case,
# the fourth is a name or path to the new detected device:

# Is necessary device name
if ! test -z "$4"; then

    CONFIG="/etc/opendomo/system/exports"
    SERVICES="nfs-kernel-server"

    # Delete drive and restart service
    OTHERDRIVES=`grep -v "$4" $CONFIG`
    echo "$OTHERDRIVES" > $CONFIG

    echo "#INFO Drive deleted"
    sudo changestate.sh service $SERVICES off
    sudo changestate.sh service $SERVICES on
else
    echo "#ERRO You need specify drive to share"
fi

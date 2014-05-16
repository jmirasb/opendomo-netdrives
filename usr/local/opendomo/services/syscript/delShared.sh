#!/bin/sh
#desc:Delete shared drive
#package:odnetdrives
#type:local

REMOTECONF="/etc/opendomo/system/fstab"
LOCALCONF="/etc/opendomo/system/exports"
MOUNTSDIR="/run/mounts"
DRIVE="$1"

if test -z "$1"; then
    echo "#ERRO You need select drive"
    /usr/local/opendomo/manageShared.sh
else
    # Search drive in local or remote
    if test -d "$MOUNTSDIR/$DRIVE"; then
        # Remote resource
        OTHERS=`grep -v "$MOUNTSDIR/$DRIVE" $REMOTECONF`
	echo "$OTHERS" > $REMOTECONF

        echo "#INFO Remote drive $DRIVE deleted"
        /usr/local/opendomo/manageShared.sh
    else
        # Local drive
        OTHERS=`grep -v "/media/$DRIVE" $LOCALCONF`
        echo "$OTHERS" > $LOCALCONF

        echo "#INFO Shared drive $DRIVE deleted"
        /usr/local/opendomo/manageShared.sh
    fi
fi

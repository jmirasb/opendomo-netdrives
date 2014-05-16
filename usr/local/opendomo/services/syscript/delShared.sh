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
else
    # Stop service
    echo "#WARN Unmounting all shared devices"
    sudo changestate.sh service netdrives-mount off

    # Multiple imput support
    for drive in "$@"; do
        # Search drive in local or remote
        if test -d "$MOUNTSDIR/$drive"; then
            # Remote resource
            OTHERS=`grep -v "$MOUNTSDIR/$drive" $REMOTECONF`
	    echo "$OTHERS" > $REMOTECONF
            rmdir "$MOUNTSDIR/$drive"

            echo "#INFO Remote drive $drive deleted"
        else
            # Local drive
            OTHERS=`grep -v "/media/$drive" $LOCALCONF`
            echo "$OTHERS" > $LOCALCONF

            echo "#INFO Shared drive $drive deleted"
        fi
    done
fi

# Return manage shared
/usr/local/opendomo/manageShared.sh

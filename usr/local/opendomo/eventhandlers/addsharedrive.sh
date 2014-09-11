#!/bin/sh
#desc: Share device

# As a Event Handler, the first and second parameters are the level and package.
# The third parameter is text and the fourth is a path to a file. In this case,
# the fourth is a name or path to the new detected device:

# Is necessary device name
if ! test -z "$4"; then

    CONFIG="/etc/opendomo/system/exports"
    DRIVE="/media/$4"
    OPTIONS="rw,no_root_squash,subtree_check"
    IPRANGE=`hostname -I | awk -F. '{print$1"."$2"."$3}'`
    HOSTRANGE=`echo $IPRANGE.0/255.255.255.0`
    SERVICES="nfs-kernel-server"

    # Adding drive to export
    if [ `grep -n1 -c "$4" $CONFIG` == "1" ]; then
        echo "#ERRO Drive exist"
    else
        echo "#INFO Adding drive"
        echo "/media/$4 $HOSTRANGE($OPTIONS)" >> "$CONFIG"

        # Restarting services
        sudo changestate.sh service $SERVICES off
        sudo changestate.sh service $SERVICES on
    fi
else
    echo "#ERRO You need specify drive to share"
fi

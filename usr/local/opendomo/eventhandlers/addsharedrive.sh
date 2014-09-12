#!/bin/sh
#desc: Add share device

# As a Event Handler, the first and second parameters are the level and package.
# The third parameter is text and the fourth is a path to a file. In this case,
# the fourth is a name or path to the new detected device:

# Is necessary device name
if ! test -z "$4"; then

    # Adding drive to export
    NFSCONFIG="/etc/opendomo/system/exports"
    DRIVE="/media/$4"
    OPTIONS="rw,no_root_squash,subtree_check"
    IPRANGE=`hostname -I | awk -F. '{print$1"."$2"."$3}'`
    HOSTRANGE=`echo $IPRANGE.0/255.255.255.0`

    if [ `grep -n1 -c "$4" $NFSCONFIG` == "1" ]; then
        echo "#ERRO Drive exist"
    else
        echo "#INFO Adding drive"
        echo "/media/$4 $HOSTRANGE($OPTIONS)" >> "$CONFIG"

        # Restarting services
        sudo changestate.sh service nfs-kernel-server off
        sudo changestate.sh service nfs-kernel-server on
    fi
    # Adding drive to samba configuration file
    SMBCONFIG="/etc/opendomo/system/smb.conf"
    NAME="$4"
    ROUTE="/media/$4"

    if [ `grep -n1 -c "\[ $4 \]" $SMBCONFIG` == "1" ]; then
        echo "#ERRO Drive exist"
    else
        echo "#INFO Adding drive"
        echo                                      >> $SMBCONFIG
        echo "[ $4 ]"				  >> $SMBCONFIG
        echo "     comment = $4 Shared by samba"  >> $SMBCONFIG
        echo "     path = $ROUTE"                 >> $SMBCONFIG
        echo "     writeable = yes"               >> $SMBCONFIG
        echo "     guest ok = no"                 >> $SMBCONFIG
        echo "     public = yes"                  >> $SMBCONFIG

        # Restarting services
        sudo changestate.sh service samba off
        sudo changestate.sh service samba on
    fi
else
    echo "#ERRO You need specify drive to share"
fi

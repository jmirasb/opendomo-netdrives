#!/bin/sh
#desc:Add shared drive
#package:odnetdrives
#type:local

REMOTECONF="/etc/opendomo/system/fstab"
MOUNTSDIR="/run/mounts"
SERVERTYPE="NFS:NetworkFS server,SMB:Windows server"

if test -z "$2"; then
    echo "#> Add remote drive"
    echo "form:`basename $0`"
    echo "	type	Server type	list[$SERVERTYPE]	$TYPE"
    echo "	ip	Server address	text	$IP"
    echo "	folder	Folder	text	$FOLDER"
    echo "	user	User name	text	$REUSER"
    echo "	passw	Password	password	$PASSWD"
    echo
else
    IP="$2"
    FOLDER="$3"
    USER="$4"
    PASSWD="$5"
    NFSOPTIONS="rw,rsize=8192,wsize=8192,timeo=14,intr"
    SMBOPTIONS="user=$USER,password=$PASSWD"
    MOUNTPOINT="$MOUNTSDIR/$IP-`basename $3`"

    if [ "$1" == "NFS" ]; then
        # Configure nfs drive
        if test -z `cat $REMOTECONF | grep "$IP:$FOLDER"`; then
            # Creating mount folder
            if mkdir -p $MOUNTPOINT; then
               echo "#INFO NetworkFS drive configured"
               echo "$IP:$FOLDER	$MOUNTPOINT	nfs	$NFSOPTIONS	0 0" >>$REMOTECONF
            fi
        else
            echo "#ERRO Drive already exist"
        fi
        # Return configuration
        /usr/local/opendomo/manageShared.sh

    elif [ "$1" == "SMB" ]; then
        # Configure samba drive
        if test -z `cat $REMOTECONF | grep "//$IP:/$FOLDER"`; then
            # Creating mount folder
            if mkdir -p $MOUNTPOINT; then
                echo "#INFO Windows drive configured"
                echo "//$IP/$FOLDER	$MOUNTPOINT	smbfs	$SMBOPTIONS	0 0" >>$REMOTECONF
            fi
        else
            echo "#ERRO Drive already exist"
        fi
        # Return configuration
        /usr/local/opendomo/manageShared.sh
    fi
fi

#!/bin/sh
#desc: Manage shared devices
#package:odnetdrives
#type:local

HOSTSCONF="/etc/opendomo/system/hosts.allow"
DRIVECONF="/etc/opendomo/system/exports"
REMDRIVES="/etc/opendomo/system/fstab"
IFS=$'\x0A'$'\x0D'

echo "#> Authorized hosts"
echo "list:`basename $0`	detailed"
if test -z "$HOSTSCONF"; then
    echo "#WARN No hosts configured yet"
else
    for host in `cat $HOSTSCONF`; do
        IP=`echo $host | awk '{print $2}'`
        NAME=`echo $host | cut -f2 -d"#"`
        echo "	-$IP	$NAME	host	$IP"
    done
fi
echo "actions:"
echo "	addHost.sh	Add"
echo "	delHost.sh	Remove"
echo

echo "#> Shared drives"
echo "list:`basename $0`	detailed"
for local in `cat $DRIVECONF`; do
    DEVICE=`echo $local | awk '{print$1}' | sed 's/\/media\///'`
    echo "	-$DEVICE	$DEVICE	device	Local device"
done
for remote in `cat $REMDRIVES`; do
    # Extracting samba or nfs configuration
    MOUNTPOINT=`echo $remote | awk '{print$2}' | sed 's/\/run\/mounts\///'`
    ADDRESS=`echo $MOUNTPOINT | cut -f1 -d-`
    DEVICE=`echo $MOUNTPOINT | cut -f2 -d-`

    if ! test -z `echo $remote | grep ":"`; then
        echo "	-$MOUNTPOINT	$DEVICE in $ADDRESS	device	NFS device"
    else
        echo "	-$MOUNTPOINT	$DEVICE in $ADDRESS	device	SMB device"
    fi
done

echo "actions:"
echo "	addShared.sh	Add remote device"
echo "	delShared.sh	Remove"
echo

#!/bin/sh
#desc: Manage network resources
#package:odnetdrives
#type:local

# Variables
IFS=$'\x0A'$'\x0D'
SERVFILE="/var/opendomo/tmp/avahi.services"
TEMPFILE="/var/opendomo/tmp/avahi.tmp"
FSTBFILE="/etc/fstab"

# Without service, see available services. With them, see detailed info
if test -z "$1"; then
    # Check services, hostnames and xbmc no standard services
    avahi-browse -larptc | grep -vE "\+|Workstation|_xbmc|_airplay" > $SERVFILE
    sed -i 's/\\.../ /g' $SERVFILE

    # Adding manual services to temporal file
    for drive in `grep "added manual" $FSTBFILE`; do
        TYPE=`echo $drive | awk '{print$7}'`
        if   [ "$TYPE" == "NetworkFS" ]; then
            HOST=`echo $drive | awk '{print$2}' | cut -f3 -d"/"`
            ADDR=`echo $drive | cut -f1 -d:`
            DRIVEPATH=`echo $drive | cut -f2 -d: | cut -f1 -d" "`
            DRIVE=`basename $DRIVEPATH`
            echo "=;eth0;IPv4;Drive $DRIVE on $HOST;Network File System;local;$HOST.local;$ADDR;2049;\"path=$DRIVEPATH\"" >> $SERVFILE
        elif [ "$TYPE" == "WindowsFS" ]; then
            # Generating temporal file
            HOST=`echo $drive | awk '{print$2}' | cut -f3 -d"/"`
            ADDR=`echo $drive | cut -f3 -d'\'`
            DRIVE=`echo $drive | cut -f3 -d'\' | cut -f1 -d" "`
	    echo "=;eth0;IPv4;$HOST;Microsoft Windows Network;local;$HOST.local;$ADDR;445" >> $SERVFILE
        fi
    done

    # See interface
    echo "#> Services on your network"
    echo "list:`basename $0`	detailed"
    test -z `cat $SERVFILE | head -c1` && echo "# The resourses in your network can't be discover, please add manually."
    for service in `cat $SERVFILE`; do
        NAME=`echo $service | awk -F";" '{print $4}'`
        TYPE=`echo $service | awk -F";" '{print $5}'`
        echo "	-$NAME-$TYPE	$NAME	service	$TYPE"
    done
    echo "actions:"
    echo "	addResource.sh	Add resource"
    echo "	configLocalResources.sh	Configure local resources"
    echo
else
    # Call resource$Service.sh for configuration
    if   test  `echo "$1" | grep "Network File System"`; then
        resourceNetworkFS.sh "$1" "auto"
    elif test  `echo "$1" | grep "Microsoft Windows Network"`; then
        resourceWindowsFS.sh "$1" "auto"
    else
        # Special resource, is a resource not usable
        resourceUnknown.sh "$1"
    fi
fi

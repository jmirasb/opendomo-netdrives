#!/bin/sh
#desc: Configure local resources
#package:odnetdrives
#type:local

IFS=$'\x0A'$'\x0D'
AVAHIDIR="/etc/avahi/services"
HOSTSERV="/var/opendomo/tmp/avahi.local"
SERVTYPE="/usr/share/avahi/service-types"
FSTBFILE="/etc/fstab"
HOSTNAME=`hostname`

# Call resource$Service.sh for configuration
if   test  `echo "$1" | grep "Network File Server"`; then
    resourceNFSServer.sh
elif test  `echo "$1" | grep "Microsoft Windows Server"`; then
    resourceWFSServer.sh
elif test  `echo "$1" | grep "SSH Remote Terminal"`; then
    resourceSSHServer.sh
elif test  `echo "$1" | grep "SFTP File Transfer"`; then
    resourceFTPServer.sh
elif test  `echo "$1" | grep "Web Site"`; then
    resourceWEBServer.sh
elif test  `echo "$1" | grep "Local Drive"`; then
    resourceLocalDrive.sh
else
    # Adding services to temporal file
    rm $HOSTSERV
    cd $AVAHIDIR
    # Adding avahi services
    for file in *; do
        # Extract service info and add to temporal file
        CODE=`cat $file | grep "</type>" | cut -f2 -d">" | cut -f1 -d"<"`
        NAME=`cat $file | grep "</name>" | cut -f2 -d">" | cut -f1 -d"<" | sed 's/\%h //'`
        TYPE=`cat $SERVTYPE | grep -m1 "$CODE:" | cut -f2 -d:`

        # Ignoring NetworkFS drives (configured in server option)
        if [ "$TYPE" != "Network File System" ]; then
            echo "=;eth0;IPv4;$NAME;$TYPE"     >> $HOSTSERV
        fi
    done
    # Adding local drives
    cd /media
    for drive in *; do
        grep "$drive" $FSTBFILE &>/dev/null || echo "=;eth0;IPv4;$drive;Local Drive"  >> $HOSTSERV
    done
    echo "=;eth0;IPv4;OpenDomoOS NetworkFS server;Network File Server"                >> $HOSTSERV
    echo "=;eth0;IPv4;OpenDomoOS Windows Network server;Microsoft Windows Server"     >> $HOSTSERV

    # See interface
    echo "#> Services provided by opendomo"
    echo "list:`basename $0`	detailed"
    for service in `cat $HOSTSERV`; do
        NAME=`echo $service | awk -F";" '{print $4}' | sed -e "s/$HOSTNAME //g"`
        TYPE=`echo $service | awk -F";" '{print $5}'`
        echo "	-$NAME-$TYPE	$NAME	service	$TYPE"
    done
    echo "actions:"
    echo "	manageNetworkResources.sh	Back"
    echo
fi

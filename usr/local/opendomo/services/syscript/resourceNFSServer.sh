#!/bin/sh
#desc: Configure NFS server
#package:odnetdrives
#type:local

IFS=$'\x0A'$'\x0D'
HOSTFILE="/etc/hosts.allow"
AVAHIDIR="/etc/avahi/services"
TEMPFILE="/var/opendomo/tmp/avahi.workstation"

if   [ "$2" == "on" ]; then
    # Discover services, move nfs services to .service file
    cd $AVAHIDIR
    mv opendomo-nfs.disabled opendomo-nfs.enabled 2>/dev/null
    for service in `ls -1 opendomo-nfs-*`; do
        NAME=`echo $service | cut -f1 -d.`
        mv $NAME.disabled $NAME.service 2>/dev/null
    done

elif [ "$2" == "off" ]; then
    # Hid services, move nfs services to .disabled file
    cd $AVAHIDIR
    mv opendomo-nfs.enabled opendomo-nfs.disabled 2>/dev/null
    for service in `ls -1 opendomo-nfs-*`; do
        NAME=`echo $service | cut -f1 -d.`
        mv $NAME.service $NAME.disabled 2>/dev/null
    done

elif ! test -z "$1"; then
    # Is a service, change state
    ADDR=`echo "$1" | cut -f1 -d-`
    HOST=`echo "$1" | cut -f2 -d-`
    if `grep "$ADDR" $HOSTFILE &>/dev/null`; then
        delHost.sh "$ADDR"
    else
        addHost.sh $HOST "$ADDR"
    fi
else

    # Searching configured and discovered workstations and see interface
    avahi-browse -larptc | grep -E "Workstation" | grep -v "+" > $TEMPFILE
    for host in `cat $HOSTFILE`; do
        HOST=`echo $host | awk '{print$3}' | cut -f2 -d"#"`
        ADDR=`echo $host | awk '{print$2}'`
        # Omit discover hosts
        if ! test -z "$HOST"; then
            grep $HOST "$TEMPFILE" &>/dev/null || echo "=;eth0;IPv4;$HOST;Workstation;local;$HOST.local;$ADDR;9;" >> $TEMPFILE
        fi
    done

    echo "#> Authorized hosts"
    echo "list:`basename $0`	detailed"
    # See discover hosts
    for host in `cat $TEMPFILE`; do
        HOST=`echo $host | awk -F";" '{print$7}' | cut -f1 -d.`
        ADDR=`echo $host | awk -F";" '{print$8}'`
        grep "$ADDR" $HOSTFILE &>/dev/null && STATUS="allow"
        grep "$ADDR" $HOSTFILE &>/dev/null || STATUS="deny"
        echo "	-$ADDR-$HOST	$HOST	service	$STATUS"
    done
    echo "actions:"
    echo "	configLocalResources.sh	Back"
    echo "	addHost.sh	Add"
    echo
    # Check discover status
    ls $AVAHIDIR/opendomo-nfs.enabled  &>/dev/null && DISCOVER=on
    ls $AVAHIDIR/opendomo-nfs.disabled &>/dev/null && DISCOVER=off
    echo "#> Server options"
    echo "form:`basename $0`"
    echo "	discover	Discover drives	subcommand[on,off]	$DISCOVER"
fi

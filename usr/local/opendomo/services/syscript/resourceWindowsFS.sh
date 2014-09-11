#!/bin/sh
#desc: Configure SMB resource
#package:odnetdrives
#type:local

IFS=$'\x0A'$'\x0D'
SERVFILE="/var/opendomo/tmp/avahi.services"
TEMPFILE="/var/opendomo/tmp/avahi.tmp"
FSTBFILE="/etc/fstab"
MOUNTDIR="/media"

if   [ "$2" == "on" ]; then
    # We have all data
    source $TEMPFILE
    SMBOPTIONS="user=$USERNAME,iocharset=utf8,file_mode=0777,dir_mode=0777,noperm"
    test -z "$PASSWORD" || SMBOPTIONS="$SMBOPTIONS,password=$PASSWORD"
    # recheck manual service
    avahi-browse -larptc | grep "Microsoft Windows Network;local;$HOST.local;$ADDR" &>/dev/null || MANUAL="added manual"
    echo "\\\\$ADDR\\$1    $MOUNTDIR/$HOST/$1    cifs    $SMBOPTIONS 0 0 # WindowsFS $MANUAL" >> $FSTBFILE

elif [ "$2" = "off" ]; then
    # Deleting resource
    source $TEMPFILE
    OTHERDRIVES=`grep -v "\S\S$ADDR\S$1" $FSTBFILE`
    echo "$OTHERDRIVES" > $FSTBFILE

elif test -z "$4" && [ "$2" = "auto" ]; then
    # Extract information form temporal file
    NAME=`echo "$1" | cut -f1 -d"-"`
    TYPE=`echo "$1" | cut -f2 -d"-"`
    LINE=`grep "$NAME;$TYPE" $SERVFILE`
    echo "HOST=`echo $LINE | awk -F";" '{print $7}' | cut -f1 -d.`"      > $TEMPFILE
    echo "ADDR=`echo $LINE | awk -F";" '{print $8}'`"                   >> $TEMPFILE
    echo "PORT=`echo $LINE | awk -F";" '{print $9}'`"                   >> $TEMPFILE
    echo "NAME=\"$NAME\""                                               >> $TEMPFILE
    echo "TYPE=\"$TYPE\""                                               >> $TEMPFILE
    # Check password in fstab for this server
    USERNAME=`awk -F"," '/$ADDR|WindowsFS/{ print$1 }' $FSTBFILE | cut -f2 -d= | uniq`
    PASSWORD=`awk '/192.168.1.3|WindowsFS/{ print$4 }' $FSTBFILE | cut -f6 -d= | uniq`
    source $TEMPFILE

else
    # Temporal file is not available (manual configuration) or parameters sent
    NAME="$1"; ADDR="$2"; HOST="$3"; USERNAME="$5"; PASSWORD="$6"
    echo "NAME=$NAME"                    > $TEMPFILE
    echo "HOST=$HOST"                    > $TEMPFILE
    echo "ADDR=$ADDR"                   >> $TEMPFILE
    echo "USERNAME=$USERNAME"           >> $TEMPFILE
    echo "PASSWORD=$PASSWORD"           >> $TEMPFILE
    source $TEMPFILE

fi

# Selecting discover configuration or manual
if [ "$2" = "auto" ]; then
    # Server info, but is necessary check password before to continue
    echo "#> Windows Server info"
    echo "form:`basename $0`"
    echo "	name	Name	hidden	$NAME"
    echo "	addr	Address	readonly	$ADDR"
    echo "	host	Hostname	readonly	$HOST"
    echo "	secu	Security	hidden	security"

else
    NAME=`echo $HOST | tr [a-z] [A-Z]`
    # Server info, but is necessary check password before to continue
    echo "#> Windows Server info"
    echo "form:`basename $0`"
    echo "	name	Name	hidden	$NAME"
    echo "	addr	Address	text	$ADDR"
    echo "	host	Hostname	text	$HOST"
    echo "	secu	Security	hidden	security"
fi

# User and password (can be void) sended, see server folders
if ! test -z "$USERNAME"; then
    echo "	user	Username	readonly	$USERNAME"
    echo "	pass	Password	readonly	$PASSWORD"
    echo "actions:"
    echo "	resourceWindowsFS.sh	Update credencials"
    echo
    echo "#> Folders in [$HOST]"
    echo "form:`basename $0`"
    #TODO Check secured servers
    FOLDERS=`smbclient -N -L $NAME 2>/dev/null | grep Disk | awk '{print$1}'`

    if test -z $FOLDERS; then
        echo "# Can't be detected folders in this server, please check configuration"
    fi
    for folder in $FOLDERS; do
        grep "\S\S$ADDR\S$folder" $FSTBFILE &>/dev/null && STATUS=on
        grep "\S\S$ADDR\S$folder" $FSTBFILE &>/dev/null || STATUS=off
        echo "	$folder	Access to [$folder] folder	subcommand[on,off]	$STATUS"
    done
    echo "actions:"
    echo "	goback	Back"
    echo

else
    # You need check security configuration first
    echo "	user	Username	text	$USERNAME"
    echo "	pass	Password	text	$PASSWORD"
    echo "actions:"
    echo "	goback	Back"
    echo "	resourceWindowsFS.sh	Update credencials"
    echo

fi

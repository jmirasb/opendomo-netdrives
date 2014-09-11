#!/bin/sh
#desc: Configure Samba server
#package:odnetdrives
#type:local

IFS=$'\x0A'$'\x0D'
SAMBAFILE="/etc/samba/smb.conf"
GLOBALSECTION=`sed '40,60d' $SAMBAFILE`
DRIVESSECTION=`sed "1,40d" $SAMBAFILE`

if ! test -z "$1"; then
    # Configure server, rebuild smb configuration file
    GLOBALSECTION=`echo "$GLOBALSECTION" | grep -v "workgroup ="`
    echo "$GLOBALSECTION"        > $SAMBAFILE
    echo "    workgroup =$1"    >> $SAMBAFILE
    echo                        >> $SAMBAFILE
    echo "$DRIVESSECTION"       >> $SAMBAFILE
fi

# Check currect configuration
WORKGROUP=`grep "workgroup =" $SAMBAFILE | cut -f2 -d=`

# Configure server options
echo "#> Configure server"
echo "form:`basename $0`"
echo "	group	Workgroup	text	$WORKGROUP"
#  TODO Only unprotected drives accepted, no user and password required
#  echo "	user	User	text	$USERNAME"
#  echo "	passw	Password	text	$PASSWORD"
echo "actions:"
echo "	configLocalResources.sh	Back"
echo "	resourceWFSServer.sh	Change"
echo

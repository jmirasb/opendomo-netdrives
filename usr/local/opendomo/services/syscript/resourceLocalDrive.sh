#!/bin/sh
#desc: Configure SSH FTP server
#package:odnetdrives
#type:local

DRIVE="$1"
CONFFILE="/media/$DRIVE/opendomo.cfg"

# Check config file
if test -f "$CONFFILE"; then
    source $CONFFILE
else
    exit 1
fi

# Configure drive
if   [ "$2" = "on" ]; then
    OPTIONS=`grep -v "DISKTYPE" $CONFFILE`
    echo "$OPTIONS"                                              > $CONFFILE
    echo "DISKTYPE=\"$DISKTYPE share\""                         >> $CONFFILE
elif [ "$2" = "off" ]; then
    OPTIONS=`grep -v "DISKTYPE" $CONFFILE`
    echo "$OPTIONS"                                              > $CONFFILE
    echo "DISKTYPE=\"`echo "$DISKTYPE" | sed 's/share//g'`\""  >> $CONFFILE
fi

# Check status and see drive info
grep share $CONFFILE &>/dev/null && STATUS=on
grep share $CONFFILE &>/dev/null || STATUS=off
echo "form:`basename $0`"
echo "	$drive	Share drive	subcommand[on,off]	$STATUS"
echo "actions:"
echo "	goback	Back"
echo

#!/bin/sh
#desc: Configure SSH FTP server
#package:odnetdrives
#type:local


DRIVE=`echo "$1" | cut -f1 -d"-"`
CONFFILE="/media/$DRIVE/opendomo.cfg"


if test -z "$DRIVE"; then
    echo "#ERRO You need a valid drive"
    echo
else
    # Configure drive
    if   [ "$2" = "on" ]; then
        OPTIONS=`grep -v "DISKTYPE" $CONFFILE`
        test -z $OPTIONS || echo "$OPTIONS"                          > $CONFFILE
        echo "DISKTYPE=\"$DISKTYPE share\""                         >> $CONFFILE
    elif [ "$2" = "off" ]; then
        OPTIONS=`grep -v "DISKTYPE" $CONFFILE`
        test -z "$OPTIONS" || echo "$OPTIONS"                        > $CONFFILE
        echo "DISKTYPE=\"`echo "$DISKTYPE" | sed 's/share//g'`\""   >> $CONFFILE
    fi

    # Check status and see drive info
    grep share $CONFFILE &>/dev/null && STATUS=on
    grep share $CONFFILE &>/dev/null || STATUS=off

    echo "form:`basename $0`"
    echo "	$DRIVE	Share [$DRIVE] in your network	subcommand[on,off]	$STATUS"
    echo "actions:"
    echo "	goback	Back"
    echo
fi

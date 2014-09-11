#!/bin/sh
#desc: Configure SSH FTP server
#package:odnetdrives
#type:local

SERVFILE="/etc/avahi/services/opendomo-sftp.service"
HIDEFILE="/etc/avahi/services/opendomo-sftp.disabled"

# Check status
test -f $SERVFILE && STATUS=on
test -f $SERVFILE || STATUS=off

if ! test -z "$1"; then
     # Move file to hide service
     test "$2" = "on"  && mv $HIDEFILE $SERVFILE 2>/dev/null
     test "$2" = "off" && mv $SERVFILE $HIDEFILE 2>/dev/null
fi

# See info service
echo "form:`basename $0`"
echo "	discover	Discover service	subcommand[on,off]	$STATUS"
echo "	:	Remember, this is a basic service in opendomo, can't be stopped, only can be hide or discover	:"
echo "actions:"
echo "	goback	Back"
echo

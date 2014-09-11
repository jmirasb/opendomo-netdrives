#!/bin/sh
#desc: Add hidden resource
#package:odnetdrives
#type:local

RESOURCES="NetworkFS:Network File System,WindowsFS:Microsoft Windows Network"

# Delete temporal file
rm "/var/opendomo/tmp/avahi.tmp"

# See form
if test -z "$1"; then
    echo "#> Add network resource"
    echo "form:`basename $0`"
    echo "	type	Type	list[$RESOURCES]	$TYPE"
    echo
else
    resource$1.sh
fi

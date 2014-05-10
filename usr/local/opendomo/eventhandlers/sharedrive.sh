#!/bin/sh
#desc: Share device

# As a Event Handler, the first and second parameters are the level and package.
# The third parameter is text and the fourth is a path to a file. In this case,
# the fourth is a name or path to the new detected device:

# Is necessary device name
if ! test -z "$4"; then
    DRIVE="/media/$4"

else
    echo "#ERRO You need specify drive to share"
fi

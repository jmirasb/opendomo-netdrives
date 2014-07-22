#!/bin/sh

mkdir -p pkg
rm pkg/*.tar.gz 2>/dev/null
PKGID="odnetdrives"
USR="--owner 1000 --group 1000 --same-permissions"
EXCLUDE=' --exclude "*~" --exclude .svn --exclude README.md --exclude LICENCE'

tar cvfz $PKGID-`date '+%Y%m%d'`.tar.gz usr var --owner 1000 --group 1000 --exclude "*~" --exclude .svn --exclude "*.a"

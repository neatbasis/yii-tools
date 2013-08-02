#!/bin/bash

DEVEL=false;

if [ -z "$1" ]; then
	echo "Usage:";
	echo "$0 path"
	exit 1;
fi;

if which chcon; then
	SELINUX=true;
else
	SELINUX=false;
fi;

if [ $DEVEL ]; then
	find "$1/protected" -type d -exec chmod ug+rwx {} \;
fi;

chmod ug+rwx "$1/assets"
find "$1/assets" -type f -exec chmod ug+rw {} \;
find "$1/assets" -type f -exec chmod a-x {} \;
chmod go-w "$1/assets/index.html"

find "$1/protected/runtime" -type f -exec chmod ug+rw {} \;
find "$1/protected/runtime" -type f -exec chmod a-x {} \;
chmod go-w "$1/protected/runtime/index.html"
chmod -R a-w "$1/yii"


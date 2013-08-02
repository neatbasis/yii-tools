#!/bin/bash

DEVEL=false;

if [ -z "$1" ]; then
	echo "Usage:";
	echo "$0 path"
	exit 1;
fi;

if which chcon &> /dev/null; then
	SELINUX=true;
else
	SELINUX=false;
fi;

if [ $DEVEL ]; then
	find "$1/protected" -type d -exec chmod ug+rwx {} \;
	if $SELINUX; then
		chcon -R -t httpd_sys_rw_content_t "$1/protected"
	fi;
fi;

chmod ug+rwx "$1/assets"
find "$1/assets" -type f -exec chmod ug+rw {} \;
find "$1/assets" -type f -exec chmod a-x {} \;
chmod go-w "$1/assets/index.html"

find "$1/protected/runtime" -type f -exec chmod ug+rw {} \;
find "$1/protected/runtime" -type f -exec chmod a-x {} \;
chmod go-w "$1/protected/runtime/index.html"
chmod -R a-w "$1/yii"

if $SELINUX; then
	chcon -R -t httpd_sys_rw_content_t "$1/assets"
	chcon -t httpd_sys_content_t "$1/assets/index.html"
	chcon -R -t httpd_sys_rw_content_t "$1/protected/runtime"
	chcon -t httpd_sys_content_t "$1/protected/runtime/index.html"
fi;



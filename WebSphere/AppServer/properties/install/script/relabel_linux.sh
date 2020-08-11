#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 COPYRIGHT International Business Machines Corp., 1997,2007
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

rc=0

set_java_contexts() {
	/usr/bin/chcon -R -t java_exec_t "${JAVA_PATH}"/bin/* 
	if [ $? -ne 0 ]; then
		rc=1
	fi
	if [ -d "${JAVA_PATH}"/javaws ]; then
	  if [ `ls -A "${JAVA_PATH}"/javaws` ]; then
		   /usr/bin/chcon -R -t java_exec_t "${JAVA_PATH}"/javaws/*
		   if [ $? -ne 0 ]; then
			   rc=1
		   fi
		fi
	fi
}

set_lib_contexts() {
	find "${INSTALL_PATH}" -name "*.so" -exec /usr/bin/chcon -t textrel_shlib_t '{}' \;
	if [ $? -ne 0 ]; then
		rc=1
	fi
	find "${INSTALL_PATH}" -name "*.jar" -exec /usr/bin/chcon -t shlib_t '{}' \;
	if [ $? -ne 0 ]; then
		rc=1
	fi
}

if [ $# -ne 1 ]; then
	echo "Install path must be specified"
	exit 2
fi

if [ -r /etc/redhat-release ]; then
    release=`cat /etc/redhat-release | awk '{print $7}'`
    version=${release%%\.*}

    if [ $version -ge 5 ]; then
        if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
                INSTALL_PATH=$1
                JAVA_PATH=$INSTALL_PATH/java/jre
                set_java_contexts
                set_lib_contexts
        fi
    fi
fi

exit $rc
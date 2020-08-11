#!/bin/sh
# 5630-A23, 5630-A22, (C) Copyright IBM Corporation, 1997, 2010
# All rights reserved. Licensed Materials Property of IBM  
# US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

if [ -n "${JAVA_EXT_DIRS}" ]; then
    echo JAVA_EXT_DIRS=${JAVA_EXT_DIRS}
else
    JAVA_EXT_DIRS="${JAVA_HOME}/jre/lib/ext"
    echo set JAVA_EXT_DIRS=${JAVA_EXT_DIRS}
fi


if [ $# -eq 2 ] || [ $# -eq 3 ]

then
	"${JAVA_EXE}" "-Djava.endorsed.dirs=$WAS_ENDORSED_DIRS" "-Dwas.install.root=$WAS_HOME" "-Dws.ext.dirs=$WAS_EXT_DIRS:$WAS_USER_DIRS" $JVM_EXTRA_CMD_ARGS -classpath "$WAS_CLASSPATH" com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.security.util.PropFilePasswordEncoder "$@"
else
	echo USAGE:  PropFilePasswordEncoder.sh file_name password_properties_list [-Backup/-noBackup]
	echo         PropFilePasswordEncoder.sh file_name -SAS [-Backup/-noBackup]
	exit
fi

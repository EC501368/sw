#!/bin/sh
# 5630-A23, 5630-A22, (C) Copyright IBM Corporation, 1997, 2010
# All rights reserved. Licensed Materials Property of IBM  
# US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

if [ $# -eq 2 ] || [ $# -eq 3 ]

then
	"$JAVA_HOME/bin/java" "-Djava.endorsed.dirs=$WAS_ENDORSED_DIRS" "-Dwas.install.root=$WAS_HOME" "-Dws.ext.dirs=$WAS_EXT_DIRS:$WAS_USER_DIRS" "-Djava.ext.dirs=$JAVA_EXT_DIRS" $JVM_EXTRA_CMD_ARGS -classpath "$WAS_CLASSPATH" com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.security.util.ResponseFilePasswordEncoder "$@"
else
	echo USAGE:  ResponseFilePasswordEncoder.sh file_name password_keys_list [-Backup/-noBackup]
	exit
fi

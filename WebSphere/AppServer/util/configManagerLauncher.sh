#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# Configuration Instance Creation Tool Launcher

print_usage() {
  echo ""
    echo "Usage: configManagerLauncher.sh <appServerRoot> <logFileLocation> <logFileName> -WS_CMT_CONF_DIR <actionRepository> [-WS_CMT_ACTION_REGISTRY <actionRegistry>]"
    echo " eg. configManagerLauncher.sh /opt/IBM/WebSphere/AppServer /mydir/logs mylog.log -WS_CMT_CONF_DIR /opt/IBM/WebSphere/myActionRepository"
    
    echo ""
}

if [ -z $1 ]
then
	print_usage
		exit 1
fi

if [ ! -d $1 ]
then
	echo "Invalid installation root...."
	print_usage
	exit 1
fi

if [ -z $2 ]
then
	print_usage
	exit 1
fi

if [ ! -d $2 ]
then
	echo "Invalid log file home"
	print_usage
	exit 1
fi

if [ -z $3 ]
then
	print_usage
	exit 1
fi


binDir=$1/bin
.  $binDir/setupCmdLine.sh


if [ -f ${JAVA_HOME}/bin/java ]; then
	JAVA_EXE="${JAVA_HOME}/bin/java"
else
	JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi


WAS_HOME=${1}
LOG_HOME=${2}
LOG_NAME=${3}

CONFIG_MANAGER_CLASSPATH=${WAS_HOME}/plugins/com.ibm.ws.runtime.jar:${WAS_HOME}/plugins/com.ibm.ws.runtime.ws390.jar:${WAS_HOME}/plugins/com.ibm.ws.runtime.dist.jar


if [ ! -z $4 ]
then
	if [ $4 = "-WS_CMT_CONF_DIR" ]
	then
		if [ -z $5 ]
		then
			print_usage
			exit 1
		fi
		
		if [ ! -d $5 ]
		then
			echo "Warning: Configure action directory does not exist on the file system."
			#print_usage
			exit 0
		fi
		
		ACTION_REPOSITORY=${5}
	else
		print_usage
		exit 1
	fi
else
	print_usage
	exit 1
fi

FILE_ENCODING=ISO8859-1
# called without an action registry defined
${JAVA_EXE} \
$JVM_EXTRA_CMD_ARGS \
-DWAS_HOME=${WAS_HOME} \
-Dwas.install.root=${WAS_HOME} \
-Dfile.encoding=${FILE_ENCODING} \
-DWS_CMT_LOG_HOME=${LOG_HOME} \
-DWS_CMT_LOG_NAME=${LOG_NAME} \
-DWS_CMT_LOG_LEVEL=3 \
-DWS_CMT_CONF_DIR=${ACTION_REPOSITORY} \
-classpath ${CONFIG_MANAGER_CLASSPATH} \
-Dws.ext.dirs=${WAS_EXT_DIRS} \
com.ibm.ws.install.configmanager.launcher.Launcher \
"$@"
exit $?




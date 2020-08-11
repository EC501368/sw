#!/bin/sh
# THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 1997,2008
# All Rights Reserved * Licensed Materials - Property of IBM
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

PLATFORM=`/bin/uname`

case $PLATFORM in

	OS/390)
		set -o logical
	;;
esac

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi


${JAVA_EXE} \
 ${CLIENTSAS} \
 ${CLIENTSSL} \
 ${CLIENTIPC} \
 ${CLIENTSOAP} \
 ${JAASSOAP} \
 $JVM_EXTRA_CMD_ARGS \
 -DKeepProfileName=true \
 -Xmx128m \
 -Dcom.ibm.ws.sdk.whoCalledMe=managesdk.sh \
 -Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager \
 -Djava.util.logging.configureByServer=true \
 -DtraceSettingsFile=${WAS_HOME}/properties/sdk/SdkTraceSettings.properties \
 -DWAS_HOME=${WAS_HOME} \
 -Dwas.install.root=${WAS_HOME} \
 -classpath ${WAS_CLASSPATH} \
 -Dws.ext.dirs=${WAS_EXT_DIRS} \
 com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application \
 com.ibm.ws.bootstrap.WSLauncher \
 com.ibm.ws.runtime.ManageSDK "$@"


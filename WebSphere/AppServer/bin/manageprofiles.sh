#!/bin/sh
# THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
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

case $PLATFORM in

	OS/390)
		WAS_HOME=${WAS_HOME%/}
	;;
esac

# Set java options for performance
case $PLATFORM in
  AIX)
      PERF_JVM_OPTIONS="-Xquickstart -Xshareclasses" ;;
  Linux)
      PERF_JVM_OPTIONS="-Xquickstart -Xshareclasses" ;;
  SunOS)
      PERF_JVM_OPTIONS="" ;;
  HP-UX)
      PERF_JVM_OPTIONS="" ;;
  OS/390)
      PERF_JVM_OPTIONS="-Xquickstart -Xshareclasses" ;;

esac

${JAVA_EXE} \
	$JVM_EXTRA_CMD_ARGS \
	-DWAS_HOME=${WAS_HOME} \
	-Dwas.install.root=${WAS_HOME} \
	-DJAVA_NATIVE_LIB_DIR=${JAVA_NATIVE_LIB_DIR} \
	-classpath ${WAS_CLASSPATH} \
  	-Dws.ext.dirs=${WAS_EXT_DIRS} \
	-Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
	$PERF_JVM_OPTIONS \
  	com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application com.ibm.ws.bootstrap.WSLauncher \
  	com.ibm.ws.runtime.WsProfile \
  	"$@"	
RC=$?
$binDir/clearClassCache.sh
exit ${RC}
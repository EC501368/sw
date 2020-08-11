#!/bin/sh
binDir=`dirname $0`
. $binDir/setupCmdLine.sh

PATH=$PATH:$binDir
export PATH

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

$JAVA_EXE \
  -Dwas.home=$WAS_HOME \
  -Dws.ext.dirs=$WAS_EXT_DIRS \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  -classpath $WAS_CLASSPATH \
  com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.websphere.ivt.client.IVTClient $*


returnCode=$?

if [ "$returnCode" = "0" ]
then
   exit 0
fi

exit 1

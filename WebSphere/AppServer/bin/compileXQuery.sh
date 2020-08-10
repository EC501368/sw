#!/bin/sh

# Licensed Materials - Property of IBM
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (c) Copyright IBM Corp. 2004,  2010. All Rights Reserved.
# US Government Users Restricted Rights-Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp

# Run CompileXQuery.sh

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

if [ -f ${JAVA_HOME}/bin/java ]; then
   JAVA_EXE="${JAVA_HOME}/bin/java"
else
   JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

"${JAVA_EXE}" \
  -Dserver.root="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  $WAS_LOGGING \
  -classpath "$WAS_CLASSPATH":"$CLASSPATH":"${WAS_HOME}"/plugins/com.ibm.ws.prereq.javamail.jar:"${WAS_HOME}"/plugins/com.ibm.xml.jar com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.xml.xci.internal.cmdline.CompileXQuery  "$@"
cd $CURRENT_DIR
exit 0

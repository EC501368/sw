#!/bin/sh

# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 2009, 2010
# All Rights Reserved * Licensed Materials - Property of IBM
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

binDir=`dirname "$0"`
. "$binDir/setupCmdLine.sh"

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

WAS_HEADER="-Dlogviewer.custom.header=${WAS_HOME}/properties/WsHeader"
WAS_LEVELS="-Dlogviewer.custom.levels=${WAS_HOME}/properties/WsLevels.properties"

${JAVA_EXE} \
  "$CLIENTSAS" \
  -Dwas.install.root="$WAS_HOME" \
  -Duser.install.root="$USER_INSTALL_ROOT" \
  -Dlog.repository.root="${USER_INSTALL_ROOT}/logs" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  $WAS_LOGGING \
  $WAS_HEADER \
  $WAS_LEVELS \
  -classpath "$WAS_CLASSPATH" com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.ws.logging.hpel.viewer.LogViewer "$@"

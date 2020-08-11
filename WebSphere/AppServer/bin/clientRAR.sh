#!/bin/sh
# Copyright IBM Corp. 2003, 2004

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

WAS_CLASSPATH="$WAS_HOME"/plugins/com.ibm.ws.prereq.asm.jar:"$WAS_CLASSPATH"
"$JAVA_HOME/bin/java" \
  $WAS_LOGGING \
  -Dcom.ibm.ws.client.installedConnectors="$CLIENT_CONNECTOR_INSTALL_ROOT" \
  -Dwas.install.root="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  -classpath "$WAS_CLASSPATH" com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.websphere.client.applicationclient.ClientRAR "$@"


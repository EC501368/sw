#!/bin/sh
# Copyright IBM Corp. 2001, 2004

# echo "Usage: clientConfig"

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

WAS_CLASSPATH="$WAS_HOME"/plugins/com.ibm.ws.prereq.asm.jar:"$WAS_CLASSPATH"
"$JAVA_HOME/bin/java" \
  $WAS_LOGGING \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  -Dcom.ibm.ws.client.installedConnectors="$CLIENT_CONNECTOR_INSTALL_ROOT" \
  -Dwas.install.root="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -classpath "$WAS_CLASSPATH" com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.websphere.client.ccrct.ResourceConfigTool


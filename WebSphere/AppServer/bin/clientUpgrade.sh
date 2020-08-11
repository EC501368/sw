#!/bin/sh

binDir=`dirname "$0"`
. "$binDir"/setupCmdLine.sh

"$JAVA_HOME/bin/java" \
  "$OSGI_INSTALL" "$OSGI_CFG" \
  $EXTRA_X_ARG \
  -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  $WAS_LOGGING \
  -DWAS_HOME="$WAS_HOME" \
  -Dcom.ibm.websphere.migration.serverRoot="$WAS_HOME" \
  -Dwas.install.root=$WAS_HOME \
  -Duser.install.root=$USER_INSTALL_ROOT \
  -classpath "$WAS_CLASSPATH":"$WAS_HOME"/properties com.ibm.wsspi.bootstrap.WSPreLauncher \
  -nosplash  -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.migration.ClientUpgrade "$@"
  rc=$?
  exit $rc
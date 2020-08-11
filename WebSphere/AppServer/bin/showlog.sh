#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.


binDir=`dirname "$0"`
. "$binDir/setupCmdLine.sh"

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi


${JAVA_EXE} \
  "$CLIENTSAS" \
  -Dwas.install.root="$WAS_HOME" \
  -Duser.install.root="$USER_INSTALL_ROOT" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  $WAS_LOGGING \
  -classpath "$WAS_CLASSPATH" com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.ejs.ras.ShowLog "$@"

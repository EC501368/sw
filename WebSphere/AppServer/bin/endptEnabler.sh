#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# Run endpointEnabler.sh
binDir=`dirname $0`
. $binDir/setupCmdLine.sh

#Platform specific args...
PLATFORM=`/bin/uname`
case $PLATFORM in
  OS/390)
    D_ARGS="-Dfile.encoding=ISO8859-1" ;;
esac  

"$JAVA_HOME/bin/java" \
  -Dserver.root="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Dwas.install.root="$WAS_HOME" \
  -Duser.install.root="$USER_INSTALL_ROOT" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  $D_ARGS \
  $WAS_LOGGING \
  -classpath "$WAS_CLASSPATH" com.ibm.wsspi.bootstrap.WSPreLauncher \
  -nosplash -application com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.wsfp.main.EndpointEnabler "$@"

exit 0

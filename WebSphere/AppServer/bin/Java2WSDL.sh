#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.


# Run Java2WSDL.sh
binDir=`dirname $0`
. $binDir/setupCmdLine.sh

"$JAVA_HOME/bin/java" \
  -Dserver.root="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  -Dcom.ibm.ffdc.log="$USER_INSTALL_ROOT"/logs/ffdc/ \
  $WAS_LOGGING \
  -classpath "$WAS_CLASSPATH":"$CLASSPATH":"$WAS_HOME/plugins/com.ibm.ws.prereq.javamail.jar" com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.ws.webservices.tools.Java2WSDL  "$@"

exit 0

#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM 
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 2003, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

USE_HIGHEST_AVAILABLE_SDK=true
binDir=`dirname $0`
. $binDir/setupCmdLine.sh

#Platform specific args...
PLATFORM=`/bin/uname`
case $PLATFORM in
  OS/390)
    D_ARGS="-Dfile.encoding=ISO8859-1" ;;
esac

# -jardir directories contain webservices.jar and j2ee.jar. These are needed
# to run wsdl2java and compile the generated files.

WAS_CLASSPATH="$WAS_HOME"/plugins/com.ibm.ws.prereq.asm.jar:"$WAS_CLASSPATH"
"$JAVA_HOME/bin/java" \
  $WAS_LOGGING \
  -Dserver.root="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  $D_ARGS \
  "$OSGI_INSTALL" "$OSGI_CFG"  \
  -classpath "$WAS_CLASSPATH":"$WAS_HOME/plugins/com.ibm.ws.prereq.ow.asm.jar":"$CLASSPATH" com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.etools.webservice.deploy.core.DeployWebService  "$@" -jardir "$WAS_HOME/lib" -jardir "$WAS_HOME/plugins"

exit 0

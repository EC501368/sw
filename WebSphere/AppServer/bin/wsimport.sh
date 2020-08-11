#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM 
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 2006, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# If a proxy server is needed for internet access
# edit and uncomment the following line.
# PROXY_INFO="-Dhttp.proxyHost=yourProxyHost -Dhttp.proxyPort=yourProxyPort"

USE_HIGHEST_AVAILABLE_SDK=true
binDir=`dirname $0`
. $binDir/setupCmdLine.sh

all_plugins=`ls "$WAS_HOME"/plugins`
for plugin in "$all_plugins"
do
WASFP_CLASSPATH="$WASFP_CLASSPATH":"$WAS_HOME"/plugins/"$plugin"
done
WASFP_CLASSPATH="$WASFP_CLASSPATH":"$WAS_CLASSPATH"

"$JAVA_HOME/bin/java" \
  $WAS_LOGGING \
  $CLIENTSSL \
  -Dserver.root="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  -Djavax.xml.accessExternalSchema=all \
   $PROXY_INFO \
  "$OSGI_INSTALL" "$OSGI_CFG"  \
  -classpath "$WASFP_CLASSPATH":"$CLASSPATH" com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.ws.jaxws.tools.WsImport "$@"

exit 0

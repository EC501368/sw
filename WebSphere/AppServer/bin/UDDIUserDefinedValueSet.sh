#!/bin/sh -v

# Licensed Materials - Property of IBM                              
#                                                                   
# 5724-I63, 5724-H88, 5655-N02, 5733-W70                                                           
#                                                                   
# (C) COPYRIGHT IBM Corp., 2004, 2010 All Rights Reserved     
#                                                                   
# US Government Users Restricted Rights - Use, duplication or       
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp. 
#
# UDDIUserDefinedValueSet shell script
#
# Version         1.9
#
#
binDir=`dirname $0`
. $binDir/setupCmdLine.sh

$JAVA_HOME/bin/java -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" "$OSGI_INSTALL" "$OSGI_CFG" $WAS_DEBUG $WAS_TRACE $CONSOLE_ENCODING $CLIENTSOAP $CLIENTSAS $CLIENTSSL -classpath $WAS_CLASSPATH -Dws.ext.dirs=$WAS_EXT_DIRS -Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager -Djava.util.logging.configureByServer=true $USER_INSTALL_PROP -Dwas.install.root=$WAS_HOME com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application com.ibm.ws.bootstrap.WSLauncher com.ibm.uddi.UDDIValueSet "$@"


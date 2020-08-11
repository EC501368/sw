#!/bin/sh

# THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2010
# All Rights Reserved * Licensed Materials - Property of IBM
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# usage:
#   EARExpander -ear <file-name>
#               -operation {expand | collapse}
#               -directory <directory> | -operationDir <directory>
#               [-expansionFlags {all | war}]
#               [-verbose]
#
# return codes:
#   -1  syntax error
#    0  ok
#    1  error
#    2  exception

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

WAS_CLASSPATH="$WAS_HOME"/plugins/com.ibm.ws.prereq.asm.jar:"$WAS_CLASSPATH"
"$JAVA_HOME/bin/java" \
  -Dwas.install.root="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Dcom.ibm.ffdc.log="$FFDCLOG" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  $WAS_LOGGING \
  -classpath "$WAS_CLASSPATH" com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.websphere.management.application.commands.EARExpander "$@"

exit $?


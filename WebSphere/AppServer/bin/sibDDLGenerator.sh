#!/bin/sh
# THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
# 5630-A36 (C) COPYRIGHT International Business Machines Corp. 2004, 2010
# All Rights Reserved * Licensed Materials - Property of IBM
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

 
binDir=`dirname $0`
. "$binDir/setupCmdLine.sh"

$JAVA_HOME/bin/java -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" $WAS_LOGGING -classpath $WAS_CLASSPATH -Dws.ext.dirs=$WAS_EXT_DIRS -Dwas.install.root=$WAS_HOME com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.sib.msgstore.persistence.DDLGenerator "$@"

exit $?
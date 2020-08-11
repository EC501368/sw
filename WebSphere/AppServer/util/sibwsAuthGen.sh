#!/bin/sh

# @start_restricted_prolog@
# Version: @(#) 1.2 SIB/ws/code/sib.webservices/unix/all/util/sibwsAuthGen.sh, SIB.webservices.runtime, WAS855.SIB, cf091607.02 05/01/26 07:23:13 [2/21/16 11:25:59]
# 
# Licensed Materials - Property of IBM
# 
# "Restricted Materials of IBM"
# 
# 5724-I63, 5724-H88, 5655-N01, 5733-W60         
# 
# (C) Copyright IBM Corp. 2004 All Rights Reserved.
# 
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with
# IBM Corp.
# @end_restricted_prolog@

binDir=`dirname $0`
. $binDir/../bin/setupCmdLine.sh

"$JAVA_HOME/jre/bin/java" \
  -Dwas.install.root="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -classpath "$WAS_CLASSPATH" "com.ibm.ws.bootstrap.WSLauncher" \
  com.ibm.ws.sib.webservices.tools.GenAuth  "$@"

exit 0

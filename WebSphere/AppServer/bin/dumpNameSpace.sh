#!/bin/sh

# All Rights Reserved - Licensed Materials - Property of IBM
# COPYRIGHT (C) International Business Machines Corp., 1997, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# Dump Name Space Launcher

BIN_DIR=`dirname $0`
. "${BIN_DIR}/setupCmdLine.sh"

if [ -f ${JAVA_HOME}/bin/java ]; then
   JAVA_EXE="${JAVA_HOME}/bin/java"
else
   JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

"${JAVA_EXE}" \
  "-Dwas.install.root=${WAS_HOME}" \
  "${CLIENTSAS}" \
  "${JAASSOAP}" \
  "${CLIENTSSL}" \
  "-Dserver.root=${WAS_HOME}" \
  "-Dws.ext.dirs=${WAS_EXT_DIRS}:${WAS_USER_DIRS}" \
  "-Dcom.ibm.ffdc.log=${FFDCLOG}" \
  "-Djava.endorsed.dirs=$WAS_ENDORSED_DIRS" \
  ${WAS_LOGGING} \
  -classpath "${WAS_CLASSPATH}" com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.websphere.naming.DumpNameSpace "$@"

exit $?


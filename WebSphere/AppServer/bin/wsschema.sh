#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
#  5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# SchemaTool launcher

CLASS_NAME=org.apache.openjpa.jdbc.schema.SchemaTool

BIN_DIR=`dirname $0`
. "${BIN_DIR}/setupCmdLine.sh"

PROVIDER_CLASSPATH=${WAS_HOME}/dev/JavaEE/j2ee.jar:${WAS_HOME}/plugins/com.ibm.ws.jpa.jar:${WAS_HOME}/plugins/com.ibm.ws.prereq.commons-collections.jar

TOOL_CLASSPATH=${PROVIDER_CLASSPATH}:${CLASSPATH}

"${JAVA_HOME}/bin/java" -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" ${VM_ARGS} -classpath ${TOOL_CLASSPATH} ${CLASS_NAME} "$@"

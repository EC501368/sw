#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 2008,  2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

CLASS_NAME=com.ibm.websphere.persistence.pdq.WsJpaDBGen

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

if [ "$1" = "-help" ]
then
   VM_ARGS1="${VM_ARGS}"
else
   VM_ARGS1="${VM_ARGS} -javaagent:${WAS_HOME}/plugins/com.ibm.ws.jpa.jar"
fi

PROVIDER_CLASSPATH=${WAS_HOME}/dev/JavaEE/j2ee.jar:${WAS_HOME}/plugins/com.ibm.ws.jpa.jar:${WAS_HOME}/plugins/com.ibm.ws.prereq.commons-collections.jar
PROVIDER_CLASSPATH=${PROVIDER_CLASSPATH}:${WAS_HOME}/plugins/com.ibm.ws.prereq.asm.jar

TOOL_CLASSPATH=${PROVIDER_CLASSPATH}:${CLASSPATH}

"${JAVA_HOME}/bin/java" -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" ${VM_ARGS1} -classpath ${TOOL_CLASSPATH} ${CLASS_NAME} $@


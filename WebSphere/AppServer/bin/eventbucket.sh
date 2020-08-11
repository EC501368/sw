#!/bin/sh

# Licensed Materials - Property of IBM
# (C) Copyright IBM Corp. 2004, 2010.  ALL RIGHTS RESERVED 
# 5724-I63, 5724-H88, 5655-N02, 5733-W70
# US Government Users Restricted Rights - Use, duplication, or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp..

binDir=`dirname $0`
. "$binDir/setupCmdLine.sh"

#The following is added through defect 236497.1
CMD_NAME=`basename $0`

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

if [ "${INV_PRF_SPECIFIED:=}" != "" ] && [ "$INV_PRF_SPECIFIED" = "true" ]
then
    ${JAVA_EXE} -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" -cp "${WAS_HOME}/lib/commandlineutils.jar" com.ibm.ws.install.commandline.utils.CommandLineUtils -specifiedProfileNotExists -profileName $WAS_PROFILE_NAME
    exit 1
elif [ "${WAS_USER_SCRIPT_FILE_NOT_EXISTS:=}" != "" ] && [ "$WAS_USER_SCRIPT_FILE_NOT_EXISTS" = "true" ]
then
    ${JAVA_EXE} -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" -cp "${WAS_HOME}/lib/commandlineutils.jar" com.ibm.ws.install.commandline.utils.CommandLineUtils -wasUserScriptFileNotExists -wasUserScript $WAS_USER_SCRIPT
    exit 1
elif [ "${NO_DFT_PRF_EXISTS:=}" != "" ] && [ "$NO_DFT_PRF_EXISTS" = "true" ]
then
    ${JAVA_EXE} -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" -cp "${WAS_HOME}/lib/commandlineutils.jar" com.ibm.ws.install.commandline.utils.CommandLineUtils -noDefaultProfile -commandName $CMD_NAME
    exit 1
fi

JACL_FILE=$WAS_HOME/util/event/eventbucket.jacl

$WAS_HOME/bin/wsadmin.sh  -f $JACL_FILE "$@"


returnCode=$?

if [ "$returnCode" = "0" ]
then
   exit 0
fi

exit 1

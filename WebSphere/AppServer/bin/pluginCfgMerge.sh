#!/bin/sh

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

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

if [ -d "$JAVA_HOME"/jre/lib/endorsed ]
then
WAS_ENDORSED_DIRS="$JAVA_HOME"/jre/lib/endorsed
fi 

"$JAVA_HOME/bin/java" \
  -Dserver.root="$WAS_HOME" \
  $CLIENTSAS \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  $USER_INSTALL_PROP \
  $WAS_LOGGING \
  -classpath "$WAS_CLASSPATH" com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.websphere.plugincfg.generator.PluginMergeTool $@

#!/bin/sh
#Ejbdeploy.sh for unix

USE_HIGHEST_AVAILABLE_SDK=true
export USE_HIGHEST_AVAILABLE_SDK

binDir=`dirname $0`
. "$binDir/setupCmdLine.sh"

WAS_EXT_DIRS=$WAS_HOME/dev/javaee5.jar:$WAS_HOME/plugins:$WAS_EXT_DIRS

if [ -f "$ITP_LOC/ejbdeploy.sh" ] ; then
  "$ITP_LOC/ejbdeploy.sh" $@
else
  if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
  else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
  fi
  ${JAVA_EXE} -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" -cp "${WAS_HOME}/lib/commandlineutils.jar" com.ibm.ws.install.commandline.utils.CommandLineUtils -ejbdeployfeaturenotinstalled  
fi

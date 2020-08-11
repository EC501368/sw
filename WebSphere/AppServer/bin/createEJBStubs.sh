#!/bin/sh

# THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 2007, 2010
# All Rights Reserved * Licensed Materials - Property of IBM
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# Create EJB stubs

# createEJBStubs.sh -help to show command usage

# Bootstrap values ...
APP_EXT_PT=com.ibm.ws.runtime.CreateEJBStubsCommand

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

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

#zOS
# "$JAVA_HOME"/bin/java -Dfile.encoding=ISO8859-1 -Xnoargsconversion \
#   -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
#   $WAS_DEBUG \
#   -Dws.ext.dirs="$WAS_EXT_DIRS" \
#   -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS"
#   -Djava.ext.dirs="$JAVA_EXT_DIRS" \
#   -classpath "$WAS_CLASSPATH" \
#   -Dwas.install.root="$WAS_HOME" \
#   $CONSOLE_ENCODING \
#   $USER_INSTALL_PROP \
#   $JVM_EXTRA_CMD_ARGS \
#   com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application com.ibm.ws.bootstrap.WSLauncher \
#   $APP_EXT_PT "$CONFIG_ROOT" "$@"

#Distributed
# "$JAVA_HOME"/bin/java \
#   -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
#   $WAS_DEBUG \
#   -Dws.ext.dirs="$WAS_EXT_DIRS" \
#   -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS"
#   -classpath "$WAS_CLASSPATH" \
#   -Dwas.install.root="$WAS_HOME" \
#   $USER_INSTALL_PROP \
#   com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application com.ibm.ws.bootstrap.WSLauncher \
#   $APP_EXT_PT "$@"

# For debugging the launcher itself
# WAS_DEBUG="-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777"

# Setup the initial java invocation;

DELIM=" "

#Common args...
D_ARGS="-Dws.ext.dirs="$WAS_EXT_DIRS" $DELIM -Dwas.install.root="$WAS_HOME" $DELIM -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" $DELIM -Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager $DELIM -Djava.util.logging.configureByServer=true"
X_ARGS=-Xbootclasspath/p:"$WAS_BOOTCLASSPATH"

#Platform specific args...
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
    LIBPATH="$WAS_LIBPATH":$LIBPATH
    export LIBPATH ;;
  Linux)
    LD_LIBRARY_PATH="$WAS_LIBPATH":$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH ;;
  SunOS)
    LD_LIBRARY_PATH="$WAS_LIBPATH":$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH ;;
  HP-UX)
    SHLIB_PATH="$WAS_LIBPATH":$SHLIB_PATH
    export SHLIB_PATH ;;
  OS/390)
      D_ARGS=""$D_ARGS" $DELIM -Dfile.encoding=ISO8859-1 $DELIM -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" $DELIM -Djava.ext.dirs="$JAVA_EXT_DIRS""
      X_ARGS=""$X_ARGS" $DELIM -Xnoargsconversion" ;;
esac

"$JAVA_EXE" \
  "$OSGI_INSTALL" "$OSGI_CFG" \
  $X_ARGS \
  $WAS_DEBUG \
  $D_ARGS \
  -classpath "$WAS_CLASSPATH" \
  $CONSOLE_ENCODING \
  $USER_INSTALL_PROP \
  $JVM_EXTRA_CMD_ARGS \
  com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application com.ibm.ws.bootstrap.WSLauncher \
  $APP_EXT_PT "$@"

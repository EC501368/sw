#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# Retrieve Signers Tool

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

#zOS
# ${JAVA_EXE}  -Dfile.encoding=ISO8859-1 -Xnoargsconversion \
#   -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
#   $DEBUG \
#   $CONSOLE_ENCODING \
#   "$CLIENTSAS" \
#   "$CLIENTSSL" \
#   "$CLIENTSOAP" \
#   -Dws.ext.dirs="$WAS_EXT_DIRS" \
#   -Djava.ext.dirs="$JAVA_EXT_DIRS" \
#   -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
#   -Dwas.install.root="$WAS_HOME" \
#   $USER_INSTALL_PROP \
#   $JVM_EXTRA_CMD_ARGS \
#   -classpath "$WAS_CLASSPATH" com.ibm.ws.bootstrap.WSLauncher \
#   $SHELL "$CONFIG_ROOT" "$WAS_CELL" "$WAS_NODE" "$@"

#ASV
# ${JAVA_EXE} \
#   -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
#   $DEBUG \
#   $CONSOLE_ENCODING \
#   "$CLIENTSAS" \
#   "$CLIENTSSL" \
#   "$CLIENTSOAP" \
#   -Dws.ext.dirs="$WAS_EXT_DIRS" \
#   -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
#   -Dwas.install.root="$WAS_HOME" \
#   $USER_INSTALL_PROP \
#   -classpath "$WAS_CLASSPATH":$CLASSPATH com.ibm.ws.bootstrap.WSLauncher \
#   $SHELL "$CONFIG_ROOT" "$WAS_CELL" "$WAS_NODE" "$@"

SHELL=com.ibm.ws.runtime.RetrieveSigners

DELIM=" "

#Common args...
C_PATH="$WAS_CLASSPATH"
D_ARGS="-Dws.ext.dirs="$WAS_EXT_DIRS" $DELIM -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" $DELIM -Dwas.install.root="$WAS_HOME" $DELIM -Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager $DELIM -Djava.util.logging.configureByServer=true "$OSGI_INSTALL" "$OSGI_CFG""
X_ARGS=-Xbootclasspath/p:"$WAS_BOOTCLASSPATH"

#Platform specific args...
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
    CONSOLE_ENCODING=-Dws.output.encoding=console
    LIBPATH="$WAS_LIBPATH":$LIBPATH
    export LIBPATH ;;
  Linux)
    CONSOLE_ENCODING=-Dws.output.encoding=console
    LD_LIBRARY_PATH="$WAS_LIBPATH":$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH ;;
  SunOS)
    CONSOLE_ENCODING=-Dws.output.encoding=console
    LD_LIBRARY_PATH="$WAS_LIBPATH":$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH ;;
  HP-UX)
    CONSOLE_ENCODING=-Dws.output.encoding=console
    SHLIB_PATH="$WAS_LIBPATH":$SHLIB_PATH
    export SHLIB_PATH ;;
  OS/390)
    C_PATH="$WAS_CLASSPATH"
    D_ARGS=""$D_ARGS" $DELIM -Dfile.encoding=ISO8859-1 $DELIM -Djava.ext.dirs="$JAVA_EXT_DIRS""
    X_ARGS=""$X_ARGS" $DELIM -Xnoargsconversion" ;;
esac

# For debugging the utility itself
# WAS_DEBUG="-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777"

${JAVA_EXE} \
  $X_ARGS \
  $WAS_DEBUG \
  $CONSOLE_ENCODING \
  "$CLIENTSAS" \
  "$CLIENTSSL" \
  "$CLIENTSOAP" \
  ${JAASSOAP:+"$JAASSOAP"} \
  $D_ARGS \
  $USER_INSTALL_PROP \
  $JVM_EXTRA_CMD_ARGS \
  -classpath "$C_PATH" \
  com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application com.ibm.ws.bootstrap.WSLauncher $SHELL "$@"

exit $?

#!/bin/sh

# THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 2004, 2010
# All Rights Reserved * Licensed Materials - Property of IBM
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# EJB Timer Service Cancel EJB Timers Command Launcher

# Launch Arguments:
#
# cancelEJBTimers.sh <server> <filter> [options]
# server  : the name of the server process to look for timers.
# filter: <-all> | <-app [-mod [-bean]]>
#         -all                        : cancel all timers
#         -app <application name>     : cancel all timers for an applicaiton
#         -mod <module name>          : cancel all timers for a module
#         -bean <bean name>           : cancel all timers for an EJB type
# options:
#         -host <host name>           : host name to connect to for command
#         -port <port number>         : port number to connect to for command
#         -conntype <connector type>  : connection type (SOAP, RMI, NONE)
#         -user <userid>              : user name / idintifier
#         -password <password>        : user password
#         -quiet                      : disables output
#         -logfile <filename>         : directs output to a file
#         -replacelog                 : clears the log file prior to executing
#         -trace                      : enables trace
#         -help                       : provides command specific help
#         -?                          : provides command specific help
#

# Bootstrap values ...
SHELL=com.ibm.ws.admin.services.CancelEJBTimersCommand

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

#zOS
# "$JAVA_HOME"/bin/java -Dfile.encoding=ISO8859-1 -Xnoargsconversion \
#   -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
#   $DEBUG \
#   "$CLIENTSAS" \
#   "$CLIENTSSL" \
#   "$CLIENTSOAP" \
#   -Dws.ext.dirs="$WAS_EXT_DIRS" \
#   -Djava.ext.dirs="$JAVA_EXT_DIRS" \
#   -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS"
#   -classpath "$WAS_CLASSPATH" \
#   -Dwas.install.root="$WAS_HOME" \
#   $CONSOLE_ENCODING \
#   $USER_INSTALL_PROP \
#   $JVM_EXTRA_CMD_ARGS \
#   com.ibm.ws.bootstrap.WSLauncher \
#   $SHELL "$CONFIG_ROOT" "$WAS_CELL" "$WAS_NODE" "$@"

#Distributed
# "$JAVA_HOME"/bin/java \
#   -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
#   $DEBUG \
#   "$CLIENTSAS" \
#   "$CLIENTSSL" \
#   "$CLIENTSOAP" \
#   -Dws.ext.dirs="$WAS_EXT_DIRS" \
#   -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS"
#   -classpath "$WAS_CLASSPATH" \
#   -Dwas.install.root="$WAS_HOME" \
#   $USER_INSTALL_PROP \
#   com.ibm.ws.bootstrap.WSLauncher \
#   $SHELL "$CONFIG_ROOT" "$WAS_CELL" "$WAS_NODE" "$@"

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
      D_ARGS=""$D_ARGS" $DELIM -Dfile.encoding=ISO8859-1 $DELIM -Djava.ext.dirs="$JAVA_EXT_DIRS""
      X_ARGS=""$X_ARGS" $DELIM -Xnoargsconversion" ;;
esac

"$JAVA_EXE" \
  "$OSGI_INSTALL" "$OSGI_CFG" \
  $X_ARGS \
  $WAS_DEBUG \
  "$CLIENTSAS" \
  "$CLIENTSSL" \
  "$CLIENTSOAP" \
  ${JAASSOAP:+"$JAASSOAP"} \
  $D_ARGS \
  -classpath "$WAS_CLASSPATH" \
  $CONSOLE_ENCODING \
  $USER_INSTALL_PROP \
  $JVM_EXTRA_CMD_ARGS \
  com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application com.ibm.ws.bootstrap.WSLauncher \
  $SHELL "$CONFIG_ROOT" "$WAS_CELL" "$WAS_NODE" "$@"

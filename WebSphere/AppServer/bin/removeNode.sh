#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# Node Removal Tool

APP_EXT_ID=com.ibm.ws.admin.services.NodeRemovalUtility

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

isJavaOption=false
nonJavaOptionCount=1
for option in "$@" ; do
  if [ "$option" = "-javaoption" ] ; then
     isJavaOption=true
  else
     if [ "$isJavaOption" = "true" ] ; then
        javaOption="$javaOption $option"
        isJavaOption=false
     else
        nonJavaOption[$nonJavaOptionCount]="$option"
        nonJavaOptionCount=$((nonJavaOptionCount+1))
     fi
  fi
done

#zOS
# "$JAVA_HOME"/bin/java -Dfile.encoding=ISO8859-1 -Xnoargsconversion \
#   -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
#   $DEBUG \
#   $CONSOLE_ENCODING \
#   "$CLIENTSAS" \
#   "$CLIENTSSL" \
#   "$CLIENTSOAP" \
#   -Dws.ext.dirs="$WAS_EXT_DIRS" \
#   -Djava.ext.dirs="$JAVA_EXT_DIRS" \
#   -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS"  \
#   $USER_INSTALL_PROP \
#   -Dwas.install.root="$WAS_HOME" \
#   $JVM_EXTRA_CMD_ARGS \
#   -classpath "$WAS_CLASSPATH" com.ibm.ws.bootstrap.WSLauncher \
#   $APP_EXT_ID "$CONFIG_ROOT" "$WAS_CELL" "$WAS_NODE" "$@"

#ASV
# "$JAVA_HOME"/bin/java \
#   -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
#   $DEBUG \
#   $CONSOLE_ENCODING \
#   "$CLIENTSAS" \
#   "$CLIENTSSL" \
#   "$CLIENTSOAP" \
#   -Dws.ext.dirs="$WAS_EXT_DIRS" \
#   -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS"  \
#   $USER_INSTALL_PROP \
#   -Dwas.install.root="$WAS_HOME" \
#   -classpath "$WAS_CLASSPATH":$CLASSPATH com.ibm.ws.bootstrap.WSLauncher \
#   $APP_EXT_ID "$CONFIG_ROOT" "$WAS_CELL" "$WAS_NODE" "$@"

DELIM=" "

#Common args...
C_PATH="$WAS_CLASSPATH"
D_ARGS="-Dws.ext.dirs="$WAS_EXT_DIRS" $DELIM -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" $DELIM -Dwas.install.root="$WAS_HOME" $DELIM -Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager $DELIM -Djava.util.logging.configureByServer=true"
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

"$JAVA_HOME"/bin/java \
  $X_ARGS \
  $WAS_DEBUG \
  $CONSOLE_ENCODING \
  $javaOption \
  "$OSGI_INSTALL" "$OSGI_CFG" \
  "$CLIENTSAS" \
  "$CLIENTSSL" \
  "$CLIENTSOAP" \
  ${JAASSOAP:+"$JAASSOAP"} \
  $D_ARGS \
  $USER_INSTALL_PROP \
  $JVM_EXTRA_CMD_ARGS \
  -classpath "$C_PATH" \
  com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application com.ibm.ws.bootstrap.WSLauncher \
  $APP_EXT_ID "$CONFIG_ROOT" "$WAS_CELL" "$WAS_NODE" "${nonJavaOption[@]}"

exit $?

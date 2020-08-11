#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# wsadmin launcher

binDir=`dirname "$0"`
. "$binDir/setupCmdLine.sh"

#The following is added through defect 238059
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

APP_EXT_ID=com.ibm.ws.admin.services.WsAdmin

if [ ! "$USER_INSTALL_ROOT" ] ; then
   USER_INSTALL_ROOT=$WAS_HOME
fi

# For debugging the utility itself
# WAS_DEBUG="-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777"

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

DELIM=" "
C_PATH="$WAS_CLASSPATH:$ITP_LOC/batchboot.jar:$ITP_LOC/batch2.jar"

#set LIBPATH and CONSOLE_ENCODING
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
      PATH=$binDir:$PATH
      ZOS_LIBRARY_PATH="$WAS_HOME"/bin
      export PATH ZOS_LIBRARY_PATH
      EXTRA_D_ARGS="-Dfile.encoding=ISO8859-1 $DELIM -Djava.ext.dirs="$JAVA_EXT_DIRS""
      EXTRA_X_ARGS="-Xnoargsconversion" ;;
esac


# Set java options for performance
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m -Xquickstart" ;;
  Linux)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m -Xquickstart" ;;
  SunOS)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m -XX:MaxPermSize=128m" ;;
  HP-UX)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m -XX:MaxPermSize=128m" ;;
  OS/390)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m" ;;
esac 

"$JAVA_EXE" \
  -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
  $EXTRA_X_ARGS \
  $CONSOLE_ENCODING \
  $WAS_DEBUG \
  "$OSGI_INSTALL" "$OSGI_CFG" \
  "$CLIENTSAS" \
  "$CLIENTSSL" \
  "$CLIENTSOAP" \
  ${JAASSOAP:+"$JAASSOAP"} \
  -Dcom.ibm.ws.scripting.wsadminprops="$WSADMIN_PROPERTIES" \
  -Dconfig_consistency_check="$CONFIG_CONSISTENCY_CHECK" \
  -Dwas.install.root="$WAS_HOME" \
  -Duser.install.root="$USER_INSTALL_ROOT" \
  -Dwas.repository.root="$CONFIG_ROOT" \
  -Dlocal.cell="$WAS_CELL" \
  -Dlocal.node="$WAS_NODE" \
  -Dcom.ibm.ws.management.standalone=true \
  -Dcom.ibm.itp.location="$WAS_HOME/bin" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  -Dcom.ibm.ffdc.log="${USER_INSTALL_ROOT}/logs/ffdc/" \
  $EXTRA_D_ARGS \
  $JVM_EXTRA_CMD_ARGS \
  $PERF_JVM_OPTIONS \
  $javaOption \
  $WAS_LOGGING \
  -classpath "$C_PATH" \
  com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application com.ibm.ws.bootstrap.WSLauncher \
  $APP_EXT_ID "${nonJavaOption[@]}"

exit $?

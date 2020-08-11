#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# wsadmin launcher

binDir=`dirname "$0"`
. "$binDir/setupCmdLine.sh"


SHELL=com.ibm.ws.runtime.WsProfileAdminListener

if [ ! "$USER_INSTALL_ROOT" ] ; then
   USER_INSTALL_ROOT=$WAS_HOME
fi

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

LOGFILE=$USER_INSTALL_ROOT/logs/wsadminListener.out

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

#Platform specific args...
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX | Linux | SunOS | HP-UX)
    CONSOLE_ENCODING=-Dws.output.encoding=console ;;
  OS/390)
    EXTRA_D_ARGS="-Dfile.encoding=ISO8859-1 $DELIM -Djava.ext.dirs="$JAVA_EXT_DIRS""
    EXTRA_X_ARGS="-Xnoargsconversion" ;;
esac

# Set java options for performance
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m -Xquickstart -Xshareclasses" ;;
  Linux)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m -Xj9 -Xquickstart -Xshareclasses" ;;
  SunOS)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m -XX:PermSize=128m" ;;
  HP-UX)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m -XX:PermSize=128m" ;;
  OS/390)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m -Xquickstart -Xshareclasses" ;;
esac 

${JAVA_EXE} \
  -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
  $EXTRA_X_ARGS \
  $CONSOLE_ENCODING \
  $WAS_LOGGING \
  $WAS_DEBUG \
  "$OSGI_INSTALL" "$OSGI_CFG" $OSGI_CLASS_SHARING \
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
  $EXTRA_D_ARGS \
  $JVM_EXTRA_CMD_ARGS \
  $PERF_JVM_OPTIONS \
  $javaOption \
  -classpath "$C_PATH" \
  com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application com.ibm.ws.bootstrap.WSLauncher \
  $SHELL "${nonJavaOption[@]}" >$LOGFILE 2>$LOGFILE

# signal the wsadmin listener is shutdown
FINISH_FILE=$1.finished
echo "wsadmin listener shutdown" > $FINISH_FILE

exit $?

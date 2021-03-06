#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 2005, 2006
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# Collect Node Metadata Tool

echo $0 entry
echo WAS_USER_SCRIPT: $WAS_USER_SCRIPT
echo PARAM 1: $1
echo PARAM 2: $2

# Set up env
. $WAS_USER_SCRIPT

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

# Java class to launch...
JAVA_CLASS=com.ibm.ws.admin.core.CollectManagedObjectMetadata

# For debugging the launcher itself
unset JAVA_DEBUG
# JAVA_DEBUG="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=7777"

# Setup the initial java invocation;

DELIM=" "

#second parm is optional node name
NODE=$WAS_NODE
if [ "$2" != "" ] ; then
   NODE=$2 
fi


#Common args...
D_ARGS="-Dws.ext.dirs="$WAS_EXT_DIRS" $DELIM \
 	-Dlocal.cell="$WAS_CELL" $DELIM \
	-Dlocal.node=$NODE $DELIM \
	-Dwas.install.root="$WAS_HOME" $DELIM \
	-Duser.install.root="$USER_INSTALL_ROOT" $DELIM \
	-Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager $DELIM \
	-Dwas.repository.root="$CONFIG_ROOT" $DELIM \
	-Dosgi.configuration.area.readOnly=true \
	-Djava.util.logging.configureByServer=true"
X_ARGS="-Xbootclasspath/p:"$WAS_BOOTCLASSPATH" -Xms128M -Xmx128M"
WAS_CLASSPATH="$WAS_HOME"/properties:"$WAS_HOME"/lib/startup.jar:"$WAS_HOME"/lib/bootstrap.jar:"$JAVA_HOME"/lib/tools.jar

#Platform specific args...
PLATFORM=`/bin/uname`

case $PLATFORM in
  AIX)
      PERF_JVM_OPTIONS="-Xquickstart -Xshareclasses" ;;
  Linux)
      ARCH=`/bin/uname -m`
      if [ $ARCH = "ia64" ]; then
          PERF_JVM_OPTIONS="-XX:MaxPermSize=128m"
      else
          PERF_JVM_OPTIONS="-Xquickstart -Xshareclasses"
      fi ;;
  SunOS)
      PERF_JVM_OPTIONS="" ;;
  HP-UX)
      PERF_JVM_OPTIONS="" ;;
  OS/390)
      PERF_JVM_OPTIONS="-Xquickstart -Xshareclasses"
      if [[ -n "$TMPDIR" ]]; then
          PERF_JVM_OPTIONS="$PERF_JVM_OPTIONS:cacheDir=$TMPDIR"
      fi ;;
esac

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
      WAS_CLASSPATH="$WAS_CLASSPATH":"$WAS_HOME"/lib/bootstrapws390.jar
      D_ARGS=""$D_ARGS" $DELIM -Dfile.encoding=ISO8859-1 $DELIM -Djava.ext.dirs="$JAVA_EXT_DIRS""
      X_ARGS=""$X_ARGS" $DELIM -Xnoargsconversion" ;;
esac

"$JAVA_EXE" \
  "$OSGI_INSTALL" "$OSGI_CFG" \
  $X_ARGS \
  $JAVA_DEBUG \
  $D_ARGS \
  $PERF_JVM_OPTIONS \
  -classpath "$WAS_CLASSPATH" \
  com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application com.ibm.ws.bootstrap.WSLauncher \
  $JAVA_CLASS -add $1


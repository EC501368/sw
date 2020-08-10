#!/bin/sh
 
# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 1997,2006
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
 
# wsadmin launcher
 
REPLACE_WAS_HOME=`dirname $0`/../
binDir=`dirname $0`/../bin
. $binDir/setupCmdLine.sh
 
 
SHELL=com.ibm.ws.scripting.WasxShell
 
if [ ! "$USER_INSTALL_ROOT" ] ; then
   USER_INSTALL_ROOT=$WAS_HOME
fi
 
 
DELIM=" "
if [ "$WAS_HOME/plugins" ] ; then
   C_PATH="$WAS_CLASSPATH:$WAS_HOME/plugins/com.ibm.ws.runtime_6.1.0.jar:$WAS_HOME/plugins/com.ibm.ws.emf_2.1.0.jar:$WAS_HOME/plugins/com.ibm.ws.bootstrap_6.1.0.jar:$WAS_HOME/plugins/org.eclipse.core.runtime_3.1.2.jar:$WAS_HOME/plugins/org.eclipse.osgi_3.1.2.jar:$WAS_HOME/plugins/com.ibm.ws.webcontainer_2.0.0.jar:$WAS_HOME/runtimes/com.ibm.ws.admin.client_6.1.0.jar":"$WAS_HOME/plugins/com.ibm.ws.batch.runtime.jar"
else
   C_PATH="$WAS_CLASSPATH:$WAS_HOME/plugins/com.ibm.ws.batch.runtime.jar:$WAS_HOME/lib/ffdc.jar:$WAS_HOME/lib/nls.jar:$WAS_HOME/lib/ras.jar:$WAS_HOME/lib/wsexception.jar:$WAS_HOME/lib/emf.jar"
fi


 
#Platform specific args...
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX | Linux | SunOS | HP-UX)
    CONSOLE_ENCODING=-Dws.output.encoding=console ;;
  OS/390)
    EXTRA_D_ARGS="-Dfile.encoding=ISO8859-1 $DELIM -Djava.ext.dirs="$JAVA_EXT_DIRS""
    EXTRA_X_ARGS="-Xnoargsconversion" 
    C_PATH="$C_PATH:$WAS_HOME/plugins/com.ibm.ws.runtime.ws390_6.1.0.jar" ;;
esac
 
# Set java options for performance
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m -Xquickstart" ;;
  Linux)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m -Xj9 -Xquickstart" ;;
  SunOS)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m -XX:PermSize=40m" ;;
  HP-UX)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m -XX:PermSize=40m" ;;
  OS/390)
      PERF_JVM_OPTIONS="-Xms256m -Xmx256m" ;;
esac 
 
"$JAVA_HOME/bin/java" \
  -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
  $EXTRA_X_ARGS \
  $CONSOLE_ENCODING \
  $javaOption \
  $WAS_DEBUG \
  "$CLIENTSAS" \
  "$CLIENTSOAP" \
  "$CLIENTSSL" \
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
  -Dcom.ibm.ws.client.installedConnectors="$CLIENT_CONNECTOR_INSTALL_ROOT" \
  $EXTRA_D_ARGS \
  $JVM_EXTRA_CMD_ARGS \
  $PERF_JVM_OPTIONS \
  $WAS_LOGGING \
  -classpath "$C_PATH" com.ibm.ws.batch.packager.WSBatchPackager $*   
 

exit $?


















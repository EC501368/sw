#!/bin/sh

# THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
# 5724-J34 (C) COPYRIGHT International Business Machines Corp., 2007
# All Rights Reserved * Licensed Materials - Property of IBM
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

#!echo "Usage: WSGrid <job properties file>"

REPLACE_WAS_HOME=`dirname $0`/../
binDir=`dirname $0`/../bin
. $binDir/setupCmdLine.sh

isJavaOption=false
for option in "$@" ; do
  if [ "$option" = "-JVMOptions" ] ; then
     isJavaOption=true
  else
     if [ "$isJavaOption" = "true" ] ; then
        javaoption=$option
        shift 
        shift
        break
     fi
  fi
done

isIIOPOption=false
for option in "$@" ; do
  if [ "$option" = "-IIOP" ] ; then
     isIIOPOption=true
  else
     if [ "$isIIOPOption" = "true" ] ; then
        iiopoption="-Djava.naming.provider.url=corbaloc:iiop:"$option
        shift
        shift
        break
     fi
  fi
done

#Platform specific args...
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
    LIBPATH=$binDir:$LIBPATH
    export LIBPATH ;;
  Linux)
    LD_LIBRARY_PATH=$binDir:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH ;;
  SunOS)
    LD_LIBRARY_PATH=$binDir:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH ;;
  HP-UX)
    SHLIB_PATH=$binDir:$SHLIB_PATH
    export SHLIB_PATH ;;
  OS/390)
    PATH="$PATH":$binDir
    ENCODE_ARGS="-Xnoargsconversion -Dfile.encoding=ISO8859-1" 
    export PATH
    X_ARGS="-Xnoargsconversion" ;;
esac

JMS_PATH=$WAS_HOME/lib/WMQ/java/lib/com.ibm.mq.jar:$WAS_HOME/lib/WMQ/java/lib/com.ibm.mqjms.jar:$WAS_HOME/lib/WMQ/java/lib/dhbcore.jar

"$JAVA_HOME/bin/java" \
  $ENCODE_ARGS \
  $CONSOLE_ENCODING \
  $javaoption \
  $CLIENTSSL \
  $JVM_EXTRA_CMD_ARGS \
  $USER_INSTALL_PROP \
  $iiopoption \
  -Dcom.ibm.ws.container=standalone \
  -Dwas.install.root="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Dcom.ibm.CORBA.BootstrapHost=$DEFAULTSERVERNAME \
  -Dcom.ibm.CORBA.BootstrapPort=$SERVERPORTNUMBER \
  -classpath "$WAS_HOME/lib/launchclient.jar:$WAS_CLASSPATH:$JMS_PATH" \
  com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.ws.grid.comm.WSGrid "$@"



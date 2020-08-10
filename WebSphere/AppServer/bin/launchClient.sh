#!/bin/sh

# THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
# 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5724-J08 COPYRIGHT International Business Machines Corp., 1997, 2010
# All Rights Reserved * Licensed Materials - Property of IBM
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

#!echo "Usage: launchClient [-profileName name | -JVMOptions options | -help | -?] <userapp> [-CC<name>=<value>] [app args] 

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

isJavaOption=false
for option in "$@" ; do
  if [ "$option" = "-JVMOptions" ] ; then
     isJavaOption=true
  else
     if [ "$isJavaOption" = "true" ] ; then
        javaoption="$javaoption $option"
        isJavaOption=false
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
    export PATH ;;
esac

"$JAVA_HOME/bin/java" \
  $ENCODE_ARGS \
  $CONSOLE_ENCODING \
  $javaoption \
  $JVM_EXTRA_CMD_ARGS \
  $USER_INSTALL_PROP \
  -Dwas.install.root="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -DMQ_USE_BUNDLE_REFERENCE_INSTALL=true -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  -Dcom.ibm.CORBA.BootstrapHost=$DEFAULTSERVERNAME \
  -Dcom.ibm.CORBA.BootstrapPort=$SERVERPORTNUMBER \
  -Dcom.ibm.ffdc.log="$FFDCLOG" \
  -Dorg.osgi.framework.bootdelegation=* \
  -classpath "$WAS_HOME/lib/launchclient.jar:$WAS_CLASSPATH" \
  com.ibm.websphere.client.applicationclient.launchClient \
  "$@"


#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 1997,2005
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# Launch Arguments:
#
#

# Bootstrap values ...
SHELL=com.ibm.ws.runtime.LaunchBatchCompiler

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
    ${JAVA_EXE} -cp "${WAS_HOME}/lib/commandlineutils.jar" com.ibm.ws.install.commandline.utils.CommandLineUtils -specifiedProfileNotExists -profileName $WAS_PROFILE_NAME
    exit 1
elif [ "${WAS_USER_SCRIPT_FILE_NOT_EXISTS:=}" != "" ] && [ "$WAS_USER_SCRIPT_FILE_NOT_EXISTS" = "true" ]
then
    ${JAVA_EXE} -cp "${WAS_HOME}/lib/commandlineutils.jar" com.ibm.ws.install.commandline.utils.CommandLineUtils -wasUserScriptFileNotExists -wasUserScript $WAS_USER_SCRIPT
    exit 1
elif [ "${NO_DFT_PRF_EXISTS:=}" != "" ] && [ "$NO_DFT_PRF_EXISTS" = "true" ]
then
    ${JAVA_EXE} -cp "${WAS_HOME}/lib/commandlineutils.jar" com.ibm.ws.install.commandline.utils.CommandLineUtils -noDefaultProfile -commandName $CMD_NAME
    exit 1
fi

# Setup the initial java invocation;
DELIM=" "

#Common args...
D_ARGS="-Dws.ext.dirs="$WAS_EXT_DIRS" $DELIM -Dwas.install.root="$WAS_HOME" $DELIM -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" $DELIM -Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager $DELIM -Djava.util.logging.configureByServer=true $DELIM -Xms64m $DELIM -Xmx256m"

#Platform specific args...
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
    EXTSHM=ON
    LIBPATH="$WAS_LIBPATH":$LIBPATH
    export LIBPATH EXTSHM ;;
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
    PATH="$PATH":$binDir
    export PATH
    D_ARGS=""$D_ARGS" $DELIM -Dfile.encoding=ISO8859-1 $DELIM -Djava.ext.dirs="$JAVA_EXT_DIRS""
    D_ARGS=""$D_ARGS" $DELIM -Dwas.serverstart.cell="$WAS_CELL""
    D_ARGS=""$D_ARGS" $DELIM -Dwas.serverstart.node="$WAS_NODE""
    D_ARGS=""$D_ARGS" $DELIM -Dwas.serverstart.server="$1""
    X_ARGS="-Xnoargsconversion" ;;
esac

# set OSGI_CFG correctly
_SERVER_NAME_NEXT=false
_SERVER_NAME_VALUE=

if [ $# -gt 0 ]; then
     for i in "$@"
     do
          if [ "${_SERVER_NAME_NEXT}" = "true" ]; then
               _SERVER_NAME_VALUE=${i}
               break
          else
               if [ "${i}" = "-server.name" ]; then
                    _SERVER_NAME_NEXT=true
               fi
          fi
     done 
fi

if [ "${_SERVER_NAME_VALUE}" != "" ]; then
     _SERVER_CFG_AREA=$USER_INSTALL_ROOT"/servers/"$_SERVER_NAME_VALUE/configuration
     OSGI_CFG="-Dosgi.configuration.area="${_SERVER_CFG_AREA}
fi

# done setting OSGI_CFG     
"$JAVA_HOME"/bin/java \
  "$OSGI_INSTALL" "$OSGI_CFG" \
  $X_ARGS \
  $WAS_DEBUG \
  $CONSOLE_ENCODING \
  $D_ARGS \
  -classpath "$WAS_CLASSPATH" \
  $USER_INSTALL_PROP \
  $JVM_EXTRA_CMD_ARGS \
  com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application com.ibm.ws.bootstrap.WSLauncher \
  $SHELL "-config.root.hidden" "$CONFIG_ROOT" "-cell.name.hidden" "$WAS_CELL" "-node.name.hidden" "$WAS_NODE" "$@"

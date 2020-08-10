#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# wsadmin launcher

binDir=`dirname "$0"`
. "$binDir/setupCmdLine.sh"

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

if [ ! "$SI_PATH" ] ; then
   echo Environment variable SI_PATH is not defined.  You need to run %%ACU_COMMON%%\setenv.sh first where %%ACU_COMMON%% is the Solution Install common directory, for example C:\Program Files\IBM\common\acu.
   exit
fi

SHELL=com.ibm.ws.management.touchpoint.tpru.RegisterTouchpoints

if [ ! "$USER_INSTALL_ROOT" ] ; then
   USER_INSTALL_ROOT=$WAS_HOME
fi

# For debugging the utility itself
# DEBUG="-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777"

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

#Platform specific args...
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX | Linux | SunOS | HP-UX)
    C_PATH="$WAS_CLASSPATH:$SI_PATH/lib/si.jar:$SI_PATH/lib/jlog.jar:$SI_PATH/lib/db2j.jar:$SI_PATH/lib/db2jcc.jar:$SI_PATH/lib/db2jcc_license_c.jar:$SI_PATH/lib/db2jnet.jar:$SI_PATH/lib/db2jtools.jar"
    CONSOLE_ENCODING=-Dws.output.encoding=console ;;
  OS/390)
    C_PATH="$WAS_CLASSPATH:$SI_PATH/lib/si.jar:$SI_PATH/lib/jlog.jar:$SI_PATH/lib/db2j.jar:$SI_PATH/lib/db2jcc.jar:$SI_PATH/lib/db2jcc_license_c.jar:$SI_PATH/lib/db2jnet.jar:$SI_PATH/lib/db2jtools.jar"
    EXTRA_D_ARGS="-Dfile.encoding=ISO8859-1 $DELIM -Djava.ext.dirs="$JAVA_EXT_DIRS""
    EXTRA_X_ARGS="-Xnoargsconversion" ;;
esac

"$JAVA_HOME/bin/java" \
  -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
  $EXTRA_X_ARGS \
  $CONSOLE_ENCODING \
  $javaOption \
  $DEBUG \
  "$CLIENTSAS" \
  "$CLIENTSSL" \
  "$CLIENTSOAP" \
  -Dcom.ibm.ws.scripting.wsadminprops="$WSADMIN_PROPERTIES" \
  -Dwas.install.root="$WAS_HOME" \
  -Duser.install.root="$USER_INSTALL_ROOT" \
  -Dwas.repository.root="$CONFIG_ROOT" \
  -Dserver.root="$WAS_HOME" \
  -Dlocal.cell="$WAS_CELL" \
  -Dlocal.node="$WAS_NODE" \
  -Dcom.ibm.ws.management.standalone=true \
  -Dcom.ibm.itp.location="$WAS_HOME/bin" \
  -Dsipath="$SI_PATH" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  $EXTRA_D_ARGS \
  $JVM_EXTRA_CMD_ARGS \
  $WAS_LOGGING \
  -classpath "$C_PATH" com.ibm.ws.bootstrap.WSLauncher \
  $SHELL "${nonJavaOption[@]}"

exit $?

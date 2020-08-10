#!/bin/sh

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

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

#CONSOLE_ENCODING controls the output encoding used for stdout/stderr
#    console - encoding is correct for a console window
#    file    - encoding is the default file encoding for the system
#    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS

PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
    EXTSHM=ON
    LIBPATH="$WAS_LIBPATH":$LIBPATH
    CONSOLE_ENCODING=-Dws.output.encoding=console
    export LIBPATH EXTSHM CONSOLE_ENCODING;;
  Linux)
    LD_LIBRARY_PATH="$WAS_LIBPATH":$LD_LIBRARY_PATH
    CONSOLE_ENCODING=-Dws.output.encoding=console
    export LD_LIBRARY_PATH CONSOLE_ENCODING;;
  SunOS)
    LD_LIBRARY_PATH="$WAS_LIBPATH":$LD_LIBRARY_PATH
    CONSOLE_ENCODING=-Dws.output.encoding=console
    export LD_LIBRARY_PATH CONSOLE_ENCODING;;
  HP-UX)
    SHLIB_PATH="$WAS_LIBPATH":$SHLIB_PATH
    CONSOLE_ENCODING=-Dws.output.encoding=console
    export SHLIB_PATH CONSOLE_ENCODING;;
  OS/390|z/OS)
    ZOPTIONS="-Xnoargsconversion -Dfile.encoding=ISO-8859-1 $JVM_EXTRA_CMD_ARGS"
    ZINPUT_HANDLER="-inputhandler com.ibm.ws.ant.utils.WebSphereInputHandler";;
esac

while [ ${#} -gt 0 ]
do
        case "${1}" in
                *\"*\'*|*\'*\"*) echo "$1" | sed "s:\":\\\\\\\&:g; s:.*:\"&\":" | read argv;;
                *\"*) argv="'$1'";;
                *) argv="\"$1\"";;
        esac
        shift
        ARGS="${ARGS} ${argv}"
done


WAS_ANT_EXTRA_CLASSPATH="$WAS_HOME/lib/bootstrap.jar"
WAS_ANT_CLASSPATH=$WAS_ANT_CLASSPATH:$WAS_HOME/plugins

WAS_EXT_DIRS=$WAS_ANT_CLASSPATH:$WAS_EXT_DIRS
export PATH

eval "$JAVA_EXE" -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" "$OSGI_INSTALL" "$OSGI_CFG" $WAS_LOGGING "$CONSOLE_ENCODING" "$CLIENTSAS" "$CLIENTSSL" -Dwas.ant.extra.classpath="$WAS_ANT_EXTRA_CLASSPATH" -DWAS_USER_SCRIPT="$WAS_USER_SCRIPT" "$USER_INSTALL_PROP" -Dwas.install.root="$WAS_HOME" -Dwas.root="$WAS_HOME" -Dws.ext.dirs="$WAS_EXT_DIRS" ${ZOPTIONS:=} -classpath "$WAS_HOME/plugins/com.ibm.ws.prereq.asm.jar:$WAS_CLASSPATH" $JVM_EXTRA_CMD_ARGS com.ibm.ws.bootstrap.WSLauncher org.apache.tools.ant.Main ${ZINPUT_HANDLER:=} ${ARGS}


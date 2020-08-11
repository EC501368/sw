#!/bin/sh
# IBM Confidential OCO Source Material
# 5630-A36 (C) COPYRIGHT International Business Machines Corp. 2011
# The source code for this program is not published or otherwise divested
# of its trade secrets, irrespective of what has been deposited with the
# U.S. Copyright Office.

parseParams()
{
   while [ $# -ge 1 ]; do
      case `echo $1|/usr/bin/tr "[A-Z]" "[a-z]"` in
         -targetdir)
            if [ "$2" = "" ]; then
               usageBadParam $1
            fi
            targetDir=$2
            shift
         ;;
         -usage|-?)
            usage
         ;;
         *)
            usageBadParam $1 ;;
      esac
      shift;
   done
}

checkVars()
{
   if [ "X$targetDir" = "X" ]; then
      usage
   fi

   `/bin/mkdir -p "$targetDir"`

   if [ ! -d "$targetDir" ]; then
      usageNoInstallRoot
   fi
}

setEnvVars()
{
   antArgs="-DWAS_INSTALL_ROOT=\"${WAS_HOME}\" -DTARGETDIR=\"${targetDir}\" -DWAS_HOME=\"${WAS_HOME}\""
}

createRemoteMigrJarFile()
{
   #Construct the parameters for the tooling call to remote migration. If any parameters are null, it may trigger an attempt to load a class by name of "".
   parameters="-classpath \"${WAS_CLASSPATH}\" -Djava.endorsed.dirs=\"$WAS_ENDORSED_DIRS\" \"${WAS_LOGGING}\" \"${CONSOLE_ENCODING}\" -DWAS_USER_SCRIPT=\"$WAS_USER_SCRIPT\" -Dws.ext.dirs=\"$WAS_EXT_DIRS\" -Dwas.ant.extra.classpath=\"$WAS_ANT_EXTRA_CLASSPATH\" -Dwas.install.root=\"$WAS_HOME\" -Dwas.root=\"$WAS_HOME\""
   if [ "X$USER_INSTALL_PROP" != "X" ]; then
      parameters="$parameters $USER_INSTALL_PROP"
   fi

   eval \"$JAVA_EXE\" ${parameters} com.ibm.ws.bootstrap.WSLauncher org.apache.tools.ant.Main -quiet -f "${installSrc}/createRemoteMigrJar.ant" ${antArgs}
   irc=$?
   if [ $irc -ne 0 ]; then
      echo "Possible error ($irc) running the create remote migration ant script, check system stderr/stdout."
   fi
   if [ $irc -eq 0 ]; then
      echo "The WebSphere Release 8.0.x Remote Migration Support jarfile has been created."
      echo "1) Send jarfile to the system where your source profile resides."
      echo "2) Unjar the file to a temp location."
      echo "3) cd to the bin directory in the temp location."
      echo "4) Run the WASPreUpgrade command against the source profile to be migrated using the -machineChange true parameter."
      echo "   See the WASPreUpgrade command details in the infoCenter."
      echo ""
   fi
}

usageBadParam()
{
   echo "ERROR: The command line parameter, $1, is invalid or no value was provided with the param."
   usage
}

usageNoInstallRoot()
{
   echo "The install location ($targetDir) does not exist, or the directory cannot be created.
     Please specify the fully qualified path location where the Remote Migration Support Jar should be created."
   usage
}

usage()
{
   echo "Usage:
   
     createRemoteMigrJar.sh -targetDir targetdir"
   
   explainParams
   exit 1
}

explainParams()
{
   echo "
   -targetDir - The directory where the jar file will be created."
}

BEGINDIR=`pwd`

installSrc=`dirname $0`
cd "${installSrc}"
installSrc=`pwd`

cd "${installSrc}/../../.."
REPLACE_WAS_HOME=`pwd`
cd bin
. ./setupCmdLine.sh
cd "${installSrc}"

if [ -f "${JAVA_HOME}/bin/java" ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

PATH=${WAS_PATH}
export PATH

WAS_ANT_EXTRA_CLASSPATH="$WAS_HOME/lib/bootstrap.jar"
WAS_ANT_CLASSPATH=$WAS_ANT_CLASSPATH:$WAS_HOME/plugins
WAS_EXT_DIRS=$WAS_ANT_CLASSPATH:$WAS_EXT_DIRS
CLASSPATH=${WAS_CLASSPATH}

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
    echo "zOS does not support cross machine migrations."
	exit -1
esac

if [ $# -eq 0 ]; then
   usage
else
   parseParams "$@"
fi
checkVars

setEnvVars
createRemoteMigrJarFile
cd "${BEGINDIR}"
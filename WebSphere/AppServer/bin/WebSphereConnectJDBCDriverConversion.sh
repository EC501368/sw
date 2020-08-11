#!/bin/sh

binDir=`dirname "$0"`
. "$binDir"/setupCmdLine.sh

#Platform specific args...
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
    CONSOLE_ENCODING=-Dws.output.encoding=console;;
  Linux)
    CONSOLE_ENCODING=-Dws.output.encoding=console;;
  SunOS)
    CONSOLE_ENCODING=-Dws.output.encoding=console;;
  HP-UX)
    CONSOLE_ENCODING=-Dws.output.encoding=console;;
  OS/390)
    EXTRA_D_ARG=-Dfile.encoding=ISO8859-1
    EXTRA_X_ARG=-Xnoargsconversion ;;
esac

"$JAVA_HOME/bin/java" \
  -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
  "$OSGI_INSTALL" "$OSGI_CFG" \
  $EXTRA_X_ARG \
  $CONSOLE_ENCODING \
  -DKeepProfileName=true \
  -Dcom.ibm.websphere.migration.serverRoot="$WAS_HOME" \
  -Dcom.ibm.ws.migration.currentProfileLogLocation="$USER_INSTALL_ROOT" \
  -Dosgi.migration.plugin.name=com.ibm.wsspi.extension.was-migration-ddconversiontool \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  -Dwas.install.root=$WAS_HOME \
  -Duser.install.root=$USER_INSTALL_ROOT \
  $WAS_LOGGING \
  $EXTRA_D_ARG \
  -classpath "$WAS_CLASSPATH":"$WAS_HOME"/properties com.ibm.wsspi.bootstrap.WSPreLauncher \
  -nosplash  -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.migration.ConversionTool "$@"
  rc=$?
  exit $rc
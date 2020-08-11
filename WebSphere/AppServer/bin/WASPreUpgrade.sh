#!/bin/sh

binDir=`dirname "$0"`
. "$binDir"/setupCmdLine.sh

isJavaOption=false
nonJavaOptionCount=1
use64bit=false
for option in "$@" ; do
  if [ "$option" = "-javaoption" ] ; then
     isJavaOption=true
  else
     if [ "$isJavaOption" = "true" ] ; then
        javaOption="$javaOption $option"
        isJavaOption=false
     else 
        if [ "$option" = "-use64BitJVM" ] ; then
            use64bit=true
        else
            nonJavaOption[$nonJavaOptionCount]="$option"
            nonJavaOptionCount=$((nonJavaOptionCount+1))
        fi
     fi
  fi
done

#zOS may use a 64-bit JVM for the migration. For that purpose, define the default JVM path here and change it for zOS only.
JAVA_PATH="$JAVA_HOME/bin/java"

#Platform specific args...
# Set java options for performance
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
	PERF_JVM_OPTIONS="-Xms256m -Xmx512m -Xquickstart"
    CONSOLE_ENCODING=-Dws.output.encoding=console
	LIBPATH="$WAS_LIBPATH":$LIBPATH
    export LIBPATH ;;	
  Linux)
    ARCH=`/bin/uname -m`
    if [ $ARCH = "ia64" ]; then
        PERF_JVM_OPTIONS="-Xms256m -Xmx512m -XX:PermSize=40m -XX:MaxPermSize=128m"
    else
        PERF_JVM_OPTIONS="-Xms256m -Xmx512m -Xj9 -Xquickstart"
    fi
    CONSOLE_ENCODING=-Dws.output.encoding=console
    LD_LIBRARY_PATH="$WAS_LIBPATH":$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH ;;	
  SunOS)
	PERF_JVM_OPTIONS="-Xms256m -Xmx512m -XX:PermSize=40m -XX:+UnlockDiagnosticVMOptions -XX:+UnsyncloadClass"
    CONSOLE_ENCODING=-Dws.output.encoding=console
	LD_LIBRARY_PATH="$WAS_LIBPATH":$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH ;;	
  HP-UX)
	PERF_JVM_OPTIONS="-Xms256m -Xmx512m -XX:PermSize=40m -XX:+UnlockDiagnosticVMOptions -XX:+UnsyncloadClass"
    CONSOLE_ENCODING=-Dws.output.encoding=console
    SHLIB_PATH="$WAS_LIBPATH":$SHLIB_PATH
    export SHLIB_PATH ;;		
  OS/390)
	PERF_JVM_OPTIONS="-Xquickstart"
    EXTRA_D_ARG=-Dfile.encoding=ISO8859-1
    EXTRA_X_ARG=-Xnoargsconversion
    if [ "$use64bit" = "true" ] ; then
       JAVA_PATH="$WAS_HOME/java64/bin/java"
       echo "Java path switched to 64 bit: ${JAVA_PATH}"
    fi ;;
esac

$JAVA_PATH \
  "$OSGI_INSTALL" "$OSGI_CFG" \
  $EXTRA_X_ARG \
  $CONSOLE_ENCODING \
  -Dcom.ibm.websphere.migration.serverRoot="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  -Dwas.install.root=$WAS_HOME \
  -Duser.install.root=$WAS_HOME \
  -Dcom.ibm.ws.migration.ulimit=`ulimit -n` \
  $PERF_JVM_OPTIONS \
  $WAS_LOGGING \
  $EXTRA_D_ARG \
  $javaOption \
  -classpath "$WAS_CLASSPATH" com.ibm.wsspi.bootstrap.WSPreLauncher \
  -nosplash -clean -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.migration.WASPreUpgrade "${nonJavaOption[@]}"
  rc=$?
  exit $rc

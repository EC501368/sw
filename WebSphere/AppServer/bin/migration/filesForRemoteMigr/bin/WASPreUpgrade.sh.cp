#!/bin/sh

binDir=`dirname "$0"`
. "$binDir"/setupCmdLine.sh
currentDir=$PWD

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
	PERF_JVM_OPTIONS="-Xms256m -Xmx512m -Xj9 -Xquickstart"
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
esac


if [ -r /etc/redhat-release ]
then
    release=`cat /etc/redhat-release | awk '{print $7}'`
    version=${release%%\.*}
        
    if [ $version -ge 5 ]
    then
        if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
            scontext=`ls --scontext "$JAVA_HOME"/bin/java | awk '{ split($1, a, ":"); print a[3] }'`

            case $scontext in
            textrel_shlib_t | java_exec_t | nfs_t) ;;
            iso9660_t) 
                echo SELinux is preventing WASPreUpgrade from running. Please mount the install CD with option \'-o context=system_u:object_r:textrel_shlib_t\' 
                exit $FAIL_RC
                ;;
            *) 
                "$currentDir"/relabel_java.sh "$JAVA_HOME"

                ;;
            esac
        fi
    fi
fi

"$JAVA_HOME/bin/java" \
  "$OSGI_INSTALL" -Dosgi.configuration.area="@user.home/WebSphere"  \
  $EXTRA_X_ARG \
  $CONSOLE_ENCODING \
  -Dcom.ibm.websphere.migration.serverRoot="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Dws.migration.pre.remote.xos="true" \
  -Dcom.ibm.ws.migration.ulimit=`ulimit -n` \
  $PERF_JVM_OPTIONS \
  $WAS_LOGGING \
  $EXTRA_D_ARG \
  $javaOption \
  -classpath "$WAS_CLASSPATH":"$WAS_HOME"/derby/migration/derby10.3.jar \
  com.ibm.wsspi.bootstrap.WSPreLauncher \
  -nosplash  -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.migration.WASPreUpgrade "${nonJavaOption[@]}"
  rc=$?
  exit $rc

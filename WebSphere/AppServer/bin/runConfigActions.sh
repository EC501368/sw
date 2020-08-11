#!/bin/sh

# "USAGE : runConfigActions.sh"
# "USAGE : This script runs any config actions that are required in the profile. "
#
# 719064 111026 ljrojas Add postinstaller ending WTOs if on z/OS

binDir=`dirname $0`
. ${binDir}/setupCmdLine.sh



# Begin: Disable Postinstaller options
# If runConfigActions.disableAlways file exists, just exit RC=0
# This flag will disable runConfigActions completely. 
disableAlways=${USER_INSTALL_ROOT}/properties/service/runConfigActions.disableAlways
if [ -f $disableAlways ]; then
	exit 0
fi
# If runConfigActions.disableAtServerStartup exists AND this script was called by startServer, exit RC=0
# This allows the script to be skipped at server startup but run manually. 
# Ensure startServer has a value. If startServer does not have a value, then line 28 will break on z/OS
if [ -n "$1" ]; then
	startServer=$1
else
	startServer=NULL
fi
	
disableSS=${USER_INSTALL_ROOT}/properties/service/runConfigActions.disableAtServerStartup
#if [[ -f $disableSS  &&  $startServer = "-startServer" ]]; then
if [ -f $disableSS ] && [ $startServer = "-startServer" ]; then	
	exit 0
fi
# End : Disable Postinstaller options


# 678372
# Create symlink if file does not exist. 
# The if stmt should only ever be true on z/OS.  
if [ ! -d ${WAS_HOME}/properties/service/productDir/WebSphere/service ]; then
 platform=`uname`
 if [ $platform = 'OS/390' ]; then
  mkdir -p ${WAS_HOME}/properties/service/productDir/WebSphere
  chmod -R 775 ${WAS_HOME}/properties/service/productDir
  smperoot=`ls -l ${WAS_HOME}/properties/service/postinstaller | awk '{print $11}'`
  smperoot=`dirname "$smperoot"`
  smperoot=$smperoot/productDir/WebSphere/service
  ln -s $smperoot ${WAS_HOME}/properties/service/productDir/WebSphere/service
 fi
fi


CP=${WAS_HOME}/properties/service/postinstaller/lib/postinstaller_mp.jar:${WAS_HOME}/properties/service/postinstaller/lib/com.ibm.ws.runtime.postinstaller.jar

if [ -f ${JAVA_HOME}/bin/java ]; then
       JAVA_EXE="${JAVA_HOME}/bin/java"
else
       JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

${JAVA_EXE} \
$JVM_EXTRA_CMD_ARGS \
-Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
-DWAS_HOME=${WAS_HOME} -DUSER_INSTALL_ROOT=${USER_INSTALL_ROOT} \
-classpath ${CP} \
com.ibm.ws.postinstall.runConfigActions.RunConfigActions $@


RC=$?

# Start:719064
# If we are on z/OS and the 'postinstaller starting' WTO was issued then
# also issue a 'postinstaller ended' WTO before exiting. 
# BBOO0401I for normal completion
# BBOO0402E for error completion (RC!=0)

platform=`uname`
if [ $platform = 'OS/390' ]; then
 if [ -e ${USER_INSTALL_ROOT}/properties/service/productDir/WTOstart.issued ]; then

  if [ $RC -eq 0 ]; then
   java -classpath ${CP} com.ibm.websphere.postinstaller.taskdefs.WriteToOperator "BBOO0401I"
  else
   java -classpath ${CP} com.ibm.websphere.postinstaller.taskdefs.WriteToOperator "BBOO0402E" "WEBSPHERE" "${USER_INSTALL_ROOT}/properties/service/productDir/logs/runConfigActions.log"  
   fi
  rm ${USER_INSTALL_ROOT}/properties/service/productDir/WTOstart.issued
 fi
fi
# End :719064

exit $RC

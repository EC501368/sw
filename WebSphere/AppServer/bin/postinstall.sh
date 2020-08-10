#!/bin/sh

show_usage(){
echo postinstall.sh \<WAS_HOME\> -WS_CMT_CONF_DIR \<WS_CMT_CONF_DIR\> -MASTER_ACTION_REGISTRY \<MASTER_ACTION_REGISTRY\> -SUB_ACTION_REGISTRY \<CACHE_ACTION_REGISTRY\> -WS_PI_ACTION_REGISTRY_EXTENSION \<REGISTRY_EXTENSION\> -WS_CMT_LOG_HOME \<WS_CMT_LOG_HOME\> -POSTINSTALL_LOG_FILE \<POSTINSTALL_LOG_FILE\>
}

curDir=`pwd`
wasDir=`dirname $0`/../
cd "${wasDir}"
WAS_HOME=`pwd`
cd "${curDir}"

if [ "$1" = "" ]; then
 show_usage
 exit 1
fi 

PARAMETERS=$@

. ${WAS_HOME}/properties/service/postinstaller/bin/setupPostinstall.sh ${WAS_HOME}

POSTINSTALL_LOG=${WAS_HOME}/logs/postinstall/postinstalldefault.log
while [ "$1" != "" ]
 do
  if [ "$1" = "-POSTINSTALL_LOG_FILE" ]; then
   POSTINSTALL_LOG=$2
  fi
  shift
 done



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
com.ibm.ws.postinstall.LaunchUnifiedPostInstaller \
${PARAMETERS}

RC=$?

if [ $RC -gt 2 ] || [ $RC -lt 0 ]; then
 echo " " >> ${POSTINSTALL_LOG} 
 echo \<log\> >> ${POSTINSTALL_LOG}
 echo \<record\> >> ${POSTINSTALL_LOG}
 echo "    "\<date\>`date "+%Y-%m-%d %H:%M:%S"`\</date\> >> ${POSTINSTALL_LOG}
 echo "    "\<level\>SEVERE\</level\> >> ${POSTINSTALL_LOG}
 echo "    "\<message\>postinstall.sh return code is $RC. See the most current Installation Manager application data log in \<IM appdata\>/logs/native for more information.\</message\> >> ${POSTINSTALL_LOG}
 echo \</record\> >> ${POSTINSTALL_LOG}
 echo \</log\> >> ${POSTINSTALL_LOG}
fi

if [ $RC -eq 1 ]; then
echo postinstall.sh return code is 1.
echo Check the usage and the \<POSTINSTALL_LOG_FILE\> specified in the parameters for more information.
show_usage
fi

exit $RC

#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 1997, 2012
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# Launch clearClassCache

# Launch Arguments:
#   none
#

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

# Default usage is quiet with log
outStream="/dev/null"
timeStamp=`date +%m%dH89S`
logDir="${WAS_HOME}/logs/clearClassCache"
if [ ! -d ${logDir} ]; then mkdir -m 755 ${logDir} ; fi
if [ -w ${logDir} ]; then
    outStream="${logDir}/${timeStamp}.log"
else 
    echo The "${WAS_HOME}/logs" directory must be writable to log results.
fi
#echo timeStamp=${timeStamp}, logDir=${logDir}, outStream=${outStream}

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

# valid values for $PLATFORM are AIX, HP-UX, Linux, SunOS and OS/390
# HP_UX and SunOS do not ship the IBM JDK, so function is not needed.
case $PLATFORM in
	AIX | Linux)
                HI_JAVA=`${JAVA_EXE} -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" -classpath "$WAS_CLASSPATH" $USER_INSTALL_PROP -Dwas.install.root="$WAS_HOME" "com.ibm.wsspi.bootstrap.WSPreLauncher" -nosplash -application "com.ibm.ws.bootstrap.WSLauncher" "com.ibm.ws.debug.osgi.JVMPathCalculator"`
                if [ "${HI_JAVA}" = "JVMPATHCALCULATOR_ERROR" ]; then
                    JAVA_EXE2="${JAVA_EXE}"
                    #echo JVMPathCalculator error exit, path to highest jvm set to ${JAVA_EXE2}
                else
                    if [ -f ${HI_JAVA}/bin/java ]; then
                        JAVA_EXE2="${HI_JAVA}/bin/java"
                    else
                        JAVA_EXE2="${HI_JAVA}/jre/bin/java"
                    fi
                    #echo JVMPathCalculator normal processing exit, path to highest jvm set to ${JAVA_EXE2} 
                fi
                ${JAVA_EXE2} -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" -Xshareclasses:destroyAll 2>${outStream} 
                launchExit=$?
		if [ "$launchExit" = 1 ]
		then
			exit 0
		fi
		exit `expr $launchExit + $?`
	;;
	
	OS/390)
		${JAVA_EXE} -Xlog:none -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" -Xshareclasses:cacheDir=${WAS_HOME},destroyAll 2>${outStream}
       	;;
        
		
	*)
		exit 0
	;;
esac


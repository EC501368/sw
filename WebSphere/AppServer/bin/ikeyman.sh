#!/bin/sh
# Copyright IBM Corp. 2001

binDir=`dirname $0`
. "$binDir/setupCmdLine.sh"

PLATFORM=`uname`
JVM_EXTRA_CMD_ARGS=""

case ${PLATFORM} in 
        Linux)
                LD_LIBRARY_PATH=/lib:/usr/lib:${LD_LIBRARY_PATH:=}
                export LD_LIBRARY_PATH
                OS_ARCH=`uname -m`
                case ${OS_ARCH} in
                    i386|i486|i586|i686|i786|i886|athlon|x86_64)
                        ;;
                    ppc|ppc64)
                        ;;
                    s390|s390x)
                        ;;
                esac
               
                ;;
        SunOS|Solaris)
                LD_LIBRARY_PATH=/lib:/usr/lib:${LD_LIBRARY_PATH:=}
                export LD_LIBRARY_PATH
                ;;
        HP-UX)
                SHLIB_PATH=/lib:/usr/lib:${SHLIB_PATH:=}
                export SHLIB_PATH
                ;;
        AIX)    
                LIBPATH=/lib:/usr/lib:${LIBPATH:=}
                export LIBPATH
                ;;
        OS/390|z/OS)
                ;;
        *)
                ;;
esac

# setup the classpath
if [ "${JAVA_HOME}" = "${JAVA_JRE}" ]
then   
   EXT=$JAVA_HOME/lib/ext
else
   EXT=$JAVA_HOME/jre/lib/ext
fi

CP="$EXT/ibmjceprovider.jar:$EXT/ibmjcefw.jar:$EXT/US_export_policy.jar:$EXT/local_policy.jar:$EXT/ibmpkcs.jar:$EXT"

if [ "${JAVA_HOME}" = "${JAVA_JRE}" ]
then   
   $JAVA_HOME/bin/java -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS"  $JVM_EXTRA_CMD_ARGS -classpath $CP com.ibm.gsk.ikeyman.Ikeyman
else
   $JAVA_HOME/jre/bin/java -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" $JVM_EXTRA_CMD_ARGS -classpath $CP com.ibm.gsk.ikeyman.Ikeyman
fi

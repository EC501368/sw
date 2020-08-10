#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
    CONSOLE_ENCODING=-Dws.output.encoding=console
    JOPTIONS="-Xmx512m -Xquickstart"
    export CONSOLE_ENCODING;;
  Linux)
    CONSOLE_ENCODING=-Dws.output.encoding=console
    ARCH=`/bin/uname -m`
    if [ $ARCH = "ia64" ]; then
        JOPTIONS="-Xmx512m -XX:MaxPermSize=128m"
    else
        JOPTIONS="-Xmx512m -Xquickstart"
    fi
    export CONSOLE_ENCODING;;
  SunOS)
    CONSOLE_ENCODING=-Dws.output.encoding=console
    JOPTIONS="-Xmx512m"
    export CONSOLE_ENCODING;;
  HP-UX)
    CONSOLE_ENCODING=-Dws.output.encoding=console
    JOPTIONS="-Xmx512m"
    export CONSOLE_ENCODING;;
  OS/390|z/OS)
    ZOPTIONS="-Xnoargsconversion -Dfile.encoding=ISO-8859-1"
    JOPTIONS="-Xmx512m";;
esac

if [ "$USER_INSTALL_ROOT" = "" ] ; then
   USER_INSTALL_ROOT=$WAS_HOME
fi

if [ "$WAS_PLPR_ROOT" = "" ] ; then
	WAS_PLPR_ROOT="$WAS_HOME/systemApps"
	export WAS_PLPR_ROOT
fi

WAS_CLASSPATH="$WAS_HOME"/plugins/com.ibm.ws.prereq.asm.jar:"$WAS_CLASSPATH"
"$JAVA_HOME/bin/java" "-Djava.endorsed.dirs=$WAS_ENDORSED_DIRS" "-Djavax.xml.transform.TransformerFactory=org.apache.xalan.processor.TransformerFactoryImpl" $WAS_LOGGING $CONSOLE_ENCODING "-Dlocal.cell=$WAS_CELL" "-Dlocal.node=$WAS_NODE" "-Duser.install.root=$USER_INSTALL_ROOT" "-Dwas.install.root=$WAS_HOME" "-Dcom.ibm.ws.management.standalone=true" "-Dwas.repository.root=$CONFIG_ROOT" "-Dpluginprocessor.root=$WAS_PLPR_ROOT" $ISC_DEBUG ${ZOPTIONS:=} ${JOPTIONS:=} "-Xbootclasspath/p:$WAS_BOOTCLASSPATH" "-classpath" "$WAS_CLASSPATH" "-Dws.ext.dirs=$WAS_EXT_DIRS" "-Djava.ext.dirs=$JAVA_EXT_DIRS:$JAVA_HOME/jre/lib/ext:$JAVA_HOME/lib/ext" "com.ibm.ws.bootstrap.WSLauncher" "com.ibm.ws.console.plugin.PluginProcessor" $@



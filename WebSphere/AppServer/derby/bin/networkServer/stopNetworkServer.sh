#!/bin/sh

# ---------------------------------------------------------
# -- This batch file is an example of how to shutdown the
# -- Cloudscape network server
# --
# -- it will read the port number from the derby.properties file.
# -- if you specify the host name, it will use it else it will default to localhost
# -- This file for use on unix/linux systems
# -- 
# -- more options are available using networkServerControl.sh
# ---------------------------------------------------------


  
# Determine current location and then make sure to set environment as correctly
# as possible.
binDir="`dirname "$0"`"
export binDir

REPLACE_WAS_HOME=$binDir/../../..                   
. "$binDir/../../../bin/setupCmdLine.sh"

# the Derby locale jars which need to be on the classpath
__DERBY_LOCALE_JARS_PATH__=$DERBY_HOME/lib/locales/derbyLocale_cs.jar:$DERBY_HOME/lib/locales/derbyLocale_de_DE.jar:$DERBY_HOME/lib/locales/derbyLocale_es.jar:$DERBY_HOME/lib/locales/derbyLocale_fr.jar:$DERBY_HOME/lib/locales/derbyLocale_hu.jar:$DERBY_HOME/lib/locales/derbyLocale_it.jar:$DERBY_HOME/lib/locales/derbyLocale_ja_JP.jar:$DERBY_HOME/lib/locales/derbyLocale_ko_KR.jar:$DERBY_HOME/lib/locales/derbyLocale_pl.jar:$DERBY_HOME/lib/locales/derbyLocale_pt_BR.jar:$DERBY_HOME/lib/locales/derbyLocale_ru.jar:$DERBY_HOME/lib/locales/derbyLocale_zh_CN.jar:$DERBY_HOME/lib/locales/derbyLocale_zh_TW.jar

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
D_ARGS=$D_ARGS" $DELIM -Dfile.encoding=ISO8859-1 $DELIM -Djava.ext.dirs="$JAVA_EXT_DIRS
X_ARGS=""$X_ARGS" $DELIM -Xnoargsconversion" ;;
esac

"$JAVA_HOME/bin/java" $CONSOLE_ENCODING -Dwas.install.root="$WAS_HOME" $X_ARGS $D_ARGS -classpath "$WAS_CLASSPATH:$DERBY_HOME/lib/derbyclient.jar:$DERBY_HOME/lib/derby.jar:$DERBY_HOME/lib/derbytools.jar:$DERBY_HOME/lib/derbynet.jar:$DERBY_HOME/lib/jh.jar:$__DERBY_LOCALE_JARS_PATH__" -Dderby.system.home="$DERBY_HOME" com.ibm.ws.bootstrap.WSLauncher org.apache.derby.drda.NetworkServerControl shutdown "$@"

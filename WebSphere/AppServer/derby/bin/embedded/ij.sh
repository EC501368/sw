#!/bin/sh
#---------------------------------------------------------
#-- This simple script is an example of how to start ij in 
#-- the Derby Embedded environment.
#-- setup env
#---------------------------------------------------------

# Determine current location and then make sure to set environment as correctly
#as possible.
binDir="`dirname "$0"`"
export binDir

SHELL=org.apache.derby.tools.ij                   

REPLACE_WAS_HOME=$binDir/../../..                   
. "$binDir/../../../bin/setupCmdLine.sh"

# the Derby jars (including the locales) which need to be on the classpath
__DERBY_LOCALE_JARS_PATH__=$DERBY_HOME/lib/locales/derbyLocale_cs.jar:$DERBY_HOME/lib/locales/derbyLocale_de_DE.jar:$DERBY_HOME/lib/locales/derbyLocale_es.jar:$DERBY_HOME/lib/locales/derbyLocale_fr.jar:$DERBY_HOME/lib/locales/derbyLocale_hu.jar:$DERBY_HOME/lib/locales/derbyLocale_it.jar:$DERBY_HOME/lib/locales/derbyLocale_ja_JP.jar:$DERBY_HOME/lib/locales/derbyLocale_ko_KR.jar:$DERBY_HOME/lib/locales/derbyLocale_pl.jar:$DERBY_HOME/lib/locales/derbyLocale_pt_BR.jar:$DERBY_HOME/lib/locales/derbyLocale_ru.jar:$DERBY_HOME/lib/locales/derbyLocale_zh_CN.jar:$DERBY_HOME/lib/locales/derbyLocale_zh_TW.jar
__DERBY_JARS__=$DERBY_HOME/lib/derbyclient.jar:$DERBY_HOME/lib/derby.jar:$DERBY_HOME/lib/derbytools.jar:$DERBY_HOME/lib/derbynet.jar:$__DERBY_LOCALE_JARS_PATH__

#Platform specific args...
PLATFORM=`/bin/uname`
case $PLATFORM in
AIX)
C_PATH=$WAS_CLASSPATH:$__DERBY_JARS__
CONSOLE_ENCODING=-Dws.output.encoding=console;;
Linux)
C_PATH=$WAS_CLASSPATH:$__DERBY_JARS__
CONSOLE_ENCODING=-Dws.output.encoding=console;;
SunOS)
C_PATH=$WAS_CLASSPATH:$__DERBY_JARS__
CONSOLE_ENCODING=-Dws.output.encoding=console;;
HP-UX)
C_PATH=$WAS_CLASSPATH:$__DERBY_JARS__
CONSOLE_ENCODING=-Dws.output.encoding=console;;
OS/390)
C_PATH=$WAS_CLASSPATH:$__DERBY_JARS__
D_ARGS=$D_ARGS" $DELIM -Dfile.encoding=ISO8859-1 $DELIM -Djava.ext.dirs="$JAVA_EXT_DIRS
X_ARGS=""$X_ARGS" $DELIM -Xnoargsconversion" ;;
esac

# ---------------------------------------------------------
# -- start ij
# ---------------------------------------------------------
#"$JAVA_HOME/bin/java" $CONSOLE_ENCODING $X_ARGs $D_ARGs -classpath "$C_PATH" -Dderby.system.home="$DERBY_HOME" -Dij.protocol=jdbc:derby: org.apache.derby.tools.ij "$@"
"$JAVA_HOME/bin/java" \
  -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
  $X_ARGS \
  $CONSOLE_ENCODING \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Dwas.install.root="$WAS_HOME" \
  -Duser.install.root="$USER_INSTALL_ROOT" \
  -Dij.protocol=jdbc:derby: \
  -Dderby.system.home="$DERBY_HOME" \
  $D_ARGS \
  $JVM_EXTRA_CMD_ARGS \
  $PERF_JVM_OPTIONS \
  $WAS_LOGGING \
  -classpath "$C_PATH" com.ibm.ws.bootstrap.WSLauncher \
  $SHELL "$@"

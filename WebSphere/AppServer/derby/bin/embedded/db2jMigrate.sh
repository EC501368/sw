#!/bin/sh
#---------------------------------------------------------
#-- This batch file is an example of how to run the Cloudscape
#-- migration tool
#--
#--
#-- This file for use on unix/linux
#---------------------------------------------------------
#-- usage: db2jMigrate.sh  [old dbname] [new dbname]
#--
#--      command below can be modify with the following options:
#--
#--         -Ddb2j.migrate.ddlOnly=true Do not perform migration. Only
#--                 generate the old DDL file, <sourceDBname>.sql, and
#--                 the new DDL file (see dbj2.migrate.ddlFile option).
#--                 The default is false.
#--
#--         -Ddb2j.migrate.appendLogs=true Do not overwrite output logs.
#--                 The default is false.
#--
#--         -Ddb2j.migrate.ddlFile=<name> Write new DDL to file <name>
#--                 to create the v 10 DB.
#--                 The default is <sourceDBName>_newDDL.sql
#--
#--
#--         -Ddb2j.migrate.disableNationalCharMigrate=true
#--          disables National Char Migrate.  Default in WAS is true
#--
#--
                                                                                
# Determine current location and then make sure to set environment as correctly
#as possible.

binDir="`dirname "$0"`"
export binDir

SHELL=com.ibm.db2j.tools.MigrateFrom51                   

REPLACE_WAS_HOME=$binDir/../../..                   
. "$binDir/../../../bin/setupCmdLine.sh"
#Platform specific args...
PLATFORM=`/bin/uname`
case $PLATFORM in
AIX)
C_PATH=$WAS_CLASSPATH:$DERBY_HOME/lib/derbyclient.jar:$DERBY_HOME/lib/derby.jar:$DERBY_HOME/lib/derbytools.jar:$DERBY_HOME/lib/derbynet.jar:$DERBY_HOME/migration/migratetoderby.jar
CONSOLE_ENCODING=-Dws.output.encoding=console;;
Linux)
#C_PATH=$WAS_CLASSPATH:$DERBY_HOME/lib/derbyclient.jar:$DERBY_HOME/lib/derby.jar:$DERBY_HOME/lib/derbytools.jar:$DERBY_HOME/lib/derbynet.jar
C_PATH=$DERBY_HOME/lib/derby.jar:$DERBY_HOME/migration/migratetoderby.jar:$WAS_CLASSPATH
CONSOLE_ENCODING=-Dws.output.encoding=console;;
SunOS)
C_PATH=$WAS_CLASSPATH:$DERBY_HOME/lib/derbyclient.jar:$DERBY_HOME/lib/derby.jar:$DERBY_HOME/lib/derbytools.jar:$DERBY_HOME/lib/derbynet.jar:$DERBY_HOME/migration/migratetoderby.jar
CONSOLE_ENCODING=-Dws.output.encoding=console;;
HP-UX)
C_PATH=$WAS_CLASSPATH:$DERBY_HOME/lib/derbyclient.jar:$DERBY_HOME/lib/derby.jar:$DERBY_HOME/lib/derbytools.jar:$DERBY_HOME/lib/derbynet.jar:$DERBY_HOME/migration/migratetoderby.jar
CONSOLE_ENCODING=-Dws.output.encoding=console;;
OS/390)
C_PATH=$WAS_CLASSPATH:$DERBY_HOME/lib/derbyclient.jar:$DERBY_HOME/lib/derby.jar:$DERBY_HOME/lib/derbytools.jar:$DERBY_HOME/lib/derbynet.jar:$DERBY_HOME/migration/migratetoderby.jar
D_ARGS=$D_ARGS" $DELIM -Dfile.encoding=ISO8859-1 $DELIM -Djava.ext.dirs="$JAVA_EXT_DIRS
X_ARGS=""$X_ARGS" $DELIM -Xnoargsconversion" ;;
esac
                                                                                
if [ $# -lt 2 ]
then
 echo USAGE: db2jMigrate.sh  [old dbname] [new dbname]
 exit
else
 OLD_DB_URL="jdbc:db2j:$1"
   export OLD_DB_URL
fi
                                                                                
LOGNAMECLOUD=$DERBY_HOME/`basename ${1}`_migrationLog.log
   export LOGNAMECLOUD
DEBUGNAME=$DERBY_HOME/`basename ${1}`_migrationDebug.log   
   export DEBUGNAME
                                                                         

"$JAVA_HOME/bin/java" \
  -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
  $X_ARGS \
  $CONSOLE_ENCODING \
  -Dwas.install.root="$WAS_HOME" \
  -Ddb2j.migrate.verbose=false \
  -Ddb2j.migrate.disableNationalCharMigrate=true \
  -Ddb2j.system.home="$DERBY_HOME" \
  -Dderby.system.home="$DERBY_HOME" \
  -Ddb2j.migrate.newDBURL="jdbc:derby:$2" \
  -Ddb2j.migrate.migrateLog="$LOGNAMECLOUD" \
  -Ddb2j.migrate.debugLog="$DEBUGNAME" \
  $D_ARGS \
  $JVM_EXTRA_CMD_ARGS \
  $PERF_JVM_OPTIONS \
  $WAS_LOGGING \
  -classpath "$C_PATH" com.ibm.ws.bootstrap.WSLauncher \
  $SHELL $OLD_DB_URL

LOGNAMECLOUD=
   export LOGNAMECLOUD
DEBUGNAME=
   export DEBUGNAME
OLD_DB_URL=
   export OLD_DB_URL




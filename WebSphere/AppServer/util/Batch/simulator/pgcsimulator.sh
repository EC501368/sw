#!/bin/sh

DIRNAME=`dirname "$0"`
XJCL=$1
OPTARG=$2

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]
then
  echo "The syntax of the command is incorrect"
  exit 8
fi

if [ ! -f $XJCL ];
then
  echo "Specified xJCL file [$XJCL] does not exist"
  exit 8
fi

APP_CLASSPATH=$(grep -i 'application.classpath' $DIRNAME/pgcsimulator.properties | cut -f2 -d'=')
SIMULATOR_HOME=$(grep -i 'simulator.home' $DIRNAME/pgcsimulator.properties | cut -f2 -d'=')

SIMULATOR_CLASSPATH=$DIRNAME/pgccommon.jar:$DIRNAME/pgcruntime.jar:$DIRNAME/pgcstandalone.jar:../../lib/batfepapi.jar

java -cp $SIMULATOR_CLASSPATH:$APP_CLASSPATH -Dsimulator.home=$SIMULATOR_HOME com.ibm.ws.gridcontainer.standalone.PGCSimulator $1 $2
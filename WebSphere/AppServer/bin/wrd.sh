#!/bin/sh

APPLICATION=com.ibm.ws.rapiddeploy.core.WRDExec
ENCODINGOPTIONS=

quit() {
	exit
}

executeWRD() {
	echo "Launching WebSphere Rapid Deployment.  Please wait..."
	echo "Starting Workbench..."
	$JAVA_HOME/bin/java -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" $ENCODINGOPTIONS -Xverify:none -Xms256m -Xmx512m -cp $wrd_cp org.eclipse.core.launcher.Main -noupdate -data "$WORKSPACE" -application $APPLICATION -launch "$@"
}

failedFeature() {
  if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
  else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
  fi
  ${JAVA_EXE} -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" -cp "${WAS_HOME}/lib/commandlineutils.jar" com.ibm.ws.install.commandline.utils.CommandLineUtils -ejbdeployfeaturenotinstalled
  quit
}

binDir=`dirname $0`
. "$binDir/setupCmdLine.sh"

if [ ! -f $ITP_LOC/ejbdeploy.sh ]; then
	failedFeature
fi

if [ -z $ITP_LOC ]; then
	echo "Need to set ITP_LOC"
	quit
fi

wrd_cp=$ITP_LOC/startup.jar

PASSPARM=""

while [ $# -gt 0 ]; do
  case $1 in
        -workspace) shift
                    WORKSPACE="$1"
                    ;;
        *) PASSPARM="$PASSPARM $1"
            ;;
  esac
  shift
done

PLATFORM=`/bin/uname`
case $PLATFORM in
   OS/390)
# For z/OS, use ascii file-encoding 
      ENCODINGOPTIONS="-Dfile.encoding=ISO8859-1 -Xnoargsconversion ";;
esac

if [ -z "$WORKSPACE" ]; then
	echo "Set WORKSPACE to the rapid deployment workspace directory"
 echo "Unix: export WORKSPACE=<workspace root> "
	quit
else
	executeWRD ${PASSPARM}
fi 

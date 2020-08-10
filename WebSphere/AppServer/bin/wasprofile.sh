#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 2007, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

#Setting bootstrap values
binDir=`dirname $0`
. $binDir/setupCmdLine.sh

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

PROFILE_CLASSPATH=$WAS_HOME/plugins/com.ibm.ws.runtime.jar

echo
${JAVA_EXE} \
  -classpath $PROFILE_CLASSPATH \
   -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
  com.ibm.ws.profile.DeprecatedCommandRetriever wasprofile.sh manageprofiles.sh  
echo

binDir=`dirname $0`
. $binDir/manageprofiles.sh "$@"

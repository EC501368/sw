#!/bin/sh

# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 2012
# All Rights Reserved * Licensed Materials - Property of IBM
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

binDir=`dirname "$0"`
. "$binDir/setupCmdLine.sh"

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

"$WAS_HOME/lib/was-isadc/isadc/isadc.sh" -outputzip "$HOME/$WAS_CELL-$WAS_NODE-WAS-ISADC.zip" -collectorBase "$WAS_HOME/lib/was-isadc/was" "$@"

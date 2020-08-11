#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 2014
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# PMI-SNMP util to encrypt securityAttributes
# Usage: SNMP_EncryptSecurityAttributes.sh <Dmgr's agentConfig.xml absolute path>


binDir=`dirname $0`
. $binDir/setupCmdLine.sh


if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

MYCLASSPATH=$WAS_HOME/optionalLibraries/IBM/SNMPAgent/com.ibm.ws.pmi.snmpagent.jar:$WAS_HOME/plugins/com.ibm.ws.prereq.snmp.jar

if [ $# -eq 1 ]

then
  "${JAVA_EXE}" -cp $MYCLASSPATH com.ibm.ws.pmi.snmp.util.EncyptionAtDmgrUtil "$@"
else
  echo "Usage: SNMP_EncryptSecurityAttributes.sh <Dmgr's agentConfig.xml absolute path>"
  exit
fi

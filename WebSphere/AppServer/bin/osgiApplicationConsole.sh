#!/bin/sh

# Licensed Materials - Property of IBM
#
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 Copyright IBM Corp. 2010
#
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# Launch the osgiApplicationConsole to allow viewing of active OSGiFrameworks
#
# Launch Arguments
#
# -h The remote host to connect to. Defaults to localhost 
# -o The remote port to connect to.
# -u The userid to connect to the secured wsadmin system.
# -p The password to connect to the secured wsadmin system.
#

# set up the usage string.
usage="osgiApplicationConsole -h <hostname> -o <port> -u <userid> -p <password>"
# iterate over the properties setting the wsadmin values for the relevant property
while getopts :h:o:u:p: arguments
do
  case $arguments in
    # If we have -h then set the host value
    h) host="-host $OPTARG";;
    # if we have -o then set the port value 
    o) port="-port $OPTARG";;
    # If we have -u then set the user value
    u) user="-user $OPTARG";;
    # if we have -p then set the password value
    p) pwd="-password $OPTARG";;
    # All other options are invalid. Display error and usage.
    \?) echo "Invalid argument passed"
        echo "$usage";;
  esac
done

# get the current directory
binDir=`dirname $0`

. $binDir/setupCmdLine.sh
ariesDir="${WAS_HOME}/feature_packs/aries"
if [ ! -d ${ariesDir} ]
then
  ariesDir="${WAS_HOME}/plugins"
fi 

ariesOSGIAppDir=${ariesDir}/osgiappbundles/com.ibm.ws.osgi.applications

# Find the osgi jar that we need for the python script
#If the OSGi jar was not available in osgiappbundles look in WAS plugins
if [ -f ${ariesOSGIAppDir}/aries/org.eclipse.osgi*.jar ]
then
  osgiJar=`ls ${ariesOSGIAppDir}/aries/org.eclipse.osgi*.jar`
else
  osgiJar=`ls ${WAS_HOME}/plugins/org.eclipse.osgi*.jar`
fi

# Set the admin jar which contains all the messages for the script.
adminJar="${ariesOSGIAppDir}/com.ibm.ws.eba.admin.jar"

# Finally Call wsadmin passing in the python script and the osgi jar on the wsadmin classpath
${WAS_HOME}/bin/wsadmin.sh -lang jython -profile ${WAS_HOME}/scriptLibraries/osgi/osgiApplicationConsole.py -wsadmin_classpath ${osgiJar}:${adminJar} ${host} ${port} ${user} ${pwd}

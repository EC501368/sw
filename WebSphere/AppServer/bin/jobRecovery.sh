#!/bin/bash

# THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
# 5724-J34 (C) COPYRIGHT International Business Machines Corp., 2007
# All Rights Reserved * Licensed Materials - Property of IBM
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

#!echo "Usage: jobRecovery server_name [options]"
#!echo "       options:"
#!echo "       -profileName <profile>"
#!echo "       -username <authentication username>
#!echo "       -password <authentication password>

if [ $# -lt 1 ]
then
   echo
   echo "Usage: $0 <server> [options]"
   echo "      options:"
   echo "       -profileName <profile>"
   echo "       -username <authenticatin username>"
   echo "       -password <authentication password>"
   echo                  
   echo "Example: $0 server1 -profileName AppSrv01 -username wsadmin -password wspassword"
   echo
   exit 1
fi

WAS_SERVER=$1     
      
WAS_PROFILE_NAME=
WAS_USER_NAME=
WAS_PASSWORD=
NEXT_IS_PROFILE=0
NEXT_IS_USER=0
NEXT_IS_PASSWORD=0
      
for arg in "$@" ; do
    if [ $NEXT_IS_PROFILE -eq 1 ]; then
        WAS_PROFILE_NAME=$arg
        NEXT_IS_PROFILE=0
    elif [ $NEXT_IS_USER -eq 1 ]; then 
        WAS_USER_NAME=$arg
        NEXT_IS_USER=0
      elif [ $NEXT_IS_PASSWORD -eq 1 ]; then
          WAS_PASSWORD=$arg
          NEXT_IS_PASSWORD=0
    fi
            
    if [ "$arg" = "-profileName" ]; then
        NEXT_IS_PROFILE=1
    elif [ "$arg" = "-username" ]; then
        NEXT_IS_USER=1
      elif [ "$arg" = "-password" ]; then
          NEXT_IS_PASSWORD=1
    fi         
done
  

cd ..
installDir=`pwd`
  
if [ "$WAS_PROFILE_NAME" = "" ]; then 
  LOCATION=$installDir
else 
  LOCATION=$installDir/profiles/$WAS_PROFILE_NAME
fi  


if [ ! -d "$LOCATION" ];
then
  echo "Directory, $LOCATION", does not exist. 
  echo "Do not specify the -profileName option on the jobRecovery command if you are executing it from the profile bin directory."
  exit 1
fi
  

cd "$LOCATION"
if [ ! -d "$LOCATION/xdtemp" ];
then
   mkdir "$LOCATION/xdtemp"
fi

if [ $? -ne 0 ]; then
    exit ${retval}
fi

cd xdtemp
if [ ! -f xd.job.scheduler.dr.site.takeover ];
then
   touch xd.job.scheduler.dr.site.takeover
fi   

if [ $? -ne 0 ]; then
    echo "Could not create file, $LOCATION/xdtemp/xd.job.scheduler.dr.site.takeover."
    exit ${retval}
fi

cd ../bin

# Start the node agent
echo Starting the nodeagent...

./startNode.sh 

# Save the return value
retval=$?

# If the nodeagent didn't start, exit with the return code.

if [ ${retval} -ne 0 ]; then
    echo "The nodeagent could not be started. Job recovery failed. Check the server log for details." 
    exit ${retval}
fi

# Start the server running the scheduler to perform the disaster recovery
echo Starting server $WAS_SERVER...

./startServer.sh $WAS_SERVER

# Save the return value
retval=$?

# If the server didn't start, exit with the return code.

if [ ${retval} -ne 0 ]; then
    echo "The specified server $WAS_SERVER could not be started. Job recovery failed. Check the server log for details." 
    exit ${retval}
fi

# Stop the server  
echo Stopping server $WAS_SERVER...

if [ "$WAS_USER_NAME" = "" ]; then
   ./stopServer.sh $WAS_SERVER 
else 
   ./stopServer.sh $WAS_SERVER -username $WAS_USER_NAME -password $WAS_PASSWORD 
fi   

# Save the return value
retval=$?

if [ ${retval} -ne 0 ]; then
   echo "The specified server $WAS_SERVER could not be stopped. Check the server log for details."
fi   

# Stop the nodeagent
echo Stopping nodeagent...

if [ "$WAS_USER_NAME" = "" ]; then
   ./stopNode.sh
else
   ./stopNode.sh -username $WAS_USER_NAME -password $WAS_PASSWORD   
fi   

# Save the return value
retval=$?

if [ ${retval} -ne 0 ]; then
   echo "The nodeagent could not be stopped. Check the server log for details."
fi   

echo "Job recovery has been completed.  Check the server logs for any error messages"


exit 0



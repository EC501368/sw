#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
CUR_DIR=`pwd`

PROFILE_NAME_CHECK=$1
CHECK=yes
#PROFILE_NAME=$1

printUsage()
{
   echo "Usage: uteConfig [profileName] [-authorizeAllAuthenticated] || [-authorizeEveryone] || [-authorizeUser [username] [realmname]]";
   exit 1;
}

authorizeUser()
{
	AUTHUSERS_SCRIPT="$WAS_HOME"/util/Batch/setUserRoles.py
	$WSADMIN -conntype NONE -f $AUTHUSERS_SCRIPT -authorizeUser $1 $2
	rc=$?

	if [ $rc -ne 0 ]; then
	  echo Error occurred while running setUserRoles.py 
	  cd $CUR_DIR
	  exit 8
	fi
}

authorizeAll()
{
	AUTHUSERS_SCRIPT="$WAS_HOME"/util/Batch/setUserRoles.py
	$WSADMIN -conntype NONE -f $AUTHUSERS_SCRIPT -authorizeAllAuthenticated
	rc=$?

	if [ $rc -ne 0 ]; then
	  echo Error occurred while running setUserRoles.py 
	  cd $CUR_DIR
	  exit 8
	fi
}

authorizeEveryone()
{
	AUTHUSERS_SCRIPT="$WAS_HOME"/util/Batch/setUserRoles.py
	$WSADMIN -conntype NONE -f $AUTHUSERS_SCRIPT -authorizeEveryone
	rc=$?

	if [ $rc -ne 0 ]; then
	  echo Error occurred while running setUserRoles.py 
	  cd $CUR_DIR
	  exit 8
	fi
}

if [[ $PROFILE_NAME_CHECK == -* ]] ;
then
	CHECK=no
fi

if [ $CHECK == "yes" ]
then
	PROFILE_NAME=$1
else
	PROFILE_NAME=""
fi

_AUTHALL="no"
_AUTHUSER="no"
_AUTHEVERYONE="no"
_USEREXPECTED="no"
_USERNAME=""
_REALMEXPECTED="no"
_REALMNAME=""


BIN_DIR=`dirname "$0"`
. "$BIN_DIR/setupCmdLine.sh"

for arg in "$@" ; do

	if [[ $_USEREXPECTED == "yes" ]]; then
          _USERNAME=$arg
	  _USEREXPECTED="no"
	  _REALMEXPECTED="yes"
       elif [[ $_REALMEXPECTED == "yes" ]]; then
	 _REALMNAME=$arg
         _REALMEXPECTED="no"
       fi


	case $arg in
            -authorizeAllAuthenticated)
               if [ $_AUTHUSER == "yes" ]; then
				echo -authorizeAll, -authorizeEveryone and -authorizeUser are mutually exclusive arguments
				printUsage
			   fi
			   if [ $_AUTHEVERYONE == "yes" ]; then
				echo -authorizeAll, -authorizeEveryone and -authorizeUser are mutually exclusive arguments
				printUsage
			   fi
			   _AUTHALL="yes"
               ;;
			 -authorizeEveryone)
               if [ $_AUTHUSER == "yes" ]; then
				echo -authorizeAll, -authorizeEveryone and -authorizeUser are mutually exclusive arguments
				printUsage
			   fi
			   if [ $_AUTHALL == "yes" ]; then
				echo -authorizeAll, -authorizeEveryone and -authorizeUser are mutually exclusive arguments
				printUsage
			   fi
			   _AUTHEVERYONE="yes"
               ;;
			    -authorizeUser)
               	     	if [ $_AUTHEVERYONE == "yes" ]; then
				echo -authorizeAll, -authorizeEveryone and -authorizeUser are mutually exclusive arguments
				printUsage
			   fi
			   if [ $_AUTHALL == "yes" ]; then
				echo -authorizeAll, -authorizeEveryone and -authorizeUser are mutually exclusive arguments
				printUsage
			   fi
			   _AUTHUSER="yes"
			   _USEREXPECTED="yes"
               ;;
			   *)
		            if [[ $arg == -* ]]; then
				echo Unknown argument detected: $arg
	                        echo
                                printUsage
			    fi
				;;
		esac
	done



if [ $_AUTHUSER == "yes" ]; then
	if [[ -z $_USERNAME || -z $_REALMNAME ]]; then
		echo Error: Both a user and realm must be specified
               echo
                echo Example: uteConfig.sh AppSrv01 -authorizeUser wasadmin defaultWIMFileBasedRealm
               echo
               printUsage
	fi
fi


# Determine if the target WebSphere installation contains a profile at all
"$BIN_DIR"/manageprofiles.sh -listProfiles | cat >> $HOME/utetmp
grep '\[\]' $HOME/utetmp > /dev/null 2>&1
rc=$?
rm $HOME/utetmp

if [ $rc -eq 0 ]; then
  echo Error: Target WebSphere installation \($WAS_HOME\) does not contain a profile
  exit 8
fi

# Determine if the specified profile exists (if one was specified)
if [[ $PROFILE_NAME != "" ]]; then
  "$BIN_DIR"/manageprofiles.sh -getPath -profileName $PROFILE_NAME | cat >> $HOME/utetmp
   grep 'Cannot retrieve' $HOME/utetmp > /dev/null 2>&1
   rc=$?

   if [ $rc -eq 0 ]; then
     echo Profile $PROFILE_NAME does not exist
     rm $HOME/utetmp
     exit $rc
   fi

  PROFILE_PATH=`cat $HOME/utetmp`
  rm $HOME/utetmp
else
  PROFILE_PATH=$USER_INSTALL_ROOT
fi

# Determine if the scheduler is already configured on the target profile
grep 'LongRunningScheduler' $PROFILE_PATH/config/cells/$WAS_CELL/nodes/$WAS_NODE/serverindex.xml > /dev/null 2>&1
rc=$?

if [ $rc -eq 0 ]; then
  echo UTE already configured on profile
  exit 8
fi

# Determine if the target profile is the correct type (appserver)
grep "com.ibm.ws.profile.type=BASE" $PROFILE_PATH/properties/profileKey.metadata > /dev/null 2>&1
rc=$?

if [ $rc -ne 0 ]; then
  echo Error: Target profile must be an Application Server profile
  exit 8
fi

if [[ ! -e $PROFILE_PATH/gridDatabase ]]; then
  mkdir $PROFILE_PATH/gridDatabase
fi

cd $PROFILE_PATH/gridDatabase

. $PROFILE_PATH/bin/setupCmdLine.sh
WSADMIN=$PROFILE_PATH/bin/wsadmin.sh

"$JAVA_HOME"/bin/java \
   $JAVA_DEBUG \
   -Djava.ext.dirs=$WAS_HOME/derby/lib \
   -Dij.protocol=jdbc:derby: org.apache.derby.tools.ij \
"$WAS_HOME"/util/Batch/CreateLRSCHEDTablesDerby.ddl
rc=$?

if [ $rc -ne 0 ]; then
  echo Error occurred while running CreateLRSCHEDTablesDerby.ddl
  cd $CUR_DIR
  exit 8
fi

UTECONFIG_SCRIPT="$WAS_HOME"/util/Batch/deployGridSchedulerAndEndpoint.py
$WSADMIN -conntype NONE -f $UTECONFIG_SCRIPT
rc=$?

if [ $rc -ne 0 ]; then
  echo Error occurred while running deployGridSchedulerAndEndpoint.py 
  cd $CUR_DIR
  exit 8
fi

UTECONFIG_SCRIPT="$WAS_HOME"/util/Batch/setGridSchedulerTarget.py
$WSADMIN -conntype NONE -f $UTECONFIG_SCRIPT
rc=$?

if [ $rc -ne 0 ]; then
  echo Error occurred while running setGridSchedulerTarget.py
  cd $CUR_DIR
  exit 8
fi


UTECONFIG_SCRIPT="$WAS_HOME"/util/Batch/createBatchWorkManager.py
$WSADMIN -conntype NONE -f $UTECONFIG_SCRIPT
rc=$?

if [ $rc -ne 0 ]; then
  echo Error occurred while running createBatchWorkManager.py 
  cd $CUR_DIR
  exit 8
fi

UTECONFIG_SCRIPT="$WAS_HOME"/util/Batch/enableStartupService.py
$WSADMIN -conntype NONE -f $UTECONFIG_SCRIPT
rc=$?

if [ $rc -ne 0 ]; then
  echo Error occurred while running enableStartupService.py
  cd $CUR_DIR
  exit 8
fi

if [ $_AUTHALL == "yes" ]; then
	authorizeAll
elif [ $_AUTHUSER == "yes" ]; then
	authorizeUser $_USERNAME $_REALMNAME
elif [ $_AUTHEVERYONE == "yes" ]; then
	authorizeEveryone
fi

echo UTE configured successfully
cd $CUR_DIR

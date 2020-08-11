#!/bin/sh
#WASROOT=/opt/IBM/WebSphere/AppServer
WAS_HOME="/jennex/WebSphere/AppServer"

#START REPLACING ${NUMBER}
numberFile=${WAS_HOME}/properties/version/nif/config/linuxMenu/productShortCut2StartMenuBase.txt
echo $numberFile
exec 3<$numberFile
read -u3 num
num=${num#number=}
read -u3 user
user=${user#user=}
exec 3<&-

if [ $user == "" ]
then
  echo "Problem determining install location"
  exit 1
fi

startMenuLocation=$user/.config/menus/applications-merged

if [ ! -e ${startMenuLocation} ]
then
	mkdir -p ${startMenuLocation}
fi

if [ ! -w ${startMenuLocation} ]
then
  echo "You must have access to ${startMenuLocation} to run this program"
  exit 1
fi

if [ ${num} == "0" ]
then
  numString=
else
  numString=${num}
fi
if test -f ${startMenuLocation}/WebSphere${numString}.menu
then
  echo "A file by the name of WebSphere${numString}.menu already exists in ${startMenuLocation}"
  echo "Another instance of WebSphere Application Server must have been installed prior to completing this install."
else
  cp -f ${WAS_HOME}/properties/version/nif/config/linuxMenu/menus/WebSphere.menu ${startMenuLocation}/WebSphere${numString}.menu
fi
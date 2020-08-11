#!/bin/sh
#WASROOT=/opt/IBM/WebSphere/AppServer
WAS_HOME=${WASROOT}
linuxMenuDirectory=${WAS_HOME}/properties/version/nif/config/linuxMenu

numberFile=${linuxMenuDirectory}/productShortCut2StartMenuBase.txt
echo $numberFile
exec 3<$numberFile
read -u3 num
num=${num#number=}
read -u3 user
user=${user#user=}
exec 3<&-

#START REPLACING ${NUMBER}
startMenuLocation=$user/.config/menus/applications-merged

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


cmp -s ${startMenuLocation}/WebSphere${numString}.menu ${linuxMenuDirectory}/menus/WebSphere.menu

if [ $? -eq 0 ]
then
  rm -f ${startMenuLocation}/WebSphere${numString}.menu
else
  echo "The file, WebSphere${numString}.menu, in ${startMenuLocation} does not match the one in ${linuxMenuDirectory}/menus.  If another installation of WebSphere Application Server was performed, please leave this file here.  If this is a mistake, please manually delete the file in /etc/xdg/menus/applications-merged."
fi
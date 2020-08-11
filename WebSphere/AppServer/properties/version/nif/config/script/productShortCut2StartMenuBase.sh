#!/bin/sh
WAS_HOME=${WASROOT}
newUserString=user=$HOME
linuxMenuDirectory=${WAS_HOME}/properties/version/nif/config/linuxMenu
startMenuLocation=${newUserString#user=}/.config/menus/applications-merged

numberFile=${linuxMenuDirectory}/productShortCut2StartMenuBase.txt
if [ ! -f $numberFile ]
then
	echo "$numberFile does not exist"
	exit 1
fi
exec 3<$numberFile
read -u3 num
#num=${num#number=}
read -u3 user
#user=${user#user=}
echo $num, $user
exec 3<&-
declare -i counter=1
while [ -f $startMenuLocation/WebSphere$counter.menu ]
do
  counter=$counter+1
done
newNumString=number=$counter
#newUserString=user=$LOGNAME
#replaces number in productShortCut2StartMenuBase.txt
awk -v numb=$num -v newNumb=$newNumString '{gsub(numb,newNumb,$0);print > FILENAME}' $numberFile
awk -v user1=$user -v newUser1=$newUserString '{gsub(user1,newUser1,$0);print > FILENAME}' $numberFile

if [ $counter == 0 ]
then
  counterString=
  directoryString=
else
  counterString=$counter
  directoryString=" ($counter)"
fi

if [ -f ${linuxMenuDirectory}/applications/AdminConsole.desktop ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/applications/AdminConsole.desktop
fi
if [ -f ${linuxMenuDirectory}/applications/MigrationWizard.desktop ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/applications/MigrationWizard.desktop
fi
if [ -f ${linuxMenuDirectory}/applications/FirstSteps.desktop ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/applications/FirstSteps.desktop
fi
if [ -f ${linuxMenuDirectory}/applications/InfoCenter.desktop ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/applications/InfoCenter.desktop
fi
if [ -f ${linuxMenuDirectory}/applications/ProfileCreation.desktop ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/applications/ProfileCreation.desktop
fi
if [ -f ${linuxMenuDirectory}/applications/Samples.desktop ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/applications/Samples.desktop
fi
if [ -f ${linuxMenuDirectory}/applications/Support.desktop ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/applications/Support.desktop
fi
if [ -f ${linuxMenuDirectory}/applications/StartServer.desktop ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/applications/StartServer.desktop
fi
if [ -f ${linuxMenuDirectory}/applications/StopServer.desktop ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/applications/StopServer.desktop
fi
if [ -f ${linuxMenuDirectory}/applications/StartServerDmgr.desktop ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/applications/StartServerDmgr.desktop
fi
if [ -f ${linuxMenuDirectory}/applications/StopServerDmgr.desktop ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/applications/StopServerDmgr.desktop
fi
if [ -f ${linuxMenuDirectory}/applications/StartServerAdminAgent.desktop ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/applications/StartServerAdminAgent.desktop
fi
if [ -f ${linuxMenuDirectory}/applications/StopServerAdminAgent.desktop ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/applications/StopServerAdminAgent.desktop
fi

if [ -f ${linuxMenuDirectory}/directories/WebSphere.directory ]
then
awk -v numb="${directoryString}" '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/directories/WebSphere.directory
fi
if [ -f ${linuxMenuDirectory}/menus/WebSphere.menu ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/menus/WebSphere.menu
fi
if [ -f ${linuxMenuDirectory}/menus/Profiles.menu ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/menus/Profiles.menu
fi
if [ -f ${linuxMenuDirectory}/menus/ProfileName.menu ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/menus/ProfileName.menu
fi

if [ -f ${linuxMenuDirectory}/menus/ApplicationServer.menu ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/menus/ApplicationServer.menu
fi
if [ -f ${linuxMenuDirectory}/menus/ApplicationServerExpress.menu ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/menus/ApplicationServerExpress.menu
fi
if [ -f ${linuxMenuDirectory}/menus/ApplicationServerND.menu ]
then
awk -v numb=${counterString} '{gsub("\\${NUMBER}",numb,$0);print > FILENAME}' ${linuxMenuDirectory}/menus/ApplicationServerND.menu
fi

#FINISHED REPLACING ${NUMBER}
if [ -f ${linuxMenuDirectory}/menus/Profiles.menu ]
then
	mv -f ${linuxMenuDirectory}/menus/Profiles.menu ${WASROOT}/properties/Profiles.menu
else
	echo "${linuxMenuDirectory}/menus/Profiles.menu does not exist"
fi

#!/bin/sh
WAS_HOME="/jennex/WebSphere/AppServer"
profileName=AppSrv01
profilePath=/jennex/WebSphere/AppServer/profiles/AppSrv01
profileMenusFolder=${profilePath}/properties/linuxMenu/menus


#Reading the breadcrumb
while read firstLine 
do
shortcutArg=$firstLine
done < "${WAS_HOME}/properties/install/shortcuts/shortcuts.txt"

slashIndex=$(echo | awk '{print index("'"${shortcutArg}"'","/")}')
slashIndex=$(($slashIndex+1))

secondMenu=$(echo | awk '{print substr("'"${shortcutArg}"'","'"${slashIndex}"'")}')
slashIndex=$(($slashIndex-2))
firstMenu=$(echo | awk '{print substr("'"${shortcutArg}"'",0,"'"${slashIndex}"'")}')

profileMenu=/etc/xdg/menus/applications-merged/"${firstMenu}"_"${secondMenu}"_"${profileName}".menu
profileMenu=${profileMenu// /_}

#check if profileMenu already exists
if [ -f $profileMenu ]
then
  echo "The profile menu already exists."
  exit 1
else
  cp ${WAS_HOME}/properties/version/nif/config/linuxMenu/menus/ProfilesX.menu ${profilePath}/properties/linuxMenu/menus/ProfilesX.menu 

   awk -v appServerLevel="${secondMenu}" '{gsub("\\App_Server_Level",appServerLevel,$0);print > FILENAME}' ${profilePath}/properties/linuxMenu/menus/ProfilesX.menu

TheProfileMenuString="<!--MENU FOR PROFILE-->\n<Menu><Name>${profileName}Profile</Name><MergeFile>${profileMenusFolder}/${profileName}.menu</MergeFile></Menu>"
awk -v profile="${TheProfileMenuString}" '{sub("<!--MENU FOR PROFILE-->",profile,$0);print > FILENAME}' ${profilePath}/properties/linuxMenu/menus/ProfilesX.menu

#replacing $WAS_HOME and $PROFILENAME
awk -v profile="${profileName}" '{gsub("\\${PROFILENAME}",profile,$0);print > FILENAME}' ${profilePath}/properties/linuxMenu/menus/ProfilesX.menu
awk -v wasHome="${WAS_HOME}" '{gsub("\\${WAS_HOME}",wasHome,$0);print > FILENAME}' ${profilePath}/properties/linuxMenu/menus/ProfilesX.menu

#renaming the file and moving it to /etc/xdg/menus/applications-merged and /etc/xdg/menus/kde-applications-merged and $HOME/.config/menus/applications-merged
firstLevel=${firstMenu// /_}
secondLevel=${secondMenu// /_}
mv "${profilePath}/properties/linuxMenu/menus/ProfilesX.menu" "${profilePath}/properties/linuxMenu/menus/${firstLevel}_${secondLevel}_${profileName}.menu"
cp "${profilePath}/properties/linuxMenu/menus/${firstLevel}_${secondLevel}_${profileName}.menu" "/etc/xdg/menus/applications-merged/${firstLevel}_${secondLevel}_${profileName}.menu"
cp "${profilePath}/properties/linuxMenu/menus/${firstLevel}_${secondLevel}_${profileName}.menu" "/etc/xdg/menus/kde-applications-merged/${firstLevel}_${secondLevel}_${profileName}.menu"
cp "${profilePath}/properties/linuxMenu/menus/${firstLevel}_${secondLevel}_${profileName}.menu" "${HOME}/.config/menus/applications-merged/${firstLevel}_${secondLevel}_${profileName}.menu"
  exit 1
fi

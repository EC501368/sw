WAS_HOME=${WASROOT}
PROFILENAME=${INPUTPROFILENAME}
profilePath=${INPUTPROFILEPATH}

#if [ ! -w ${WAS_HOME}/properties/Profiles.menu ]
#then
#  echo "You must have write access to ${WAS_HOME}/properties/Profiles.menu to run this program"
#  exit 1
#fi

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

profileMenu=/etc/xdg/menus/applications-merged/"${firstMenu}"_"${secondMenu}"_"${PROFILENAME}".menu
profileMenuKde=/etc/xdg/menus/kde-applications-merged/"${firstMenu}"_"${secondMenu}"_"${PROFILENAME}".menu
profileMenuUserHome="${HOME}"/.config/menus/applications-merged/"${firstMenu}"_"${secondMenu}"_"${PROFILENAME}".menu
profileMenu=${profileMenu// /_}
profileMenuKde=${profileMenuKde// /_}
profileMenuUserHome=${profileMenuUserHome// /_}


rm $profileMenu $profileMenuKde $profileMenuUserHome


#TheProfileMenuString="<Menu><Name>${PROFILENAME}Profile</Name><MergeFile>${INPUTPROFILEPATH}/properties/linuxMenu/menus/${PROFILENAME}.menu</MergeFile></Menu>"
#awk -v profile="${TheProfileMenuString}" '{sub(profile,"",$0);print > FILENAME}' ${WAS_HOME}/properties/Profiles.menu
#awk 'NF > 0 {print > FILENAME}' ${WAS_HOME}/properties/Profiles.menu

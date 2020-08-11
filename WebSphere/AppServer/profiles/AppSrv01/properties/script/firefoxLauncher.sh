#!/bin/sh
#This script uses the assumption that the BROWSER var
#is used for defining which browser is the default
#browser. This is common as there is no definitive
#standard for defining the default browser between
#all the different unix/unix-based distributions.

WEBBROWSER=$BROWSER
URL=$1

if [ $WEBBROWSER ] 
then
	$WEBBROWSER $URL &
else	
	WEBBROWSER="firefox"
	FFNUM=`ps -A | grep -c firefox-bin`
	
	if [ $FFNUM -eq 0 ] 
	then
		$WEBBROWSER $URL &
	else
		$WEBBROWSER -remote "openUrl($URL, new-window)" &
	fi
fi

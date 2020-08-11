#!/bin/sh
CUR_DIR=`pwd`
cd `dirname ${0}`
.  /jennex/WebSphere/AppServer/profiles/AppSrv01/bin/setupCmdLine.sh
.  /jennex/WebSphere/AppServer/profiles/AppSrv01/firststeps/fbrowser.sh

/jennex/WebSphere/AppServer/java/jre/bin/java \
  -classpath /jennex/WebSphere/AppServer/lib/htmlshell.jar:/jennex/WebSphere/AppServer/plugins/com.ibm.ws.runtime.jar \
  com.ibm.ws.install.htmlshell.Launcher 2> /dev/null > /dev/null \
  --file /jennex/WebSphere/AppServer/profiles/AppSrv01/firststeps/firststeps \
  --width 653 \
  --height 600 \
  --resizable false \
  --icon /jennex/WebSphere/AppServer/profiles/AppSrv01/firststeps/ws16x16.gif \
  --profilepath /jennex/WebSphere/AppServer/profiles/AppSrv01 \
  --cellname jennexNode01Cell \
  --wasroot /jennex/WebSphere/AppServer \
  --FirstStepsDefaultBrowser $FirstStepsDefaultBrowser \
  --FirstStepsDefaultBrowserPath $FirstStepsDefaultBrowserPath
  
  cd ${CUR_DIR}

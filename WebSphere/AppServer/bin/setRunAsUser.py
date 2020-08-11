# This program may be used, executed, copied, modified and distributed
# without royalty for the purpose of developing, using, marketing, or distribution

#-------------------------------------------------------
# setRunAsUser.py:
#     This script will add/modify a runAsUser attribute
#     to ProcessExecution of a server.
#     This script takes 3 arguments, nodename,
#     servername, and userID
#
#     Usage in local mode:
#     wsadmin -conntype NONE -lang jython -f setRunAsUser.py <nodename> <servername> <userID>
#
#     Usage on a server:
#     wsadmin -lang jython -f setRunAsUser.py <nodename> <servername> <userID>
#-------------------------------------------------------

import sys
import java

nl = java.lang.System.getProperty('line.separator')

if len(sys.argv) < 3:
   print "This script requires 3 parameters"
   print "Usage in local mode: wsadmin -conntype NONE -lang jython -f setRunAsUser.py <nodename> <servername> <userID>"
   print "Usage in jmx mode: wsadmin -lang jython -f setRunAsUser.py <nodename> <servername> <userID>"
else:
   nodeName = sys.argv[0]
   serverName = sys.argv[1]
   userID = sys.argv[2]

# define a function to add/modify runAsUser attribute to processExecution
def setRunAsUserAttribute(): 
   global nl
   global nodeName, serverName, userID
   try:
      # get a server id
      serverID = AdminConfig.getid("\"/Node:"+nodeName+"/Server:"+serverName+"/\"")
      print "Server id receiving runAsUser modification is " + serverID
      # get server JavaProcessDef
      javaPDefs = AdminConfig.list('JavaProcessDef', serverID).split(nl)
      for javaPDef in javaPDefs:
         # get the ProcessExecution
         pExe = AdminConfig.showAttribute(javaPDef, 'execution') 
         # set runAsUser to <userID>
         AdminConfig.modify(pExe, [['runAsUser', userID]])
         AdminConfig.save()
         print "Setting up processExecution " + pExe + " runAsUser as " + userID
   except:
      print "runAsUser setup threw an exception."
      print "Exception is ", sys.exc_type, sys.exc_value 


# call the function
setRunAsUserAttribute()


#!/bin/sh
#
#THIS PRODUCT CONTAINS LICENSED MATERIALS OF IBM
#
#5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 2013
#
#The source code for this program is not published or otherwise divested
#of its trade secrets, irrespective of what has been deposited with the
#U.S. Copyright Office.
#
# ----------------------------------------------------------------------------
# Upgrade the SIBus DB schema from  lower version to v8.5 or higher
#
# Usage: sibDBUpgrade.sh -runUpgrade true or false  
#                  -dbUser db_user  
#                  -dbSchema db_schema_name -dbType db_type                  " 
#		   [-dbServerName db_server_name ]
#                  [-dbName db_name]  
#                  [-dbPassword db_password]  
#                  [-dbNode db_node_name]   
#		   [-oracleHome oracle_home]
#                  [-scriptDir gen_script_dir] 
#           	   [-permanent <number of permanent tables>]                
#           	   [-temporary <number of temporary tables>]                 
#
# Where:
#   -runUpgrade true or false    		- Required, Specify true to run the upgrade.
#                    		   	       		    Specify false to generate ddl scripts only. 
#   -dbUser db_user               		- Required, UserID for Database.
#   -dbSchema db_schema_name     		- Required, Schema name where particular ME associated with it, in the case of Oracle and Informix mention db_schema_user 
#   -dbType db_type              		- Required, Supported Database types are
#					     		    DB2, Derby, Oracle, SqlServer, Sybase OR Informix
#   -dbName db_name              		- Optional, Database name if runUpgrade is true.
#
#   -dbPassword db_password      		- Optional, Password. DB2 will prompt if not specified.
#   -dbNode db_node_name         		- Optional, Database node name. This is required 
#                                            		    if the current machine has db2 client.
#   -dbServerName db_server_name 		- Optional, Database server name. This is required if the upgrade is for SqlServer or Sybase Database.   
#   					     	
#   -oracleHome oracle_home      		- Optional, Path to Oracle Home if db_type=Oracle 
#   -scriptDir gen_script_dir     		- Optional, Directory to generate the DDL scripts.   
#                    			     		    If not specified, the scripts will be generated in 
#                    			     		    <current_dir>/SIBusDBUpgrade
#   -permanent <number of permanent tables>   	- Optional, Specify Number >0             
#   -temporary <number of temporary tables>   	- Optional, Specify Number >0             
# Note:- No execution in the case of Databases like DB2 on z/OS, Informix, SqlServer, Derby - Only DDL statements getting generated
#
#   Example 1:                                                          
#  sibDBUpgrade.sh -runUpgrade false -dbUser db2inst1  -dbSchema SIBusMESchema -dbType DB2
#  
#   Example 2:                                                          
#  sibDBUpgrade.sh -runUpgrade true -dbName SIBus -dbUser db2inst1 -dbSchema SIBusMESchema -dbType DB2
#  
#   Example 3(for z/OS, Informix,  Derby, SqlServer - -runUpgrade must false, no execution of scripts): 
#  sibDBUpgrade.sh -runUpgrade false -dbName SIBus -dbUser db2inst1 -dbSchema SIBusMESchema -dbType DB2
#  
#
# Return Codes:  0 for success, 1 for fail, 2 for no upgrade
# --------------------------------------------------------------------------

generate_ddl() {
  echo "-----------------------------------------------------------------" >> "$DDL_FILE"
  echo "-- Licensed Materials - Property of IBM" >> "$DDL_FILE"
  echo "-- (C) Copyright IBM Corp.  2012.  ALL RIGHTS RESERVED" >> "$DDL_FILE"
  echo "-- 5724-I63, 5724-H88, 5655-N02, 5733-W70" >> "$DDL_FILE"
  echo "-- US Government Users Licensed Rights - Use, duplication, or disclosure" >> "$DDL_FILE"
  echo "-- licensed by GSA ADP Schedule Contract with IBM Corp." >> "$DDL_FILE"
  echo "-----------------------------------------------------------------" >> "$DDL_FILE"
  echo "-----------------------------------------------------------------" >> "$DDL_FILE"
  echo "-- DB script that migrates a lower version of  SIBus schema to" >> "$DDL_FILE"
  echo "-- a 8.5.0 schema or higher." >> "$DDL_FILE"
  echo "--" >> "$DDL_FILE"
  
  echo "--" >> "$DDL_FILE"
  
  echo "--" >> "$DDL_FILE"
  echo "-- A full database backup must be taken PRIOR to executing" >> "$DDL_FILE"
  echo "-- this script" >> "$DDL_FILE"
  echo "-----------------------------------------------------------------" >> "$DDL_FILE"
  echo "-- set current schema = $DB_USER@" >> "$DDL_FILE"
  echo "" >> "$DDL_FILE"
  echo "-----------------------------------------------------------------" >> "$DDL_FILE"
  echo "-- now we can safely begin the upgrade processing" >> "$DDL_FILE"
  echo "-----------------------------------------------------------------" >> "$DDL_FILE"
  echo "" >> "$DDL_FILE"
  
  echo "-- Altering SIBOWNER table" >> "$DDL_FILE"

  if  [ "$DB_TYPE" = "Derby" ] ; then
	echo -- Process This script in the ij command line processor. >> "$DDL_FILE"
	echo -- Example:  >> "$DDL_FILE"
	echo -- java -Djava.ext.dirs=Opt/WebSPhere/AppServer/derby/lib -Dij.protocol=jdbc:derby: org.apache.derby.tools.ij upgrade_SIBus_db.db  >> "$DDL_FILE"
	echo >> "$DDL_FILE"
	echo "CONNECT 'jdbc:derby:$DB_NAME;create=false';" >> "$DDL_FILE"
	echo >> "$DDL_FILE"
	echo "ALTER TABLE $DB_SCHEMA.SIBOWNER ADD ME_LUTS TIMESTAMP;" >>  "$DDL_FILE"
	echo "" >> "$DDL_FILE"
	echo "ALTER TABLE $DB_SCHEMA.SIBOWNER ADD ME_INFO VARCHAR(254);" >>  "$DDL_FILE"
	echo "" >> "$DDL_FILE"
	echo "ALTER TABLE $DB_SCHEMA.SIBOWNER ADD ME_STATUS VARCHAR(16);" >>  "$DDL_FILE"
	echo "" >> "$DDL_FILE"
  fi  
  if [ "$DB_TYPE" = "DB2"  ]  ; then
  	echo "ALTER TABLE $DB_SCHEMA.SIBOWNER ADD ME_LUTS TIMESTAMP;" >>  "$DDL_FILE"
	echo "" >> "$DDL_FILE"
	echo "ALTER TABLE $DB_SCHEMA.SIBOWNER ADD ME_INFO VARCHAR(254);" >>  "$DDL_FILE"
	echo "" >> "$DDL_FILE"
	echo "ALTER TABLE $DB_SCHEMA.SIBOWNER ADD ME_STATUS VARCHAR(16);" >>  "$DDL_FILE"
	echo "" >> "$DDL_FILE"
  elif [ "$DB_TYPE" = "Oracle" ]; then
	echo "ALTER TABLE $DB_SCHEMA.SIBOWNER ADD (ME_LUTS TIMESTAMP, ME_INFO VARCHAR(254), ME_STATUS VARCHAR(16));" >>  "$DDL_FILE"
	echo "" >> "$DDL_FILE"
  elif [ "$DB_TYPE" = "Informix" ]; then
	echo "ALTER TABLE $DB_SCHEMA.SIBOWNER ADD ME_LUTS DATETIME YEAR TO FRACTION(5), ME_INFO VARCHAR(254), ME_STATUS VARCHAR(16) " >>  "$DDL_FILE"
	echo "go" >> "$DDL_FILE"
	echo "" >> "$DDL_FILE"
  elif [ "$DB_TYPE" = "SqlServer" ]; then
	echo "ALTER TABLE $DB_SCHEMA.SIBOWNER ADD ME_LUTS DATETIME, ME_INFO VARCHAR(254), ME_STATUS VARCHAR(16) " >>  "$DDL_FILE"
	echo "go" >> "$DDL_FILE"
	echo "" >> "$DDL_FILE"
  elif [ "$DB_TYPE" = "Sybase" ]; then
	echo "ALTER TABLE $DB_SCHEMA.SIBOWNER ADD ME_LUTS DATETIME, ME_INFO VARCHAR(254), ME_STATUS VARCHAR(16) " >>  "$DDL_FILE"
	echo "go" >> "$DDL_FILE"
	echo "" >> "$DDL_FILE"
  
  fi

  echo "" >> "$DDL_FILE"

  echo "-- Altering SIB00X tables" >> "$DDL_FILE"

 I=0
 TOTAL_COUNT=$((TEMP_TABLE+PERM_TABLE+STREAM_TABLE))
  if [ "$DB_TYPE" = "DB2"  ] || [ "$DB_TYPE" = "Derby" ] || [ "$DB_TYPE" = "Oracle" ] ; then
   while [ $I -le $TOTAL_COUNT ] 
	 do
		if [ $I -gt 9 ] ; then
			echo "ALTER TABLE $DB_SCHEMA.SIB0$I ADD REDELIVERED_COUNT  INTEGER; " >>  "$DDL_FILE"
			echo "" >> "$DDL_FILE"
		else
			echo "ALTER TABLE $DB_SCHEMA.SIB00$I ADD REDELIVERED_COUNT  INTEGER; " >>  "$DDL_FILE"
			echo "" >> "$DDL_FILE"
		fi
        I=`expr $I+1` 
	 done 
  	 echo "COMMIT;" >> "$DDL_FILE"
  else
    while [ $I -le $TOTAL_COUNT ] 
	 do
		if [ $I -gt 9 ] ; then
			echo "ALTER TABLE $DB_SCHEMA.SIB0$I ADD REDELIVERED_COUNT  INT " >>  "$DDL_FILE"
			echo "go" >> "$DDL_FILE"
			echo "" >> "$DDL_FILE"
		else
			echo "ALTER TABLE $DB_SCHEMA.SIB00$I ADD REDELIVERED_COUNT  INT " >>  "$DDL_FILE"
			echo "go" >> "$DDL_FILE"
			echo "" >> "$DDL_FILE"
		fi
        I=`expr $I+1` 
	 done 
	 echo "COMMIT" >> "$DDL_FILE"
	 echo "go" >> "$DDL_FILE"

  fi
  

  echo "" >> "$DDL_FILE"


  
	
}



# Licensed Materials - Property of IBM
# (C) Copyright IBM Corp.  2012.  ALL RIGHTS RESERVED 
# 5724-I63, 5724-H88, 5655-N02, 5733-W70
# US Government Users Licensed Rights - Use, duplication, or disclosure
# licensed by GSA ADP Schedule Contract with IBM Corp.

#--------------------------------------------------------------------------

attach_db() {

   if [ "$DB_NODE" != "" ]; then                                
      #Attach to the remote server                              
      echo "db2 ATTACH TO $DB_NODE USER $DB_USER USING xxxxx"   
      db2 ATTACH TO $DB_NODE USER $DB_USER $USING               
                                                             
      RC=$?                                                     
      if [ $RC -eq 0 ] ; then                                   
        IS_ATTACHED=1                                          
      else                                                      
        exit 1;                                                
      fi                                                        
   fi                                                           
}

connect_db() {

  if [ $IS_CONNECTED -eq 0 ]; then

     #Connect to the database specifying the id and the password      
     echo "db2 connect to $DB_NAME user $DB_USER using xxxxx"         
     db2 connect to $DB_NAME user $DB_USER $USING                     
     RC=$?                                                            

     if [ $RC -eq 0 ] ; then                                          
        IS_CONNECTED=1                                                
     else                                                             
        exit 1;                                                       
     fi                                                               
  fi
}

disconnect_db() {

   #If connected then disconnect
   if [ $IS_CONNECTED -eq 1 ] ; then
      echo "db2 connect reset"
      db2 connect reset
      IS_CONNECTED=0
   fi

   #If a client install, detach from the remote server
   if [ $IS_ATTACHED -eq 1 ] ; then
      echo "db2 detach"
      db2 detach
      IS_ATTACHED=0
   fi
}

run_upgrade_DB2() {

  
  #eval ". ~$DB_USER/sqllib/db2profile"

  USING="USING $DB_PASSWORD"
  if [ "$DB_PASSWORD" = "" ]; then
     USING=""
  fi

  attach_db
  connect_db

  
  echo "Running the SIBus DB2 database schema upgrade."
  echo "db2 -t -f $DDL_FILE -s +c"
  db2 -t -f "$DDL_FILE" -s +c
  RC=$?

  # Suppress some warnings
  if [ $RC -eq 3 ] ; then
     RC=0
  fi
  
  

  

  disconnect_db 

}

run_upgrade_Oracle() {

echo "sqlplus xxxxxx @$DDL_FILE"
sqlplus -S /nolog <<EOF
WHENEVER SQLERROR EXIT_FAILURE
connect $CONNECT_STRING
@$DDL_FILE
quit  
EOF
RC=$? 
            

}



run_upgrade_Derby() {

echo " $DDL_FILE "
chmod 777 $DDL_FILE
 echo " Upgrading happens by running Manually " 
# quit  
# EOF
RC=$? 
            

}

run_upgrade_SYBASE() {

echo "isql -S $SERVER_NAME -D $DB_NAME  -U $DB_USER -P xxxxxx -i $DDL_FILE -o   $FINDSTR_OUTPUT_TXT"
isql -S $SERVER_NAME -D $DB_NAME  -U $DB_USER -P $DB_PASSWORD -i $DDL_FILE -o   $FINDSTR_OUTPUT_TXT
# quit  
# EOF
RC=$? 
            

}


is_dbClient_available() {
OS_NAME=`uname`
  if [ "$OS_NAME" = "OS/390" ] ; then
	echo "-runUpgrade true - not supported in z/OS environment"
	exit 1
  else
  	if [ "$DB_TYPE" = "DB2" ] ; then
  		which db2
  	elif [ "$DB_TYPE" = "Oracle" ]; then
  		which sqlplus
  	elif [ "$DB_TYPE" = "Sybase" ]; then
	  	which isql
  	fi
  	RC=$?                                                     
      	if [ $RC -eq 1 ] ; then
  		echo "For -runUpgrade true - Check whether appropriate database client libraries available in PATH "
		exit 1
	fi
  fi
	
}


generate_and_run_script() {

  if [ ! -d $SCRIPT_DIR ] ; then 
     echo "Directory $SCRIPT_DIR not found."
     exit 1
  fi

 

  # Create DB2 dir if not exist
  if [ ! -d $DB_UPGRADE_DIR ]; then
      mkdir $DB_UPGRADE_DIR
  fi

  if [ -f $DDL_FILE ]; then
     rm -f $DDL_FILE
  fi

  

  echo "Generating the SIBus DB schema upgrade scripts to directory $SCRIPT_DIR"

  generate_ddl
  

  if [ "$RUN_UPGRADE" = "true" ]; then
  
  
	
	if [ "$DB_TYPE" = "DB2" ] ; then
	     is_dbClient_available
	     run_upgrade_DB2
	elif [ "$DB_TYPE" = "Oracle" ]; then
	   is_dbClient_available
           run_upgrade_Oracle 
	elif [ "$DB_TYPE" = "Sybase" ]; then
	   is_dbClient_available
           run_upgrade_SYBASE 
	elif [ "$DB_TYPE" = "Derby" ]; then
           run_upgrade_Derby 
	fi
	
	

	if [ "$DB_TYPE" != "Informix" ] ||  [ "$DB_TYPE" != "SqlServer" ] ||  [ "$DB_TYPE" != "Derby" ]; then
	
     if [ $RC -eq 0 ] ; then
        echo "The SIBus DB schema upgrade completed successfully(see findstr_output.txt for any error)."
     else
        echo "Errors occurred while upgrading the SIBus  database schema."
     fi
	 
	fi

     exit $RC

  else
    exit 0;
  fi
}


   SCRIPT_DIR=`pwd`

# Initialize variables
RC=0
RUN_UPGRADE=""
DB_NAME=""
DB_SCHEMA=""
DB_TYPE=""
DB_USER=""
DB_PASSWORD=""
DB_NODE=""
SERVER_NAME=""
IS_ATTACHED=0
IS_CONNECTED=0
NEED_UPGRADE=0
# for oracle
ORACLE_ROLE=sysdba
#for accepting number of temporary and permanent table  @run time
TEMP_TABLE=1
PERM_TABLE=1
STREAM_TABLE=1

print_usage() {
  echo "Usage: sibDBUpgrade.sh -runUpgrade true or false                "
  echo "           -dbUser db_user                                           "
  echo "           -dbSchema db_schema_name -dbType db_type                  " 
  echo "           [-dbServerName db_server_name ]					                  " 
  echo "           [-dbNode db_node_name] [-dbName db_name]                  "
  echo "           [-dbPassword db_password]                                 " 
  echo "           [-oracleHome oracle_home]								 "	
  echo "           [-scriptDir gen_script_dir]                               "
  echo "           [-permanent <number of permanent tables>]                "
  echo "           [-temporary <number of temporary tables>]                 "
  echo "" 
  echo "  Where:                                                             "
  echo "   -runUpgrade true or false    		- Required, Specify true to run the upgrade.                 "
  echo "                    			    		    Specify false to generate ddl scripts only.      " 
  echo "   -dbUser db_user        			- Required, UserID for Database.                             "
  echo "   -dbSchema db_schema_name 			- Required, Schema name where particular ME associated with it, in the case of Oracle, Informix mention db_schema_user"
  echo "   -dbType db_type        			- Required, Supported Database types are "
  echo "                                            		    DB2, Derby, Oracle, SqlServer, Sybase OR Informix 						     "
  echo "   -dbName db_name        			- Optional, Database name if -runUpgrade is true.   "
  echo "   -dbNode db_node_name   			- Optional, Database node name. This is required    "
  echo "                    			    		    if the current machine has a db2 client.          "
  echo "   -dbServerName db_server_name 		- Optional, Database server name. This is required    "
  echo "                                            		    if the upgrade is for Sybase or SqlServer database.          "
  echo "   -dbPassword db_password    			- Optional, DB2 will prompt if not specified.      "
  echo "   -oracleHome oracle_home   			- Optional, Path to Oracle Home if db_type=Oracle             "
  echo "   -scriptDir gen_script_dir 			- Optional, Directory to generate the DDL scripts.  "
  echo "                                  	    		    If not specified, the scripts will be generated in "
  echo "                    		            		    <current_dir>\SIBusDBUpgrade            "
  echo "   -permanent <number of permanent tables>   	- Optional, Specify Number >0             "
  echo "   -temporary <number of temporary tables>   	- Optional, Specify Number >0             "
  echo ""
  echo " Example 1:                                                          "
  echo "   sibDBUpgrade.sh -runUpgrade false -dbUser db2inst1  -dbSchema SIBusMESchema -dbType DB2"
  echo ""
  echo " Example 2:                                                          "
  echo "   sibDBUpgrade.sh -runUpgrade true -dbName SIBus -dbUser db2inst1 -dbSchema SIBusMESchema -dbType DB2"
  echo ""
  echo " Example 3(for z/OS, Informix, SqlServer - -runUpgrade must false, no execution of scripts): "
  echo "   sibDBUpgrade.sh -runUpgrade false -dbName SIBus -dbUser db2inst1 -dbSchema SIBusMESchema -dbType DB2"
  echo ""

}

if [ "$1" = "" ]; then
  print_usage
  exit 0
fi

# Get inputs
while [ -n "$1" ]; do

   case $1 in
      -runUpgrade)

         RUN_UPGRADE=$2

         if [ "$RUN_UPGRADE" = "" ] ; then
            print_usage
            echo "A value is required for parameter -runUpgrade"
            exit 1
         fi
         
         if [ "$2" != "true" ] && [ "$2" != "false" ]; then
            print_usage
            echo "Invalid value $2 for parameter -runUpgrade"
            exit 1
         fi

         shift;;

      -dbName)
         DB_NAME=$2
         shift;;

	-dbSchema)
         DB_SCHEMA=$2
	    
	   if [ "$DB_SCHEMA" = "" ] ; then
            print_usage
            echo "A value is required for parameter -dbSchema"
            exit 1
         fi

         shift;;

	-dbType)
	
	   DB_TYPE=$2

	   if [ "$DB_TYPE" = "" ] ; then
            print_usage
            echo "A value is required for parameter -dbType"
            exit 1
         fi


         
         shift;;

      -dbNode)
         if [ "$2" != "" ]; then
            DB_NODE=$2
         fi
         shift;;
		 
	 -dbServerName)
         if [ "$2" != "" ]; then
            SERVER_NAME=$2
         fi
         shift;;

      -dbUser)   
         DB_USER=$2
         shift;;

      -dbPassword)
         if [ "$2" != "" ]; then
            DB_PASSWORD=$2
         fi
         shift;;

      -scriptDir)
         if [ "$2" != "" ]; then
            SCRIPT_DIR=$2
         fi
         shift;;

      -oracleHome)
         if [ "$2" != "" ]; then
	    ORACLE_HOME=$2
	 fi
         shift;;

      -permanent)
	
	 if [ "$2" -le 0 ] ; then
            print_usage
            echo "Invalid value $2 for parameter -permanent"
            exit 1
         else
            PERM_TABLE=$2
         fi
         shift;;

	       
      -temporary)
         
         if [ "$2" -le 0 ] ; then
	    print_usage
	    echo "Invalid value $2 for parameter -temporary"
	    exit 1
         else
            TEMP_TABLE=$2
         fi
	 shift;;
      *) print_usage 
         echo "Invalid parameter $1"
         exit 1

   esac
   shift;
done

# Set variables

DB_UPGRADE_DIR=$SCRIPT_DIR/SIBusDBUpgrade
FINDSTR_OUTPUT_TXT=$DB_UPGRADE_DIR/findstr_output.txt
DDL_FILE=$DB_UPGRADE_DIR/upgrade_SIBus_db.db

# for Oracle database
if [ "$DB_TYPE" = "Oracle" ] ; then
   CONNECT_STRING="$DB_USER/$DB_PASSWORD@$DB_NAME as $ORACLE_ROLE"
	if [ "$ORACLE_HOME" = "" ]; then
   		print_usage
   		echo "A value for parameter -oracleHome is required"
   		exit 1
	fi

fi


if [ "$DB_USER" = "" ]; then
   print_usage
   echo "A value for parameter -dbUser is required"
   exit 1
fi

if [ "$RUN_UPGRADE" = "" ]; then
   print_usage
   echo "A value for parameter -runUpgrade is required"
   exit 1
fi

if [ "$RUN_UPGRADE" = "false" ]; then
   # Go directly to script generation
   generate_and_run_script
fi

if [ "$RUN_UPGRADE" = "true" ]; then
	if [ "$DB_TYPE" = "SqlServer" ] || [ "$DB_TYPE" = "Sybase" ] ; then
		if [ "$SERVER_NAME" = "" ] ; then
			print_usage
			echo "A value for parameter -dbServerName is required"
			exit 1
		fi
	fi
fi

if [ "$DB_NAME" = "" ]; then
   print_usage
   echo "A value for parameter -dbName is required"
   exit 1
fi

if [ "$DB_TYPE" = "" ]; then
   print_usage
   echo "A value for parameter -dbType is required"
   exit 1
fi

if [ "$DB_SCHEMA" = "" ]; then
   print_usage
   echo "A value for parameter -dbSchema is required"
   exit 1
fi

generate_and_run_script


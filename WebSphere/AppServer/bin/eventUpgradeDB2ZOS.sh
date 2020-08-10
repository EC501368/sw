#!/bin/sh
#
#THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
#
#5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 2005
#
 #The source code for this program is not published or otherwise divested
#of its trade secrets, irrespective of what has been deposited with the
#U.S. Copyright Office.
#
# ----------------------------------------------------------------------------
# Upgrade the Event Service DB2 z/OS database schema from v5.x to v6.1
#
# Usage: eventUpgradeDB2ZOS -runUpgrade true_or_false  \ 
#                  -dbUser dbUser \ 
#                  [-dbName db_name] \ 
#                  [-dbPassword db_password] \  
#                  [-dbNode db_node_name]  \ 
#                  [-scriptDir gen_scriptDir] \ 
#                  [-eventDBName event_db_name] \ 
#                  [-catalogDBName event_cat_db_name] \ 
#                  [-storageGroup storage_group_name] \ 
#                  [-bufferPool4K name_4K_buffer_pool] \ 
#                  [-bufferPool8K name_8K_buffer_pool] \ 
#                  [-bufferPool16K name_16K_buffer_pool] \ 
#                  [-dbDiskSizeInMB db_disk_size_in_MB]  
#
# Where:
#   true_or_false  - Specify true to run the upgrade.
#                    Specify false to generate ddl scripts only.#                    On native OS/390, this parameter will always be#                    set to false which is generate only. User must#                    use SPUFI to run the generated DDL script.#                    Specify false to generate ddl scripts only. 
#   db_user        - Required db2 userid.
#   db_name        - Required database name if runUpgrade is true.
#   db_password    - Optional password. DB2 will prompt if not specified.
#   db_node_name   - Optional database node name. This is required 
#                    if the current machine is a db2 client.
#   gen_script_dir - Optional directory to generate the DDL scripts.   
#                    If not specified, the scripts will be generated in 
#                    <current_dir>/eventDBUpgrade/DB2ZOS 
#   eventDBName    - Optional event database group name. Default to event 
#   catalogDBName  - Optional event catalog database group name. 
#                    Default to eventcat. 
#   storage_group_name   - Optional storage group name. Default to sysdeflt.
#   name_4K_buffer_pool  - Optional 4K buffer pool name. Default to BP9.
#   name_8K_buffer_pool  - Optional 8K buffer pool name. Default to BP8K9.
#   name_16K_buffer_pool - Optional 16K buffer pool name. Default to BP16K9.
#   db_disk_size_in_MB   - Optional size of database. Default to 100.
#
#  Example 1:
#     eventUpgradeDB2ZOS -runUpgrade false -dbUser db2inst1
#
#  Example 2: 
#     eventUpgradeDB2ZOS -runUpgrade true -dbName event -dbUser db2inst1 
#
# Return Codes:  0 for success, 1 for fail, 2 for no upgrade
# --------------------------------------------------------------------------


generate_metadata() {

  if [ -f $METADATA_FILE ] ; then
    rm -f $METADATA_FILE
  fi

  echo "-----------------------------------------------------------------" >> "$METADATA_FILE"
  echo "-- Licensed Materials - Property of IBM" >> "$METADATA_FILE"
  echo "-- (C) Copyright IBM Corp. 2004, 2010.  ALL RIGHTS RESERVED" >> "$METADATA_FILE"
  echo "-- 5724-I63, 5724-H88, 5655-N02, 5733-W70" >> "$METADATA_FILE"
  echo "-- US Government Users Restricted Rights - Use, duplication, or disclosure" >> "$METADATA_FILE"
  echo "-- restricted by GSA ADP Schedule Contract with IBM Corp." >> "$METADATA_FILE"
  echo "-----------------------------------------------------------------" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "-----------------------------------------------------------------" >> "$METADATA_FILE"
  echo "-- DB2 script that populates the cei_t_cbe_map table, which maps" >> "$METADATA_FILE"
  echo "-- CBE elements and attributes to tables and columns. It also" >> "$METADATA_FILE"
  echo "-- populates the cei_t_properties table, which contains runtime" >> "$METADATA_FILE"
  echo "-- properties." >> "$METADATA_FILE"
  echo "-----------------------------------------------------------------" >> "$METADATA_FILE"
  echo "set current schema = $DB_USER;" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "DELETE FROM cei_t_cbe_map WHERE cbe_version = '1.0.1';" >> "$METADATA_FILE"
  echo "COMMIT;" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "DELETE FROM cei_t_properties WHERE property_name IN" >> "$METADATA_FILE"
  echo "('CbeMajorVersion', 'CbeMinorVersion', 'CbePtfLevel'," >> "$METADATA_FILE"
  echo "'SchemaMajorVersion'," >> "$METADATA_FILE"
  echo "'SchemaMinorVersion', 'SchemaPtfLevel'," >> "$METADATA_FILE"
  echo "'CurrentBucketNumber', 'NumberOfBuckets');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "COMMIT;" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--base event table" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','global_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@globalInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','version','CommonBaseEvent/@version');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','extension_name'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@extensionName');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map(cbe_version,table_name,column_name," >> "$METADATA_FILE"
  echo "element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','local_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@localInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES ('1.0.1','cei_t_event','creation_time'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@creationTime');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES ('1.0.1','cei_t_event','creation_time_utc','dateTimeAsLong');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','severity','CommonBaseEvent/@severity');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','priority','CommonBaseEvent/@priority');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','sequence_number'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@sequenceNumber');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES ('1.0.1','cei_t_event','repeat_count'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@repeatCount');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','elapsed_time'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@elapsedTime');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','msg','CommonBaseEvent/@msg');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','msg_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/msgDataElement/msgId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','msg_id_type'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/msgDataElement/msgIdType');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','msg_catalog_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/msgDataElement/msgCatalogId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','msg_catalog_type'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/msgDataElement/msgCatalogType');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','msg_catalog'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/msgDataElement/msgCatalog');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','msg_locale'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/msgDataElement/@msgLocale');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','has_context'," >> "$METADATA_FILE"
  echo "'boolean(CommonBaseEvent/contextDataElements)');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','has_msg_tokens'," >> "$METADATA_FILE"
  echo "'boolean(CommonBaseEvent/msgDataElement/msgCatalogTokens)');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','has_extended_elem'," >> "$METADATA_FILE"
  echo "'boolean(CommonBaseEvent/extendedDataElements)');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','has_any_element','hasAnyElement');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','has_event_assoc'," >> "$METADATA_FILE"
  echo "'boolean(CommonBaseEvent/associatedEvents)');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--context table" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_context','global_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@globalInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_context','context_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/contextDataElements/contextId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_context','context_name'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/contextDataElements/@name');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_context','context_position','position');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_context','context_type'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/contextDataElements/@type');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_context','context_value'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/contextDataElements/contextValue');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--Message catalog token table" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_msg_token','global_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@globalInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_msg_token','array_index','arrayIndex');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_msg_token','token'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/msgDataElement/msgCatalogTokens');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--Situation table" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','sit_category_name'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/situation/@categoryName');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','reasoning_scope'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/situation/situationType/@reasoningScope');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','sit_has_any_elem','sitHasAnyElement');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','success_disp'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/situation/situationType/@successDisposition');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','situation_qual'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/situation/situationType/@situationQualifier');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','situation_disp'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/situation/situationType/@situationDisposition');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','operation_disp'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/situation/situationType/@operationDisposition');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','availability_disp'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/situation/situationType/@availabilityDisposition');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','processing_disp'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/situation/situationType/@processingDisposition');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','report_category'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/situation/situationType/@reportCategory');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','feature_disp'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/situation/situationType/@featureDisposition');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event','dependency_disp'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/situation/situationType/@dependencyDisposition');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--Event association table" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event_reln','global_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@globalInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event_reln','assoc_event_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/associatedEvents/@resolvedEvents');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event_reln','engine_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/associatedEvents/associationEngine');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_event_reln','array_index','arrayIndex');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--Association engine table" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_assoc_eng','engine_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/associatedEvents/associationEngineInfo/@id');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_assoc_eng','engine_type'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/associatedEvents/associationEngineInfo/@type');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_assoc_eng','engine_name'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/associatedEvents/associationEngineInfo/@name');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--Event association view" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_v_reln_eng','global_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@globalInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_v_reln_eng','assoc_event_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/associatedEvents/@resolvedEvents');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_v_reln_eng','engine_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/associatedEvents/associationEngineInfo/@id');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_v_reln_eng','array_index','arrayIndex');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_v_reln_eng','engine_type'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/associatedEvents/associationEngineInfo/@type');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_v_reln_eng','engine_name'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/associatedEvents/associationEngineInfo/@name');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--Component table" >> "$METADATA_FILE"
  echo "--Both the reporter and source components map to the same table" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_compid','global_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@globalInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_compid','rel_type','relationType');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_compid','component_type'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/reporterComponentId/@componentType;' ||" >> "$METADATA_FILE"
  echo "'CommonBaseEvent/sourceComponentId/@componentType');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_compid','component'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/reporterComponentId/@component;' ||" >> "$METADATA_FILE"
  echo "'CommonBaseEvent/sourceComponentId/@component');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_compid','sub_component'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/reporterComponentId/@subComponent;' ||" >> "$METADATA_FILE"
  echo "'CommonBaseEvent/sourceComponentId/@subComponent');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_compid','comp_id_type'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/reporterComponentId/@componentIdType;' ||" >> "$METADATA_FILE"
  echo "'CommonBaseEvent/sourceComponentId/@componentIdType');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_compid','instance_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/reporterComponentId/@instanceId;' ||" >> "$METADATA_FILE"
  echo "'CommonBaseEvent/sourceComponentId/@instanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_compid','application'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/reporterComponentId/@application;' ||" >> "$METADATA_FILE"
  echo "'CommonBaseEvent/sourceComponentId/@application');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_compid','exec_env'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/reporterComponentId/@executionEnvironment;' ||" >> "$METADATA_FILE"
  echo "'CommonBaseEvent/sourceComponentId/@executionEnvironment');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_compid','location'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/reporterComponentId/@location;' ||" >> "$METADATA_FILE"
  echo "'CommonBaseEvent/sourceComponentId/@location');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_compid','location_type'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/reporterComponentId/@locationType;' ||" >> "$METADATA_FILE"
  echo "'CommonBaseEvent/sourceComponentId/@locationType');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_compid','process_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/reporterComponentId/@processId;' ||" >> "$METADATA_FILE"
  echo "'CommonBaseEvent/sourceComponentId/@processId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_compid','thread_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/reporterComponentId/@threadId;' ||" >> "$METADATA_FILE"
  echo "'CommonBaseEvent/sourceComponentId/@threadId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--Any element table" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_anyelmnt','global_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@globalInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_anyelmnt','element_type','elementType');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_anyelmnt','array_index','arrayIndex');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_anyelmnt','chunk_number','chunkNumber');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_anyelmnt','element_name','elementName');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_anyelmnt','namespace','nameSpace');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES ('1.0.1','cei_t_anyelmnt','value','value');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES ('1.0.1','cei_t_anyelmnt','rowid','rowid');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--Extended data element table" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_elem','global_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@globalInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_elem','element_key','elementKey');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_elem','parent_element_key','parentElementKey');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_elem','element_name'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/extendedDataElements/@name');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_elem','element_level','level');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_elem','element_position','position');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_elem','data_type'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/extendedDataElements/@type');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_elem','string_value'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/extendedDataElements[@type=''string'']/values');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_elem','long_value'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/extendedDataElements[@type=''boolean'']/values');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "UPDATE cei_t_cbe_map" >> "$METADATA_FILE"
  echo "SET element_xpath = element_xpath ||" >> "$METADATA_FILE"
  echo "';CommonBaseEvent/extendedDataElements[@type=''byte'']/values'" >> "$METADATA_FILE"
  echo "WHERE cbe_version='1.0.1'" >> "$METADATA_FILE"
  echo "AND table_name = 'cei_t_ext_elem'" >> "$METADATA_FILE"
  echo "AND column_name = 'long_value';" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "UPDATE cei_t_cbe_map" >> "$METADATA_FILE"
  echo "SET element_xpath = element_xpath ||" >> "$METADATA_FILE"
  echo "';CommonBaseEvent/extendedDataElements[@type=''short'']/values' ||" >> "$METADATA_FILE"
  echo "';CommonBaseEvent/extendedDataElements[@type=''int'']/values'" >> "$METADATA_FILE"
  echo "WHERE cbe_version='1.0.1'" >> "$METADATA_FILE"
  echo "AND table_name = 'cei_t_ext_elem'" >> "$METADATA_FILE"
  echo "AND column_name = 'long_value';" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "UPDATE cei_t_cbe_map" >> "$METADATA_FILE"
  echo "SET element_xpath = element_xpath ||" >> "$METADATA_FILE"
  echo "';CommonBaseEvent/extendedDataElements[@type=''long'']/values;' ||" >> "$METADATA_FILE"
  echo "'CommonBaseEvent/extendedDataElements[@type=''dateTime'']/values'" >> "$METADATA_FILE"
  echo "WHERE cbe_version='1.0.1'" >> "$METADATA_FILE"
  echo "AND table_name = 'cei_t_ext_elem'" >> "$METADATA_FILE"
  echo "AND column_name = 'long_value';" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_elem','float_value'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/extendedDataElements[@type=''float'']/values;' ||" >> "$METADATA_FILE"
  echo "'CommonBaseEvent/extendedDataElements[@type=''double'']/values');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--String extended data element values" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_string','global_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@globalInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_string','element_key','elementKey');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_string','array_index','arrayIndex');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_string','value'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/extendedDataElements/values');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--Integer extended data element values" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_int','global_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@globalInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_int','element_key','elementKey');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_int','array_index','arrayIndex');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_int','value'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/extendedDataElements/values');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--Float extended data element values" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_float','global_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@globalInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_float','element_key','elementKey');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_float','array_index','arrayIndex');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_float','value'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/extendedDataElements/values');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_float','value_string','floatAsString');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--DateTime extended data element values" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_date','global_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@globalInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_date','element_key','elementKey');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_date','array_index','arrayIndex');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_date','value'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/extendedDataElements/values');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_date','value_utc','dateTimeAsLong');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "--Binary extended data element values" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_blob','global_id'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/@globalInstanceId');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_blob','element_key','elementKey');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_blob','chunk_number','chunkNumber');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_blob','value'," >> "$METADATA_FILE"
  echo "'CommonBaseEvent/extendedDataElements/values');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_cbe_map" >> "$METADATA_FILE"
  echo "(cbe_version,table_name,column_name,element_xpath)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('1.0.1','cei_t_ext_blob','rowid','rowid');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_properties" >> "$METADATA_FILE"
  echo "(property_name,property_value)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('CbeMajorVersion','1');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_properties" >> "$METADATA_FILE"
  echo "(property_name,property_value)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('CbeMinorVersion','0');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_properties" >> "$METADATA_FILE"
  echo "(property_name,property_value)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('CbePtfLevel','1');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_properties" >> "$METADATA_FILE"
  echo "(property_name,property_value)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('SchemaMajorVersion','6');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_properties" >> "$METADATA_FILE"
  echo "(property_name,property_value)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('SchemaMinorVersion','0');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_properties" >> "$METADATA_FILE"
  echo "(property_name,property_value)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('SchemaPtfLevel','0');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_properties" >> "$METADATA_FILE"
  echo "(property_name,property_value)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('NumberOfBuckets','2');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "INSERT INTO cei_t_properties" >> "$METADATA_FILE"
  echo "(property_name,property_value)" >> "$METADATA_FILE"
  echo "VALUES" >> "$METADATA_FILE"
  echo "('CurrentBucketNumber','0');" >> "$METADATA_FILE"
  echo "" >> "$METADATA_FILE"
  echo "COMMIT;" >> "$METADATA_FILE"
}


generate_check_version() {

  if [ -f $CHECK_VERSION_FILE ] ; then
    rm -f $CHECK_VERSION_FILE
  fi

  echo "--------------------------------------------------------------------------" >> "$CHECK_VERSION_FILE"
  echo "-- Licensed Materials - Property of IBM" >> "$CHECK_VERSION_FILE"
  echo "-- (C) Copyright IBM Corp. 2004, 2010.  ALL RIGHTS RESERVED" >> "$CHECK_VERSION_FILE"
  echo "-- 5724-I63, 5724-H88, 5655-N02, 5733-W70" >> "$CHECK_VERSION_FILE"
  echo "-- US Government Users Restricted Rights - Use, duplication, or disclosure" >> "$CHECK_VERSION_FILE"
  echo "-- restricted by GSA ADP Schedule Contract with IBM Corp." >> "$CHECK_VERSION_FILE"
  echo "--------------------------------------------------------------------------" >> "$CHECK_VERSION_FILE"
  echo "CHECK DATA" >> "$CHECK_VERSION_FILE"
  echo "-- DB2 Utility control file that is used with the CHECK DATA DB2" >> "$CHECK_VERSION_FILE"
  echo "-- utility after a CEI 5.1.0 or 5.1.1 database is upgraded to a" >> "$CHECK_VERSION_FILE"
  echo "-- CEI 6.0.0 database. Running the CHECK DATA utility gets" >> "$CHECK_VERSION_FILE"
  echo "-- tablespaces out of the check pending state." >> "$CHECK_VERSION_FILE"
  echo "--" >> "$CHECK_VERSION_FILE"
  echo "-- All of the data will be valid, so we do not need to specify" >> "$CHECK_VERSION_FILE"
  echo "-- where to place invalid rows." >> "$CHECK_VERSION_FILE"
  echo "--" >> "$CHECK_VERSION_FILE"
  echo "-- To submit the CHECK DATA DB2 utility:" >> "$CHECK_VERSION_FILE"
  echo "--  1. Upload the contents of this file to a data set on the host." >> "$CHECK_VERSION_FILE"
  echo "--     It must be uploaded with a fixed record format with a logical" >> "$CHECK_VERSION_FILE"
  echo "--     record length of 80." >> "$CHECK_VERSION_FILE"
  echo "--  2. In ISPF, go to the DB2I Primary Option Menu" >> "$CHECK_VERSION_FILE"
  echo "--  3. Select option 8 Utilities" >> "$CHECK_VERSION_FILE"
  echo "--  4. In entry field 1 FUNCTION, specify EDITJCL" >> "$CHECK_VERSION_FILE"
  echo "--  5. In entry field 3 UTILITY, specify CHECK DATA" >> "$CHECK_VERSION_FILE"
  echo "--  6. In entry field 4 STATEMENT DATA SET, specify the data set" >> "$CHECK_VERSION_FILE"
  echo "--     name for the dataset that contains the contents of this file." >> "$CHECK_VERSION_FILE"
  echo "--  7. In the entry field 6 LISTDEF? YES/NO , specify NO" >> "$CHECK_VERSION_FILE"
  echo "--  8. In the entry field TEMPLATE? YES/NO, specify NO" >> "$CHECK_VERSION_FILE"
  echo "--  9. Press the enter key to generate the JCL" >> "$CHECK_VERSION_FILE"
  echo "-- 10. Press the enter key to clear the screen of output messages" >> "$CHECK_VERSION_FILE"
  echo "-- 11. Edit the generated JCL as needed" >> "$CHECK_VERSION_FILE"
  echo "-- 12. On the Command ===>, enter submit and press enter" >> "$CHECK_VERSION_FILE"
  echo "TABLESPACE event.ceicfg" >> "$CHECK_VERSION_FILE"
  echo "TABLESPACE event.ceievent" >> "$CHECK_VERSION_FILE"
  echo "TABLESPACE event.ceiextel" >> "$CHECK_VERSION_FILE"
  echo "TABLESPACE event.ceiexstr" >> "$CHECK_VERSION_FILE"
  echo "TABLESPACE event.ceiexint" >> "$CHECK_VERSION_FILE"
  echo "TABLESPACE event.ceiexflt" >> "$CHECK_VERSION_FILE"
  echo "TABLESPACE event.ceiexdte" >> "$CHECK_VERSION_FILE"
  echo "TABLESPACE event.ceiexblb" >> "$CHECK_VERSION_FILE"
  echo "TABLESPACE event.ceianyel" >> "$CHECK_VERSION_FILE"
  echo "TABLESPACE event.ceireln" >> "$CHECK_VERSION_FILE"
  echo "TABLESPACE event.ceicntxt" >> "$CHECK_VERSION_FILE"
  echo "TABLESPACE event.ceicomp" >> "$CHECK_VERSION_FILE"
  echo "TABLESPACE event.ceimsgtk" >> "$CHECK_VERSION_FILE"
}

##########################################################################
# Licensed Materials - Property of IBM
# (C) Copyright IBM Corp. 2004, 2010.  ALL RIGHTS RESERVED 
# 5724-I63, 5724-H88, 5655-N02, 5733-W70
# US Government Users Restricted Rights - Use, duplication, or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
##########################################################################
#--------------------------------------------------------------------------

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

}

run_upgrade() {

  echo "Checking the Event Service DB2 database schema version."
  #eval ". ~$DB_USER/sqllib/db2profile"

  USING="USING $DB_PASSWORD"
  if [ "$DB_PASSWORD" = "" ]; then
     USING=""
  fi

  connect_db

  # Delete schema version check output file if exist
  if [ -f $SCHEMA_VERSION_DB2 ]; then
     rm -f $SCHEMA_VERSION_DB2
  fi

  # Generate schema_version.db2 that checks for version to upgrade
  echo "select substr(t1.property_value || '.' || t2.property_value || '.' || t3.property_value,1,80) from cei_t_properties t1, cei_t_properties t2, cei_t_properties t3 where t1.property_name = 'SchemaMajorVersion' and t2.property_name = 'SchemaMinorVersion' and t3.property_name = 'SchemaPtfLevel'" >> $SCHEMA_VERSION_DB2

  # Delete version check output if exists
  if [ -f $SCHEMA_VERSION_TXT ] ; then
     rm -f $SCHEMA_VERSION_TXT
  fi

  # Check schema version
  echo  "db2 +o -x -z $SCHEMA_VERSION_TXT -f $SCHEMA_VERSION_DB2"
  db2 +o -x -z $SCHEMA_VERSION_TXT -f $SCHEMA_VERSION_DB2

  if [ ! $RC -eq 0 ]; then
     echo "Failed to check the Event Service database schema version."
     exit 1
  fi

  # check for schema version 5.1.0
  cat $SCHEMA_VERSION_TXT | grep "5.1.0" > /dev/null
  RC=$? 

  if [ $RC -eq 0 ]; then
     # Found version 5.1.0, need upgrade
     NEED_UPGRADE=1
     UPGRADE_CAT=1
  else

     # check for schema version 5.1.1
     cat $SCHEMA_VERSION_TXT | grep "5.1.1" > /dev/null
     RC=$? 

     if [ $RC -eq 0 ]; then
        # Found version 5.1.1, need upgrade
        NEED_UPGRADE=1
     fi
  fi

  if [ $NEED_UPGRADE -eq 0 ]; then

     # Check for error
     cat $SCHEMA_VERSION_TXT | grep "SQLSTATE"  > /dev/null
     RC=$?

     if [ $RC -eq 0 ]; then
        disconnect_db
        cat $SCHEMA_VERSION_TXT
        exit 1
     else
        # The Event Service DB2 z/OS database upgrade is not needed
        echo "The Event Service DB2 z/OS database schema is up to date. No upgrade is needed."
        disconnect_db
        exit 2
     fi
  fi 

  echo "Running the Event Service DB2 z/OS database schema upgrade."

  if [ $UPGRADE_CAT -eq 1 ]; then
     # This must be version 5.1.0.
     # Upgrade the catatalog first to bring it from 5.1.0 to 5.1.1
     echo "db2 -td@ -f $CAT_DDL_FILE -s +c"
     db2 -td@ -f "$CAT_DDL_FILE" -s +c
     RC=$?
  fi

  if [ $RC -eq 0 ]; then
     echo "db2 -td@ -f $DDL_FILE -s +c"
     db2 -td@ -f "$DDL_FILE" -s +c
     RC=$?
  else
     echo "DB2 command returned RC=$RC"
     RC=1
  fi 

  if [ $RC -eq 0 ]; then
     echo db2 -s -t -f $METADATA_FILE
     db2 -s -t -f "$METADATA_FILE"
  else
     echo "DB2 command returned RC=$RC"
     RC=1
  fi

  disconnect_db 

}


generate_ddl() {

  binDir=`dirname "$0"`              
   . "$binDir/setupCmdLine.sh"       

  # Construct the parameters to be passed to the java script generator
  INPUT_PARAMS="-DDB_TYPE=DB2ZOS -DOUTPUT_DIR=$DB_UPGRADE_DIR"
  INPUT_PARAMS="$INPUT_PARAMS -Deventdbname=$EVENT_DB_NAME" 
  INPUT_PARAMS="$INPUT_PARAMS -Dcatalogdbname=$CAT_DB_NAME"
  INPUT_PARAMS="$INPUT_PARAMS -DstorageGroup=$STORAGE_GROUP"
  INPUT_PARAMS="$INPUT_PARAMS -DbufferPool4K=$BUFFER_POOL_4K"
  INPUT_PARAMS="$INPUT_PARAMS -DbufferPool8K=$BUFFER_POOL_8K"
  INPUT_PARAMS="$INPUT_PARAMS -DbufferPool16K=$BUFFER_POOL_16K"
  INPUT_PARAMS="$INPUT_PARAMS -DdbDiskSizeInMB=$DB_DISK_SIZE_MB"
  "$JAVA_HOME/bin/java" $WAS_LOGGING $CONSOLE_ENCODING -Dwas.install.root="$WAS_HOME" -Dws.ext.dirs="$WAS_EXT_DIRS" $USER_INSTALL_PROP -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" -classpath "$WAS_CLASSPATH" $INPUT_PARAMS com.ibm.ws.bootstrap.WSLauncher com.ibm.events.install.db.DBGenerateUpgradeScripts $*   
   RC=$?

   if [ ! $RC -eq 0 ] ; then
      exit $1
   fi
}

generate_and_run_script() {

  if [ ! -d $SCRIPT_DIR ] ; then 
     echo "Directory $SCRIPT_DIR not found."
     exit 1
  fi

  # Create script dir if not exist
  if [ ! -d $EVENT_UPGRADE_DIR ] ; then 
      mkdir $EVENT_UPGRADE_DIR
  fi

  # Create DB2 dir if not exist
  if [ ! -d $DB_UPGRADE_DIR ]; then
      mkdir $DB_UPGRADE_DIR
  fi

  echo "Generating the Event Service DB2 z/OS database schema upgrade scripts to directory $SCRIPT_DIR"

  # Cleanup before generate
  if [ -f $METADATA_FILE ] ; then
     rm -f $METADATA_FILE
  fi

  if [ -f $CHECK_VERSION_FILE ] ; then
     rm -f $CHECK_VERSION_FILE
  fi

  generate_ddl
  generate_metadata
  generate_check_version

  if [ "$RUN_UPGRADE" = "true" ]; then

     run_upgrade

     if [ $RC -eq 0 ] ; then
        echo "The Event Service DB2 z/OS database schema upgrade completed successfully."
     else
        echo "Errors occurred while upgrading the Event Service DB2 z/OS database schema."
     fi

     exit $RC

  else
    exit 0;
  fi
}


SCRIPT_DIR=`dirname $0`
if [ "$SCRIPT_DIR" = "." ] ; then
   SCRIPT_DIR=`pwd`
fi

# Initialize variables
RC=0
RUN_UPGRADE=""
DB_NAME=""
DB_USER=""
DB_PASSWORD=""
IS_CONNECTED=0
NEED_UPGRADE=0
NATIVE_390=0

# Check OS, Set to generate scripts only on native OS/390
case `uname -s` in
   OS/390 ) NATIVE_390=1; RUN_UPGRADE=false;;
esac

# ------------------------------------------------------------------------
UPGRADE_CAT=0
EVENT_DB_NAME=event
CAT_DB_NAME=eventcat
STORAGE_GROUP=sysdeflt
BUFFER_POOL_4K=BP9
BUFFER_POOL_8K=BP8K9
BUFFER_POOL_16K=BP16K9
DB_DISK_SIZE_MB=100
# ------------------------------------------------------------------------



print_usage() {
  echo "Usage: eventUpgradeDB2ZOS.sh -runUpgrade true_or_false \             "
  echo "   -dbUser db_user \                                                 "
  echo "   [-dbName db_name] \                                               "
  echo "   [-dbPassword db_password] \                                       " 
  echo "   [-scriptDir gen_script_dir] \                                     "
  echo "   [-eventDBName event_db_name] \                                    "
  echo "   [-catalogDBName event_cat_db_name] \                              "
  echo "   [-storageGroup storage_group_name] \                              "
  echo "   [-bufferPool4K name_4K_buffer_pool] \                             "
  echo "   [-bufferPool8K name_8K_buffer_pool] \                             "
  echo "   [-bufferPool16K name_16K_buffer_pool] \                           "
  echo "   [-dbDiskSizeInMB db_disk_size_in_MB] \                            "
  echo "" 
  echo "  Where:                                                             "
  echo "   true_or_false  - Specify true to run the upgrade.                 "
  echo "                    Specify false to generate ddl scripts only.      " 
  echo "                    On native OS/390, this parameter will always be  "
  echo "                    set to false which is generate only. User must   "
  echo "                    use SPUFI to run the generated DDL script.       "
  echo "   db_user        - Required db2 userid.                             "
  echo "   db_name        - Required database name if -runUpgrade is true.   "
  echo "                    if the current machine is a db2 client.          "
  echo "   db_password    - Optional. DB2 will prompt if not specified.      "
  echo "   gen_script_dir - Optional directory to generate the DDL scripts.  "
  echo "                    If not specified, the scripts will be generated  "
  echo "                    in <current_dir>\eventDBUpgrade\DB2ZOS .         "
  echo "   eventDBName   -  Optional event database group name.              "
  echo "                    Default to event                                 "
  echo "   catalogDBName  - Optional event catalog database group name.      "
  echo "                    Default to eventcat.                             "
  echo "   storage_group_name   - Optional storage group name.               "
  echo "                          Default to sysdeflt.                       "
  echo "   name_4K_buffer_pool  - Optional 4K buffer pool name.              "
  echo "                          Default to BP9.                            "
  echo "   name_8K_buffer_pool  - Optional 8K buffer pool name.              "
  echo "                          Default to BP8K9.                          "
  echo "   name_16K_buffer_pool - Optional 16K buffer pool name.             "
  echo "                          Default to BP16K9.                         "
  echo "   db_disk_size_in_MB   - Optional size of database.                 "
  echo "                          Default to 100.                            "
  echo ""
  echo " Example 1:                                                          "
  echo "   upgrade_event_db2zos.sh -runUpgrade false -dbUser db2inst1        "
  echo ""
  echo " Example 2:                                                          "
  echo "   upgrade_event_db2zos.sh -runUpgrade true -dbName event            "
  echo "        -dbUser db2inst1                                             "
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

         if [ $NATIVE_390 -eq 1 ] ; then 

            # On native 390, runUpgrade can only be false
            if [ "$2" = "true" ] ; then
               echo "runUpgrade can only set to false on native OS/390"
               echo "User must use SPUFI to run the generated DDL scripts" 
            fi
         else
            # Not on native 390, runUpgrade can be true or false
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
         fi

         shift;;

      -dbName)
         DB_NAME=$2
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

      -eventDBName)
         EVENT_DB_NAME=$2
         shift;;
      -catalogDBName)
         CAT_DB_NAME=$2
         shift;;
      -storageGroup)
         STORAGE_GROUP=$2
         shift;;
      -bufferPool4K)
         BUFFER_POOL_4K=$2
         shift;;
      -bufferPool8K)
         BUFFER_POOL_8K=$2
         shift;;
      -bufferPool16K)
         BUFFER_POOL_16K=$2
         shift;;
      -dbDiskSizeInMB)
         DB_DISK_SIZE_MB=$2
         shift;;
      *) print_usage 
         echo "Invalid parameter $1"
         exit 1

   esac
   shift;
done

# Set variables
EVENT_UPGRADE_DIR=$SCRIPT_DIR/eventDBUpgrade
DB_UPGRADE_DIR=$EVENT_UPGRADE_DIR/DB2ZOS
SCHEMA_VERSION_DB2=$DB_UPGRADE_DIR/schema_version.db2
SCHEMA_VERSION_TXT=$DB_UPGRADE_DIR/schema_version.txt
FINDSTR_OUTPUT_TXT=$DB_UPGRADE_DIR/findstr_output.txt
DDL_FILE=$DB_UPGRADE_DIR/upgrade_event_db.db2
METADATA_FILE=$DB_UPGRADE_DIR/ins_metadata.db2
CAT_DDL_FILE=$DB_UPGRADE_DIR/upgrade_event_db_catalog.db2
CHECK_VERSION_FILE=$DB_UPGRADE_DIR/check_version.ctl

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

if [ "$DB_NAME" = "" ]; then
   print_usage
   echo "A value for parameter -dbName is required"
   exit 1
fi

if [ "$DB_USER" = "" ]; then
   print_usage
   echo "A value for parameter -dbUser is required"
   exit 1
fi

generate_and_run_script


--------------- Begin Copyright - Do not add comments here --------------
--
-- Licensed Materials - Property of IBM
--
-- Restricted Materials of IBM
--
-- Virtual Member Manager
--
-- Copyright IBM Corp. 2005, 2010
--
-- US Government Users Restricted Rights - Use, duplication or
-- disclosure restricted by GSA ADP Schedule Contract with
-- IBM Corp.
--
----------------------------- End Copyright -----------------------------
CREATE TABLE @dbschema.@LAENTITY (
	ENTITY_ID		BIGINT NOT NULL,
	ENTITY_TYPE		VARGRAPHIC(36) CCSID 13488 NOT NULL,
	EXT_ID			VARGRAPHIC(200) CCSID 13488 NOT NULL,
	FULL_EXT_ID		VARGRAPHIC(1000) CCSID 13488 NOT NULL,
	REPOS_ID		CHAR(36) NOT NULL
);


CREATE TABLE @dbschema.@LAKEYS (
	KEYS_ID			INTEGER NOT NULL,
	TABLENAME		VARGRAPHIC(256) CCSID 13488 NOT NULL,
	COLUMNNAME		VARGRAPHIC(18) CCSID 13488 NOT NULL,
	COUNTER			BIGINT	NOT NULL,
	PREFETCH_SIZE		BIGINT DEFAULT 20,
	LOWER_BOUND		BIGINT DEFAULT 0,
	UPPER_BOUND 		BIGINT DEFAULT 2147483648
);


CREATE TABLE @dbschema.@LAPROP (
	PROP_ID			INTEGER NOT NULL,
	NAME			VARGRAPHIC(200) CCSID 13488 NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	META_NAME		VARGRAPHIC(36) CCSID 13488 DEFAULT 'DEFAULT' NOT NULL,
	IS_COMPOSITE		INTEGER DEFAULT 0,
	VALUE_LENGTH		INTEGER,
	READ_ONLY		INTEGER DEFAULT 0,
	MULTI_VALUED		INTEGER DEFAULT 1,
	CASE_EXACT_MATCH	INTEGER DEFAULT 1,
	CLASSNAME		VARGRAPHIC(512) CCSID 13488,
	DESCRIPTION		VARGRAPHIC(512) CCSID 13488,
	APPLICATION_ID		VARGRAPHIC(254) CCSID 13488 DEFAULT 'com.ibm.websphere.wim' NOT NULL
);


CREATE TABLE @dbschema.@LAPROPTYPE (
	TYPE_ID			CHAR(16) NOT NULL,
	DESCRIPTION		VARGRAPHIC(254) CCSID 13488
);


CREATE TABLE @dbschema.@LAPROPENT (
	PROP_ID			INTEGER	NOT NULL,
	APPLICABLE_ENTTYPE	VARGRAPHIC(36) CCSID 13488 NOT NULL,
	REQUIRED_ENTTYPE	INTEGER DEFAULT 0 NOT NULL
);
 

CREATE TABLE @dbschema.@LALONGPROP (
	VALUE_ID		BIGINT NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		BIGINT NOT NULL,
	COMPOSITE		BIGINT,
	PROPVALUE		BIGINT,
	META_VALUE		VARGRAPHIC(36) CCSID 13488
);


CREATE TABLE @dbschema.@LABLOBPROP (
	VALUE_ID		BIGINT NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		BIGINT NOT NULL,
	COMPOSITE		BIGINT,
	PROPVALUE		BLOB(10000000),
	META_VALUE		VARGRAPHIC(36) CCSID 13488
);


CREATE TABLE @dbschema.@LADBLPROP (
	VALUE_ID		BIGINT NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		BIGINT NOT NULL,
	COMPOSITE		BIGINT,
	PROPVALUE		DOUBLE,
	META_VALUE		VARGRAPHIC(36) CCSID 13488
);


CREATE TABLE @dbschema.@LAINTPROP (
	VALUE_ID		BIGINT NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		BIGINT NOT NULL,
	COMPOSITE		BIGINT,
	PROPVALUE		INTEGER,
	META_VALUE		VARGRAPHIC(36) CCSID 13488
);


CREATE TABLE @dbschema.@LAREFPROP (
	VALUE_ID		BIGINT NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		BIGINT NOT NULL,
	COMPOSITE		BIGINT,
	REF_UNAME_KEY		VARGRAPHIC(236) CCSID 13488 NOT NULL,
	REF_UNAME		VARGRAPHIC(1000) CCSID 13488 NOT NULL,
	REF_EXT_ID		VARGRAPHIC(200) CCSID 13488 NOT NULL,
	REF_FULL_EXT_ID		VARGRAPHIC(1000) CCSID 13488 NOT NULL,
	REF_REPOS_ID		CHAR(36) NOT NULL,
	META_VALUE		VARGRAPHIC(36) CCSID 13488
);


CREATE TABLE @dbschema.@LASTRPROP (
	VALUE_ID		BIGINT NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		BIGINT NOT NULL,
	COMPOSITE		BIGINT,
	PROPVALUE		VARGRAPHIC(1500) CCSID 13488,
	VALUE_KEY		VARGRAPHIC(1500) CCSID 13488,
	META_VALUE		VARGRAPHIC(36) CCSID 13488
);


CREATE TABLE @dbschema.@LATSPROP (
	VALUE_ID		BIGINT NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		BIGINT NOT NULL,
	COMPOSITE		BIGINT,
	PROPVALUE		TIMESTAMP,
	META_VALUE		VARGRAPHIC(36) CCSID 13488
);


CREATE TABLE @dbschema.@LACOMPREL (
	COMPOSITE_ID		INTEGER NOT NULL,
	COMPONENT_ID		INTEGER NOT NULL,
	IS_REQUIRED		INTEGER DEFAULT 0 NOT NULL,
	IS_KEY			INTEGER DEFAULT 0 NOT NULL
);


CREATE TABLE @dbschema.@LACOMPPROP (
	VALUE_ID		BIGINT NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	ENTITY_ID		BIGINT NOT NULL,
	COMPOSITE_ID		BIGINT,
	META_VALUE		VARGRAPHIC(36) CCSID 13488
);

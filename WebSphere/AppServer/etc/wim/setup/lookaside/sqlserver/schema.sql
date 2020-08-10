--------------- Begin Copyright - Do not add comments here --------------
--
-- Licensed Materials - Property of IBM
--
-- Restricted Materials of IBM
--
-- Virtual Member Manager
--
-- (C) Copyright IBM Corp. 2005, 2010
--
-- US Government Users Restricted Rights - Use, duplication or
-- disclosure restricted by GSA ADP Schedule Contract with
-- IBM Corp.
--
----------------------------- End Copyright -----------------------------
CREATE TABLE @DbUser@.LAENTITY (
	ENTITY_ID		NUMERIC(38, 0) NOT NULL,
	ENTITY_TYPE		VARCHAR(36) NOT NULL,
	EXT_ID			NVARCHAR(200) NOT NULL,
	FULL_EXT_ID		NVARCHAR(1000) NOT NULL,
	REPOS_ID		CHAR(36) NOT NULL
);


CREATE TABLE @DbUser@.LAKEYS (
	KEYS_ID			INTEGER NOT NULL,
	TABLENAME		VARCHAR(256) NOT NULL,
	COLUMNNAME		VARCHAR(18) NOT NULL,
	COUNTER			NUMERIC(38, 0)	NOT NULL,
	PREFETCH_SIZE		NUMERIC(38, 0) DEFAULT 20 NULL,
	LOWER_BOUND		NUMERIC(38, 0) DEFAULT 0 NULL,
	UPPER_BOUND 		NUMERIC(38, 0) DEFAULT 2147483648 NULL
);


CREATE TABLE @DbUser@.LAPROP (
	PROP_ID			INTEGER NOT NULL,
	NAME			VARCHAR(200) NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	META_NAME		NVARCHAR(36) DEFAULT 'DEFAULT' NOT NULL,
	IS_COMPOSITE		TINYINT DEFAULT 0 NULL,
	VALUE_LENGTH		SMALLINT NULL,
	READ_ONLY		TINYINT DEFAULT 0 NULL,
	MULTI_VALUED		TINYINT DEFAULT 1 NULL,
	CASE_EXACT_MATCH	TINYINT DEFAULT 1 NULL,
	CLASSNAME		VARCHAR(512) NULL,
	DESCRIPTION		NVARCHAR(512) NULL,
	APPLICATION_ID		VARCHAR(254) DEFAULT 'com.ibm.websphere.wim' NOT NULL
);


CREATE TABLE @DbUser@.LAPROPTYPE (
	TYPE_ID			CHAR(16) NOT NULL,
	DESCRIPTION		NVARCHAR(254) NULL
);


CREATE TABLE @DbUser@.LAPROPENT (
	PROP_ID			INTEGER	NOT NULL,
	APPLICABLE_ENTTYPE	VARCHAR(36) NOT NULL,
	REQUIRED_ENTTYPE	TINYINT DEFAULT 0 NOT NULL
);
 

CREATE TABLE @DbUser@.LALONGPROP (
	VALUE_ID		NUMERIC(38, 0) NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		NUMERIC(38, 0) NOT NULL,
	COMPOSITE		NUMERIC(38, 0) NULL,
	PROPVALUE		NUMERIC(38, 0) NULL,
	META_VALUE		NVARCHAR(36) NULL
);


CREATE TABLE @DbUser@.LABLOBPROP (
	VALUE_ID		NUMERIC(38, 0) NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		NUMERIC(38, 0) NOT NULL,
	COMPOSITE		NUMERIC(38, 0) NULL,
	PROPVALUE		IMAGE NULL,
	META_VALUE		NVARCHAR(36) NULL
);


CREATE TABLE @DbUser@.LADBLPROP (
	VALUE_ID		NUMERIC(38, 0) NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		NUMERIC(38, 0) NOT NULL,
	COMPOSITE		NUMERIC(38, 0) NULL,
	PROPVALUE		FLOAT(32) NULL,
	META_VALUE		NVARCHAR(36) NULL
);


CREATE TABLE @DbUser@.LAINTPROP (
	VALUE_ID		NUMERIC(38, 0) NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		NUMERIC(38, 0) NOT NULL,
	COMPOSITE		NUMERIC(38, 0) NULL,
	PROPVALUE		INTEGER NULL,
	META_VALUE		NVARCHAR(36) NULL
);


CREATE TABLE @DbUser@.LAREFPROP (
	VALUE_ID		NUMERIC(38, 0) NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		NUMERIC(38, 0) NOT NULL,
	COMPOSITE		NUMERIC(38, 0) NULL,
	REF_UNAME_KEY		NVARCHAR(236) NOT NULL,
	REF_UNAME		NVARCHAR(1000) NOT NULL,
	REF_EXT_ID		NVARCHAR(200) NOT NULL,
	REF_FULL_EXT_ID		NVARCHAR(1000) NOT NULL,
	REF_REPOS_ID		CHAR(36) NOT NULL,
	META_VALUE		NVARCHAR(36) NULL
);


CREATE TABLE @DbUser@.LASTRPROP (
	VALUE_ID		NUMERIC(38, 0) NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		NUMERIC(38, 0) NOT NULL,
	COMPOSITE		NUMERIC(38, 0) NULL,
	PROPVALUE		NVARCHAR(1500) NULL,
	VALUE_KEY		NVARCHAR(1500) NULL,
	META_VALUE		NVARCHAR(36) NULL
);


CREATE TABLE @DbUser@.LATSPROP (
	VALUE_ID		NUMERIC(38, 0) NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	TYPE_ID			CHAR(16) NOT NULL,
	ENTITY_ID		NUMERIC(38, 0) NOT NULL,
	COMPOSITE		NUMERIC(38, 0) NULL,
	PROPVALUE		DATETIME NULL,
	META_VALUE		NVARCHAR(36) NULL
);


CREATE TABLE @DbUser@.LACOMPREL (
	COMPOSITE_ID		INTEGER NOT NULL,
	COMPONENT_ID		INTEGER NOT NULL,
	IS_REQUIRED		TINYINT DEFAULT 0 NOT NULL,
	IS_KEY			TINYINT DEFAULT 0 NOT NULL
);


CREATE TABLE @DbUser@.LACOMPPROP (
	VALUE_ID		NUMERIC(38, 0) NOT NULL,
	PROP_ID			INTEGER NOT NULL,
	ENTITY_ID		NUMERIC(38, 0) NOT NULL,
	COMPOSITE_ID		NUMERIC(38, 0) NULL,
	META_VALUE		NVARCHAR(36) NULL
);

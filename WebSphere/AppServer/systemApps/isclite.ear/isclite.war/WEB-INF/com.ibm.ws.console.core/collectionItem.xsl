<?xml version="1.0"?>

<!--THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
5724-i63, 5724-H88(C) COPYRIGHT International Business Machines Corp., 1997, 2004
All Rights Reserved * Licensed Materials - Property of IBM
US Government Users Restricted Rights - Use, duplication or disclosure
restricted by GSA ADP Schedule Contract with IBM Corp.-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xml:space="default">
  <xsl:param name="contextRoot" select="default"/>
  <xsl:param name="pluginId" select="default"/>
  <xsl:param name="embedded" select="false"/>

  <xsl:output method="xml" 
              indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="collectionItem"/>
  </xsl:template>

  <xsl:template match="collectionItem">
    <xsl:apply-templates select="item"/>
  </xsl:template>

  <xsl:template match="item">
    <item value="{@value}" link="{@link}" icon="{@icon}" tooltip="{@tooltip}" classtype="com.ibm.ws.console.core.item.CollectionItem"/>
  </xsl:template>
</xsl:stylesheet>


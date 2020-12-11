<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

  <!--
  Description: ul/li based navigation. No features from admin implemented.
  Recommended settings:
  Fold out: True or False
  Upper menu: Dynamic or Static
  First level: > 0
  Last level: >= First level
	Made for ecommerce navigation
	<ul class="dwnavigation" id="topnav" data-settings="endlevel:1;template:TopNavigationEcom.xslt;">
  -->

  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"  encoding="utf-8" />
  <xsl:param name="html-content-type" />
  <xsl:template match="/NavigationTree">

	<xsl:if test="count(//Page) > 0">
	  <ul>
			<xsl:if test="Settings/LayoutNavigationAttributes/@class!=''">
				<xsl:attribute name="class">
					<xsl:value-of select="Settings/LayoutNavigationAttributes/@class" disable-output-escaping="yes"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="Settings/LayoutNavigationAttributes/@id!=''">
				<xsl:attribute name="id">
					<xsl:value-of select="Settings/LayoutNavigationAttributes/@id" disable-output-escaping="yes"/>
				</xsl:attribute>
			</xsl:if>
		<xsl:apply-templates select="Page">
		  <xsl:with-param name="depth" select="1"/>
		</xsl:apply-templates>
	  </ul>
	</xsl:if>

  </xsl:template>

  <xsl:template match="//Page">
	<xsl:param name="depth"/>
	<li>
		<xsl:attribute name="class">
			<xsl:if test="@InPath='True'">active </xsl:if>
			<xsl:if test="position() = 1">firstitem </xsl:if>
			<xsl:if test="position() = count(//Page)">lastitem </xsl:if>
			<xsl:if test="@Active='True'">active</xsl:if>
		</xsl:attribute>
	  <a>
		<xsl:attribute name="href">
		  <xsl:value-of select="@FriendlyHref" disable-output-escaping="yes"/>
		</xsl:attribute>
		<xsl:value-of select="@MenuText" disable-output-escaping="yes"/>
		<xsl:value-of select="@ImageMouseOver" disable-output-escaping="yes"/>
	  </a>
	</li>
  </xsl:template>

</xsl:stylesheet>
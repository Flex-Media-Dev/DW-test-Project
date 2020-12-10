<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<!--
Made for ecommerce navigation
<ul class="dwnavigation" id="leftnav" data-settings="template:LeftNavigationEcom.xslt">
-->
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"  encoding="utf-8" />
	<xsl:param name="html-content-type" />
	<xsl:template match="/NavigationTree">

		<xsl:if test="count(//Page[@InPath='True']/Page) > 0">
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
				
				<xsl:apply-templates select="Page[@InPath='True']/Page">
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
				<xsl:if test="$depth=1">
					<i class="icon-chevron-right"></i> </xsl:if>
				<xsl:value-of select="@MenuText" disable-output-escaping="yes"/>
			</a>
			<xsl:if test="count(Page) and @InPath='True' and @AbsoluteLevel&lt;3">
				<ul class="M{@AbsoluteLevel}">
					<xsl:apply-templates select="Page">
						<xsl:with-param name="depth" select="$depth+1"/>
					</xsl:apply-templates>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

</xsl:stylesheet>
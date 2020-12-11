<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"  encoding="utf-8" />

	<xsl:template match="/NavigationTree">
		<xsl:if test="Page">
			<ul class="nav navbar-nav">
				<xsl:apply-templates select="Page"/>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Page">
		<li>
			<xsl:choose>

				<xsl:when test="Page">
					<xsl:variable name="class">dropdown</xsl:variable>
					<xsl:if test="normalize-space($class)">
						<xsl:attribute name="class">
							<xsl:value-of select="normalize-space($class)"/>
						</xsl:attribute>
					</xsl:if>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="@FriendlyHref" disable-output-escaping="yes" />
						</xsl:attribute>
						<xsl:attribute name="class">dropdown-toggle</xsl:attribute>
						<xsl:attribute name="data-toggle">dropdown</xsl:attribute>
						<xsl:value-of select="@MenuText" disable-output-escaping="yes" />
						<b class="caret"><xsl:comment/></b>
					</a>
						<ul>
								<xsl:attribute name="class">dropdown-menu</xsl:attribute>
								<xsl:apply-templates select="Page"/>
						</ul>
				</xsl:when>

				<xsl:otherwise>
					<xsl:variable name="class">
						<xsl:if test="@InPath = 'True'"> active </xsl:if>
						<xsl:if test="@Active = 'True'"> current </xsl:if>
					</xsl:variable>
					<xsl:if test="normalize-space($class)">
						<xsl:attribute name="class">
							<xsl:value-of select="normalize-space($class)"/>
						</xsl:attribute>
					</xsl:if>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="@FriendlyHref" disable-output-escaping="yes" />
						</xsl:attribute>
						<xsl:value-of select="@MenuText" disable-output-escaping="yes" />
					</a>
					<xsl:if test="Page">
						<ul>
							<xsl:apply-templates select="Page"/>
						</ul>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>
</xsl:stylesheet>

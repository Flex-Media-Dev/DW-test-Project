<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
								xmlns:msxsl="urn:schemas-microsoft-com:xslt"
								xmlns:js="urn:javascript">

	<msxsl:script language="C#" implements-prefix="js"><![CDATA[
public string literal(string content)
{
   return string.Format("'{0}'", content.Replace("'", "\\'"));
}
]]></msxsl:script>
	<xsl:output method="text"/>

	<xsl:param name="name" select="'default'"/>

	<xsl:template match="/Styles">
		<xsl:text>CKEDITOR.stylesSet.add(</xsl:text>
		<xsl:value-of select="js:literal($name)"/>
		<xsl:text>, [</xsl:text>
		<xsl:for-each select="Style">
			<xsl:apply-templates select="."/>
			<xsl:if test="position() &lt; last()">,</xsl:if>
		</xsl:for-each>
		<xsl:text>]);</xsl:text>
	</xsl:template>

	<xsl:template match="Style">
		<xsl:text>{</xsl:text>
		<xsl:text>name:</xsl:text>
		<xsl:value-of select="js:literal(@name)"/>
		<xsl:text></xsl:text>
		<xsl:text>, element:</xsl:text>
		<xsl:value-of select="js:literal(@element)"/>
		<xsl:text></xsl:text>
		<xsl:if test="Attribute">
			<xsl:text>, attributes: {</xsl:text>
			<xsl:for-each select="Attribute">
				<xsl:value-of select="js:literal(@name)"/>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="js:literal(@value)"/>
				<xsl:if test="position() &lt; last()">,</xsl:if>
			</xsl:for-each>
			<xsl:text>}</xsl:text>
		</xsl:if>
		<xsl:text>}</xsl:text>
	</xsl:template>
</xsl:stylesheet>

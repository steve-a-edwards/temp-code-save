<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!--
		Steve Edwards	-->

	<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
	<xsl:strip-space elements="*" />

	<xsl:template match="/">(<xsl:apply-templates select="*"/>)</xsl:template>
	
	<xsl:template match="*">(<xsl:value-of select="local-name(.)"/><xsl:apply-templates select="*"/>)</xsl:template>
	
</xsl:stylesheet>

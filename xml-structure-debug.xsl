<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!--	Steve Edwards
			Callable templates to:
			- output all of the element names above a given element name
			- output a reduced form of the overall document structure
		-->

	<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
	<xsl:strip-space elements="*" />
	
	<xsl:template match="/">
		<xsl:call-template name="elements-above-given">
			<xsl:with-param name="given-element-name" select="'RETRIEVAL_REFERENCE_NUMBER_37'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="elements-above-given">
		<xsl:param name="given-element-name"/>
<!-- 
	<xsl:variable name="searched-element-name" select="'RETRIEVAL_REFERENCE_NUMBER_37'"/>
 -->	
	<xsl:variable name="found-nodes" select="//*[local-name() = $given-element-name]"/>
		
	<xsl:variable name="list-of-parent-nodes">
		<xsl:apply-templates select="$found-nodes" mode="found"/>
	</xsl:variable>
		
		<xsl:value-of select="normalize-space($list-of-parent-nodes)"></xsl:value-of>
		
	</xsl:template>
	
	<xsl:template match="*" mode="found">
		<xsl:value-of select="local-name()"/>:
		<xsl:if test=". != /">
			<xsl:apply-templates select=".." mode="found"/>
		</xsl:if>
	</xsl:template>

	
</xsl:stylesheet>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
	<xsl:template match="/">
	
		<xsl:variable name="searched-element-name" select="'RETRIEVAL_REFERENCE_NUMBER_37'"/>
		
		<xsl:variable name="found-nodes" select="//*[local-name() = $searched-element-name]"/>
		
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

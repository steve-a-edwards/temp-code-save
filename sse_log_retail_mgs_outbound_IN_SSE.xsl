<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dp="http://www.datapower.com/extensions"
	extension-element-prefixes="dp"
	exclude-result-prefixes="dp">
	
	<!-- Logging Option 1: Simple local logging in each existing application domain -->

	<xsl:template match="/">
	
		<!-- THIS SECTION MIGHT BE DIFFERENT WHERE THE ORIGINAL PAYLOAD IS INCLUDED WITHIN ENCLOSING XML -->
		<xsl:variable name="payload" select="/"/>
		<!-- ('request', 'response') -->
		<!--  <xsl:variable name="direction" select="'response'"/> -->
		<xsl:variable name="direction" select="dp:variable('var://service/transaction-rule-type')"/>
		<!-- END SECTION -->
	
		<!-- https://www.ibm.com/support/knowledgecenter/en/SS9H2Y_7.7.0/com.ibm.dp.doc/message_xsltfunction.html -->
		<xsl:variable name="log-category" select="'wsrr'"/>
		<xsl:variable name="log-level" select="'info'"/>
	
		<xsl:variable name="URI" select="dp:variable('var://service/URI')"/>
		
		<xsl:variable name="ClientIP" select="dp:request-header('X-Client-IP')"/>
		
		<xsl:variable name="log-data">
			<xsl:choose>
				<xsl:when test="$direction = 'request'">
					Direction: REQ RequestID: <xsl:value-of
						select="$payload/*[local-name()  = 'Request']/*[local-name()  = 'Header']/*[local-name()  = 'RequestID']/text()" />
				</xsl:when>
				<xsl:when test="$direction = 'response'">
					<xsl:variable name="response-code" select="dp:response-header('x-dp-response-code')"/>

					Direction: RES RequestID: <xsl:value-of
						select="$payload/*[local-name()  = 'Response']/*[local-name()  = 'Header']/*[local-name()  = 'RequestID']/text()" />
					ResponseCode: <xsl:value-of
						select="$payload/*[local-name()  = 'Response']/*[local-name()  = 'Header']/*[local-name()  = 'ResponseCode']/text()" />
					HTTP STATUS CODE: <xsl:value-of select="$response-code"/>
				</xsl:when>
				<xsl:otherwise>No code provided for direction: <xsl:value-of select="$direction"/></xsl:otherwise>
			</xsl:choose>

		</xsl:variable>
		
		<xsl:variable name="log-string" select="concat('SRC-IP: ', $ClientIP, ' URI: ', $URI, ' ', $log-data)"/>


		<xsl:message dp:priority="{$log-level}" dp:type="{$log-category}"><xsl:value-of select="normalize-space($log-string)" /></xsl:message>
		
		<!-- Carry through incoming message -->
		<xsl:copy-of select='/'/>
		
	</xsl:template>

</xsl:stylesheet>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dp="http://www.datapower.com/extensions"
	extension-element-prefixes="dp"
	exclude-result-prefixes="dp">
	
	<!--	Steve Edwards, IBM DataPower Specialist, 6th March 2019.
			Code to trigger publication events to DataPower logging system.
			Separate set up of logging target required.
			Deals with request and response formats for logging:
				/soa-infra/services/DCCI/TopUpDevice
	-->

	<xsl:template match="/">
	
		<!-- THIS SECTION MIGHT BE DIFFERENT WHERE THE ORIGINAL PAYLOAD IS INCLUDED WITHIN ENCLOSING XML -->
		<xsl:variable name="payload" select="/"/>
		<!-- END SECTION -->
		
		<xsl:variable name="direction" select="dp:variable('var://service/transaction-rule-type')"/>
		
		<!-- https://www.ibm.com/support/knowledgecenter/en/SS9H2Y_7.7.0/com.ibm.dp.doc/message_xsltfunction.html -->
		<xsl:variable name="log-category" select="'wsrr'"/>
		<xsl:variable name="log-level" select="'info'"/>
	
		<xsl:variable name="URI" select="dp:variable('var://service/URI')"/>
		
		<xsl:variable name="ClientIP" select="dp:request-header('X-Client-IP')"/>
		
		<xsl:variable name="log-data">
			<xsl:variable name="Body" select="$payload/*[local-name()  = 'Envelope']/*[local-name()  = 'Body']"/>
			<xsl:choose>
				<xsl:when test="$direction = 'request'">
					Direction: REQ 
					RETRIEVAL_REFERENCE_NUMBER_37: <xsl:value-of
						select="$Body/*[local-name()  = 'InitiateProcessPrePaymentRequest']/*[local-name()  = 'Request']/*[local-name()  = 'RETRIEVAL_REFERENCE_NUMBER_37']/text()" />
				</xsl:when>
				<xsl:when test="$direction = 'response'">
					Direction: RES 
					<xsl:variable name="Response" select="$Body/*[local-name()  = 'InitiateProcessPrePaymentResponse']/*[local-name()  = 'Response']"/>
					RETRIEVAL_REFERENCE_NUMBER_37: <xsl:value-of
						select="$Response/*[local-name()  = 'RETRIEVAL_REFERENCE_NUMBER_37']/text()" />
					UTRN_125: <xsl:value-of
						select="$Response/*[local-name()  = 'UTRN_125']/text()" />
					<xsl:variable name="response-code" select="dp:response-header('x-dp-response-code')"/>
					HTTP STATUS CODE: <xsl:value-of select="$response-code"/>
				</xsl:when>
				<xsl:otherwise>No code provided for direction: <xsl:value-of select="$direction"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="log-string" select="concat('SRC-IP: ', $ClientIP, ' URI: ', $URI, ' ', $log-data)"/>

		<xsl:message dp:priority="{$log-level}" dp:type="{$log-category}">Log string: <xsl:value-of select="normalize-space($log-string)" /></xsl:message>
		
		<!-- Carry through incoming message -->
		<xsl:copy-of select='/'/>
		
	</xsl:template>

</xsl:stylesheet>

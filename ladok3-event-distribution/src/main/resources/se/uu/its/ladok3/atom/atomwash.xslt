<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:template match="/atom:entry/atom:content">
    <xsl:value-of select="."/></td>
  </xsl:template>
</xsl:stylesheet>
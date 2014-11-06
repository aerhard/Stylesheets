<?xml version="1.0" encoding="utf-8"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.tei-c.org/ns/1.0"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns:teix="http://www.tei-c.org/ns/Examples" xmlns:iso="http://www.iso.org/ns/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
	xmlns:o="urn:schemas-microsoft-com:office:office"
	xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
	xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
	xmlns:v="urn:schemas-microsoft-com:vml" xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
	xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
	xmlns:w10="urn:schemas-microsoft-com:office:word"
	xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
	xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
	xmlns:mml="http://www.w3.org/1998/Math/MathML"
	xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
	xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
	xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0" version="2.0" exclude-result-prefixes="#all">
	<!-- import default conversion style -->
	<xsl:import href="../../default/docx/from.xsl"/>
	<xsl:import href="tables.xsl"/>
	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
		<desc>
			<p>Conversion profile of the project Richard Strauss: Werke</p>
			<p>This software is dual-licensed: 1. Distributed under a Creative Commons Attribution-ShareAlike 3.0 Unported License http://creativecommons.org/licenses/by-sa/3.0/ 2. http://www.opensource.org/licenses/BSD-2-Clause Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met: * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution. This software is provided by the copyright holders and contributors "as is" and any express or implied warranties, including, but not limited to, the implied warranties of merchantability and fitness for a particular purpose are disclaimed. In no event shall the copyright holder or contributors be liable for any direct, indirect, incidental, special, exemplary, or consequential damages (including, but not limited to, procurement of substitute goods or services; loss of use, data, or profits; or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this software, even if advised of the possibility of such damage. </p>
			<p>Author: Alexander Erhard</p>
		</desc>
	</doc>
	
	<xsl:template match="tei:hi[@rend='Sigle_Quelle']" mode="pass2">
		<xsl:variable name="content">
			<xsl:apply-templates select="@*[not(name()='rend')]|text()|node()" mode="pass2"/>
			<xsl:variable name="following-node" select="following-sibling::node()[1]"/>
			<xsl:if test="$following-node[tei:seg/@rend] and $following-node[@rend='Sigle_Quelle']">
				<xsl:copy-of select="$following-node/node()"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="siglum-flat" select="replace(string($content), '\*', '_asterisk')"></xsl:variable>
		<ref type="siglum" target="q:{$siglum-flat}">
			<xsl:copy-of select="$content"/>
		</ref>
	</xsl:template>
	
	<xsl:template match="tei:hi[@rend='Sigle_Quelle'][tei:seg/@rend]" mode="pass2"/>

	<xsl:template match="tei:hi[@rend='Sigle_Signatur']" mode="pass2">
		<idno><xsl:apply-templates select="@*[not(name()='rend')]|text()|node()" mode="pass2"/></idno>
	</xsl:template>

	<xsl:template match="tei:hi[@rend='Werktitel']" mode="pass2">
		<title type="main"><xsl:apply-templates select="@*[not(name()='rend')]|text()|node()" mode="pass2"/></title>
	</xsl:template>
	
	<xsl:template match="tei:table[@rend='TabelleRubrik']" mode="pass2">
		<list type="gloss">
			<xsl:for-each select="tei:row">
				<label><xsl:apply-templates select="tei:cell[1]/*|tei:cell[1]/node()" mode="pass2"/></label>
				<item><xsl:apply-templates select="tei:cell[2]/*|tei:cell[2]/node()" mode="pass2"/></item>
			</xsl:for-each>
		</list>
	</xsl:template>
	
</xsl:stylesheet>
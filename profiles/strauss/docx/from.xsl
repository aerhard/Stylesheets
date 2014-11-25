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
	xmlns:functx="http://www.functx.com"
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
	
	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
		<desc>The path to the file with the character declarations used for mapping glyph proxy strings (#p#) to glyph references (&lt;g ref="g:dynamicPiano"/>)</desc>
	</doc>
	<xsl:param name="charDeclFilePath">../../../../../data/RSW/RSW_glyphs.xml</xsl:param>
	
	<xsl:function name="functx:escape-for-regex" as="xs:string">
		<xsl:param name="arg" as="xs:string?"/>
		<xsl:sequence select="
			replace($arg,
			'(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
			"/>
	</xsl:function>
	
	<xsl:variable name="glyphMappings" select="document($charDeclFilePath)//mapping[@type='plain-text']"/>
	
	<xsl:variable name="glyphMappingRegex">
		<xsl:variable name="escapedGlyphMappings">
			<xsl:for-each select="$glyphMappings">
				<item><xsl:value-of select="functx:escape-for-regex(.)"/></item>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="string-join($escapedGlyphMappings/item, '|')"></xsl:value-of>
	</xsl:variable>

	<!--<xsl:template match="tei:hi[@rend='Sigle_Quelle']" mode="pass2">
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
	
	<xsl:template match="tei:hi[@rend='Sigle_Quelle'][tei:seg/@rend]" mode="pass2"/>-->

	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
		<desc>New root template: apply root template from import and post-process that output in "strauss-custom" mode.</desc>
	</doc>
	<xsl:template match="/">
		<xsl:variable name="teiConversion">
			<xsl:apply-imports/>
		</xsl:variable>
<!--		<a><xsl:value-of select="$charDeclFilePath"></xsl:value-of></a>-->
<!--		<a>
			<xsl:copy-of select="$glyphMappingRegex"/>
		</a>-->
		<xsl:apply-templates select="$teiConversion" mode="strauss-custom"/>
	</xsl:template>

	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
		<desc>Identity tranformation for all nodes but text()</desc>
	</doc>
	<xsl:template match="@*|comment()|processing-instruction()" mode="strauss-custom">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="*" mode="strauss-custom">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="strauss-custom"/>
		</xsl:copy>
	</xsl:template>
	
	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
		<desc>Copy text / replace glyph proxy strings with <b>g</b> glyph referenes.</desc>
	</doc>
	<xsl:template match="text()" mode="strauss-custom">
		<xsl:analyze-string select="." regex="{$glyphMappingRegex}">
			<xsl:matching-substring>
				<xsl:variable name="this" select="."></xsl:variable>
				<g ref="g:{$glyphMappings[text()=$this]/../@xml:id}"></g>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>


	<!-- templates in "strauss-custom" mode -->

	<xsl:template match="figure" mode="strauss-custom">
		<figure xml:id="TOF-{format-number(count(preceding::figure)+1, '0000')}">
			<xsl:apply-templates select="@*[not(name()='id')]|node()" mode="strauss-custom"/>
		</figure>
	</xsl:template>

	<xsl:template match="graphic" mode="strauss-custom">
		<xsl:copy>
			<xsl:apply-templates select="@*[not(name()=('n', 'rend'))]" mode="strauss-custom"/>
		</xsl:copy>
	</xsl:template>

	<!-- blockquotes are marked with paragraph style templates in Word; this can lead to ambiguity when there are multiple Bolockzitat_T paragraph styles
	in a row 1) a sequence of distinct blockquotes? 2) a single blockquote with multiple paragraphs. Might be OK as long as each paragraph only consists of 
	a single paragraph. -->
	<xsl:template match="p[@rend='Blockzitat_T']" mode="strauss-custom">
		<cit rend="block">
			<quote>
				<xsl:copy>
					<xsl:apply-templates select="@*[not(name()='rend')]|node()" mode="strauss-custom"/>
				</xsl:copy>
			</quote>
		</cit>
	</xsl:template>

	<xsl:template match="hi[@rend='Sigle_Quelle']" mode="strauss-custom">
		<xsl:if test="normalize-space(.)">
			<xsl:variable name="content">
				<xsl:choose>
					<xsl:when test="contains(string(.), '#')">
						<xsl:value-of select="substring-before(., '#')"/>
						<hi rend="sub"><xsl:value-of select="substring-after(., '#')"/></hi>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="siglum-flat" select="replace(replace(replace(string($content), '\*', '_a_'), '/', '_s_'), '[\-|–]', '_t_')"></xsl:variable>
			<ref type="siglum" target="q:{$siglum-flat}">
				<xsl:copy-of select="$content"/>
			</ref>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@rend[.='footnote text']" mode="strauss-custom"/>
	<xsl:template match="note/@n" mode="strauss-custom"/>
	
	<xsl:template match="table/@rend[.='TabelleKorr']" mode="strauss-custom"/>
	<xsl:template match="div[table/@rend='TabelleKorr']" mode="strauss-custom">
		<xsl:copy>
			<xsl:attribute name="type">revisions</xsl:attribute>
			<xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="strauss-custom"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="table/@rend[.='TabelleTKA']" mode="strauss-custom"/>
	<xsl:template match="div[table/@rend='TabelleTKA']" mode="strauss-custom">
		<xsl:copy>
			<xsl:attribute name="type">editorial-interventions</xsl:attribute>
			<xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="strauss-custom"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="table/@rend[.='TabelleIA']" mode="strauss-custom"/>
	<xsl:template match="div[table/@rend='TabelleIA']" mode="strauss-custom">
		<xsl:copy>
			<xsl:attribute name="type">variants</xsl:attribute>
			<xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="strauss-custom"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="cell[hi/@rend='Tabellenkopf']" mode="strauss-custom">
		<xsl:copy>
		<xsl:attribute name="role">label</xsl:attribute>
			<xsl:apply-templates select="@*|hi/node()" mode="strauss-custom"></xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="hi[@rend='Vortrag_Allegro']" mode="strauss-custom">
		<term type="musical" subtype="tempo">
			<xsl:apply-templates select="@*[not(name()='rend')]|node()" mode="strauss-custom"></xsl:apply-templates>
		</term>
	</xsl:template>
	<xsl:template match="hi[@rend='Vortrag_cresc']" mode="strauss-custom">
		<term type="musical" subtype="dynamic">
			<xsl:apply-templates select="@*[not(name()='rend')]|node()" mode="strauss-custom"></xsl:apply-templates>
		</term>
	</xsl:template>
	<xsl:template match="hi[@rend='Vortrag_divisi']" mode="strauss-custom">
		<term type="musical" subtype="directive">
			<xsl:apply-templates select="@*[not(name()='rend')]|node()" mode="strauss-custom"></xsl:apply-templates>
		</term>
	</xsl:template>
	<xsl:template match="hi[@rend='Vortrag_sprechend']" mode="strauss-custom">
		<term type="musical" subtype="directive">
			<xsl:apply-templates select="@*[not(name()='rend')]|node()" mode="strauss-custom"></xsl:apply-templates>
		</term>
	</xsl:template>
	<xsl:template match="hi[@rend='Regie']" mode="strauss-custom">
		<q>
			<xsl:apply-templates select="@*[not(name()='rend')]|node()" mode="strauss-custom"></xsl:apply-templates>
		</q>
	</xsl:template>
	
	<xsl:template match="hi[@rend='Tonname']" mode="strauss-custom">
		<term type="musical" subtype="pitch">
			<xsl:analyze-string select="." regex="(^[a-zA-Z]+)(\d)*$">
				<xsl:matching-substring>
					<xsl:value-of select="regex-group(1)"></xsl:value-of>
					<xsl:if test="regex-group(2)">
						<xsl:variable name="supSub">
							<xsl:choose>
								<!-- if the string starts with an upper-case letter, set hi/@rend=sub, otherwise sup -->
								<xsl:when test="matches(regex-group(1),'^[ABCDEFGAH]')">sub</xsl:when>
								<xsl:otherwise>sup</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<hi rend="{$supSub}"><xsl:value-of select="regex-group(2)"></xsl:value-of></hi>
					</xsl:if>
				</xsl:matching-substring>
				<xsl:non-matching-substring>
					<xsl:variable name="msg">FEHLER: Tonname "<xsl:value-of select="."/>" konnte nicht konvertiert werden.</xsl:variable>
					<xsl:comment><xsl:value-of select="$msg"/></xsl:comment>
					<xsl:message><xsl:value-of select="$msg"/></xsl:message>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
		</term>
	</xsl:template>

	<xsl:template match="hi[@rend='Sigle_Signatur']" mode="pass2">
		<idno type="signature"><xsl:apply-templates select="@*[not(name()='rend')]|text()|node()" mode="pass2"/></idno>
	</xsl:template>

	<xsl:template match="hi[@rend='Werktitel']" mode="strauss-custom">
		<title type="main"><xsl:apply-templates select="@*[not(name()='rend')]|text()|node()" mode="strauss-custom"/></title>
	</xsl:template>
	
	<xsl:template match="table[@rend='TabelleRubrik']" mode="strauss-custom">
		<list type="gloss">
			<xsl:for-each select="row">
				<label><xsl:apply-templates select="cell[1]/*|cell[1]/node()" mode="strauss-custom"/></label>
				<item><xsl:apply-templates select="cell[2]/*|cell[2]/node()" mode="strauss-custom"/></item>
			</xsl:for-each>
		</list>
	</xsl:template>
	
	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
		<desc>Extract msDescs from all divs with a header containing only a siglum</desc>
	</doc>
	<xsl:template match="div[head/hi/@rend='Sigle_Quelle'][count(head/node())=1]" mode="strauss-custom">
		<xsl:variable name="siglum">
			<xsl:apply-templates select="head/hi" mode="strauss-custom"/>
		</xsl:variable>
		<msDesc xml:id="{substring-after($siglum//@target, 'q:')}">
			<msIdentifier>
				<repository>[Angabe fehlt]</repository>
				<idno>[Angabe fehlt]</idno>
			</msIdentifier>
			<xsl:for-each select="p">
				<head><xsl:apply-templates select="node()" mode="strauss-custom"/></head>
			</xsl:for-each>
			<ab type="siglum"><xsl:copy-of select="$siglum//ref/node()"/></ab>
			<xsl:for-each select="div">
				<xsl:apply-templates select="." mode="strauss-inMsDesc"/>
			</xsl:for-each>
			
		</msDesc>
	</xsl:template>
	
	<xsl:template match="div" mode="strauss-inMsDesc">
		<ab>
			<xsl:attribute name="type">physDesc</xsl:attribute>
			<xsl:apply-templates mode="strauss-custom"/>
		</ab>
	</xsl:template>
	
	<xsl:template match="head[.='Physische Angaben']" mode="strauss-custom">
		<xsl:attribute name="type">physDesc</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="head[.='Inhalt']" mode="strauss-custom">
		<xsl:attribute name="type">content</xsl:attribute>
	</xsl:template>

	<xsl:template match="div[head='Bemerkung']" mode="strauss-inMsDesc">
		<ab type="remarks">
			<note>
				<ab type="head">Bemerkung</ab>
				<xsl:apply-templates select="table/node()" mode="strauss-custom"/>
			</note>			
		</ab>
	</xsl:template>
	
	<xsl:template match="div[head='Bemerkungen']" mode="strauss-inMsDesc">
		<ab type="remarks">
			<note>
				<ab type="head">Bemerkung</ab>
				<xsl:apply-templates select="table/node()" mode="strauss-custom"/>
			</note>			
		</ab>
	</xsl:template>
	
	<xsl:template match="div[contains(head/text(),'Korrekturverzeichnis')][table]" mode="strauss-inMsDesc">
		<ab type="revisions">
			<table>
				<head><xsl:apply-templates select="head/node()" mode="strauss-custom"/></head>
				<xsl:apply-templates select="table/node()" mode="strauss-custom"/>
			</table>
		</ab>
	</xsl:template>

</xsl:stylesheet>
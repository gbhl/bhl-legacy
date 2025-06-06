<?xml version="1.0" encoding="ucs-2"?>
<xsl:stylesheet version="1.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/>

	<xsl:template match="/">
		<html>
			<xsl:apply-templates/>
		</html>
	</xsl:template>

	<xsl:template match="marc:leader">
		<p class="bibHead">LEADER</p>
		<xsl:variable name="leader" select="text()"/>
		<xsl:variable name="leader5" select="substring($leader,6,1)"/>
		<xsl:variable name="leader6" select="substring($leader,7,1)"/>
		<xsl:variable name="leader7" select="substring($leader,8,1)"/>
		<xsl:variable name="leader8" select="substring($leader,9,1)"/>
		<xsl:variable name="leader9" select="substring($leader,10,1)"/>
		<xsl:variable name="leader17" select="substring($leader,18,1)"/>
		<xsl:variable name="leader18" select="substring($leader,19,1)"/>
		<xsl:variable name="leader19" select="substring($leader,20,1)"/>
		<ul>
			<li>Record Status:
			<span class="bibValue"><xsl:value-of select="$leader5"/></span>
			</li>
			<li>Type of record:
			<span class="bibValue"><xsl:value-of select="$leader6"/></span>
			</li>
			<li>Bibliographic level:
			<span class="bibValue"><xsl:value-of select="$leader7"/></span>
			</li>
			<li>Type of control:
			<span class="bibValue"><xsl:value-of select="$leader8"/></span>
			</li>
			<li>Undefined:
			<span class="bibValue"><xsl:value-of select="$leader9"/></span>
			</li>
			<li>Encoding level:
			<span class="bibValue"><xsl:value-of select="$leader17"/></span>
			</li>
			<li>Descriptive cataloging form:
			<span class="bibValue"><xsl:value-of select="$leader18"/></span>
			</li>
			<li>Linked record requirement:
			<span class="bibValue"><xsl:value-of select="$leader19"/></span>
			</li>
		</ul>
	</xsl:template>

	<xsl:template match="marc:controlfield">
		<p class="bibHead">CONTROL FIELD</p>
		<ul>
			<xsl:for-each select=".">
				<li>Control Field <xsl:value-of select="@tag" />: 
				<span class="bibValue"><xsl:value-of select="text()" /></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	
	<xsl:template match="marc:datafield[@tag=010]">
		<p class="bibHead">LIBRARY OF CONGRESS CONTROL NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>LC control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>NUCMC control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Cancelled/invalid LC control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=011]">
		<p class="bibHead">LINKING LIBRARY OF CONGRESS CONTROL NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Linking LC control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=013]">
		<p class="bibHead">PATENT CONTROL INFORMATION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Country:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Type of number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Status:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Party to document:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=014]">
		<p class="bibHead">LINKAGE NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Linkage number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Source of number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Cancelled/invalid linkage number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=015]">
		<p class="bibHead">NATIONAL BIBLIOGRAPHY NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>National bibliography number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=016]">
		<p class="bibHead">NATIONAL BIBLIOGRAPHIC AGENCY CONTROL NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Canceled/invalid control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=017]">
		<p class="bibHead">COPYRIGHT REGISTRATION NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Copyright registration number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Source (agency assigning number):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=018]">
		<p class="bibHead">COPYRIGHT ARTICLE-FEE CODE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Copyright article-fee code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=020]">
		<p class="bibHead">INTERNATIONAL STANDARD BOOK NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Binding information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Terms of availability:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Cancelled/invalid ISBN:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=022]">
		<p class="bibHead">INTERNATIONAL STANDARD SERIAL NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Incorrect ISSN:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Cancelled ISSN:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=024]">
		<p class="bibHead">OTHER STANDARD IDENTIFIER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Standard recording code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Terms of availability:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Additional codes following the standard number or code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Cancelled/invalid standard code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of code or number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=025]">
		<p class="bibHead">OVERSEAS ACQUISITION NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Overseas acquisition number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=027]">
		<p class="bibHead">STANDARD TECHNICAL REPORT NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Standard Technical Report Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Cancelled/invalid STRN:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=028]">
		<p class="bibHead">PUBLISHER NUMBER FOR MUSIC
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Publisher number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=030]">
		<p class="bibHead">CODEN DESIGNATION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>CODEN:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Cancelled/invalid CODEN:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=032]">
		<p class="bibHead">POSTAL REGISTRATION NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Postal registration number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Source (agency assigning number):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=033]">
		<p class="bibHead">DATE/TIME AND PLACE OF AN EVENT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Formatted date/time:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Geographic classification area code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Geographic classification subarea code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=034]">
		<p class="bibHead">CODED CARTOGRAPHIC MATHEMATICAL DATA
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Category of scale:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Constant ratio linear horizontal scale:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Constant ratio linear vertical scale:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Coordinates--westernmost longitude:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Coordinates--easternmost longitude:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Coordinates--northernmost latitude:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Coordinates--southernmost latitude:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Angular scale:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Declination--northern limit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Declination--southern limit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Right ascension--eastern limit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Right ascension--western limit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Equinox:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>G-ring latitude:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>G-ring longitude:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=035]">
		<p class="bibHead">SYSTEM CONTROL NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>System control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Cancelled/invalid system control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=036]">
		<p class="bibHead">ORIGINAL STUDY NUMBER FOR COMPUTER DATA FILES
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Original study number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Source (agency assigning number):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=037]">
		<p class="bibHead">SOURCE OF ACQUISITION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Stock number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Source of stock number/acquisition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Terms of availability:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Form of issue:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Additional format characteristics:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=039]">
		<p class="bibHead">LEVEL OF BIBLIOGRAPHIC CONTROL AND CODING DETAIL
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Level of rules in bibliographic description:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Level of effort used to assign nonsubject heading access points:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Level of effort used to assign subject headings:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Level of effort used to assign classification:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Number of fixed field character positions coded:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=040]">
		<p class="bibHead">CATALOGING SOURCE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Original cataloging agency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Language of cataloging:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Transcribing agency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Modifying agency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Description conventions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=041]">
		<p class="bibHead">LANGUAGE CODE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Language code of text/sound track or separate title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Language code of summary or abstract/overprinted title or subtitle:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Language code of sung or spoken text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Language code of librettos:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Language code of table of contents:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Language code of accompanying material other than librettos:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Language code of original and/or intermediate translations of text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=042]">
		<p class="bibHead">AUTHENTICATION CODE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Authentication code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=043]">
		<p class="bibHead">GEOGRAPHIC AREA CODE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Geographic area code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Local GAC code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of local code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=044]">
		<p class="bibHead">COUNTRY OF PUBLISHING/PRODUCING ENTITY CODE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Country of publishing/producing entity code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Local subentity code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>ISO subentity code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of local subentity data:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=045]">
		<p class="bibHead">TIME PERIOD OF CONTENT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Time period code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Formatted 9999 B.C. through A.D. time period:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Formatted pre-9999 B.C. time period:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=046]">
		<p class="bibHead">SPECIAL CODED DATES
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Type of date code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Date 1 (B.C. date):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Date 1 (A.D. date):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date 2 (B.C. date):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Date 2 (A.D. date):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=047]">
		<p class="bibHead">FORM OF MUSICAL COMPOSITION CODE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Form of musical composition code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=048]">
		<p class="bibHead">NUMBER OF MUSICAL INSTRUMENTS OR VOICES CODE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Performer or ensemble:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Soloist:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=050]">
		<p class="bibHead">LIBRARY OF CONGRESS CALL NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and number sequence:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Classification number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Supplementary class number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=051]">
		<p class="bibHead">LIBRARY OF CONGRESS COPY, ISSUE, OFFPRINT STATEMENT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Classification number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Copy information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=052]">
		<p class="bibHead">GEOGRAPHIC CLASSIFICATION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Geographic classification area code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Geographic classification subarea code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Subject:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Populated place name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Code source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=055]">
		<p class="bibHead">CALL NUMBERS/CLASS NUMBERS ASSIGNED IN CANADA
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Classification number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of call/class number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=058]">
		<p class="bibHead">OTHER GEOGRAPHIC CLASSIFICATION CODE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Geographic classification area code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Geographic classification subarea code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Code source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=060]">
		<p class="bibHead">NATIONAL LIBRARY OF MEDICINE CALL NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Classification number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=061]">
		<p class="bibHead">NATIONAL LIBRARY OF MEDICINE COPY STATEMENT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Classification number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Copy information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=066]">
		<p class="bibHead">CHARACTER SETS PRESENT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Non-ASCII G0 default character set designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Non-ANSEL G1 default character set designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Alternate graphic character set identification:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=070]">
		<p class="bibHead">NATIONAL AGRICULTURAL LIBRARY CALL NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Classification number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=071]">
		<p class="bibHead">NATIONAL AGRICULTURAL LIBRARY COPY STATEMENT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Classification number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Copy information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=072]">
		<p class="bibHead">SUBJECT CATEGORY CODE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Subject category code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Subject category code subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Code source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=073]">
		<p class="bibHead">TYPE OF PROGRAM OR ORGANIZATION CODE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Type of program or organization code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Code source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=074]">
		<p class="bibHead">GPO ITEM NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>GPO item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Cancelled/invalid GPO item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=080]">
		<p class="bibHead">UNIVERSAL DECIMAL CLASSIFICATION NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Universal Decimal Classification number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Common auxiliary subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Edition identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=082]">
		<p class="bibHead">DEWEY DECIMAL CALL NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Classification number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>DDC number--abridged NST version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Edition number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=084]">
		<p class="bibHead">OTHER CLASSIFICATION NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Classification number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=086]">
		<p class="bibHead">GOVERNMENT DOCUMENT CLASSIFICATION NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Classification number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Cancelled/invalid classification number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Number source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=088]">
		<p class="bibHead">REPORT NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Cancelled/invalid report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=090]">
		<p class="bibHead">LOCAL CALL NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Local class number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Local Cutter number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=091]">
		<p class="bibHead">MICROFILM SHELF LOCATION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Microfilm shelf location:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=100]">
		<p class="bibHead">MAIN ENTRY--PERSONAL NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Personal name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Numeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Titles and other words associated with a name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Dates associated with a name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Attribution qualifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Fuller form of name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=110]">
		<p class="bibHead">MAIN ENTRY--CORPORATE NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Corporate name or jurisdiction name as entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Subordinate unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Location of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of meeting or treaty signing:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section/meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=111]">
		<p class="bibHead">MAIN ENTRY--MEETING NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Meeting name or jurisdiction name as entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Number (BK CF MP MU SE VM MX):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Location of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Subordinate unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section/meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Name of meeting following jurisdiction name entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=130]">
		<p class="bibHead">MAIN ENTRY--UNIFORM TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of treaty signing:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=210]">
		<p class="bibHead">ABBREVIATED TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Abbreviated title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=211]">
		<p class="bibHead">ACRONYM OR SHORTENED TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Acronym or shortened title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=212]">
		<p class="bibHead">VARIANT ACCESS TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Variant access title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=214]">
		<p class="bibHead">AUGMENTED TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Augmented title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=222]">
		<p class="bibHead">KEY TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Key title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=240]">
		<p class="bibHead">UNIFORM TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of treaty signing:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=241]">
		<p class="bibHead">ROMANIZED TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Romanized title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=242]">
		<p class="bibHead">TRANSLATION OF TITLE BY CATALOGING AGENCY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Remainder of title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Remainder of title page transcription /statement of responsibility:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Designation of section:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Name of part/section (BK AM MP MU VM SE):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Language code of translated title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=243]">
		<p class="bibHead">COLLECTIVE UNIFORM TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of treaty signing:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=245]">
		<p class="bibHead">TITLE STATEMENT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Remainder of title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Remainder of title page transcription/statement of responsibility:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Designation of section:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Name of part/section (SE):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Inclusive dates:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Bulk dates:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=246]">
		<p class="bibHead">VARYING FORM OF TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Title proper/short title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Remainder of title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Designation of section:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Name of part/section (SE):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Designation of volume and issue number and/or date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=247]">
		<p class="bibHead">FORMER TITLE OR TITLE VARIATIONS
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Title proper/short title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Remainder of title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Designation of section:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Name of part/section (SE):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Designation of volume and issue number and/or date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=250]">
		<p class="bibHead">EDITION STATEMENT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Edition statement:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Remainder of edition statement:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=254]">
		<p class="bibHead">MUSICAL PRESENTATION STATEMENT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Musical presentation statement:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=255]">
		<p class="bibHead">CARTOGRAPHIC MATHEMATICAL DATA
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Statement of scale:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Statement of projection:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Statement of coordinates:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Statement of zone:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Statement of equinox:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Outer G-ring coordinate pairs:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Exclusion G-ring coordinate pairs:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=256]">
		<p class="bibHead">COMPUTER FILE CHARACTERISTICS
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Computer file characteristics:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=257]">
		<p class="bibHead">COUNTRY OF PRODUCING ENTITY FOR ARCHIVAL FILMS
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Country of producing entity for archival films:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=260]">
		<p class="bibHead">PUBLICATION, DISTRIBUTION, ETC. (IMPRINT)
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Place of publication, distribution, etc.:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Name of publisher, distributor, etc.:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Date of publication, distribution, etc.:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Place of manufacture:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Manufacturer:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Date of manufacture:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=263]">
		<p class="bibHead">PROJECTED PUBLICATION DATE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Projected publication date:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=265]">
		<p class="bibHead">SOURCE FOR ACQUISITION/SUBSCRIPTION ADDRESS
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Source for acquisition/subscription address:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=270]">
		<p class="bibHead">ADDRESS
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Address:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>270-b = City:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>State or province:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Country:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Postal code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Title preceding attention name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Attention name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Title following attention name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Type of address:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Specialized telephone number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Telephone number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Fax number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Electronic mail address:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>TDD or TTY number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Contact person:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Title of contact person:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Hours:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=300]">
		<p class="bibHead">PHYSICAL DESCRIPTION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Extent:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Other physical details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Dimensions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Accompanying material:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Type of unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Size of unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=301]">
		<p class="bibHead">PHYSICAL DESCRIPTION FOR FILMS (PRE-AACR 2)
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Extent of item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Sound characteristics:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Color characteristics:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Dimensions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Accompanying material:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Speed:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=302]">
		<p class="bibHead">PAGE OR ITEM COUNT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Page count:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=303]">
		<p class="bibHead">SUBORDINATE ENTITIES
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Name or description:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Schedule:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Location:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Contact person:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=304]">
		<p class="bibHead">LINEAR FOOTAGE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Linear footage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=305]">
		<p class="bibHead">PHYSICAL DESCRIPTION FOR SOUND RECORDINGS (Pre-AACR 2)
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Extent:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Other physical details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Dimensions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Microgroove or standard:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Stereophonic, monaural:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Number of tracks:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Serial identification:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Matrix and/or take number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=306]">
		<p class="bibHead">PLAYING TIME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Playing time:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=307]">
		<p class="bibHead">HOURS, ETC.
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Hours:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Additional information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=308]">
		<p class="bibHead">PHYSICAL DESCRIPTION FOR FILMS (ARCHIVAL)
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Number of reels:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Footage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Sound characteristics:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Color characteristics:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Width:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Presentation format:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=310]">
		<p class="bibHead">CURRENT PUBLICATION FREQUENCY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Current publication frequency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Date of current publication frequency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=311]">
		<p class="bibHead">MEETING ROOMS AND FACILITIES AVAILABLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>General description of facilities:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Name and location:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Physical description:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Capacity:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Equipment available:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Rental fee:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Special restrictions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Accommodations for the disabled:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Contact person:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=312]">
		<p class="bibHead">EQUIPMENT AVAILABLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Type of equipment:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Brand name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Physical description:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Rental fee:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Special restrictions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Accommodations for the disabled:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Contact person:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=315]">
		<p class="bibHead">FREQUENCY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Frequency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Dates of frequency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=321]">
		<p class="bibHead">FORMER PUBLICATION FREQUENCY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Former publication frequency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Dates of former publication frequency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=340]">
		<p class="bibHead">PHYSICAL MEDIUM
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Material base and configuration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Dimensions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Materials applied to surface:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Information recording technique:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Support:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Production rate/ratio:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Location within medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Technical specifications of medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=342]">
		<p class="bibHead">GEOSPATIAL REFERENCE DATA
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Coordinate or distance units:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Latitude resolution:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Longitude resolution:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Standard parallel or oblique line latitude:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Oblique line longitude:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Longitude of central meridian or projection center:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Latitude of projection origin or projection center:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>False easting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>False northing:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Scale factor:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Height of perspective point above surface:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Azimuthal angle:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Azimuth measure point longitude or straight vertical longitude from pole:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Landsat number and path number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Zone identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Ellipsoid name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Semi-major axis:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Denominator of flattening ratio:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Vertical resolution:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Vertical encoding method:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Local planar, local, or other projection or grid description:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Local planar or local georeference information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Reference method used:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=343]">
		<p class="bibHead">PLANAR COORDINATE DATA
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Planar coordinate encoding method:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Planar distance units:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Abscissa resolution:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Ordinate resolution:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Distance resolution:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Bearing resolution:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Bearing units:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Bearing reference direction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Bearing reference meridian:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='=']">
				<li>ICE:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Price:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Form of issue:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=351]">
		<p class="bibHead">ORGANIZATION AND ARRANGEMENT OF MATERIALS
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Organization:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Arrangement:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Hierarchical level:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=352]">
		<p class="bibHead">DIGITAL GRAPHIC REPRESENTATION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Direct reference method:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Object type:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Object count:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Row count:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Column count:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Vertical count:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Indirect reference description:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=355]">
		<p class="bibHead">SECURITY CLASSIFICATION CONTROL
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Security classification:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Handling instructions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>External dissemination information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Downgrading or declassification event:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Classification system:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Country of origin code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Downgrading date:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Declassification date:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Authorization:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=357]">
		<p class="bibHead">ORIGINATOR DISSEMINATION CONTROL
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Originator control term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Originating agency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Authorized recipients of material:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Other restrictions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=359]">
		<p class="bibHead">RENTAL PRICE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Rental price:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=362]">
		<p class="bibHead">DATES OF PUBLICATION AND/OR SEQUENTIAL DESIGNATION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Dates of publication and/or sequential designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Source of information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=440]">
		<p class="bibHead">SERIES STATEMENT/ADDED ENTRY--TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Volume number/sequential designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=490]">
		<p class="bibHead">SERIES STATEMENT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Series statement:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Library of Congress call number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Volume number/sequential designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=500]">
		<p class="bibHead">GENERAL NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>General note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Library of Congress call number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Source of note information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=501]">
		<p class="bibHead">WITH NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>With note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=502]">
		<p class="bibHead">DISSERTATION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Dissertation note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=503]">
		<p class="bibHead">BIBLIOGRAPHIC HISTORY NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Bibliographic history note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=504]">
		<p class="bibHead">BIBLIOGRAPHY, ETC. NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Bibliography, etc. note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Number of references:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=505]">
		<p class="bibHead">FORMATTED CONTENTS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Formatted contents note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Statement of responsibility:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Uniform Resource Identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=506]">
		<p class="bibHead">RESTRICTIONS ON ACCESS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Terms governing access:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Jurisdiction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Physical access provisions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Authorized users:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Authorization:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=507]">
		<p class="bibHead">SCALE NOTE FOR GRAPHIC MATERIAL
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Representative fraction of scale note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Remainder of scale note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=508]">
		<p class="bibHead">CREATION/PRODUCTION CREDITS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Creation/production credits note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=510]">
		<p class="bibHead">CITATION/REFERENCES NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Name of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Dates of coverage of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Location within source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=511]">
		<p class="bibHead">PARTICIPANT OR PERFORMER NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Participant or performer note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=512]">
		<p class="bibHead">EARLIER OR LATER VOLUMES SEPARATELY CATALOGED NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Earlier or later volumes separately cataloged note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=513]">
		<p class="bibHead">TYPE OF REPORT AND PERIOD COVERED NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Type of report:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Period covered:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=514]">
		<p class="bibHead">DATA QUALITY NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Attribute accuracy report:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Attribute accuracy value:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Attribute accuracy explanation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Logical consistency report:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Completeness report:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Horizontal position accuracy report:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Horizontal position accuracy value:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Horizontal position accuracy explanation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Vertical positional accuracy report:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Vertical positional accuracy value:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Vertical positional accuracy explanation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Cloud cover:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Uniform Resource Identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Display note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=515]">
		<p class="bibHead">NUMBERING PECULIARITIES NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Numbering peculiarities note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Source of note information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=516]">
		<p class="bibHead">TYPE OF COMPUTER FILE OR DATA NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Type of computer file or data note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=517]">
		<p class="bibHead">CATEGORIES OF FILMS NOTE (ARCHIVAL)
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Different formats:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Content descriptors:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Additional animation techniques:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=518]">
		<p class="bibHead">DATE/TIME AND PLACE OF AN EVENT NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Date/time and place of an event note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=520]">
		<p class="bibHead">SUMMARY, ETC.
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Summary, etc.:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Expansion of summary note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Uniform Resource Identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Source of note information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=521]">
		<p class="bibHead">TARGET AUDIENCE NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Target audience note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=522]">
		<p class="bibHead">GEOGRAPHIC COVERAGE NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Geographic coverage note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=523]">
		<p class="bibHead">TIME PERIOD OF CONTENT NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Time period of content note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Dates of data collection note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=524]">
		<p class="bibHead">PREFERRED CITATION OF DESCRIBED MATERIALS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Preferred citation of described materials note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of schema used:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=525]">
		<p class="bibHead">SUPPLEMENT NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Supplement note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Source of note information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=526]">
		<p class="bibHead">STUDY PROGRAM INFORMATION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Program name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Interest level:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Reading level:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Title point value:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Nonpublic note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=527]">
		<p class="bibHead">CENSORSHIP NOTE
</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Censorship note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=530]">
		<p class="bibHead">ADDITIONAL PHYSICAL FORM AVAILABLE NOTE
</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Additional physical form available note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Availability source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Availability conditions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Order number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Uniform Resource Identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Source of note information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=531]">
		<p class="bibHead">ELIGIBILITY, FEES, PROCEDURES NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Eligibility:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Fee:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Admission procedures:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Documents required:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Waiting list:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Waiting period:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=533]">
		<p class="bibHead">REPRODUCTION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Type of reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Place of reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Agency responsible for reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Physical description of reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Series statement of reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Dates of publication and/or sequential designation of issues reproduced:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note about reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Fixed-length data elements of reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=534]">
		<p class="bibHead">ORIGINAL VERSION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry of original:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition statement of original:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Publication, distribution, etc. of original:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Physical description, etc. of original:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Series statement of original:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Key title of original:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Location of original:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note about original:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Introductory phrase:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title statement of original:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=535]">
		<p class="bibHead">LOCATION OF ORIGINALS/DUPLICATES NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Custodian:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Postal address:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Country:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Telecommunications address:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Repository location code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=536]">
		<p class="bibHead">FUNDING INFORMATION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Text of note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Contract number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Grant number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Undifferentiated number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Program element number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Project number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Task number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Work unit number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=537]">
		<p class="bibHead">SOURCE OF DATA NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Source of data note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=538]">
		<p class="bibHead">SYSTEM DETAILS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>System details note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=540]">
		<p class="bibHead">TERMS GOVERNING USE AND REPRODUCTION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Terms governing use and reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Jurisdiction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Authorization:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Authorized users:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=541]">
		<p class="bibHead">IMMEDIATE SOURCE OF ACQUISITION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Source of acquisition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Address:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Method of acquisition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of acquisition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Accession number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Owner:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Purchase price:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Extent:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Type of unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=543]">
		<p class="bibHead">SOLICITATION INFORMATION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Solicitation information note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=544]">
		<p class="bibHead">LOCATION OF OTHER ARCHIVAL MATERIALS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Custodian:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Address:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Country:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Provenance:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=545]">
		<p class="bibHead">BIOGRAPHICAL OR HISTORICAL DATA
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Biographical or historical data:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Expansion:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Uniform Resource Identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=546]">
		<p class="bibHead">LANGUAGE NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Language note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Information code or alphabet:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Source of note information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=547]">
		<p class="bibHead">FORMER TITLE COMPLEXITY NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Former title complexity note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Source of note information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=550]">
		<p class="bibHead">ISSUING BODY NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Issuing body note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Source of note information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=552]">
		<p class="bibHead">ENTITY AND ATTRIBUTE INFORMATION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Entity type label:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Entity type definition and source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Attribute label:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Attribute definition and source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Enumerated domain value:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Enumerated domain value definition and source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Range domain minimum and maximum:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Codeset name and source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Unrepresentable domain:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Attribute units of measurement and resolution:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Beginning date and ending date of attribute values:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Attribute value accuracy:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Attribute value accuracy explanation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Attribute measurement frequency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Entity and attribute overview:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Entity and attribute detail citation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Uniform Resource Identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Display note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=555]">
		<p class="bibHead">CUMULATIVE INDEX/FINDING AIDS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Cumulative index/finding aids note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Availability source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Degree of control:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Bibliographic reference:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Uniform Resource Identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=556]">
		<p class="bibHead">INFORMATION ABOUT DOCUMENTATION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Information about documentation note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=561]">
		<p class="bibHead">OWNERSHIP AND CUSTODIAL HISTORY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>History:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Time of collation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=562]">
		<p class="bibHead">COPY AND VERSION IDENTIFICATION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Identifying markings:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Copy identification:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Version identification:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Presentation format:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Number of copies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=565]">
		<p class="bibHead">CASE FILE CHARACTERISTICS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Number of cases/variables:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Name of variable:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Unit of analysis:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Universe of data:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Filing scheme or code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=567]">
		<p class="bibHead">METHODOLOGY NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Methodology note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=570]">
		<p class="bibHead">EDITOR NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Editor note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Source of note information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=571]">
		<p class="bibHead">VOLUNTEERS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Volunteers note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Special requirements:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=572]">
		<p class="bibHead">AFFILIATION AND OTHER RELATIONSHIPS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Affiliation and other relationships note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=573]">
		<p class="bibHead">CREDENTIALS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Credentials note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=574]">
		<p class="bibHead">TRANSPORTATION AND DIRECTIONS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Transportation and directions note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=575]">
		<p class="bibHead">ACCOMMODATIONS FOR THE DISABLED NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Accommodations for the disabled note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=576]">
		<p class="bibHead">SERVICES AVAILABLE NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Services available note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=580]">
		<p class="bibHead">LINKING ENTRY COMPLEXITY NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Linking entry complexity note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Source of note information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=581]">
		<p class="bibHead">PUBLICATIONS ABOUT DESCRIBED MATERIALS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Publications about described materials note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=582]">
		<p class="bibHead">RELATED COMPUTER FILES NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Related computer files note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=583]">
		<p class="bibHead">ACTION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Action:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Action identification:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Time of action:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Action interval:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Contingency for action:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Authorization:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Jurisdiction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Method of action:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Site of action:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Action agent:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Status:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Extent:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Type of unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Uniform Resource Identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Nonpublic note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=584]">
		<p class="bibHead">ACCUMULATION AND FREQUENCY OF USE NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Accumulation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Frequency of use:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=585]">
		<p class="bibHead">EXHIBITIONS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Exhibitions note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=586]">
		<p class="bibHead">AWARDS NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Awards note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=587]">
		<p class="bibHead">OTHER INFORMATION AVAILABLE NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Other information available note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=590]">
		<p class="bibHead">LOCAL NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Local note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Provenance:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Condition of individual reels:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=600]">
		<p class="bibHead">SUBJECT ADDED ENTRY--PERSONAL NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Personal name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Numeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Titles and other words associated with a name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Dates associated with a name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Attribution qualifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Fuller form of name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Form subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>General subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Chronological subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Geographic subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of heading or term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=610]">
		<p class="bibHead">SUBJECT ADDED ENTRY--CORPORATE NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Corporate name or jurisdiction name as entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Subordinate unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Location of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of meeting or treaty signing:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section/meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Form subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>General subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Chronological subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Geographic subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of heading or term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=611]">
		<p class="bibHead">SUBJECT ADDED ENTRY--MEETING NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Meeting name or jurisdiction name as entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Number (BK CF MP MU SE VM MX):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Location of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Subordinate unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section/meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Name of meeting following jurisdiction name entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Form subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>General subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Chronological subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Geographic subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of heading or term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=630]">
		<p class="bibHead">SUBJECT ADDED ENTRY--UNIFORM TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of treaty signing:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Form subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>General subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Chronological subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Geographic subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of heading or term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=650]">
		<p class="bibHead">SUBJECT ADDED ENTRY--TOPICAL TERM
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Topical term or geographic name as entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Topical term following geographic name as entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Location of event:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Active dates:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Form subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>General subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Chronological subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Geographic subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of heading or term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=651]">
		<p class="bibHead">SUBJECT ADDED ENTRY--GEOGRAPHIC NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Geographic name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Geographic name following place entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Form subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>General subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Chronological subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Geographic subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of heading or term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=652]">
		<p class="bibHead">SUBJECT ADDED ENTRY--REVERSED GEOGRAPHIC
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Geographic name of place element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>General subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Chronological subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Geographic subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=653]">
		<p class="bibHead">INDEX TERM--UNCONTROLLED
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Uncontrolled term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=654]">
		<p class="bibHead">SUBJECT ADDED ENTRY--FACETED TOPICAL TERMS
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Focus term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Non-focus term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Facet/hierarchy designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Form subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Chronological subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Geographic subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of heading or term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Material specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=655]">
		<p class="bibHead">INDEX TERM--GENRE/FORM/PHYSICAL CHARACTERISTICS
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Genre/form/physical characteristics:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Non-focus term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Facet/hierarchy designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Form subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>General subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Chronological subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Geographic subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=656]">
		<p class="bibHead">INDEX TERM--OCCUPATION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Occupation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Form subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>General subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Chronological subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Geographic subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=657]">
		<p class="bibHead">INDEX TERM--FUNCTION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Function:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Form subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>General subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Chronological subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Geographic subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=658]">
		<p class="bibHead">INDEX TERM--CURRICULUM OBJECTIVE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main curriculum objective:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Subordinate curriculum objective:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Curriculum code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Correlation factor:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=700]">
		<p class="bibHead">ADDED ENTRY--PERSONAL NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Personal name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Numeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Titles and other words associated with a name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Dates associated with a name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Attribution qualifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Fuller form of name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=705]">
		<p class="bibHead">ADDED ENTRY--PERSONAL NAME (PERFORMER)
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Personal name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Numeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Titles and other words associated with a name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Dates associated with a name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=710]">
		<p class="bibHead">ADDED ENTRY--CORPORATE NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Corporate name or jurisdiction name as entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Subordinate unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Location of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of meeting or treaty signing:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section/meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=711]">
		<p class="bibHead">ADDED ENTRY--MEETING NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Meeting name or jurisdiction name as entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Number (BK CF MP MU SE VM MX):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Location of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Subordinate unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section/meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Name of meeting following jurisdiction name entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=715]">
		<p class="bibHead">ADDED ENTRY--CORPORATE NAME-PERFORMING GROUP
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Corporate name or jurisdiction name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Subordinate unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section/meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Nonprinting information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=720]">
		<p class="bibHead">ADDED ENTRY--UNCONTROLLED NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=730]">
		<p class="bibHead">ADDED ENTRY--UNIFORM TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of treaty signing:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=740]">
		<p class="bibHead">ADDED ENTRY--UNCONTROLLED RELATED/ANALYTICAL TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Uncontrolled related/analytical title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Institution to which field applies:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=752]">
		<p class="bibHead">ADDED ENTRY--HIERARCHICAL PLACE NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Country:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>State, province, territory:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>County, region, islands area:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>City:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=753]">
		<p class="bibHead">SYSTEM DETAILS ACCESS TO COMPUTER FILES
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Make and model of machine:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Programming language:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Operating system:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=754]">
		<p class="bibHead">ADDED ENTRY--TAXONOMIC IDENTIFICATION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Taxonomic name/taxonomic hierarchical category:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of taxonomic identification:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=755]">
		<p class="bibHead">ADDED ENTRY--PHYSICAL CHARACTERISTICS
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Access term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>General subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Chronological subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Geographic subdivision:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=760]">
		<p class="bibHead">MAIN SERIES ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Parallel title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=762]">
		<p class="bibHead">SUBSERIES ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Parallel title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=765]">
		<p class="bibHead">ORIGINAL LANGUAGE ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Series data for related item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Parallel title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Standard Technical Report Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=767]">
		<p class="bibHead">TRANSLATION ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Series data for related item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Parallel title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Standard Technical Report Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=770]">
		<p class="bibHead">SUPPLEMENT/SPECIAL ISSUE ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Series data for related item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Parallel title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Standard Technical Report Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=772]">
		<p class="bibHead">PARENT RECORD ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Series data for related item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Parallel title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Standard Technical Report Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=773]">
		<p class="bibHead">HOST ITEM ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Series data for related item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Abbreviated title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Standard Technical Report Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=774]">
		<p class="bibHead">CONSTITUENT UNIT ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Series data for related item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Standard Technical Report Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=775]">
		<p class="bibHead">OTHER EDITION ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Language code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Country code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Series data for related item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Parallel title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Standard Technical Report Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=776]">
		<p class="bibHead">ADDITIONAL PHYSICAL FORM ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Series data for related item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Parallel title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Standard Technical Report Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=777]">
		<p class="bibHead">ISSUED WITH ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Series data for related item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Parallel title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=780]">
		<p class="bibHead">PRECEDING ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Series data for related item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Parallel title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Standard Technical Report Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=785]">
		<p class="bibHead">SUCCEEDING ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Series data for related item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Parallel title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Standard Technical Report Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=786]">
		<p class="bibHead">ISSUED WITH ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Period of content:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Series data for related item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Abbreviated title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Standard Technical Report Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Source contribution:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=787]">
		<p class="bibHead">NONSPECIFIC RELATIONSHIP ENTRY
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Main entry heading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Edition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Qualifying information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Place, publisher, and date of publication:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Relationship information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Physical description of source:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Display text:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Series data for related item:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Material-specific details:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Other item identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Parallel title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Report number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Standard Technical Report Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>International Standard Serial Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>CODEN designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>International Standard Book Number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Control subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=800]">
		<p class="bibHead">SERIES ADDED ENTRY--PERSONAL NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Personal name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Numeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Titles and other words associated with a name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Dates associated with a name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Attribution qualifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Fuller form of name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Volume number/sequential designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=810]">
		<p class="bibHead">SERIES ADDED ENTRY--CORPORATE NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Corporate name or jurisdiction name as entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Subordinate unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Location of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of meeting or treaty signing:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section/meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Volume number/sequential designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=811]">
		<p class="bibHead">SERIES ADDED ENTRY--MEETING NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Meeting name or jurisdiction name as entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Number (BK CF MP MU SE VM MX):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Location of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Subordinate unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section/meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Name of meeting following jurisdiction name entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Volume number/sequential designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=830]">
		<p class="bibHead">SERIES ADDED ENTRY--UNIFORM TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of treaty signing:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Volume number/sequential designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=840]">
		<p class="bibHead">SERIES ADDED ENTRY--TITLE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Volume or number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=841]">
		<p class="bibHead">HOLDINGS CODED DATA VALUES
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Type of record:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Fixed-length data elements:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Encoding level:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=842]">
		<p class="bibHead">TEXTUAL PHYSICAL FORM DESIGNATOR
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Textual physical form designator:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=843]">
		<p class="bibHead">REPRODUCTION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Type of reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Place of reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Agency responsible for reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Physical description of reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Series statement of reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Dates of publication and/or sequential designation of issues reproduced:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Note about reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Fixed-length data elements of reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=844]">
		<p class="bibHead">NAME OF UNIT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Name of unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=845]">
		<p class="bibHead">TERMS GOVERNING USE AND REPRODUCTION NOTE
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Terms governing use and reproduction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Jurisdiction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Authorization:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Authorized users:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=850]">
		<p class="bibHead">HOLDING INSTITUTION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Holding institution:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Holdings:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Inclusive dates:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Retention statement:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=851]">
		<p class="bibHead">LOCATION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Name (custodian or owner):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Institutional division:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Street address:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Country:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Location of units:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Repository location code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=852]">
		<p class="bibHead">LOCATION/CALL NUMBER
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Location:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Sublocation or collection:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Shelving location:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Address:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Coded location qualifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>= Qualifier type:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>= Number of units 1-9:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>= Unit type:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Non-coded location qualifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Classification part:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Item part:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Shelving control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Call number prefix:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Shelving form of title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Call number suffix:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Country code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Piece designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Piece physical condition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Copyright article-fee code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Copy number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Nonpublic note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of classification or shelving scheme:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=853]">
		<p class="bibHead">CAPTIONS AND PATTERN--BASIC BIBLIOGRAPHIC UNIT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>First level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Second level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Third level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Fourth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Fifth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Sixth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Alternative numbering scheme, first level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Alternative numbering scheme, second level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>First level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Second level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Third level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Fourth level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Alternative numbering scheme, chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Copy:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Bibliographic units per next higher level:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Numbering continuity:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Frequency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Calendar change:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Regularity pattern:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=854]">
		<p class="bibHead">CAPTIONS AND PATTERN--SUPPLEMENTARY MATERIAL
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>First level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Second level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Third level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Fourth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Fifth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Sixth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Alternative numbering scheme, first level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Alternative numbering scheme, second level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>First level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Second level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Third level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Fourth level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Alternative numbering scheme, chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Type of supplementary material:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Copy:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Bibliographic units per next higher level:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Numbering continuity:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Frequency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Calendar change:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Regularity pattern:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=855]">
		<p class="bibHead">CAPTIONS AND PATTERN--INDEXES
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>First level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Second level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Third level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Fourth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Fifth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Sixth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Alternative numbering scheme, first level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Alternative numbering scheme, second level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>First level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Second level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Third level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Fourth level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Alternative numbering scheme, chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Type of index:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Copy:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Bibliographic units per next higher level:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Numbering continuity:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Frequency:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Calendar change:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Regularity pattern:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=856]">
		<p class="bibHead">ELECTRONIC LOCATION AND ACCESS
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Field link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Host name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Access number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Compression information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Path:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Electronic name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Uniform resource name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Processor of request:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Instruction:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Bits per second:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Password:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Logon:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Contact for access assistance:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Name of location of host in subfield $a:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Operating system:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Port:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Electronic format type :
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Settings:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>File size:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Terminal emulation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Uniform Resource Identifier:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Hours access method available:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Record control number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Nonpublic note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Link text :
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Access method:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=863]">
		<p class="bibHead">ENUMERATION AND CHRONOLOGY--BASIC BIBLIOGRAPHIC UNIT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>First level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Second level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Third level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Fourth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Fifth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Sixth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Alternative numbering scheme, first level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Alternative numbering scheme, second level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>First level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Second level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Third level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Fourth level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Alternative numbering scheme, chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Converted Gregorian year:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Piece designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Piece physical condition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Copyright article-fee code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Copy number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Break indicator:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Nonpublic note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=864]">
		<p class="bibHead">ENUMERATION AND CHRONOLOGY--SUPPLEMENTARY MATERIAL
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>First level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Second level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Third level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Fourth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Fifth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Sixth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Alternative numbering scheme, first level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Alternative numbering scheme, second level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>First level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Second level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Third level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Fourth level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Alternative numbering scheme, chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Converted Gregorian year:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Title of supplementary material:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Piece designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Piece physical condition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Copyright article-fee code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Copy number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Break indicator:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Nonpublic note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=865]">
		<p class="bibHead">ENUMERATION AND CHRONOLOGY--INDEXES
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>First level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Second level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Third level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Fourth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Fifth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Sixth level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Alternative numbering scheme, first level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Alternative numbering scheme, second level of enumeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>First level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Second level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Third level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Fourth level of chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Alternative numbering scheme, chronology:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Converted Gregorian year:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Title of index:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Piece designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Piece physical condition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Copyright article-fee code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Copy number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Break indicator:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Nonpublic note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=866]">
		<p class="bibHead">TEXTUAL HOLDINGS--BASIC BIBLIOGRAPHIC UNIT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Textual string:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Nonpublic note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=867]">
		<p class="bibHead">TEXTUAL HOLDINGS--SUPPLEMENTARY MATERIAL
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Textual holdings:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Nonpublic note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=868]">
		<p class="bibHead">TEXTUAL HOLDINGS--INDEXES
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Textual holdings:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Nonpublic note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=870]">
		<p class="bibHead">VARIANT PERSONAL NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Personal name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Numeration:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Titles and other words associated with a name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Dates associated with a name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Tag and sequence number of the field for which 870 is a variant(R):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Fuller form of name:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=871]">
		<p class="bibHead">VARIANT CORPORATE NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Corporate name or jurisdiction name as entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Subordinate unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Location of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of meeting or treaty signing:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Relator term:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Tag and sequence number of the field for which 871 is a variant(R):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section/meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=872]">
		<p class="bibHead">VARIANT CONFERENCE OR MEETING NAME
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Meeting name or jurisdiction name as entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Number (BK CF MP MU SE VM MX):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Location of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Subordinate unit:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Tag and sequence number of the field for which 872 is a variant(R):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section/meeting:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Name of meeting following jurisdiction name entry element:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Affiliation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Relator code:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=873]">
		<p class="bibHead">VARIANT UNIFORM TITLE HEADING
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Uniform title:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date of treaty signing:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Date of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Miscellaneous information:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Medium:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Tag and sequence number of the field for which 873 is a variant(R):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Form subheading:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Language of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Medium of performance for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Number of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Arranged statement for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Name of part/section of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Key for music:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Version:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Title of a work:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=876]">
		<p class="bibHead">ITEM INFORMATION--BASIC BIBLIOGRAPHIC UNIT
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Internal item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Invalid or cancelled internal item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Cost:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date acquired:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Source of acquisition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Use restrictions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Item status:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Temporary location:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Piece designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Invalid or cancelled piece designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Copy number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Nonpublic note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=877]">
		<p class="bibHead">ITEM INFORMATION--SUPPLEMENTARY MATERIAL
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Internal item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Invalid or cancelled internal item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Cost:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date acquired:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Source of acquisition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Use restrictions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Item status:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Temporary location:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Piece designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Invalid or cancelled piece designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Copy number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Nonpublic note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=878]">
		<p class="bibHead">ITEM INFORMATION--INDEXES
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Internal item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Invalid or cancelled internal item number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Cost:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Date acquired:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Source of acquisition:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Use restrictions:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Item status:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Temporary location:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Piece designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Invalid or cancelled piece designation:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Copy number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Nonpublic note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Public note:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Materials specified:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Link and sequence number:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=880]">
		<p class="bibHead">ALTERNATE GRAPHIC REPRESENTATION
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Linkage:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='0']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='1']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Same as associated field:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Undefined; each contains blank (#):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Undefined; each contains blank (#):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='9']">
				<li>Undefined; each contains blank (#):
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=886]">
		<p class="bibHead">FOREIGN MARC INFORMATION FIELD
		</p>
		<ul>
			<xsl:for-each select="marc:subfield[@code='a']">
				<li>Tag of the foreign MARC field/Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='b']">
				<li>Content of the foreign MARC field/Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='2']">
				<li>Source of data:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='c']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='d']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='e']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='f']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='g']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='h']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='i']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='j']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='k']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='l']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='m']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='n']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='o']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='p']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='r']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='s']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='t']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='u']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='w']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='x']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='y']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='0']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='1']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='3']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='4']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='5']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='6']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='7']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='8']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='9']">
				<li>Foreign MARC subfield:
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<!-- This catch-all template was added to handle extra stuff added by individual institutions.
		MOBOT in pariticular uses several data fields above the range defined at http://www.loc.gov/marc -->
	<xsl:template match="marc:datafield[@tag>886]">
		<p class="bibHead">DATA FIELD <xsl:value-of select="@tag" /></p>
		<ul>
			<xsl:for-each select="marc:subfield">
				<li>Code <xsl:value-of select="@code" />: 
				<span class="bibValue"><xsl:value-of select="text()"/></span>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	
</xsl:stylesheet>

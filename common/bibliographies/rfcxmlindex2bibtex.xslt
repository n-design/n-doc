<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
               xmlns:rfcidx="http://www.rfc-editor.org/rfc-index" >
<xsl:output method="text"/>

<!-- rfcxmlindex2bibtex.xslt written by Roland Bless  -->

<!-- Get rfc-index in xml format from ftp://ftp.isi.edu/in-notes/rfc-index.xml
     then translate it to bibtex format by invoking e.g.: 
     xsltproc  rfcxmlindex2bibtex rfc-index.xml | sed 's/_/\\_/'
     or 
     java org.apache.xalan.xslt.Process -in rfc-index.xml -xsl rfcxmlindex2bibtex.xslt -out -  | sed 's/_/\\_/'
     -->

<!-- customizable variables -->

<xsl:variable name="entrytype">
  <xsl:text>@misc</xsl:text>
</xsl:variable>

<xsl:variable name="rfctype">
<xsl:text>RFC</xsl:text>
</xsl:variable>

<xsl:variable name="urlrfcretrieval">
<xsl:text>https://www.rfc-editor.org/rfc/</xsl:text>
</xsl:variable>

<xsl:variable name="obsoletedby">
<xsl:text>Obsoleted by </xsl:text>
</xsl:variable>

<xsl:variable name="updatedby">
<xsl:text>Updated by </xsl:text>
</xsl:variable>

<xsl:variable name="statFS">INTERNET STANDARD</xsl:variable>
<xsl:variable name="statDS">DRAFT STANDARD</xsl:variable>
<xsl:variable name="statPS">PROPOSED STANDARD</xsl:variable>
<xsl:variable name="statU">UNKNOWN</xsl:variable>
<xsl:variable name="statBCP">BEST CURRENT PRACTICE</xsl:variable>
<xsl:variable name="statFYI">FOR YOUR INFORMATION</xsl:variable>
<xsl:variable name="statEXP">EXPERIMENTAL</xsl:variable>
<xsl:variable name="statH">HISTORIC</xsl:variable>
<xsl:variable name="statI">INFORMATIONAL</xsl:variable>

<xsl:variable name="lstatFS">Internet Standard</xsl:variable>
<xsl:variable name="lstatDS">Draft Standard</xsl:variable>
<xsl:variable name="lstatPS">Proposed Standard</xsl:variable>
<xsl:variable name="lstatU">Unknown</xsl:variable>
<xsl:variable name="lstatBCP">Best Current Practice</xsl:variable>
<xsl:variable name="lstatFYI">For Your Information</xsl:variable>
<xsl:variable name="lstatEXP">Experimental</xsl:variable>
<xsl:variable name="lstatH">Historic</xsl:variable>
<xsl:variable name="lstatI">Informational</xsl:variable>

<!-- internal variables -->

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="escapesyms">
  <xsl:text>_</xsl:text>
</xsl:variable>

<!-- template matches -->

<xsl:template match="/">
  <xsl:apply-templates select="rfcidx:rfc-index"/>
</xsl:template>

<xsl:template match="rfcidx:rfc-index">
  <xsl:apply-templates select="rfcidx:rfc-entry"/>
</xsl:template>

<xsl:template match="rfcidx:rfc-entry">
  <xsl:value-of select="$entrytype" /><xsl:text>{rfc</xsl:text>
  <xsl:variable name="rfcno" select="number(substring-after(rfcidx:doc-id/text(),$rfctype))"/>
  <xsl:value-of select="$rfcno"/>,
  <xsl:text>author="</xsl:text>
  <xsl:for-each select="rfcidx:author">
    <xsl:if test="position()>1"><xsl:text> and </xsl:text></xsl:if>
    <xsl:value-of select="rfcidx:name"/>
    <xsl:if test="rfcidx:title='Editor'"><xsl:text> {(Ed.)}</xsl:text></xsl:if>
  </xsl:for-each>",
  <xsl:apply-templates  select="rfcidx:title" mode="plain"/>,
  <xsl:text>howpublished="RFC </xsl:text><xsl:value-of select="$rfcno"/>
  <xsl:variable name="rstatus" select="rfcidx:current-status"/>			    
  <xsl:variable name="cstatus">
  <xsl:choose>
      <xsl:when test="$rstatus=$statFS" ><xsl:value-of select="$lstatFS"/></xsl:when>
      <xsl:when test="$rstatus=$statDS" ><xsl:value-of select="$lstatDS"/></xsl:when>
      <xsl:when test="$rstatus=$statPS" ><xsl:value-of select="$lstatPS"/></xsl:when>
      <xsl:when test="$rstatus=$statU"  ><xsl:value-of select="$lstatU"/></xsl:when>
      <xsl:when test="$rstatus=$statBCP"><xsl:value-of select="$lstatBCP"/></xsl:when>
      <xsl:when test="$rstatus=$statFYI"><xsl:value-of select="$lstatFYI"/></xsl:when>
      <xsl:when test="$rstatus=$statEXP"><xsl:value-of select="$lstatEXP"/></xsl:when>
      <xsl:when test="$rstatus=$statH"  ><xsl:value-of select="$lstatH"/></xsl:when>
      <xsl:when test="$rstatus=$statI"><xsl:value-of select="$lstatI"/></xsl:when>
  <xsl:otherwise>
      <xsl:value-of select="rfcidx:current-status"/>
  </xsl:otherwise>
  </xsl:choose>
  </xsl:variable>
  <xsl:if test="not(rfcidx:current-status='UNKNOWN')"> (<xsl:value-of select="$cstatus"/>)</xsl:if>",
  <xsl:text>series="Internet Request for Comments"</xsl:text>,
  <xsl:text>type="</xsl:text><xsl:value-of select="$rfctype"/>",
  <xsl:text>number="</xsl:text><xsl:value-of select="$rfcno"/>",
  <xsl:if test="rfcidx:format/rfcidx:page-count">
    <xsl:text>pages="1--</xsl:text><xsl:value-of select="rfcidx:format/rfcidx:page-count"/>",
  </xsl:if>
  <xsl:text>year=</xsl:text><xsl:value-of select="rfcidx:date/rfcidx:year"/>,
  <xsl:text>month=</xsl:text><xsl:value-of select="translate(substring(rfcidx:date/rfcidx:month,1,3),'ABCDEFGHIJKMLNOPQRSTUVWXYZ','abcdefghijkmlnopqrstuvwxyz')"/>,
  <xsl:apply-templates  select="rfcidx:date/rfcidx:day"/>
  <xsl:text>issn="2070-1721"</xsl:text>,
  <xsl:text>publisher="RFC Editor"</xsl:text>,
  <xsl:text>institution="RFC Editor"</xsl:text>,
  <xsl:text>organization="RFC Editor"</xsl:text>,
  <xsl:text>address="Fremont, CA, USA"</xsl:text>,
  <xsl:if test="count(rfcidx:obsoleted-by|rfcidx:updated-by) &gt; 0">
  <xsl:text>  note="</xsl:text>
  </xsl:if>
  <xsl:apply-templates  select="rfcidx:obsoleted-by"/>
  <xsl:if test="count(rfcidx:updated-by) &gt; 0">
  <xsl:choose>
  <xsl:when test="count(rfcidx:obsoleted-by) &gt; 0">
    <xsl:text>, </xsl:text><xsl:value-of select="translate(substring($updatedby,1,1),'ABCDEFGHIJKMLNOPQRSTUVWXYZ','abcdefghijkmlnopqrstuvwxyz')"/><xsl:value-of select="substring($updatedby,2)"/>
  </xsl:when>
  <xsl:otherwise><xsl:value-of select="$updatedby"/></xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates  select="rfcidx:updated-by"/>
  </xsl:if>
  <xsl:if test="count(rfcidx:obsoleted-by|rfcidx:updated-by) &gt; 0"><xsl:text>",</xsl:text><xsl:value-of select="$newline"/></xsl:if>
  <xsl:text>url="</xsl:text><xsl:value-of select="$urlrfcretrieval"/><xsl:text>rfc</xsl:text><xsl:value-of select="$rfcno"/>.txt",
  <xsl:text>key="</xsl:text><xsl:value-of select="$rfctype"/><xsl:text> </xsl:text><xsl:value-of select="$rfcno"/>",
  <xsl:if test="rfcidx:abstract">
    <xsl:text>abstract={</xsl:text><xsl:value-of select="rfcidx:abstract"/>},
  </xsl:if>
  <xsl:if test="rfcidx:keywords">
    <xsl:text>keywords="</xsl:text>
    <xsl:value-of select="rfcidx:keywords/rfcidx:kw"/>
    <xsl:for-each select="rfcidx:keywords/rfcidx:kw">
      <xsl:choose>
	<xsl:when test="position()=1"><xsl:value-of select="rfcidx:keywords/rfcidx:kw"/></xsl:when>
	<xsl:when test="position()>1"><xsl:text>, </xsl:text><xsl:value-of select="."/></xsl:when>
      </xsl:choose>
    </xsl:for-each>",
  </xsl:if>
  <xsl:if test="rfcidx:doi">
    <xsl:text>doi="</xsl:text>
    <xsl:value-of select="rfcidx:doi"/>",
  </xsl:if>  
<xsl:text>}</xsl:text><xsl:value-of select="$newline"/>
<xsl:value-of select="$newline"/>
</xsl:template>


<xsl:template match="rfcidx:title" mode="plain">
  <xsl:text>title="{</xsl:text><xsl:value-of select="."/><xsl:text>}"</xsl:text>
</xsl:template>

<!-- replaces _ with \_ , but it is very slow -> better use sed -->
<xsl:template match="rfcidx:title" mode="replace">
  <xsl:text>title="{</xsl:text>
      <xsl:variable name="originaltitle" select="."/>
      <xsl:variable name="return">
      <xsl:choose>
        <xsl:when test="contains($originaltitle,$escapesyms)">
	     <xsl:call-template name="escapechars">
	       <xsl:with-param name="inputstr"><xsl:value-of select="$originaltitle"/></xsl:with-param>
	     </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
	  <xsl:value-of select="$originaltitle"/>
        </xsl:otherwise>
      </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="$return"/>
   <xsl:text>}"</xsl:text>
</xsl:template>


<!-- replaces escapechar with \escapechar -->
<xsl:template name="escapechars">
 <xsl:param name="inputstr"/>
  <xsl:variable name="first">
      <xsl:choose>
        <xsl:when test="contains($inputstr, $escapesyms)">
          <xsl:value-of select="substring-before($inputstr, $escapesyms)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$inputstr"/>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:variable>
    <xsl:variable name="middle">
      <xsl:choose>
        <xsl:when test="contains($inputstr, $escapesyms)">
          <xsl:text>\</xsl:text><xsl:value-of select="$escapesyms"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text></xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  <xsl:variable name="last">
      <xsl:choose>
        <xsl:when test="contains($inputstr, $escapesyms)">
          <xsl:choose>
            <xsl:when test="contains(substring-after($inputstr, $escapesyms), $escapesyms)">
              <xsl:call-template name="escapechars">
                <xsl:with-param name="inputstr"><xsl:value-of select="substring-after($inputstr, $escapesyms)"/></xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-after($inputstr, $escapesyms)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text></xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  <xsl:value-of select="concat($first, $middle, $last)"/>
</xsl:template>

<xsl:template match="rfcidx:date/rfcidx:day">
<xsl:text>day="</xsl:text><xsl:value-of select="number(.)"/>",  
</xsl:template>

<xsl:template match="rfcidx:obsoleted-by">
  <xsl:value-of select="$obsoletedby"/>
  <xsl:text>RFC</xsl:text><xsl:if test="count(rfcidx:doc-id) &gt; 1">s</xsl:if><xsl:text> </xsl:text>
  <xsl:for-each select="rfcidx:doc-id">
  <xsl:choose>
   <xsl:when test="position()=1"><xsl:value-of select="number(substring-after(text(),$rfctype))"/></xsl:when>
   <xsl:when test="position()>1"><xsl:text>, </xsl:text><xsl:value-of select="number(substring-after(text(),$rfctype))"/></xsl:when>
  </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rfcidx:updated-by">
  <xsl:text>RFC</xsl:text><xsl:if test="count(rfcidx:doc-id) &gt; 1">s</xsl:if><xsl:text> </xsl:text>
  <xsl:for-each select="rfcidx:doc-id">
  <xsl:choose>
   <xsl:when test="position()=1"><xsl:value-of select="number(substring-after(text(),$rfctype))"/></xsl:when>
   <xsl:when test="position()>1"><xsl:text>, </xsl:text><xsl:value-of select="number(substring-after(text(),$rfctype))"/></xsl:when>
  </xsl:choose>
  </xsl:for-each>
</xsl:template>

</xsl:transform>

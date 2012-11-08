<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:saxon="http://saxon.sf.net/"
  version="2.0">
  <!-- xpath, left, right, string-index, range, string-range, match -->
  <xsl:function name="tei:parse-uri">
    <xsl:param name="uri"/>
    <xsl:variable name="function" select="substring-after($uri,'#')"/>
    <xsl:variable name="function-name" select="substring-before($function,'(')"/>
    <xsl:choose>
      <xsl:when test="matches($function,'^(\w|-)+\(.+\)$')">
        <xsl:choose>
          <xsl:when test="$function-name = 'xpath'">
            <xsl:sequence select="saxon:evaluate(substring-before(substring-after($function,'('),')'))"/>
          </xsl:when>
          <xsl:when test="$function-name = 'range'">
            <xsl:analyze-string select="substring-after($function" regex=""></xsl:analyze-string>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
    
    
  </xsl:function>
  
  <xsl:function name="tei:get-point"></xsl:function>
  
  <xsl:function name="tei:get-node">
    <xsl:param name="path"/>
    <xsl:param name="doc"/>
    <xsl:choose>
      <xsl:when test="starts-with($path,'/')"><xsl:sequence select="$doc//saxon:evaluate($path)"/></xsl:when>
      <xsl:otherwise><xsl:sequence select="$doc//id($path)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tei:getMatch">
    <xsl:param name="str"/>
    <xsl:param name="regex"/>
    <xsl:param name="i"/>
    <xsl:analyze-string select=" $str" regex="{$regex}">
      <xsl:matching-substring><xsl:value-of select="regex-group($i)"/></xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:function>
  
  <xsl:function name="tei:getStartPos">
    <xsl:param name="node"/>
    <xsl:param name="regex"/>
    <xsl:param name="i"/>
    <xsl:variable name="txt">
      <xsl:choose>
        <xsl:when test="$node//text()"><xsl:value-of select="string-join($node//text(),'')"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="string-join($node/following-sibling::node()/descendant-or-self::text(),'')"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="match" select="tei:getMatch($txt, $regex, $i)"/>
    <xsl:value-of select="string-length(substring-before($txt, $match))"/>
  </xsl:function>
  
  <xsl:function name="tei:getEndPos">
    <xsl:param name="node"/>
    <xsl:param name="regex"/>
    <xsl:param name="i"/>
    <xsl:variable name="txt">
      <xsl:choose>
        <xsl:when test="$node//text()"><xsl:value-of select="string-join($node//text(),'')"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="string-join($node/following-sibling::node()/descendant-or-self::text(),'')"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="match" select="tei:getMatch($txt, $regex, $i)"/>
    <xsl:value-of select="string-length(substring-before($txt, $match)) + string-length($match)"/>
  </xsl:function>
  
  <xsl:function name="tei:evaluate-xpath">
    <xsl:param name="xpath"/>
    <xsl:param name="context"/>
    <xsl:choose>
      <xsl:when test="string-length($xpath) gt 0">
        <xsl:variable name="new-context">
          <xsl:choose>
            <xsl:when test="starts-with($xpath,'//')">
              <xsl:variable name="pop" select="substring-after($xpath,'//')"/>
              <xsl:variable name="first-part">
                <xsl:choose>
                  <xsl:when test="contains($pop,'/')"><xsl:value-of select="substring-before($pop,'/')"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="$pop"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="contains($pop,'/')">
                  
                </xsl:when>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="tei:evaluate-xpath(replace($xpath,'^//?[^/]+',''),$new-context)"></xsl:sequence>
      </xsl:when>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tei:eval-xpath-part">
    <xsl:param name="part"/>
    <xsl:param name="context"/>
    <xsl:choose>
      <xsl:when test="contains($part,'[')">
        <xsl:variable name="attr-name" select="tei:attr-name-from-predicate(concat('[',substring-after($part,'[')))"/>
        <xsl:variable name="attr-val" select="tei:attr-value-from-predicate(concat('[',substring-after($part,'[')))"/>
        <xsl:sequence select="$context//*[local-name(.) = $part and ./@*[name() = $attr-name and . = $attr-val]]"/>
      </xsl:when>
      <xsl:otherwise><xsl:sequence select="$context//*[local-name(.) = $part]"/></xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tei:check-xpath">
    <xsl:param name="xpath"/>
    <xsl:variable name="quot">'</xsl:variable>
    <xsl:value-of select="matches($xpath,'^//?(\w+(\[@?\w+\s?=\s?$quot[^$quot]+$quot/?))+')"/>
  </xsl:function>
  
  <xsl:function name="tei:attr-name-from-predicate">
    <xsl:param name="pred"/>
    <xsl:value-of select="normalize-space(substring-before(substring-after($pred,'@'),'='))"/>
  </xsl:function>
  
  <xsl:function name="tei:attr-value-from-predicate">
    <xsl:param name="pred"/>
    <xsl:variable name="quot">'</xsl:variable>
    <xsl:value-of select="normalize-space(replace(substring-after($pred,'='),$quot,''))"/>
  </xsl:function>
  
  
  
</xsl:stylesheet>
<!-- 
     demonstration: sum of Pascal triangle reciprocals 
     
     https://www.ibm.com/developerworks/mydeveloperworks/blogs/HermannSW/entry/sum_of_pascal_s_triangle_reciprocals10
-->
<!DOCTYPE root [
  <!ENTITY sum    "&#8721;">
  <!ENTITY infin  "&#8734;">
  <!ENTITY nbsp   "&#160;">
  <!ENTITY ge     "&#8805;">
  <!ENTITY hellip "&#8230;">
]>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
  <xsl:output method="html"/>

  <!-- binomial coefficients -->
  <xsl:template name="binomial">
    <xsl:param name="i" select="0"/>
    <xsl:param name="j" select="0"/>

    <xsl:choose>
      <xsl:when test="$j > $i">0</xsl:when>
      <xsl:when test=" 0 > $j">0</xsl:when>
      <xsl:when test=" 0 > $i">0</xsl:when>
      <xsl:when test="$i = $j">1</xsl:when>
      <xsl:when test="$j =  0">1</xsl:when>
      <xsl:otherwise>
        <xsl:variable name="rec">
          <xsl:call-template name="binomial">
            <xsl:with-param name="i" select="$i - 1"/>
            <xsl:with-param name="j" select="$j - 1"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="($rec * $i) div $j"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- recursive part of theorem -->
  <xsl:template name="theoremRec">
    <xsl:param name="i"/>
    <xsl:param name="j"/>

    <xsl:choose>
      <xsl:when test="$i = $j">0</xsl:when>
      <xsl:otherwise>
        <xsl:variable name="a">
          <xsl:call-template name="theoremRec">
            <xsl:with-param name="i" select="$i - 1"/>
            <xsl:with-param name="j" select="$j"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="b">
          <xsl:call-template name="binomial">
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="j" select="$j"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="$a + (1 div $b)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- sum_i=j+1^infty 1/(i choose j) = 1/(j-1) -->
  <xsl:template name="theorem">
    <xsl:param name="j" select="/ctrl/jmax"/>

    <xsl:if test="$j > 1">
      <!-- increasing table numbering, recurse first -->
      <xsl:call-template name="theorem">
        <xsl:with-param name="j" select="$j - 1"/>
      </xsl:call-template>

      <xsl:variable name="sum">
        <xsl:call-template name="theoremRec">
          <xsl:with-param name="i" select="$j + /ctrl/terms"/>
          <xsl:with-param name="j" select="$j"/>
        </xsl:call-template>
      </xsl:variable>
  
      <tr><td><xsl:value-of select="$j"/></td><td><sup>1</sup>/<sub><xsl:value-of select="1 div $sum"/></sub></td></tr>
    </xsl:if>
  </xsl:template>

  <!-- numerial evidence of theorem -->
  <xsl:template match="/">
    <a href="https://www.ibm.com/developerworks/mydeveloperworks/blogs/HermannSW/entry/sum_of_pascal_s_triangle_reciprocals10">Blog</a> entry on sum of Pascal's triangle reciprocals.
    <p/>
    <span style="font-size:1.5em">&sum;<sup>&infin;</sup><sub>i=j+1</sub>&nbsp;<sup>1</sup>/<sub>(i choose j)</sub> = <sup>1</sup>/<sub>(j-1)</sub> , &nbsp;&nbsp;&nbsp;j&ge;2</span>
    <p/>
    Numerical evidence &hellip;
    <table border="1">
    <tr><th>j</th><th>sum of first <xsl:value-of select="/ctrl/terms"/> terms</th></tr>

    <xsl:call-template name="theorem" />

    <tr><td>&hellip;</td><td>&hellip;</td></tr>
    </table>
  </xsl:template>
  
</xsl:stylesheet>

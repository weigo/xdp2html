<?xml version="1.0" encoding="iso-8859-1"?>
<!-- /* * Copyright 2005, 2007 the original author or authors. Licensed under the * Apache License, Version 2.0 (the "License"); you may not 
  use this file except * in compliance with the License. You may obtain a copy of the License at * http://www.apache.org/licenses/LICENSE-2.0 Unless 
  required by applicable law * or agreed to in writing, software distributed under the License is * distributed on an "AS IS" BASIS, WITHOUT WARRANTIES 
  OR CONDITIONS OF ANY * KIND, either express or implied. See the License for the specific language * governing permissions and limitations under 
  the License. */ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html" indent="yes" encoding="UTF-8" />
  <xsl:strip-space elements="*" />

  <xsl:param name="submitURL" />
  <xsl:param name="applicationURL" />

  <!-- ignore these elements -->
  <xsl:template match="bind|format|picture|event|items|assist|caption|value" />

  <xsl:template match="xdp">
    <html>
      <head>
        <title>display xdp formular as html</title>
        <meta http-equiv="pragma" content="no-cache" />
        <meta http-equiv="cache-control" content="no-cache" />
        <meta http-equiv="expires" content="0" />
        <meta http-equiv="description" content="formular" />
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <xsl:element name="script">
          <xsl:attribute name="src">
            <xsl:text>checkForMultipleNameDeclarations.js</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="type">
			<xsl:text>text/javascript</xsl:text>
		  </xsl:attribute>
        </xsl:element>
        <xsl:element name="style">
          <xsl:attribute name="type">text/css</xsl:attribute>
          <xsl:text>
body { font-size: 10pt; font-family: arial, helvetica, sans-serif; }
p { margin: 0pt; }
span { margin: 0pt; }
          </xsl:text>
        </xsl:element>
      </head>
      <body>
        <xsl:element name="form">
          <xsl:attribute name="method">
			<xsl:text>POST</xsl:text>
		  </xsl:attribute>
          <xsl:attribute name="action">
			<xsl:value-of select="$submitURL" />
		  </xsl:attribute>
          <xsl:apply-templates select="template/subform" />
          <!--xsl:apply-templates select="template//field" / -->
        </xsl:element>
        <!-- JavaScript redlining duplicate textfields/textareas -->
        <xsl:element name="script">
          <xsl:attribute name="type">
			<xsl:text>text/javascript</xsl:text>
		  </xsl:attribute>
          <xsl:text>checkForMultipleNameDeclarations();</xsl:text>
        </xsl:element>
      </body>
    </html>
  </xsl:template>

  <!-- template for insertion of hidden input fields for the scripts parameters -->
  <xsl:template name="params">
    <xsl:param name="name" />
    <xsl:param name="value" />
    <xsl:if test="boolean($value)">
      <xsl:element name="input">
        <xsl:attribute name="type">
          <xsl:text>hidden</xsl:text>
		</xsl:attribute>
        <xsl:attribute name="value">
					<xsl:value-of select="$value" />
				</xsl:attribute>
        <xsl:attribute name="name">
					<xsl:value-of select="$name" />
				</xsl:attribute>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="draw|subform|field">
    <xsl:param name="name" />
    <xsl:element name="div">
      <xsl:attribute name="style">
				<xsl:call-template name="position" />
				<xsl:call-template name="margin" />
				<xsl:call-template name="rectangle" />
				<xsl:call-template name="line" />
			</xsl:attribute>
      <!-- special case draw with ui (normal text fe.) -->
      <xsl:variable name="ui" select="ui" />
      <xsl:choose>
        <xsl:when test="boolean($ui) and not(boolean($name))">
          <xsl:call-template name="fields">
            <xsl:with-param name="element" select="name(ui/*[position()=1])" />
            <xsl:with-param name="name" select="@name" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="boolean($name)">
          <xsl:call-template name="fields">
            <xsl:with-param name="element" select="name(ui/*[position()=1])" />
            <xsl:with-param name="name" select="$name" />
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="exclGroup">
    <xsl:element name="div">
      <xsl:attribute name="style">
				<xsl:call-template name="position" />
				<xsl:call-template name="margin" />
			</xsl:attribute>
      <xsl:variable name="name" select="@name" />
      <xsl:apply-templates>
        <xsl:with-param name="name" select="$name" />
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <!-- images are inlined in xdp, this won't be displayed in most browsers -->
  <xsl:template name="image">
    <xsl:element name="a">
      <xsl:attribute name="href">
				<xsl:text>data:</xsl:text>
				<xsl:value-of select="value/image/@contentType" />
				<xsl:text>;base64,</xsl:text>
				<xsl:value-of select="translate(normalize-space(value/image/text()),' ','')" />
			</xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- template for emission of position attributes for divs and spans, best centralize this -->
  <xsl:template name="position">
    <xsl:text>position:absolute;</xsl:text>
    <xsl:if test="boolean(@x)">
      <xsl:text>left:</xsl:text>
      <xsl:value-of select="@x" />
      <xsl:text>;</xsl:text>
    </xsl:if>
    <xsl:if test="boolean(@y)">
      <xsl:text>top:</xsl:text>
      <xsl:value-of select="@y" />
      <xsl:text>;</xsl:text>
    </xsl:if>
    <xsl:if test="boolean(@w)">
      <xsl:text>width:</xsl:text>
      <xsl:value-of select="@w" />
      <xsl:text>;</xsl:text>
    </xsl:if>
    <xsl:if test="boolean(@h)">
      <xsl:text>height:</xsl:text>
      <xsl:value-of select="@h" />
      <xsl:text>;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- dispatcher template for UI elements -->
  <xsl:template name="fields">
    <xsl:param name="element" />
    <xsl:param name="name" />
    <xsl:choose>
      <xsl:when test="$element='button'">
        <xsl:call-template name="button" />
      </xsl:when>
      <xsl:when test="$element='textEdit'">
        <xsl:variable name="height" select="@h" />
        <xsl:variable name="exData" select="value/exData" />
        <!-- this is an extremely fishy kludge to distinguish ordinary input fields from textareas -->
        <xsl:choose>
          <xsl:when test="10 &lt; substring-before($height, 'mm') and not(boolean($exData))">
            <xsl:call-template name="textArea" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="textField" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$element='numericEdit'">
        <xsl:call-template name="textField" />
      </xsl:when>
      <xsl:when test="$element='dateTimeEdit'">
        <xsl:call-template name="textField" />
      </xsl:when>
      <xsl:when test="$element='checkButton'">
        <xsl:call-template name="checkButton">
          <xsl:with-param name="name" select="$name" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$element='passwordEdit'">
        <xsl:call-template name="passwordEdit" />
      </xsl:when>
      <xsl:when test="$element='choiceList'">
        <xsl:call-template name="choiceList" />
      </xsl:when>
      <xsl:when test="$element='imageEdit'">
        <xsl:call-template name="image" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- exData elements contains html snippets, handle these -->
  <xsl:template match="body">
    <xsl:apply-templates />
  </xsl:template>

  <!-- handle p elements under bodies -->
  <xsl:template match="p">
    <xsl:element name="p">
      <xsl:for-each select="@*">
        <xsl:attribute name="{name()}">
					<xsl:value-of select="." />
				</xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <!-- special handling for spans under p's under bodies -->
  <xsl:template match="span">
    <xsl:if test="boolean(node())">
      <xsl:variable name="styleval" select="@style" />
      <xsl:element name="span">
        <xsl:choose>
          <xsl:when test="$styleval = 'xfa-tab-count:1'">
            <xsl:text>&#160;</xsl:text>
          </xsl:when>
          <xsl:when test="$styleval = 'xfa-spacerun:yes'">
            <xsl:text>&#160;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="@*">
              <xsl:attribute name="{name()}">
								<xsl:value-of select="." />
							</xsl:attribute>
            </xsl:for-each>
            <xsl:copy-of select="node()|text()" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- insert the submit button, change 'submit' to whatever text you'd like to be displayed (one could even parameterize the stylesheet for 
    this. -->
  <xsl:template name="button">
    <xsl:element name="input">
      <xsl:attribute name="type">submit</xsl:attribute>
      <xsl:attribute name="value">
				<!-- xsl:value-of select="caption/value/text/text()" /-->
				<xsl:text>submit</xsl:text>
			</xsl:attribute>
      <xsl:attribute name="name">
				<xsl:value-of select="@name" />
			</xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template name="textField">
    <xsl:element name="span">
      <xsl:attribute name="style">
				<xsl:if test="boolean(caption/font/@typeface)">
					<xsl:text>font-family:</xsl:text>
					<xsl:value-of select="caption/font/@typeface" />
					<xsl:text>;</xsl:text>
				</xsl:if>
				<xsl:if test="boolean(font/@size)">
					<xsl:text>font-size:</xsl:text>
					<xsl:value-of select="font/@size" />
					<xsl:text>;</xsl:text>
				</xsl:if>
				<xsl:if test="boolean(font/@typeface)">
					<xsl:text>font-family:</xsl:text>
					<xsl:value-of select="font/@typeface" />
					<xsl:text>;</xsl:text>
				</xsl:if>
				<xsl:if test="boolean(font/@weight)">
					<xsl:text>font-weight:</xsl:text>
					<xsl:value-of select="font/@weight" />
					<xsl:text>;</xsl:text>
				</xsl:if>
				<xsl:if test="boolean(font/@underline)">
					<xsl:if test="font/@underline = '1'">
						<xsl:text>text-decoration:underline;</xsl:text>
					</xsl:if>
				</xsl:if>
				<xsl:if test="boolean(caption/para/@vAlign)">
					<xsl:text>vertical-align:</xsl:text>
					<xsl:value-of select="caption/para/@vAlign" />
					<xsl:text>;</xsl:text>
				</xsl:if>
			</xsl:attribute>
      <xsl:choose>
        <xsl:when test="boolean(caption/value/text/text())">
          <xsl:value-of select="caption/value/text/text()" />
        </xsl:when>
        <xsl:when test="boolean(value/text/text())">
          <xsl:value-of select="value/text/text()" />
        </xsl:when>
        <xsl:when test="boolean(value/exData)">
          <xsl:apply-templates select="value/exData" />
        </xsl:when>
        <xsl:when test="boolean(caption/value/exData)">
          <xsl:apply-templates select="caption/value/exData" />
        </xsl:when>
      </xsl:choose>
    </xsl:element>
    <xsl:if test="boolean(caption)">
      <xsl:element name="span">
        <xsl:attribute name="style">
					<xsl:text>position:absolute;left:</xsl:text>
					<xsl:value-of select="caption/@reserve" />
					<xsl:if test="boolean(para/@vAlign)">
						<xsl:text>;vertical-align:</xsl:text>
						<xsl:value-of select="para/@vAlign" />
						<xsl:text>;</xsl:text>
					</xsl:if>
				</xsl:attribute>
        <xsl:element name="input">
          <xsl:attribute name="style">
						<xsl:text>width:</xsl:text>
						<xsl:call-template name="input-width">
							<xsl:with-param name="w">
								<xsl:value-of select="@w" />
							</xsl:with-param>
							<xsl:with-param name="reserve">
								<xsl:value-of select="caption/@reserve" />
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>mm;</xsl:text>
					</xsl:attribute>
          <xsl:attribute name="type">
						<xsl:text>text</xsl:text>
					</xsl:attribute>
          <xsl:attribute name="name">
						<xsl:value-of select="@name" />
					</xsl:attribute>
          <xsl:attribute name="value" />
          <xsl:if test="boolean(value/text/@maxlength)">
            <xsl:attribute name="maxlength">
							<xsl:value-of select="value/text/@maxlength" />
						</xsl:attribute>
          </xsl:if>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- helper template to calculate the width of a caption for a textarea or textfield -->
  <xsl:template name="input-width">
    <xsl:param name="w" />
    <xsl:param name="reserve" />
    <xsl:variable name="width">
      <xsl:call-template name="convert-to-mm">
        <xsl:with-param name="l">
          <xsl:value-of select="$w" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="res">
      <xsl:call-template name="convert-to-mm">
        <xsl:with-param name="l">
          <xsl:value-of select="$reserve" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$width - $res" />
  </xsl:template>

  <!-- helper template to convert units in inch to mm -->
  <xsl:template name="convert-to-mm">
    <xsl:param name="l" />
    <xsl:choose>
      <xsl:when test="contains($l, 'mm')">
        <xsl:value-of select="number(substring-before($l, 'mm'))" />
      </xsl:when>
      <xsl:when test="contains($l, 'in')">
        <xsl:value-of select="number(number(substring-before($l, 'in')) * 2.54)" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- this template together whith the one handling textfields should probably be refactored -->
  <xsl:template name="textArea">
    <xsl:element name="p">
      <xsl:attribute name="style">
				<xsl:if test="boolean(caption/@reserve)">
					<xsl:text>width:</xsl:text>
					<xsl:value-of select="caption/@reserve" />
					<xsl:text>;</xsl:text>
				</xsl:if>
				<xsl:text>font-family:</xsl:text>
				<xsl:value-of select="caption/font/@typeface" />
				<xsl:text>;</xsl:text>
				<xsl:if test="boolean(font/@size)">
					<xsl:text>font-size:</xsl:text>
					<xsl:value-of select="font/@size" />
					<xsl:text>;</xsl:text>
				</xsl:if>
				<xsl:if test="boolean(font/@weight)">
					<xsl:text>font-weight:</xsl:text>
					<xsl:value-of select="font/@weight" />
					<xsl:text>;</xsl:text>
				</xsl:if>
				<xsl:if test="boolean(font/@underline)">
					<xsl:if test="font/@underline = '1'">
						<xsl:text>text-decoration:underline;</xsl:text>
					</xsl:if>
				</xsl:if>
				<xsl:if test="boolean(caption/para/@vAlign)">
					<xsl:text>vertical-align:</xsl:text>
					<xsl:value-of select="caption/para/@vAlign" />
					<xsl:text>;</xsl:text>
				</xsl:if>
			</xsl:attribute>
      <xsl:choose>
        <xsl:when test="boolean(caption/value/text/text())">
          <xsl:value-of select="caption/value/text/text()" />
        </xsl:when>
        <xsl:when test="boolean(value/text/text())">
          <xsl:value-of select="value/text/text()" />
        </xsl:when>
        <xsl:when test="boolean(value/exData)">
          <xsl:apply-templates select="value/exData" />
        </xsl:when>
        <xsl:when test="boolean(caption/value/exData)">
          <xsl:apply-templates select="caption/value/exData" />
        </xsl:when>
      </xsl:choose>
    </xsl:element>
    <xsl:if test="boolean(caption)">
      <xsl:element name="span">
        <xsl:attribute name="style">
					<xsl:text>position:absolute;top:0;left:</xsl:text>
					<xsl:value-of select="caption/@reserve" />
					<xsl:if test="boolean(para/@vAlign)">
						<xsl:text>;vertical-align:</xsl:text>
						<xsl:value-of select="para/@vAlign" />
						<xsl:text>;</xsl:text>
					</xsl:if>
					<xsl:if test="boolean(@w)">
						<xsl:text>width:</xsl:text>
						<xsl:value-of select="@w" />
						<xsl:text>;</xsl:text>
					</xsl:if>
					<xsl:if test="boolean(@h)">
						<xsl:text>height:</xsl:text>
						<xsl:value-of select="@h" />
						<xsl:text>;</xsl:text>
					</xsl:if>
				</xsl:attribute>
        <xsl:element name="textarea">
          <xsl:attribute name="style">
						<xsl:if test="boolean(@w)">
							<xsl:text>width:</xsl:text>
							<xsl:call-template name="input-width">
								<xsl:with-param name="w">
									<xsl:value-of select="@w" />
								</xsl:with-param>
								<xsl:with-param name="reserve">
									<xsl:value-of select="caption/@reserve" />
								</xsl:with-param>
							</xsl:call-template>
							<xsl:text>mm;</xsl:text>
						</xsl:if>
						<xsl:if test="boolean(@h)">
							<xsl:text>height:</xsl:text>
							<xsl:value-of select="@h" />
							<xsl:text>;</xsl:text>
						</xsl:if>
					</xsl:attribute>
          <xsl:attribute name="name">
						<xsl:value-of select="@name" />
					</xsl:attribute>
          <xsl:if test="boolean(value/text/@maxlength)">
            <xsl:attribute name="maxlength">
							<xsl:value-of select="value/text/@maxlength" />
						</xsl:attribute>
          </xsl:if>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template name="passwordEdit">
    <xsl:element name="span">
      <xsl:attribute name="style">
				<xsl:text>font-family:</xsl:text>
				<xsl:value-of select="caption/font/@typeface" />
				<xsl:text>;</xsl:text>
				<xsl:if test="boolean(caption/para/@vAlign)">
					<xsl:text>vertical-align:</xsl:text>
					<xsl:value-of select="caption/para/@vAlign" />
					<xsl:text>;</xsl:text>
				</xsl:if>
			</xsl:attribute>
      <xsl:value-of select="caption/value/text/text()" />
    </xsl:element>
    <xsl:element name="span">
      <xsl:attribute name="style">
				<xsl:text>position:absolute;left:</xsl:text>
				<xsl:value-of select="caption/@reserve" />
				<xsl:text>;</xsl:text>
				<xsl:if test="boolean(para/@vAlign)">
					<xsl:text>vertical-align:</xsl:text>
					<xsl:value-of select="para/@vAlign" />
					<xsl:text>;</xsl:text>
				</xsl:if>
			</xsl:attribute>
      <xsl:element name="input">
        <xsl:attribute name="type">
					<xsl:text>password</xsl:text>
				</xsl:attribute>
        <xsl:attribute name="name">
					<xsl:value-of select="@name" />
				</xsl:attribute>
        <xsl:attribute name="id">
					<xsl:value-of select="@name" />
				</xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="checkButton">
    <xsl:param name="name" />
    <xsl:choose>
      <xsl:when test="caption/@placement = 'right'">
        <!-- xsl:element name="span" -->
        <xsl:call-template name="checkbox">
          <xsl:with-param name="name" select="$name" />
        </xsl:call-template>
        <!-- /xsl:element -->
        <xsl:element name="div">
          <xsl:attribute name="style">
						<xsl:text>font-family:</xsl:text>
						<xsl:value-of select="caption/font/@typeface" />
						<xsl:text>;</xsl:text>
						<xsl:if test="boolean(caption/para/@vAlign)">
							<xsl:text>vertical-align:</xsl:text>
							<xsl:value-of select="caption/para/@vAlign" />
							<xsl:text>;</xsl:text>
						</xsl:if>
						<xsl:text>position:absolute;left:</xsl:text>
						<xsl:call-template name="input-width">
							<xsl:with-param name="w">
								<xsl:value-of select="@w" />
							</xsl:with-param>
							<xsl:with-param name="reserve">
								<xsl:value-of select="caption/@reserve" />
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>mm;vertical-align:</xsl:text>
						<xsl:value-of select="para/@vAlign" />
						<xsl:text>;</xsl:text>
					</xsl:attribute>
          <xsl:choose>
            <xsl:when test="boolean(caption/value/exData)">
              <xsl:apply-templates select="caption/value/exData" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="caption/value/text/text()" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:when>
      <xsl:when test="caption/@placement = 'left'">
        <xsl:element name="span">
          <xsl:attribute name="style">
						<xsl:text>font-family:</xsl:text>
						<xsl:value-of select="caption/font/@typeface" />
						<xsl:text>;</xsl:text>
						<xsl:if test="boolean(caption/para/@vAlign)">
							<xsl:text>vertical-align:</xsl:text>
							<xsl:value-of select="caption/para/@vAlign" />
							<xsl:text>;</xsl:text>
						</xsl:if>
					</xsl:attribute>
          <xsl:value-of select="caption/value/text/text()" />
        </xsl:element>
        <xsl:element name="span">
          <xsl:attribute name="style">
						<xsl:text>position:absolute;left:</xsl:text>
						<xsl:value-of select="caption/@reserve" />
						<xsl:text>;vertical-align:</xsl:text>
						<xsl:value-of select="para/@vAlign" />
						<xsl:text>;</xsl:text>
					</xsl:attribute>
        </xsl:element>
        <xsl:call-template name="checkbox">
          <xsl:with-param name="name" select="$name" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="checkbox">
    <xsl:param name="name" />
    <xsl:element name="input">
      <xsl:attribute name="type">
				<xsl:choose>
					<xsl:when test="ui/checkButton/@shape = 'round'">
						<xsl:text>radio</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>checkbox</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
      <xsl:attribute name="name">
				<xsl:choose>
					<xsl:when test="boolean($name)">
						<xsl:value-of select="$name" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@name" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
      <xsl:attribute name="id">
				<xsl:value-of select="@name" />
			</xsl:attribute>
      <xsl:attribute name="value">
				<xsl:value-of select="caption/value/text/text()" />
			</xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template name="choiceList">
    <xsl:choose>
      <xsl:when test="caption/@placement = 'top'">
        <xsl:element name="span">
          <xsl:attribute name="style">
						<xsl:text>font-family:</xsl:text>
						<xsl:value-of select="caption/font/@typeface" />
						<xsl:text>;</xsl:text>
						<xsl:if test="boolean(caption/para/@vAlign)">
							<xsl:text>vertical-align:</xsl:text>
							<xsl:value-of select="caption/para/@vAlign" />
							<xsl:text>;</xsl:text>
						</xsl:if>
					</xsl:attribute>
          <xsl:value-of select="caption/value/text/text()" />
        </xsl:element>
        <xsl:element name="span">
          <xsl:attribute name="style">
						<xsl:text>position:absolute;top:</xsl:text>
						<xsl:value-of select="caption/@reserve" />
						<xsl:text>;left:0;</xsl:text>
						<xsl:if test="boolean(para/@vAlign)">
							<xsl:text>vertical-align:</xsl:text>
							<xsl:value-of select="para/@vAlign" />
							<xsl:text>;</xsl:text>
						</xsl:if>
					</xsl:attribute>
          <xsl:call-template name="select" />
        </xsl:element>
      </xsl:when>
      <xsl:when test="not(boolean(caption/@placement))">
        <xsl:element name="span">
          <xsl:attribute name="style">
						<xsl:text>font-family:</xsl:text>
						<xsl:value-of select="caption/font/@typeface" />
						<xsl:text>;</xsl:text>
						<xsl:if test="boolean(caption/para/@vAlign)">
							<xsl:text>vertical-align:</xsl:text>
							<xsl:value-of select="caption/para/@vAlign" />
							<xsl:text>;</xsl:text>
						</xsl:if>
					</xsl:attribute>
          <xsl:value-of select="caption/value/text/text()" />
        </xsl:element>
        <xsl:element name="span">
          <xsl:attribute name="style">
						<xsl:text>position:absolute;left:</xsl:text>
						<xsl:value-of select="caption/@reserve" />
						<xsl:text>;vertical-align:</xsl:text>
						<xsl:value-of select="para/@vAlign" />
						<xsl:text>;</xsl:text>
					</xsl:attribute>
          <xsl:call-template name="select" />
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="select">
    <xsl:element name="select">
      <xsl:attribute name="name">
				<xsl:value-of select="@name" />
			</xsl:attribute>
      <xsl:attribute name="id">
				<xsl:value-of select="@name" />
			</xsl:attribute>
      <xsl:choose>
        <xsl:when test="ui/choiceList/@open = 'always'">
          <xsl:attribute name="size">5</xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:for-each select="items[position() = 1]/text">
        <xsl:element name="option">
          <xsl:attribute name="value">
						<xsl:value-of select="text()" />
					</xsl:attribute>
          <xsl:value-of select="text()" />
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template name="rectangle">
    <xsl:if test="boolean(value/rectangle)">
      <xsl:text>
				border-color:#000;border-width:10;position:absolute;top:
			</xsl:text>
      <xsl:value-of select="@y" />
      <xsl:text>;left:</xsl:text>
      <xsl:value-of select="@x" />
      <xsl:text>;width:</xsl:text>
      <xsl:value-of select="@w" />
      <xsl:text>;height:</xsl:text>
      <xsl:value-of select="@h" />
      <xsl:text>;</xsl:text>
    </xsl:if>
  </xsl:template>
  <xsl:template name="line">
    <xsl:if test="boolean(value/line)">
      <xsl:text>position:absolute;top:</xsl:text>
      <xsl:value-of select="@y" />
      <xsl:text>;left:</xsl:text>
      <xsl:value-of select="@x" />
      <xsl:text>;width:</xsl:text>
      <xsl:value-of select="@w" />
      <xsl:text>;height:</xsl:text>
      <xsl:choose>
        <xsl:when test="substring-before(@h, 'in') = '0'">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@h" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="margin">
    <xsl:if test="boolean(margin/@topInset)">
      <xsl:text>margin-top:</xsl:text>
      <xsl:value-of select="margin/@topInset" />
      <xsl:text>;</xsl:text>
    </xsl:if>
    <xsl:if test="boolean(margin/@bottomInset)">
      <xsl:text>margin-bottom:</xsl:text>
      <xsl:value-of select="margin/@bottomInset" />
      <xsl:text>;</xsl:text>
    </xsl:if>
    <xsl:if test="boolean(margin/@leftInset)">
      <xsl:text>margin-left:</xsl:text>
      <xsl:value-of select="margin/@leftInset" />
      <xsl:text>;</xsl:text>
    </xsl:if>
    <xsl:if test="boolean(margin/@rightInset)">
      <xsl:text>margin-right:</xsl:text>
      <xsl:value-of select="margin/@rightInset" />
      <xsl:text>;</xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

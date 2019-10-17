<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:     	phrase-timing2avs.xslt
    # Purpose:  	Create an avs file from a SAB timing and Phrases file.
    # Part of:  		Xrunner - https://github.com/SILAsiaPub/xrunner
    # Author:   	Ian McQuay <ian_mcquay@sil.org>
    # Created:  	2019-09-13
    # Copyright:	(c) 2019 SIL International
    # Licence:  	<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
    <xsl:output method="text" encoding="utf-8"/>
    <xsl:include href="project.xslt"/>
    <xsl:template match="/">
        <xsl:call-template name="source">
            <xsl:with-param name="image" select="$bgimage"/>
        </xsl:call-template>
        <xsl:text>&#10;</xsl:text>
        <xsl:for-each select="$timing">
            <xsl:variable name="pos" select="position()"/>
            <xsl:variable name="phrase" select="tokenize($text[number($pos)],'\|')[2]"/>
            <xsl:variable name="word" select="tokenize($phrase,' ')"/>
            <xsl:variable name="cell" select="tokenize(.,'\t')"/>
            <xsl:choose>
                <xsl:when test="count($word) gt 21">
                    <xsl:text>&#10;# more than 21 words</xsl:text>
                    <xsl:call-template name="scroll-line">
                        <xsl:with-param name="frameStart" select="format-number((number($cell[1])  - number($pre-sec) - 1)  * number($fps),'0')"/>
                        <xsl:with-param name="txt" select="f:getwords($word,0,8)"/>
                        <!-- substring-before($phrase,concat($word[8],' ')) -->
                    </xsl:call-template>
                    <xsl:call-template name="scroll-line">
                        <xsl:with-param name="frameStart" select="format-number((number($cell[1])  - number($pre-sec) ) * number($fps),'0')"/>
                        <xsl:with-param name="txt" select="f:getwords($word,7,15)"/>
                        <!-- substring-before(substring-after($phrase,$word[7]),$word[15]) -->
                    </xsl:call-template>
                    <xsl:call-template name="scroll-line">
                        <xsl:with-param name="frameStart" select="format-number((number($cell[1])  - number($pre-sec) +1) * number($fps),'0')"/>
                        <xsl:with-param name="txt" select="f:getwords($word,14,22)"/>
                        <!-- substring-before(substring-after($phrase,$word[14]),$word[22]) -->
                    </xsl:call-template>
                    <xsl:call-template name="scroll-line">
                        <xsl:with-param name="frameStart" select="format-number((number($cell[1])  - number($pre-sec) + 2) * number($fps),'0')"/>
                        <xsl:with-param name="txt" select="f:getwords($word,21,count($word) + 1)"/>
                        <!-- substring-after($phrase,$word[21]) -->
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="count($word) gt 14">
                    <xsl:text>&#10;# more than 14 words</xsl:text>
                    <xsl:call-template name="scroll-line">
                        <xsl:with-param name="frameStart" select="format-number((number($cell[1])  - number($pre-sec) - 1) * number($fps),'0')"/>
                        <xsl:with-param name="txt" select="f:getwords($word,0,8)"/>
                    </xsl:call-template>
                    <xsl:call-template name="scroll-line">
                        <xsl:with-param name="frameStart" select="format-number((number($cell[1])  - number($pre-sec)) * number($fps),'0')"/>
                        <xsl:with-param name="txt" select="f:getwords($word,7,15)"/>
                    </xsl:call-template>
                    <xsl:call-template name="scroll-line">
                        <xsl:with-param name="frameStart" select="format-number((number($cell[1])  - number($pre-sec) + 1) * number($fps),'0')"/>
                        <xsl:with-param name="txt" select="f:getwords($word,14,count($word) + 1)"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="count($word) gt 8">
                    <xsl:text>&#10;# more than 9 words</xsl:text>
                    <xsl:call-template name="scroll-line">
                        <xsl:with-param name="frameStart" select="format-number((number($cell[1])  - number($pre-sec) - 1) * number($fps),'0')"/>
                        <xsl:with-param name="txt" select="f:getwords($word,0,8)"/>
                    </xsl:call-template>
                    <xsl:call-template name="scroll-line">
                        <xsl:with-param name="frameStart" select="format-number((number($cell[1])  - number($pre-sec) ) * number($fps),'0')"/>
                        <xsl:with-param name="txt" select="f:getwords($word,7,count($word) + 1)"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#10;# less than 9 words</xsl:text>
                    <xsl:call-template name="scroll-line">
                        <xsl:with-param name="frameStart" select="format-number((number($cell[1])  - number($pre-sec)) * number($fps),'0')"/>
                        <xsl:with-param name="txt" select="$phrase"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:call-template name="func"/>
    </xsl:template>
    <xsl:template name="scroll-line">
        <xsl:param name="frameStart"/>
        <xsl:param name="txt"/>
        <xsl:text>&#10;clip = clip.VScrollTitle( </xsl:text>
        <xsl:value-of select="$frameStart"/>
        <xsl:text> , "</xsl:text>
        <xsl:value-of select="$txt"/>
        <xsl:text>", "</xsl:text>
        <xsl:value-of select="$font-name"/>
        <xsl:text>", </xsl:text>
        <xsl:value-of select="$font-size"/>
        <xsl:text>, $ffffff ,</xsl:text>
        <xsl:value-of select="$onscreen"/>
        <xsl:text> )</xsl:text>
    </xsl:template>
    <xsl:template name="source">
        <xsl:param name="image"/>
        <xsl:text>clip = ImageSource("</xsl:text>
        <xsl:value-of select="$image"/>
        <xsl:text>", end = </xsl:text>
        <xsl:value-of select="$audio-len"/>
        <xsl:text>, fps = </xsl:text>
        <xsl:value-of select="$fps"/>
        <xsl:text>)&#10;audio = DirectShowSource("</xsl:text>
        <xsl:value-of select="$mp3"/>
        <xsl:text>", video=False)</xsl:text>
    </xsl:template>
    <xsl:template name="func">
        <xsl:text>
return AudioDub(clip,audio )

   function VScrollTitle( clip    Clop, \
                          int     StartFrame, \
                          string  Title, \
                          string  Font, \
                          int     FontSize, \
                          int     Colour, \
                          int     Time ) {

       ef = StartFrame + int( Time * Clop.FrameRate )
       return Animate( Clop, StartFrame, ef, "subtitle",\
       Title, Clop.width/2, int(Clop.Height*1.2), StartFrame, ef, Font, FontSize, Colour, 0, 5, 0, -1,\
       Title, Clop.width/2,                    0, StartFrame, ef, Font, FontSize, Colour, 0, 5, 0, -1)
   }
</xsl:text>
    </xsl:template>
    <xsl:template name="func1">
        <xsl:text>

   function SABscroll( clip    Clop, \
                          float     StartTime, \
                          float     EndTime, \
                          string  Title, \
                          string  Font, \
                          int     FontSize, \
                          int     Colour ) {
       ef = int( EndTime * Clop.FrameRate )
       sf = int(StartTime * Clop.FrameRate)
       return Animate( Clop, sf, ef, "subtitle",\
       Title, Clop.width/2, int(Clop.Height*1.2), sf, ef, Font, FontSize, Colour, 0, 0, -1,\
       Title, Clop.width/2,                    0, sf, ef, Font, FontSize, Colour, 0, 0, -1)
   }
</xsl:text>
    </xsl:template>
    <xsl:template name="selectword">
        <xsl:param name="phrase"/>
        <xsl:param name="count"/>
        <xsl:param name="first"/>
        <xsl:param name="last"/>
        <xsl:if test="number($count) gt number($first) and number($count) lt number($last)">
            <xsl:value-of select="concat($phrase[number($count)],' ')"/>
            <xsl:call-template name="selectword">
                <xsl:with-param name="phrase" select="$phrase"/>
                <xsl:with-param name="count" select="number($count) + 1"/>
                <xsl:with-param name="first" select="$first"/>
                <xsl:with-param name="last" select="$last"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:function name="f:getwords">
        <xsl:param name="phrase"/>
        <xsl:param name="pre"/>
        <xsl:param name="post"/>
        <xsl:for-each select="$phrase">
            <xsl:if test="position() gt number($pre)">
                <xsl:if test="position() lt number($post)">
                    <xsl:value-of select="concat(.,' ')"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <!--
        <xsl:call-template name="selectword">
            <xsl:with-param name="phrase" select="$phrase"/>
            <xsl:with-param name="count" select="1"/>
            <xsl:with-param name="first" select="$first"/>
            <xsl:with-param name="last" select="$last"/>
        </xsl:call-template> -->
    </xsl:function>
</xsl:stylesheet>

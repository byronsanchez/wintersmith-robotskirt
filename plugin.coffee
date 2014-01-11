async = require 'async'
Robotskirt = require 'robotskirt'
fs = require 'fs'
path = require 'path'
url = require 'url'
hljs = require 'highlight.js'

renderMarkdownIntoHtml = (env, page) ->

  extensions = env.config.robotskirt.extensions or []
  htmlFlags = env.config.robotskirt.htmlFlags or []
  isSmartypantsEnabled = env.config.robotskirt.smart or false

  robotskirtExtensions = convertConfigurationStringsIntoRobotskirtIDs(extensions)
  robotskirtHtmlFlags = convertConfigurationStringsIntoRobotskirtIDs(htmlFlags)

  renderer = new Robotskirt.HtmlRenderer(robotskirtHtmlFlags)
  renderer = defineSyntaxHighlightingForCodeBlocks(renderer)
  markdown = new Robotskirt.Markdown(renderer, robotskirtExtensions)
  renderedHtml = markdown.render(page.markdown)

  if isSmartypantsEnabled
    renderedHtml = Robotskirt.smartypantsHtml(renderedHtml)

  return renderedHtml

convertConfigurationStringsIntoRobotskirtIDs = (configurationStringObject) ->

  robotskirtIDs = []
  for v,k in configurationStringObject
    uppercaseValue = v.toUpperCase()
    robotskirtIDs[k] = Robotskirt[uppercaseValue]

  return robotskirtIDs

defineSyntaxHighlightingForCodeBlocks = (renderer) ->

  renderer.blockcode = (code, lang) ->
    if lang?
      try
        lang = 'cpp' if lang is 'c'
        return "<div><pre><code class=\"lang-#{lang}\">" + hljs.highlight(lang, code).value + "</code></pre></div>"
      catch error
        return code
    else
      lang = 'text'
      return "<div><pre><code class=\"lang-#{lang}\">" + code + "</code></pre></div>"

  return renderer

module.exports = (env, callback) ->

  class RobotskirtPage extends env.plugins.MarkdownPage

    # Method written by Luke Hagan (lukehagan.com)
    # Licensed under the MIT license
    # https://github.com/lhagan/wintersmith-showdown/blob/master/plugin.coffee
    # Commit ID: 24cb3539b23d3749cfcad90012f1d98d544d9868
    getHtml: (base=env.config.baseUrl) ->
      # TODO: cleaner way to achieve this?
      # http://stackoverflow.com/a/4890350
      name = @getFilename()
      name = name[name.lastIndexOf('/')+1..]
      loc = @getLocation(base)
      fullName = if name is 'index.html' then loc else loc + name
      # handle links to anchors within the page
      @_html = @_htmlraw.replace(/(<(a|img)[^>]+(href|src)=")(#[^"]+)/g, '$1' + fullName + '$4')
      # handle relative links
      @_html = @_html.replace(/(<(a|img)[^>]+(href|src)=")(?!http|\/)([^"]+)/g, '$1' + loc + '$4')
      # handles non-relative links within the site (e.g. /about)
      if base
        @_html = @_html.replace(/(<(a|img)[^>]+(href|src)=")\/([^"]+)/g, '$1' + base + '$4')
      return @_html

    getIntro: (base) ->
      html = @getHtml(base)
      cutoffs = ['<!--more-->', '<span class="more', '<h2', '<hr']
      idx = Infinity
      for cutoff in cutoffs
        i = html.indexOf cutoff
        if i isnt -1 and i < idx
          idx = i
      if idx isnt Infinity
        return html.substr 0, idx
      else
        return html

    @property 'hasMore', ->
      @_html ?= @getHtml()
      @_intro ?= @getIntro()
      @_hasMore ?= (@_html.length > @_intro.length)
      return @_hasMore

  RobotskirtPage.fromFile = (filepath, callback) ->

    async.waterfall [
      (callback) ->
        fs.readFile filepath.full, callback
      (buffer, callback) ->
        RobotskirtPage.extractMetadata buffer.toString(), callback
      (result, callback) =>
        {markdown, metadata} = result
        page = new this filepath, metadata, markdown
        callback null, page
      (page, callback) =>
        renderedHtml = renderMarkdownIntoHtml(env, page)
        page._htmlraw = renderedHtml
        callback null, page
      (page, callback) =>
        callback null, page
    ], callback
   
  env.registerContentPlugin 'pages', '**/*.*(markdown|mkd|md)', RobotskirtPage

  callback()


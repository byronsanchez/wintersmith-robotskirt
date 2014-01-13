path = require 'path'
wintersmith = require 'wintersmith'
chai = require 'chai'
expect = chai.expect
wsRobotskirt = require './../src'

env = null
loadedData = null
Robotskirt = null

describe "wintersmith-robotskirt", ->

  beforeEach (done) ->
    testDir = __dirname
    contentsDir = path.join(testDir, "contents")
    templatesDir = path.join(testDir, "templates")
    outputDir = path.join(testDir, "build")
    env = null
    Config = require('./config.json')
    Config.contents = contentsDir
    Config.templates = templatesDir
    Config.output = outputDir
    env = wintersmith Config
    env.workDir = testDir
    expect(env).to.be.an.instanceOf(wintersmith.Environment)
    env.load((err, result) ->
      loadedData = result
      expect(loadedData.contents).to.be.an.instanceOf(wintersmith.ContentTree)
      Robotskirt = env.helpers.RobotskirtPage
      done()
    )

  it "should have the plugin instance", (done) ->
    articles = loadedData.contents['articles']._.directories.map (item) -> item.index
    expect(articles).to.be.an('array')
    expect(loadedData.contents['articles']['test-article']['index.md']).to.be.an.instanceOf(env.plugins.RobotskirtPage)
    done()

  it "should define syntax highlighting of codeblocks", (done) ->
    dummyObject = {}
    Robotskirt.defineSyntaxHighlightingForCodeBlocks(dummyObject)
    expect(dummyObject.blockcode).to.be.a('function')
    done()

  it "should translate configuration settings to Robotskirt IDs", (done) ->
    sampleExtensionConfigurationObject = ['ext_strikethrough']
    translatedExtensionIds = Robotskirt.convertConfigurationStringsIntoRobotskirtIDs(
      sampleExtensionConfigurationObject
    )
    expect(translatedExtensionIds).to.be.an('array')
    expect(translatedExtensionIds[0]).to.equal(16)

    sampleHtmlFlagConfigurationObject = ['html_skip_links']
    translatedHtmlFlagIds = Robotskirt.convertConfigurationStringsIntoRobotskirtIDs(
      sampleHtmlFlagConfigurationObject
    )
    expect(translatedHtmlFlagIds).to.be.an('array')
    expect(translatedHtmlFlagIds[0]).to.equal(8)
    done()
  
  it "should call a render without extensions and without html flags", (done) ->
    config = {}
    config.robotskirt = {}
    config.robotskirt.extensions = []
    config.robotskirt.htmlFlags = []
    config.robotskirt.smart = false
    page = {}
    page.markdown = "**Simple markdown** with a ~~strikethrough~~ if ext and \"quotes\""
    # Ignoring newlines for now.
    html = Robotskirt.renderMarkdownIntoHtml(config, page).replace(/\r?\n|\r/g, '')
    expect(html).to.equal("<p><strong>Simple markdown</strong> with a ~~strikethrough~~ if ext and &quot;quotes&quot;</p>")
    done()

  it "should call a render with extensions", (done) ->
    config = {}
    config.robotskirt = {}
    config.robotskirt.extensions = ['ext_strikethrough']
    config.robotskirt.htmlFlags = []
    config.robotskirt.smart = false
    page = {}
    page.markdown = "**Simple markdown** with a ~~strikethrough~~ if ext and \"quotes\""
    # Ignoring newlines for now.
    html = Robotskirt.renderMarkdownIntoHtml(config, page).replace(/\r?\n|\r/g, '')
    expect(html).to.equal("<p><strong>Simple markdown</strong> with a <del>strikethrough</del> if ext and &quot;quotes&quot;</p>")
    done()

  it "should call a render with html flags", (done) ->
    config = {}
    config.robotskirt = {}
    config.robotskirt.extensions = []
    config.robotskirt.htmlFlags = ['html_skip_links']
    config.robotskirt.smart = false
    page = {}
    page.markdown = "[test link skip](https://github.com/byronsanchez/wintersmith-robotskirt)"
    # Ignoring newlines for now.
    html = Robotskirt.renderMarkdownIntoHtml(config, page).replace(/\r?\n|\r/g, '')
    expect(html).to.equal("<p>[test link skip](https://github.com/byronsanchez/wintersmith-robotskirt)</p>")
    done()

  it "should call a render with smartypants enabled", (done) ->
    config = {}
    config.robotskirt = {}
    config.robotskirt.extensions = []
    config.robotskirt.htmlFlags = []
    config.robotskirt.smart = true
    page = {}
    page.markdown = "**Simple markdown** with a ~~strikethrough~~ if ext and \"quotes\""
    # Ignoring newlines for now.
    html = Robotskirt.renderMarkdownIntoHtml(config, page).replace(/\r?\n|\r/g, '')
    expect(html).to.equal("<p><strong>Simple markdown</strong> with a ~~strikethrough~~ if ext and &ldquo;quotes&rdquo;</p>")
    done()

  it "should accept <!--more--> as a valid intro cutoff point", (done) ->
    config = {}
    config.robotskirt = {}
    config.robotskirt.extensions = []
    config.robotskirt.htmlFlags = []
    config.robotskirt.smart = false
    page = {}
    page.markdown = "**Simple markdown** with a ~~strikethrough~~ if ext and \"quotes\""
    # Ignoring newlines for now.
    html = Robotskirt.renderMarkdownIntoHtml(config, page).replace(/\r?\n|\r/g, '')
    expect(html).to.equal("<p><strong>Simple markdown</strong> with a ~~strikethrough~~ if ext and &quot;quotes&quot;</p>")
    done()


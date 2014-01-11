# wintersmith-robotskirt

[Robotskirt](https://github.com/benmills/robotskirt) plugin for 
[Wintersmith](https://github.com/jnordberg/wintersmith). It will render
Markdown content using Robotskirt. Code highlighting is done via 
[highlight.js](https://github.com/isagalaev/highlight.js).

## Requirements

This repo is meant to be used as a plugin for 
[Wintersmith](https://github.com/jnordberg/wintersmith)-generated websites. To 
use this plugin, simply setup a wintersmith website and follow the setup 
instructions below.

## Setup

Setting up the plugin is very simple:

    npm install wintersmith-robotskirt

Alternatively, you can define the plugin as a dependency in your `package.json` file and run:

    npm install

In your `config.json` file, you must define the location of the plugin:

    "plugins": [
      "./node_modules/wintersmith-robotskirt/"
    ]

## Configuration

You may configure how robotskirt parses the Markdown content using Robotskirt
extensions. Simply define the extensions you wish to use in `config.json` as 
follows:

    "robotskirt": {
      "extensions": [
        "ext_fenced_code",
        "ext_no_intra_emphasis",
        "ext_tables",
        "ext_strikethrough",
        "ext_superscript"
      ]
    }

You may also configure how the HTML renderer outputs your html files. Identify 
the flags you need in `config.json`:

    "robotskirt": {
      "html_flags": [
        "html_use_xhtml",
        "html_hard_wrap"
      ]
    }

List of available Robotskirt extensions:

- ext_fenced_code
- ext_no_intra_emphasis
- ext_autolink
- ext_strikethrough
- ext_lax_spacing
- ext_superscript
- ext_tables

List of HTML rendering flags:

- html_skip_html
- html_skip_style
- html_skip_images
- html_skip_links
- html_expand_tabs
- html_safelink
- html_toc
- html_hard_wrap
- html_use_xhtml
- html_escape

## Usage

After doing the initial setup and configuration, your wintersmith builds will 
automatically use Robotskirt to render html pages.

## License

TODO


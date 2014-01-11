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

You may configure how robotskirt renders the html defining any of robotskirt's
available extensions in a robotskirt configuration option in `config.json.`:

    "robotskirt": {
      "extensions": [
        "ext_fenced_code",
        "ext_no_intra_emphasis",
        "ext_tables",
        "ext_strikethrough",
        "ext_superscript"
      ]
    }

The available extensions are as follows:

- ext_fenced_code
- ext_no_intra_emphasis
- ext_autolink
- ext_strikethrough
- ext_lax_spacing
- ext_superscript
- ext_tables

## Usage

After doing the initial setup and configuration, your wintersmith builds will 
automatically use Robotskirt to render html pages.

## License

TODO


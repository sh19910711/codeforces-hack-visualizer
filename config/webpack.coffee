webpack = require("webpack")
path = require("path")

webpackPlugins = []

webpackPlugins.push new webpack.ResolverPlugin [
  new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin "bower.json", ["main"]
]

webpackPlugins.push new webpack.DefinePlugin
  VERSION: JSON.stringify("0.0.0")
  DEBUG: process.env["DEBUG"] == "yes"

unless process.env["DEBUG"] == "yes"
  console.log "webpack: enable uglifyjs"
  webpackPlugins.push new webpack.optimize.UglifyJsPlugin
    compress:
      warnings: false

webpackPlugins.push new webpack.IgnorePlugin /^\.\/locale$/, /moment$/

module.exports =
  
  entry:
    "main": "main"
    "worker": "worker"
 
  resolve:
    root: [
      path.join(__dirname, "../bower_components")
      path.join(__dirname, "../src/coffee")
    ]

    extensions: [
      ""
      ".coffee"
      ".js"
    ]

  output:
    filename: "[name].js"

  externals:
    "jquery": "jQuery"

  module:
    loaders: [
      { test: /\.coffee$/, loader: "coffee" }
    ]

  plugins: webpackPlugins


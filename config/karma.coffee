module.exports = (config)->

  config.set

    basePath: "../"

    frameworks: ["mocha", "chai", "sinon"]

    preprocessors:
      "spec/**/*.coffee": ["webpack"]
      "tmp/html/**/*.html": ["html2js"]

    webpack: require("./webpack")

    webpackMiddleware:
      noInfo: true

    reporters: ["spec"]

    port: 9876

    colors: true

    logLevel: config.LOG_INFO

    autoWatch: false

    browsers: [
      "PhantomJS"
    ]

    singleRun: true


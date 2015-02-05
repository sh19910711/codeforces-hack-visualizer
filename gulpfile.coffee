gulp = require("gulp")

gulp.task "default", ["build"] 

gulp.task "build", [
  "main.js"
  "style.css"
]

gulp.task "bower", (done)->
  bower = require("bower")
  bower.commands.install().on "end", ->
    done()
  undefined

gulp.task "watch", ->
  gulp.watch "src/sass/**/*.scss", ["style.css"]
  gulp.watch "src/coffee/**/*.coffee", ["main.js"]

gulp.task "main.js", ["bower"], ->
  gulpWebpack = require("gulp-webpack")
  webpackConfig = require("./config/webpack")

  gulp.src ["src/coffee/**/*.coffee"]
    .pipe gulpWebpack(webpackConfig)
    .pipe gulp.dest("lib/public/js/")

gulp.task "style.css", ->
  sass = require("gulp-sass")
  minify = require("gulp-minify-css")
  gulp.src ["src/sass/**/*.scss"]
    .pipe sass()
    .pipe minify()
    .pipe gulp.dest("lib/public/css/")

gulp.task "template.html", ->
  run = require("gulp-run")
  streamify = require("gulp-streamify")
  concat = require("gulp-concat")
  gulp.src ["lib/views/template.slim"]
    .pipe run("bundle exec slimrb -s", verbosity: 1)
    .pipe streamify(concat "template.html")
    .pipe gulp.dest("tmp/html/")

gulp.task "test", ["bower", "template.html"], ->
  karma = require("gulp-karma")
  testScripts = [
    "tmp/html/**/*.html"
    "bower_components/jquery/dist/jquery.js"
    "spec/coffee/spec_helper.coffee"
    "spec/coffee/**/*_spec.coffee"
  ]
  gulp.src testScripts
    .pipe karma
      configFile: "config/karma.coffee"

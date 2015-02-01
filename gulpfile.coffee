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

gulp.task "main.js/watch", ->
  gulp.watch "src/coffee/**/*.coffee", ["main.js"]

gulp.task "main.js", ["bower"], ->
  gulpWebpack = require("gulp-webpack")
  webpackConfig = require("./config/webpack")

  gulp.src ["src/coffee/**/*.coffee"]
    .pipe gulpWebpack(webpackConfig)
    .pipe gulp.dest("lib/public/js/")

gulp.task "style.css", ->
  sass = require("gulp-sass")
  gulp.src ["src/sass/**/*.scss"]
    .pipe sass()
    .pipe gulp.dest("lib/public/css/")

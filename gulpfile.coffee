gulp    = require 'gulp'
shell   = require 'gulp-shell'
coffee  = require 'gulp-coffee'
uglify = require('gulp-uglify')
# sass    = require 'gulp-sass'
stylus = require('gulp-stylus')
plumber = require 'gulp-plumber'

gulp.task 'default', ['build']
gulp.task 'build', [
  'compress:js'
  'build:css'
  # 'build:web'
]

gulp.task 'build:coffee', ->
  gulp.src('src/coffee/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('temp'))

gulp.task 'build:css', () ->
  gulp.src 'src/styles/*.styl'
      .pipe plumber()
      .pipe stylus compress: true
      .pipe gulp.dest 'dist/'

gulp.task 'compress:js', ['build:coffee', 'build:bundle'], ->
  gulp.src 'temp/**/*.js'
      .pipe uglify()
      .pipe gulp.dest 'dist/'


source = require 'vinyl-source-stream'
webpack = require('gulp-webpack')

gulp.task 'build:bundle', shell.task [
  'webpack'
]


gulp.task 'default', ['build']


gulp.task 'watch', ['build'], ->
  gulp.watch 'src/**/*.coffee', ['build:coffee']
  gulp.watch 'src/styles/**/*.scss', ['build:css']
  # gulp.watch 'temp/**/*', ['build:web']

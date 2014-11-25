module.exports = (grunt)->
  'use strict'
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    watch:
      files: [
        './*.styl'
        './*.coffee'
      ]
      tasks: ['stylus', 'coffee']

    stylus:
      compile:
        options:
          paths: ['/usr/local/lib/node_modules/nib/lib/']
        files:
          './cinnamon.css': './cinnamon.styl'

    coffee:
      compile:
        files:
          'hatena_recommend_widget.js': [
            'hatena_recommend_widget.coffee'
          ]

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.registerTask 'default', ['watch']

module.exports = (grunt)->
  'use strict'
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    watch:
      files: [
        './*.styl'
        './*.coffee'
        './generator/coffee/*.coffee'
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
        expand: yes
        files:
          'hatena_recommend_widget.js': 'hatena_recommend_widget.coffee'
          './generator/js/profile_gen.js': './generator/coffee/profile_gen.coffee'

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.registerTask 'default', ['watch']

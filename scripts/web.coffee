# Description:
#   Setup a webpage for Hubot
#
# Author:
#   jjgrainger

module.exports = (robot) ->

  # get the bootstrap script for spotify app
  boot = require './../apps/web/boot.coffee'

  # run bootstrap
  boot robot

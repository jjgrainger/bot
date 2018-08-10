# Description
#   Display notification message for Github webhook
#
# Author:
#   jjgrainger <github@jjgrainger.co.uk>

module.exports = (robot) ->

  # get the bootstrap script for spotify app
  boot = require './../apps/github/boot.coffee'

  # run bootstrap
  boot robot

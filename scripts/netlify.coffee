# Description
#   Display notification message for Netlify webhook
#
# Author:
#   jjgrainger <github@jjgrainger.co.uk>

module.exports = (robot) ->

  # get the bootstrap script for spotify app
  boot = require './../apps/netlify/boot.coffee'

  # run bootstrap
  boot robot

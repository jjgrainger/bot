# Description
#   Display notification message for Netlify webhook
#
# Configuration:
#   NETLIFY_ACCESS_TOKEN
#
# Commands:
#   hubot netlify deploy <site_id> - trigger a deploy
#
# Author:
#   jjgrainger <github@jjgrainger.co.uk>

module.exports = (robot) ->

  # get the bootstrap script for spotify app
  boot = require './../apps/netlify/boot.coffee'

  # run bootstrap
  boot robot

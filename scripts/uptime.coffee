# Description
#   Uptime monitoring
#
# Configuration:
#   UPTIMEROBOT_API_KEY
#   HUBOT_URL
#
# Commands:
#   hubot monitor add <url> - add uptime monitoring for site
#   hubot monitor status <monitor> - show current status for the monitor
#
# Author:
#   jjgrainger <github@jjgrainger.co.uk>

module.exports = (robot) ->

  # get the bootstrap script for spotify app
  boot = require './../apps/uptime/boot.coffee'

  # run bootstrap
  boot robot

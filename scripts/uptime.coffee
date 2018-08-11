# Description
#   Uptime monitoring
#
# Commands:
#   hubot monitor add <url> - add uptime monitoring for site
#   hubot monitor status <monitor> - show current status for the monitor
#
# Author:
#   jjgrainger <josephgrainger@gmail.com>

module.exports = (robot) ->

  # get the bootstrap script for spotify app
  boot = require './../apps/uptime/boot.coffee'

  # run bootstrap
  boot robot

# Description
#   Get weather reports from Open Weather Maps APIs
#
# Configuration:
#   WEATHER_API_KEY
#   WEATHER_UNITS
#
# Commands:
#   hubot weather <location> - see the current weather for a location
#   hubot forecast <location> - see the weather forecast for a location
#
# Author:
#   jjgrainger <github@jjgrainger.co.uk>

module.exports = (robot) ->

  # get the bootstrap script for spotify app
  boot = require './../apps/weather/boot.coffee'

  # run bootstrap
  boot robot

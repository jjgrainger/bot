# Description
#   Control Spotify playback with Hubot
#
# Configuration:
#   SPOTIFY_CLIENT_ID
#   SPOTIFY_CLIENT_SECRET
#   HUBOT_URL
#
# Commands:
#   hubot spotify me - show's you who's logged in
#   hubot spotify play <search> - plays a song on spotify by search term
#   hubot spotify now - show currently playing track
#   hubot spotify pause - pause the current playback
#   hubot spotify resume - resume the current playback
#   hubot spotify next - skip to next track
#   hubot spotify [previous|prev] - go back to previous track
#   hubot spotify [volume|vol|v] <0-100> - set the volume
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   jjgrainger <github@jjgrainger.co.uk>

module.exports = (robot) ->

  # get the bootstrap script for spotify app
  boot = require './../apps/spotify/boot.coffee'

  # run bootstrap
  boot robot

# Description
#   Grab a Chuck Norris joke, can also personalise with name
#
# Commands:
#   hubot chuck - get a random chuck norris joke
#   hubot chuck me - replace your name in chuck norris joke
#   hubot chuck <name> - replace <name> in chuck norris joke
#
# Author:
#   jjgrainger <github@jjgrainger.co.uk>

request = require 'request'

module.exports = (robot) ->

  robot.respond /chuck?(.*)/i, (msg) ->
    # grab the name passed
    name = msg.match[1].trim()

    # setup request options
    options = {
      url: 'http://api.icndb.com/jokes/random',
    }

    # if the name matches 'me'
    if name.match /me/i
      # replace with the users @name
      name = "@#{msg.message.user.name}"

    # if a name was passed
    if name.length > 0
      # split the name to get the first and last
      name = name.split ' '

      # set first and last name as query string options
      options.qs = {
        firstName: name[0],
        lastName: name[1] || ''
      }

    # display request options in debugging
    robot.logger.debug "hubot/chuck: request options", JSON.stringify options

    # get the joke from the api
    request options, (err, res, body) ->
      data = JSON.parse body

      if data.type == 'success'
        # get joke, remove double space when no last name
        joke = data.value.joke.replace '  ', ' '

        msg.send "> #{joke}"
      else
        msg.send "Uh oh?! Looks like something went wrong..."





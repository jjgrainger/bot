# Add Spotify commands to Hubot

module.exports = (robot, client) ->
  # get the track attachment function
  trackAttachment = require './messages/track.coffee'

  # Get the authotization url
  robot.respond /spotify auth/i, (msg) ->
    msg.send process.env.HUBOT_URL + "/hubot/spotify/auth"

  # See who's logged in/authenticated
  robot.respond /spotify me/i, (msg) ->
    client.get '/me', (err, res, body) ->
      # parse the response
      data = JSON.parse body
      # get the users name, fallback to their username
      username = data.display_name ? data.id
      # get the profile url
      link = data.external_urls.spotify

      robot.logger.info "hubot/spotify: logged in as %s", username

      msg.send "Currently logged in as <#{link}|#{username}>"

  # Ask hubot to play a song, hubot spotify play <query>
  robot.respond /spotify play (.*)/i, (msg) ->
    # get search query from messafe
    query = msg.match[1].trim()

    # look for a track on Spotify with query
    client.get '/search', { q: query, type: 'track', limit: 1 }, (err, res, data) ->

      data = JSON.parse data
      track = data.tracks.items.shift()

      if track

        robot.logger.info "hubot/spotify: track found %s - by %s for query '%s'", track.name, track.artists[0].name, query

        params =
          context_uri: track.album.uri,
          offset:
            uri: track.uri

        client.put '/me/player/play', params, (err, res, body) ->
          msg.send trackAttachment msg.message.room, track

      # if no tracks are found
      else
        robot.logger.info "hubot/spotify: no tracks found for \"%s\"",  query

        msg.send "I couldn't find any tracks for '#{query}'"

  # See the currently playing track
  robot.respond /spotify (now|wasson|currently)/i, (msg) ->
    client.get '/me/player/currently-playing', (err, res, body) ->
      data = JSON.parse body
      msg.send trackAttachment msg.message.room, data.item

  # Pause current playback
  robot.respond /spotify pause/i, (msg) ->
    client.put '/me/player/pause', (err, res, body) ->
      console.log res.statusCode

  # Resume the current playback
  robot.respond /spotify resume/i, (msg) ->
      client.put '/me/player/play', (err, res, body) ->
        robot.logger.info "hubot/spotify: resume play, status code: %s", res.statusCode

  # Go to next track
  robot.respond /spotify next/i, (msg) ->
    client.post '/me/player/next', (err, res, body) ->
      # console.log res.statusCode
      client.get '/me/player/currently-playing', (err, res, body) ->
        data = JSON.parse body
        msg.send trackAttachment msg.message.room, data.item

  # Go to previous track
  robot.respond /spotify (previous|prev)/i, (msg) ->
    client.post '/me/player/previous', (err, res, body) ->
      # console.log res.statusCode
      client.get '/me/player/currently-playing', (err, res, body) ->
        data = JSON.parse body
        msg.send trackAttachment msg.message.room, data.item

  # Set the volume
  robot.respond /spotify (v|vol|volume) (.*)/i, (msg) ->
    # clean up the volume match
    v = parseInt msg.match[2].trim()

    client.put '/me/player/volume?volume_percent=' + v, (err, res, body) ->
      robot.logger.info "hubot/spotify: set volume to %s, status code: %s", v, res.statusCode

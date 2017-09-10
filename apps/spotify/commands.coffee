module.exports = (robot, client) ->

    trackAttachment = require './messages/track.coffee'

    # Get the authotization url
    robot.respond /spotify auth/i, (msg) ->
        msg.send process.env.HUBOT_URL + "/hubot/spotify/auth"

    # See who's logged in/authenticated
    robot.respond /spotify me/i, (msg) ->
        client.get '/me', (err, res, body) ->
            data = JSON.parse body
            msg.send "Currently logged in as " + data.display_name

    # Ask hubot to play a song, hubot spotify play <query>
    robot.respond /spotify play (.*)/i, (msg) ->
        client.get '/search', { q: msg.match[1].trim(), type: 'track', limit: 1 }, (err, res, data) ->
            data = JSON.parse data
            track = data.tracks.items[0]

            params =
                context_uri: track.album.uri,
                offset:
                    uri: track.uri

            client.put '/me/player/play', params, (err, res, body) ->
                msg.send trackAttachment msg.message.room, track

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
                console.log res.statusCode

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

        v = parseInt msg.match[2].trim()

        client.put '/me/player/volume?volume_percent=' + v, (err, res, body) ->
            console.log res.statusCode

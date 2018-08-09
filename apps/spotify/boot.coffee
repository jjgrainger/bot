# Main boot script
# Required in the scripts/spotify.coffee script
# and run to bootstrap the app into hubot

# Get the spotify client
Spotify = require __dirname + '/libs/Client'

module.exports = (robot) ->

  # create the client
  client = new Spotify {
    client_id: process.env.SPOTIFY_CLIENT_ID || false,
    client_secret: process.env.SPOTIFY_CLIENT_SECRET || false,
    callback: process.env.HUBOT_URL + "/hubot/spotify/callback" || false,
  }

  # when brain loads, get tokens if set
  robot.brain.on 'loaded', ->
    client.tokens = robot.brain.get 'app:spotify:tokens' or {}

  # add routes to hubot
  require(__dirname + '/routes.coffee')(robot, client);

  # add commands to hubot
  require(__dirname + '/commands.coffee')(robot, client);

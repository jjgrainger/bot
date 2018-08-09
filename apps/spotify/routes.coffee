module.exports = (robot, client) ->

  # Authorize botify to control Spotify
  robot.router.get "/hubot/spotify/auth", (req, res) ->

    # scopes needed for botify to work
    scopes = [
      "user-read-private",
      "user-read-email",
      "user-read-playback-state",
      "user-modify-playback-state"
    ]

    # query to pass to spotify auth
    url = client.authorizeUrl(scopes)

    # redirect to auth page
    res.redirect url

  # callback for when the user authorises the app
  # will be returned with a code to use to get
  # oauth tokens to use when working with the api
  robot.router.get "/hubot/spotify/callback", (req, res) ->

    # grab the auth code
    code = req.query.code

    # get tokens for user
    client.requestTokens code, (err, response, body) ->

      # set the tokens in persistant storage
      robot.brain.set 'app:spotify:tokens', body

      # redirect the user back to the main page
      res.redirect process.env.HUBOT_URL + "/hubot/spotify/"

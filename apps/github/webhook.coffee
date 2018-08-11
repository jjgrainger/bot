# Add route to recevieve Github webhooks
module.exports = (robot) ->
  # handle incoming webhooks
  robot.router.post "/hubot/webhook/github", (req, res) ->

    robot.logger.info "webhook/github received:", req.headers['x-github-event']

    # create data object to pass to event emitter
    data =
      event: req.headers["x-github-event"]
      signature: req.headers["X-Hub-Signature"]
      delivery: req.headers["X-Github-Delivery"]
      payload: JSON.parse req.body.payload
      query: req.query

    # emit general webhook event
    robot.emit "webhook:github", data
    # emit event specific event
    robot.emit "webhook:github:#{data.event}", data

    res.end "ok"

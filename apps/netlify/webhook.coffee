# Add route to recevieve Netlify webhooks
module.exports = (robot) ->
  # handle incoming webhooks
  robot.router.post "/hubot/webhook/netlify", (req, res) ->

    robot.logger.info "webhook/netlify received:", req.headers['x-netlify-event']

    # create data object to pass to event emitter
    data =
      event: req.headers['x-netlify-event']
      payload: req.body
      query: req.query

    # emit general webhook event
    robot.emit "webhook:netlify", data
    # emit event specific event
    robot.emit "webhook:netlify:#{data.event}", data

    res.end "ok"

  # https://6bc685a7.ngrok.io/hubot/webhook/netlify?room=ohthatsnice

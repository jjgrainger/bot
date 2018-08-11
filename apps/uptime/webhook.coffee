report = require __dirname + '/messages/report.coffee'

module.exports = (robot) ->

  # create the webhook route
  robot.router.get "/hubot/webhook/uptime", (req, res) ->
    # define the room to show monitoring alerts
    room = 'monitoring'

    alert = {
      status: req.query.alertTypeFriendlyName.toUpperCase(),
      details: req.query.alertDetails,
      time: req.query.alertDateTime,
      monitor: {
        name: req.query.monitorFriendlyName,
        url: req.query.monitorURL,
      }
    }

    # create slack attachment
    attachment = report room, alert

    # send the message
    robot.send { room: "##{room}" }, attachment

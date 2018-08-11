request = require 'request'
url = require 'url'

module.exports = (robot) ->

  # when brain loads, make sure we have a alert contact setup
  robot.brain.on 'loaded', ->
    # check hubot brain for alert contact
    alert = robot.brain.get 'app:uptime:alert'

    # if we have an alert contact setup, log it
    if alert
      robot.logger.info "hubot/uptime: alert id is set", alert

    # create a new alert contact in uptimerobot
    else
      robot.emit "app:uptime:create_alert"

  # create an alert contact to use with uptimerobot
  robot.on "app:uptime:create_alert", ->
    # define the alert webhook url
    alert_url = process.env.HUBOT_URL + "/hubot/webhook/uptime?"

    # request options
    options = {
      method: 'POST',
      url: 'https://api.uptimerobot.com/v2/newAlertContact',
      headers: {
        'content-type': 'application/x-www-form-urlencoded',
        'cache-control': 'no-cache'
      },
      form: {
        api_key: process.env.UPTIMEROBOT_API_KEY,
        format: 'json',
        type: '5', # webhook
        friendly_name: "Hubot/#{robot.name}",
        value: alert_url
      }
    }

    # make api call to create an alert contact
    request options, (error, response, body) ->

      # parse the json response
      data = JSON.parse body
      # if the api returned an error, log it
      if data.error
        robot.logger.error "hubot/uptime: ERROR", data.error.message
      # save the alert contact to hubot
      else
        robot.brain.set "app:uptime:alert", data.alertcontact.id
        robot.logger.info "hubot/uptime: new alert id created", data.alertcontact.id

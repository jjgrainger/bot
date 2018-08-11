request = require 'request'
url = require 'url'
report = require __dirname + '/messages/report.coffee'

module.exports = (robot) ->

  # add a new monitor to uptime robot
  robot.respond /monitor add (.*)/i, (msg) ->
    # parse the domain
    domain = url.parse msg.match[1]

    # get variables we need for api call
    monitor_url = domain.href
    monitor_name = domain.hostname
    monitor_alert = robot.brain.get "app:uptime:alert"

    # validate the domain, make sure its a url
    robot.logger.info "hubot/uptime: attempt to add new monitor for", monitor_url

    options = {
      method: 'POST',
      url: 'https://api.uptimerobot.com/v2/newMonitor',
      headers: {
        'content-type': 'application/x-www-form-urlencoded',
        'cache-control': 'no-cache'
      },
      form: {
        api_key: process.env.UPTIMEROBOT_API_KEY,
        format: 'json',
        type: '1',
        url: monitor_url,
        friendly_name: monitor_name,
        alert_contacts: monitor_alert
      }
    };

    request options, (error, response, body) ->

      data = JSON.parse body

      if data.error
        msg.send "whoops, seems there was an error - _#{data.error.message}_"
      else
        msg.send "Now monitoring #{monitor_name} :mag:"

  # get the current status of a monitor
  robot.respond /monitor status (.*)/i, (msg) ->
    # parse the monitor name/url
    monitor = url.parse msg.match[1]

    # create options for api request
    options = {
      method: 'POST',
      url: 'https://api.uptimerobot.com/v2/getMonitors',
      headers: {
        'cache-control': 'no-cache',
        'content-type': 'application/x-www-form-urlencoded'
      },
      form: {
        api_key: process.env.UPTIMEROBOT_API_KEY,
        format: 'json',
        logs: '1',
        logs_limit: 1,
        limit: 5,
        search: monitor.hostname
      }
    }

    # make the api call
    request options, (error, response, body) ->
      # parse the reponse data
      data = JSON.parse body

      # if no monitors were returned, let the user know
      if not data.monitors.length
        msg.send "Sorry, I couldn't find any monitors for #{monitor.hostname}"

      # create monitor alerts for those returned
      else
        # get human friendly monitor status
        statuses = {
          0: "paused"
          1: "not checked yet"
          2: "up"
          8: "seems down"
          9: "down"
        }

        # get the room
        room = msg.message.room

        # we may get more than 1 monitor
        for monitor in data.monitors

          # get the human friendly status for the monitor
          status = statuses[monitor.status]
          # extract the most recent log
          log = monitor.logs.shift()

          # create an alert object with the information we have
          alert = {
            status: status.toUpperCase(),
            details: log.reason.detail,
            time: log.datetime,
            monitor: {
              name: monitor.friendly_name,
              url: monitor.url,
            }
          }

          # create slack attachment
          attachment = report room, alert

          # send the message
          msg.send attachment

module.exports = (robot) ->

  # get weather scripts
  weather = require __dirname + '/libs/client.coffee'
  getUnit = require __dirname + '/libs/unit.coffee'
  getEmoji = require __dirname + '/libs/emoji.coffee'

  robot.respond /weather (.*)/i, (msg) ->

    weather.get 'weather', { qs: { q: msg.match[1].trim() } }, (err, res, body) ->

      data = JSON.parse body

      temp = "#{Math.round data.main.temp}#{getUnit()}"
      condition = data.weather[0].description
      location = data.name
      emoji = getEmoji data.weather[0].icon

      msg.send "Looks like it's #{temp} with #{condition} in #{location}#{emoji}"



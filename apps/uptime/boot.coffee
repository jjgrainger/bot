module.exports = (robot) ->

  # add uptime monitoring scripts
  require(__dirname + '/events.coffee')(robot)
  require(__dirname + '/webhook.coffee')(robot)
  require(__dirname + '/commands.coffee')(robot)

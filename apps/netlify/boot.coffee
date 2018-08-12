module.exports = (robot) ->

  # add webhook to Hubot
  require(__dirname + '/webhook.coffee')(robot)

  # add event handlers (listeners) to Hubot
  require(__dirname + '/handlers/started.coffee')(robot)
  require(__dirname + '/handlers/success.coffee')(robot)

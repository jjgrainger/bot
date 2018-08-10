module.exports = (robot) ->

  # add webhook to Hubot
  require(__dirname + '/webhook.coffee')(robot)

  # add event handlers (listeners) to Hubot
  require(__dirname + '/handlers/issues.coffee')(robot)

module.exports = (robot) ->

  # add webhook to Hubot
  require(__dirname + '/webhook.coffee')(robot)

  # add event handlers (listeners) to Hubot
  require(__dirname + '/handlers/issues.coffee')(robot)
  require(__dirname + '/handlers/pull_request.coffee')(robot)

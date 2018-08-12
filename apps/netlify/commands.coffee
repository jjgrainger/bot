module.exports = (robot) ->

  request = require 'request'
  url = require 'url'
  netlify = require './libs/client.coffee'
  client = new netlify process.env.NETLIFY_ACCESS_TOKEN

  robot.respond /netlify deploy (.*)/i, (msg) ->
    # get the site id to deploy
    domain = url.parse msg.match[1]
    site_id = domain.hostname

    # emit a deploy event
    robot.emit "app:netlify:deploy", site_id

  # handle the deploy evenet
  robot.on "app:netlify:deploy", (site_id) ->

    robot.logger.info "hubot/netlify: deploy triggered for", site_id

    # check for a build hook
    build_hook = robot.brain.get "app:netlify:build_hooks:#{site_id}"

    # if we have a build hook, use it
    if build_hook
      request.post "https://api.netlify.com/build_hooks/#{build_hook}", (err, res, body) ->
        robot.logger.info "hubot/netlify: build_hook triggered: { build_hook: #{build_hook}, site_id: #{site_id} response: #{body} }"

    # no build hook, lets create one
    else
      # emit a create build hook event
      robot.emit "app:netlify:create_build_hook", site_id

  # handle create build hook event
  robot.on "app:netlify:create_build_hook", (site_id) ->

    robot.logger.info "hubot/netlify: creating build_hook for", site_id

    # create build hook for that site id
    client.post "sites/#{site_id}/build_hooks", {
      form: {
        title: "Hubot/#{robot.name}",
        branch: "master"
      }
    }, (err, res, body) ->

      data = JSON.parse body

      if data.code
        robot.logger.error "hubot/netlify: could not create build_hook for #{site_id}", data
      else
        # set the build hook to use later
        robot.brain.set "app:netlify:build_hooks:#{site_id}", data.id
        # emit the deploy event with the site_id
        robot.emit "app:netlify:deploy", site_id

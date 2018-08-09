module.exports = (robot) ->

  express = require 'express'
  path = require 'path'

  # static folder
  robot.router.use express.static path.join __dirname, 'public'

  # setup views, will add this later
  # robot.router.set 'views', path.join __dirname, '/views'
  # robot.router.set 'view engine', 'pug'

  # basic route using views, more to come
  # robot.router.get "/", (req, res) ->
    # res.render "index", { title: "Hey", message: "Hello world!" }

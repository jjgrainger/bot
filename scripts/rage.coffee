# Description
#   Say it again, but with rage!
#
# Commands:
#   hubot rage <text> - say it again, but with rage!
#
# Author:
#   jjgrainger <josephgrainger@gmail.com>

module.exports = (robot) ->

  robot.respond /rage (.*)/i, (res) ->
    res.send res.match[1].toUpperCase()

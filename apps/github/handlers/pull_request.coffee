module.exports = (robot) ->

  # handle the event
  robot.on "webhook:github:pull_request", (data) ->

    # only handle 'opened' issues
    if data.payload.action != 'opened'
      return

    robot.logger.info "webhook/github processing pull_request"

    # get the room to display the issue
    room = data.query.room or 'bot-tests'

    # get the data we want from the payload
    pull = data.payload.pull_request
    user = data.payload.pull_request.user
    repo = data.payload.repository

    # create slack attachment
    attachment = {
      room: "##{room}",
      text: "A new pull request was opened on *#{repo.name} ##{pull.number}: #{pull.title}*",
      attachments: [{
        fallback: "A new pull request was opened on #{repo.name} ##{pull.number}: #{pull.title}",
        author_name: "GitHub",
        author_icon: "https://slack-imgs.com/?c=1&o1=wi32.he32.si&url=https%3A%2F%2Fa.slack-edge.com%2Fbfaba%2Fimg%2Funfurl_icons%2Fgithub.png",
        title: "##{pull.number} #{pull.title}",
        title_link: pull.html_url,
        text: "Submitted by <#{user.html_url}|@#{user.login}>\nOn <#{repo.html_url}|#{repo.full_name}>",
        thumb_url: user.avatar_url,
      }]
    }

    # send the message
    robot.send { room: "##{room}" }, attachment

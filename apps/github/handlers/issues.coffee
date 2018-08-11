module.exports = (robot) ->

  # handle the event
  robot.on "webhook:github:issues", (data) ->

    # only handle 'opened' issues
    if data.payload.action != 'opened'
      return

    robot.logger.info "webhook/github processing issue"

    # get the room to display the issue
    room = data.query.room or 'bot-tests'

    # get the data we want from the payload
    issue = data.payload.issue
    user = data.payload.issue.user
    repo = data.payload.repository

    # create slack attachment
    attachment = {
      room: "##{room}",
      text: "A new issue was opened on *#{repo.name} ##{issue.number}: #{issue.title}*",
      attachments: [{
        fallback: "A new issue was opened on #{repo.name} ##{issue.number}: #{issue.title}",
        author_name: "GitHub",
        author_icon: "https://slack-imgs.com/?c=1&o1=wi32.he32.si&url=https%3A%2F%2Fa.slack-edge.com%2Fbfaba%2Fimg%2Funfurl_icons%2Fgithub.png",
        title: "##{issue.number} #{issue.title}",
        title_link: issue.html_url,
        text: "Submitted by <#{user.html_url}|@#{user.login}>\nOn <#{repo.html_url}|#{repo.full_name}>",
        thumb_url: user.avatar_url,
      }]
    }

    # send the message
    robot.send { room: "##{room}" }, attachment

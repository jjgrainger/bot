module.exports = (robot) ->


  robot.on "webhook:netlify", (data) ->
    # get the room for the notification
    room = data.query.room or 'bot-tests'

    # parse the deploy date for Slack
    deploy_date = Date.parse(data.payload.published_at)
    publish_ts = deploy_date / 1000


    # create slack attachment
    attachment = {
      room: "##{room}",
      text: "Successful deploy of *#{data.payload.name}*",
      attachments: [{
        color: "#36a64f"
        fallback: "Successful deploy of *#{data.payload.name}*",
        author_name: "Netlify",
        author_icon: "https://cdn.freebiesupply.com/logos/large/2x/netlify-logo-png-transparent.png",
        title: "#{data.payload.name}",
        title_link: "#{data.payload.url}",
        text: "<#{data.payload.admin_url}/deploys/#{data.payload.id}|View the build log>",
        thumb_url: data.payload.screenshot_url,
        footer: "Using git branch #{data.payload.branch}",
        ts: publish_ts
      }]
    }

    # send the message
    robot.send { room: "##{room}" }, attachment

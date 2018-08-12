module.exports = (robot) ->


  robot.on "webhook:netlify:deploy_building", (data) ->
    # get the room for the notification
    room = data.query.room or 'bot-tests'

    # send the message
    robot.send { room: "##{room}" }, "Deploy started for *#{data.payload.name}* <#{data.payload.admin_url}/deploys/#{data.payload.id}|view logs>"

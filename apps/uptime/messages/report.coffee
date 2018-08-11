module.exports = (room, alert) ->
  return {
    room: "##{room}",
    text: "Monitor #{alert.monitor.name} is *#{alert.status}*",
    attachments: [{
      fallback: "Monitor #{alert.monitor.name} is *#{alert.status}*",
      title: alert.monitor.name,
      title_link: alert.monitor.url,
      text: "Reason: #{alert.details}",
      author_name: "Uptime Robot",
      author_icon: "https://slack-imgs.com/?c=1&o1=wi32.he32.si&url=https%3A%2F%2Fuptimerobot.com%2Fassets%2Fico%2Ffavicon.ico"
      ts: alert.time
    }]
  }

module.exports = (weather_icon) ->

  # match open weather map icons with emojis
  weather_emoji_icons = {
      # clear skies
      "01d": ":sunny:",
      "01n": ":sunny:", # night
      # few clouds
      "02d": ":partly_sunny:",
      "02n": ":partly_sunny:",
      # scattered clouds
      "03d": ":cloud:",
      "03n": ":cloud:",
      # broken clouds/overcast
      "04d": ":cloud:",
      "04n": ":cloud:",
      # rain
      "09d": ":rain_cloud:",
      "10d": ":partly_sunny_rain:",
      # thunder
      "11d": ":thunder_cloud_and_rain:",
      # snow
      "13d": ":snow_cloud:",
      # mist/fog
      "50d": ":cloud:",
  }

  return " #{weather_emoji_icons[weather_icon]}" || '';

module.exports = () ->
  units = process.env.WEATHER_UNITS || "metric"

  named_unit = switch
    when units == "metric" then "°C"
    when units == "imperial" then "°F"
    else  "K"

  return named_unit

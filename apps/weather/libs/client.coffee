request = require 'request';

client = request.defaults {
    baseUrl: 'https://api.openweathermap.org/data/2.5/',
    qs: {
        appid: process.env.WEATHER_API_KEY,
        units: process.env.WEATHER_UNITS || 'metric'
    }
}

module.exports = client

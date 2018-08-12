request = require 'request';

module.exports = (token) ->

  return request.defaults {
      baseUrl: 'https://api.netlify.com/api/v1/',
      qs: {
          access_token: token
      }
  }

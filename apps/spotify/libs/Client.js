var request = require('request');
var qs = require('querystring');

// Create spotify client
var Spotify = function(options) {
  this.client_id = options.client_id || false;
  this.client_secret = options.client_secret || false;
  this.callback = options.callback || false;
};

// Token storage
Spotify.prototype.tokens = {};

// Create basic auth token
Spotify.prototype.authBasic = function() {
  return new Buffer(this.client_id + ":" + this.client_secret).toString('base64');
};

// generate an authorize url
Spotify.prototype.authorizeUrl = function(scopes, state) {

  var params = {
    "client_id": this.client_id,
    "response_type": "code",
    "redirect_uri": this.callback,
    "state": state || "",
    "scope": scopes.join(" ")
  };

  return "https://accounts.spotify.com/authorize/?" + qs.stringify(params);
},

// request access/refresh tokens
Spotify.prototype.requestTokens = function(code, cb) {

  var self = this;

  request.post({
    url: "https://accounts.spotify.com/api/token",
    form: {
      "grant_type": "authorization_code",
      "code": code,
      "redirect_uri": self.callback
    },
    headers: {
      'Authorization': 'Basic ' + self.authBasic()
    },
    json: true
  }, function(err, res, body) {

    self.tokens = body;

    if (cb) {
      cb(err, res, body);
    }
  });
};

// refresh access tokens
Spotify.prototype.refreshTokens = function(callback) {

  var self = this;

  request.post({
    url: "https://accounts.spotify.com/api/token",
    form: {
      "grant_type": "refresh_token",
      "refresh_token": self.tokens.refresh_token
    },
    headers: {
      'Authorization': 'Basic ' + self.authBasic()
    },
    json: true
  }, function(err, res, body) {
    self.tokens = body;
    if (callback) { callback(err, res, body); }
  });
};

// Check
Spotify.prototype.isAuthenticated = function() {
  if (this.tokens.access_token) {
    return true;
  }

  return false;
};

// Api
// Spotify.call("GET", "/me", function(err, res, body) {
//
// });
Spotify.prototype.call = function() {

  var self = this;

  var args = arguments;

  var method = arguments[0] || "GET";
  var uri = arguments[1] || "";
  var data = {};
  var cb = function() {};

  if (typeof arguments[2] === 'function' && arguments[3] === undefined) {
    cb = arguments[2];
  } else {
    data = arguments[2];
    cb = arguments[3];
  }

  var options = {
    uri: uri,
    baseUrl: "https://api.spotify.com/v1/",
    method: method || "GET",
    headers: {
      'Authorization': 'Bearer ' + self.tokens.access_token
    }
  };

  if (data !== undefined) {
    if (method === "GET") {
      options.qs = data;
    } else {
      options.body = data;
      options.json = true;
    }
  }

  request(options, function(err, res, body) {

    // token has expired...
    if (res.statusCode === 401) {
      self.refreshTokens(function() {
        self.call.apply(self, args);
      });
    } else {
      cb(err, res, body);
    }
  });
};

Spotify.prototype.get = function() {
  var args = arguments;
  args = Object.keys(args).map(function(key) { return args[key]; });
  args.unshift("GET");
  this.call.apply(this, args);
};

Spotify.prototype.post = function() {
  var args = arguments;
  args = Object.keys(args).map(function(key) { return args[key]; });
  args.unshift("POST");
  this.call.apply(this, args);
};

Spotify.prototype.put = function() {
  var args = arguments;
  args = Object.keys(args).map(function(key) { return args[key]; });
  args.unshift("PUT");
  this.call.apply(this, args);
};

module.exports = Spotify;

var request = require('request');

var token;

function base64ToUtf8(str) {
  return decodeURIComponent(new Buffer(str, 'base64').toString());
}

function getClaimsFromToken(jwt) {
  var encoded = jwt && jwt.split('.')[1];
  var jsonString = base64ToUtf8(encoded);
  return JSON.parse(jsonString);
}

function isExpired(jwt) {
  var claims = getClaimsFromToken(jwt);
  var epochNow = new Date().getTime() / 1000;
  return claims.exp <= epochNow - 10;
}

function tokenIsValid() {
  return !!(token && !isExpired(token));
}

function getTokenFromAuth0(callback) {
  var data = {
    'client_id': 'QHQy75S7tmnhDdBGYSnszzlhMPul0fAE',
    'username': process.env.AUTH0_BEKKBOT_USERNAME,
    'password': process.env.AUTH0_BEKKBOT_PASSWORD,
    'connection': 'applications',
    'grant_type': 'password',
    'scope': 'openid groups app_metadata'
  };

  request.post('https://bekk-dev.eu.auth0.com/oauth/ro', { json: true, body: data }, function(error, response, body) {
    if (!error && response.statusCode == 200) {
      token = body.id_token;
      callback(body.id_token);
    }
  })
}

function getToken(callback) {
  if (tokenIsValid()) {
    callback(token);
  } else {
    getTokenFromAuth0(callback);
  }
}

module.exports.getToken = getToken;

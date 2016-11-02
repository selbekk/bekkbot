# Description:
#   Gjør kall mot ansatt-apiet
#
# Commands:
#   hubot ansatte - hvor mange ansatte har bekk?

auth = require('./../lib/auth.js')

module.exports = (robot) ->
  robot.respond /ansatte/i, (res) ->
    auth.getToken (token) ->
      robot.http("https://api.dev.bekk.no/employee-svc/employees")
      .header('Authorization', "Bearer #{token}")
      .get() (err, response, body) ->
        responseData = null
        try
          responseData = JSON.parse body
        catch error
          res.send "Noe gikk åt skogen da jeg skulle parse JSON. Kjipe greier :("
          return
        res.reply "Antall ansatte i BEKK-sjappa er #{responseData.length}! :olav:"

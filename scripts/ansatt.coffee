# Description:
#   Gjør kall mot ansatt-apiet
#
# Commands:
#   hubot ansatte - hvor mange ansatte har bekk?
#   hubot vis meg <ansattnavn> - Få bilde av den ansatte

auth = require('./../lib/auth.js')
employeeSvcUrl = "https://api.dev.bekk.no/employee-svc/"

module.exports = (robot) ->
  robot.respond /ansatte/i, (res) ->
    auth.getToken (token) ->
      robot.http(employeeSvcUrl + "employees")
      .header('Authorization', "Bearer #{token}")
      .get() (err, response, body) ->
        responseData = null
        try
          responseData = JSON.parse body
        catch error
          res.send "Noe gikk åt skogen da jeg skulle parse JSON. Kjipe greier :("
          return
        res.reply "Antall ansatte i BEKK-sjappa er #{responseData.length}! :olav:"


  robot.respond /vis meg (.*)/i, (res) ->
    auth.getToken (token) ->
      robot.http(employeeSvcUrl + "employees")
      .header('Authorization', "Bearer #{token}")
      .get() (err, response, body) ->
        ansatte = null
        try
          ansatte = JSON.parse body
        catch error
          res.send "Noe gikk åt skogen da jeg skulle parse JSON. Kjipe greier :("
          return
        ansattnavn = res.match[1]
        ansatteMedLiktNavn = ansatte.filter (ansatt) -> ansatt.name.toLowerCase() is ansattnavn.toLowerCase()
        if ansatteMedLiktNavn.length != 1
          res.reply "Beklager, jeg skjønner ikke hvem #{ansattnavn} er :confused: Kan du prøve med et annet navn? :smile:"
        else
          res.reply ansatteMedLiktNavn[0].employeeImageUrl

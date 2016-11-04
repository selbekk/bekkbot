# Description:
#   Gjør kall mot ansatt-apiet
#
# Commands:
#   hubot ansatte - hvor mange ansatte har bekk?
#   hubot vis <ansattnavn> - Få bilde av Bekkeren
#   hubot vis <ansattnavn> med skjegg - Få et mer humorbasert bilde av bekkeren
#   hubot hvor glad er <ansattnavn> - Få et tall på hvor glad Bekkeren er, fra Microsofts Emotion API

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

  robot.respond /vis (.*)/i, (res) ->
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
        text = res.match[1]
        if text.indexOf("med skjegg") > -1
          utrimmaAnsattnavn = text.replace /med skjegg/, ""
          ansattnavn = utrimmaAnsattnavn.trim()
          ansatteMedLiktNavn = ansatte.filter (ansatt) -> ansatt.name.toLowerCase() is ansattnavn.toLowerCase()
          if ansatteMedLiktNavn.length != 1
            res.reply "Beklager, jeg skjønner ikke hvem <#{ansattnavn}> er :confused: Kan du prøve med et annet navn? :smile:"
          else
            res.reply 'https://wurstify.me/proxy?since=0&url=' + ansatteMedLiktNavn[0].employeeImageUrl
        else
          ansattnavn = text.trim()
          ansatteMedLiktNavn = ansatte.filter (ansatt) -> ansatt.name.toLowerCase() is ansattnavn.toLowerCase()
          if ansatteMedLiktNavn.length != 1
            res.reply "Beklager, jeg skjønner ikke hvem <#{ansattnavn}> er :confused: Kan du prøve med et annet navn? :smile:"
          else
            res.reply ansatteMedLiktNavn[0].employeeImageUrl


  robot.respond /hvor glad er (.*)/i, (res) ->
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
          res.reply "Beklager, jeg skjønner ikke hvem <#{ansattnavn}> er :confused: Kan du prøve med et annet navn? :smile:"
        else
          ansattBilde = ansatteMedLiktNavn[0].employeeImageUrl
          requestBody = JSON.stringify({ url: ansattBilde })
          robot.http("https://api.projectoxford.ai/emotion/v1.0/recognize")
          .header('Content-Type', 'application/json')
          .header('Ocp-Apim-Subscription-Key', process.env.MS_EMOTION_API_TOKEN)
          .post(requestBody) (err, response, body) ->
            parsedResponse = null
            try
              parsedResponse = JSON.parse body
            catch error
              res.send "Noe gikk åt skogen da jeg skulle parse JSON. Kjipe greier :("
              return
            gladhet = parsedResponse[0].scores.happiness
            gladhetProsent = (gladhet * 100).toFixed()
            res.reply "#{ansattnavn} med ansattbilde #{ansattBilde} er #{gladhetProsent}% glad! :grin:"


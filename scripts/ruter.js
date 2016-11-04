const moment = require('moment')
const url = "http://reisapi.ruter.no/Favourites/GetFavourites?favouritesRequest=3010071-60-Tonsenhagen"

module.exports = (robot) => {
  robot.hear(/(.*)neste buss fra skuret(.*)/, (msg) => {
    robot.http(url)
    .get()((err, res, body) => {
      const departures = JSON.parse(body).shift().MonitoredStopVisits
      const times = departures.map((departure) => {
        const time = departure.MonitoredVehicleJourney.MonitoredCall.ExpectedArrivalTime
        return moment(time)
      }).filter((time) => {
			     return time.isBefore(moment().add(1, 'hours'));
      }).map((time) => {
        return time.diff(moment(), 'minutes')
      })

      if (times.length == 0){
        msg.reply("Det er ingen avganger innen den neste time :cry:")
      }else {
        if (times.length == 1){
          msg.reply(`Bussen går fra Skuret om ${times.pop()} minutter :running:`)
        } else {
          const last = times.pop()
          msg.reply(`Bussen går fra Skuret om ${times.join(", ")} og ${last} minutter :running:`)
        }

      }
    })
  })
}

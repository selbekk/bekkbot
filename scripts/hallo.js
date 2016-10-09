// Description:
//   Et enkelt testscript for enkel funksjonalitet
//
// Commands:
//   hubot hallo - boten hilser tilbake med heisann


module.exports = function (robot) {
	robot.respond(/hallo/ ,function(res){
		res.reply("Heisann!");
	})
}
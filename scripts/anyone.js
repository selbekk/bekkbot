// Description:
//   Et enkelt testscript for enkel trigger-funksjonalitet
//
// Commands:
//   hubot hallo - boten hilser tilbake med heisann


module.exports = function (robot) {
	robot.hear(/anyone/ ,function(res){
		res.reply("Pick me! Pick me!");
	})
}
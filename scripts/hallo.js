module.exports = function (robot) {
	robot.respond(/hallo/ ,function(res){
		res.reply("Heisann!");
	})
}
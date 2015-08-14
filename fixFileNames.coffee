fs = require "fs"

scores = fs.readdirSync("mscx")
for score, i in scores
	new_score = "_" + i + ".mscx"
	fs.rename "mscx/#{score}", "mscx/#{new_score}"
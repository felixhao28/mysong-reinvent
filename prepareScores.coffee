fs = require "fs"
xml2js = require("xml2js")
require "shelljs/global"

scores_folder = "scores"

scores = fs.readdirSync(scores_folder)

for score in scores
	scoreFilePath = "#{scores_folder}/#{score}"
	exec("7z x #{scoreFilePath} -omscx *.mscx -aot")

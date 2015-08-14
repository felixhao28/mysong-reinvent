parseString = require('xml2js').parseString
fs = require "fs"
xml = fs.readFileSync "chords.xml"
parseString xml, (err, result) ->
	chord = result.museScore.chord
	voicing = chord.voicing[0]
	name = chord.name[0]
	console.log chord
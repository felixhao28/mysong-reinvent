http = require "http"
request_lib = require "request"
fs = require "fs"
cheerio = require "cheerio"
parseXML = require("xml2js").parseString

key = "oauth_consumer_key=BXUmpu3QEdEf3hK6qX8vTmgTFJty86M6"

request_lib.defaults
  pool:
    maxSockets: 5

requests = []
pool = 3

notify = ->
  if requests.length > 0 and pool > 0
    pool--
    {url, cb} = requests.pop()
    request_lib url, (error, response, body) ->
      pool++
      setTimeout notify
      cb(error, response, body)

request = (url, cb) ->
  requests.push
    url: url
    cb: cb
  notify()

downloadScore = (scoreUrl) ->
  scoreInfoUrl = "http://api.musescore.com/services/rest/resolve.xml?url=http://musescore.com#{scoreUrl}&" + key
  # scoreInfoUrl = "http://api.musescore.com/services/rest/score/#{scoreId}.xml?" + key
  console.log "downloading scoreInfo=" + scoreInfoUrl
  request scoreInfoUrl, (error, response, body) ->
    if error
      console.log "error downloading " + scoreInfoUrl
    parseXML body, (err, scoreInfo) ->
      if err
        console.log "error parsing " + scoreInfoUrl
      else
        console.log "finish scoreInfo=" + scoreInfoUrl
      scoreId = scoreInfo.score.id[0]
      secret = scoreInfo.score.secret[0]
      downloadUrl = "http://static.musescore.com/#{scoreId}/#{secret}/score.mscz"
      r = request_lib(downloadUrl)
      r.on "response", (resp)->
        if resp.statusCode is 200
          r.pipe(fs.createWriteStream("scores/#{scoreId}.mscz"))
          r.resume()

downloadPage = (pageNo) ->
  url = "https://musescore.com/sheetmusic?page=#{pageNo}&instruments=0&parts=1"
  console.log "downloading page=" + pageNo
  request url, (error, response, body) ->
    if error
      console.log "error downloading " + url
    else
      console.log "finish page=" + pageNo
      $ = cheerio.load body
      $(".field-content > a:not(.picture)").each (i, e) ->
        href = e.attribs.href
        downloadScore href

for pageNo in [0...194]
  downloadPage pageNo

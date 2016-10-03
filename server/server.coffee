# rostermatic plugin, server-side component
# These handlers are launched with the wiki server. 

fs = require 'fs'
async = require 'async'


startServer = (params) ->
  app = params.app
  argv = params.argv

  route = (endpoint) -> "/plugin/rostermatic/#{endpoint}"
  path = (file) -> "#{argv.data}/../#{file}"

  info = (file, done) ->
    fs.stat path("#{file}/status/favicon.png"), (err, stat) ->
      done null, {file, birth:stat?.birthtime?.getTime()}

  app.get route('sites'), (req, res) ->
    fs.readdir path(''), (err, files) ->
      sites = async.map files||[], info, (err, sites) ->
        res.json {sites}

module.exports = {startServer}

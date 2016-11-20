# rostermatic plugin, server-side component
# These handlers are launched with the wiki server. 

fs = require 'fs'
async = require 'async'
jsonfile = require 'jsonfile'

# http://www.sebastianseilund.com/nodejs-async-in-practice

startServer = (params) ->
  app = params.app
  argv = params.argv

  route = (endpoint) -> "/plugin/rostermatic/#{endpoint}"
  path = (file) -> "#{argv.data}/../#{file}"

  info = (file, done) ->
    site = {file}
    birth = (cb) ->
      fs.stat path("#{file}/status/favicon.png"), (err, stat) ->
        site.birth = stat?.birthtime?.getTime(); cb()
    pages = (cb) ->
      fs.readdir path("#{file}/pages"), (err, pages) ->
        site.pages = pages?.length; cb()
    owner = (cb) ->
      jsonfile.readFile path("#{file}/status/owner.json"), {throws:false}, (err, owner) ->
        site.owner = owner; cb()
    persona = (cb) ->
      fs.readFile path("#{file}/status/persona.identity"),'utf8', (err, identity) ->
        site.persona = identity; cb()
    openid = (cb) ->
      fs.readFile path("#{file}/status/open_id.identity"),'utf8', (err, identity) ->
        site.openid = identity; cb()
    async.series [birth,pages,owner,persona,openid], (err) ->
      done null, site

  authorizedAsAdmin = (req, res, next) ->
    if app.securityhandler.isAdmin(req)
      next()
    else
      admin = "none specified" unless argv.admin
      user = "not logged in" unless req.session?.passport?.user || req.session?.email || req.session?.friend
      user ||= 'not admin user'
      res.status(403).send {admin, user}

  app.get route('sites'), authorizedAsAdmin, (req, res) ->
    fs.readdir path(''), (err, files) ->
      sites = async.map files||[], info, (err, sites) ->
        res.json {sites}

module.exports = {startServer}

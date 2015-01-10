# Description:
#   Announce Read the Docs build status
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_READ_THE_DOCS_DEBUG - whether or not to output every incoming payload
#
# Commands:
#   None
#
# URLS:
#   POST /hubot/read-the-docs?room=<room>[&type=<type]
#     - for XMPP servers (such as HipChat) this is the XMPP room id which has the form id@server
#
# Author:
#   lonnen

url = require('url')
querystring = require('querystring')

module.exports = (robot) ->

  robot.router.post "/hubot/read-the-docs", (req, res) ->
    query = querystring.parse url.parse(req.url).query

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    try
      payload = JSON.parse req.body

      console.log "Read the Docs hook received: #{payload}"

    catch error
      console.log "Read the Docs hook error: #{error}. Payload: #{req.body}"

    res.end JSON.stringify { send: true }

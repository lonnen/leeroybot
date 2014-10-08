# Description:
#   Find the build status of an open-source project on Travis
#   Can also notify about builds, just enable the webhook notification on travis http://about.travis-ci.org/docs/user/build-configuration/ -> 'Webhook notification'
#
# Dependencies:
#
# Configuration:
#   None
#
# Commands:
#   hubot travis <user>/<repo> - Returns the build status of https://github.com/<user>/<repo>
#
# URLS:
#   POST /hubot/travis?room=<room>[&type=<type]
#     - for XMPP servers (such as HipChat) this is the XMPP room id which has the form id@server
#
# Author:
#   sferik
#   nesQuick
#   sergeylukin
#   lonnen

url = require('url')
querystring = require('querystring')

# hack attack!
# a hardcoded map of email to irc handle
usernameMap =
    "mail@peterbe.com": "peterbe"
    "chris.lonnen@gmail.com": "lonnen"


module.exports = (robot) ->

  robot.respond /travis (.*)/i, (msg) ->
    project = escape(msg.match[1])
    msg.http("https://api.travis-ci.org/repos/#{project}")
      .get() (err, res, body) ->
        response = JSON.parse(body)
        if response.last_build_status == 0
          msg.send "Build status for #{project}: Passing"
        else if response.last_build_status == 1
          msg.send "Build status for #{project}: Failing"
        else
          msg.send "Build status for #{project}: Unknown"

  robot.router.post "/hubot/travis", (req, res) ->
    query = querystring.parse url.parse(req.url).query

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    try
      payload = JSON.parse req.body.payload
      unless payload.type is "pull_request"
        console.log "ignoring travis hook type: #{payload.type}"
        res.end JSON.stringify { send: true }

      author = usernameMap[payload.author_email] || payload.author_email
      robot.send user, "[#{payload.repository.name}] #{payload.author_email} PR build #{payload.status_message.toUpperCase()}: #{payload.compare_url}"
    catch error
      console.log "travis hook error: #{error}. Payload: #{req.body.payload}"

    res.end JSON.stringify { send: true }

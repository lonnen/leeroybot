# Description:
#   Generates help commands for Hubot.
#
# Commands:
#   hubot help - Displays all of the help commands that Hubot knows about.
#   hubot help <query> - Displays all help commands that match <query>.
#
# URLS:
#   /hubot/help
#
# Notes:
#   These commands are grabbed from comment blocks at the top of each file.

helpContents = (name, commands) ->

  """
<!DOCTYPE html>
<html>
  <head>
  <meta charset="utf-8">
  <title>#{name} Help</title>
  <style type="text/css">
    body {
      background: rgb(250, 250, 220);
      color: rgb(74, 64, 64);
      font-family: monospace;
      padding: 0;
      margin: 0;
    }
    h1 {
      margin: 8px;
      padding: 0;
      background: rgb(151, 210, 178);
    }
    .commands {
      font-size: 14px;
    }
    p {
      border-bottom: 1px solid rgb(217, 126, 98);
      margin: 0;
      padding: 15px 10px;
    }
    p:last-child {
      border: 0;
    }
  </style>
  </head>
  <body>
    <h1>#{name} Help</h1>
    <div class="commands">
      #{commands}
    </div>
  </body>
</html>
  """

module.exports = (robot) ->
  robot.respond /help\s*(.*)?$/i, (msg) ->
    cmds = robot.helpCommands()
    filter = msg.match[1]

    if filter
      cmds = cmds.filter (cmd) ->
        cmd.match new RegExp(filter, 'i')
      if cmds.length == 0
        msg.send "No available commands match #{filter}"
        return

    # sending individually floods the server
    # so if we know the url, send that instead
    if process.eng.HUBOT_HEROKU_KEEPALIVE_URL
      msg.send "#{process.env.HUBOT_HEROKU_KEEPALIVE_URL}#{robot.name}/help"
      return

    prefix = robot.alias or robot.name
    cmds = cmds.map (cmd) ->
      cmd = cmd.replace /hubot/ig, robot.name
      cmd.replace new RegExp("^#{robot.name}"), prefix

    emit = cmds.join "\n"

    msg.send emit

  robot.router.get "/#{robot.name}/help", (req, res) ->
    cmds = robot.helpCommands().map (cmd) ->
      cmd.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')

    emit = "<p>#{cmds.join '</p><p>'}</p>"

    emit = emit.replace /hubot/ig, "<b>#{robot.name}</b>"

    res.setHeader 'content-type', 'text/html'
    res.end helpContents robot.name, emit

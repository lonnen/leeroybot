# LeeroyBot

This is Mozilla Web Engineering's customized version of GitHub's chat bot, hubot.


### Auto Deploy

LeeroyBot deploys on change to master.


### Testing Hubot Locally

You can test LeeroyBot locally by running the following:

    % bin/hubot

This will initiate the bot in a shell repl. You'll see some start up output
about where your scripts come from and a prompt:

    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading adapter shell
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/lonnen/Development/hubot/scripts
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/lonnen/Development/hubot/src/scripts
    Hubot>

Then you can interact with hubot by typing `hubot help`.

    Hubot> hubot help

    Hubot> animate me <query> - The same thing as `image me`, except adds a few
    convert me <expression> to <units> - Convert expression to given units.
    help - Displays all of the help commands that Hubot knows about.
    ...


### Scripting

Functionality is implemented mostly in scripts. There are plenty of examples in
the `./scripts` folder. More are available as part of the external
[hubot script catalog][hubot-script-catalog], and as stand alone packages,
like those published by the [Hubot Scripts][hubot-scripts] organization.

Any script in `./scripts` will be loaded with the bot. External scripts must be
explicitly identified in either `external-scripts.json` or `hubot-scripts.json`
in order to be loaded when LeeroyBot is run.

Read up on the details in the [script guide][script-guide].

[hubot-script-catalog]: http://hubot-script-catalog.herokuapp.com/
[hubot-scripts]: https://github.com/hubot-scripts
[script-guide]: https://github.com/github/hubot/blob/master/docs/scripting.md


### Redis Persistence

LeeroyBot relies on Redis for persistence. The bot will look in the environment
for any of the following: `REDISTOGO_URL`, `REDISCLOUD_URL`, `BOXEN_REDIS_URL`,
or `REDIS_URL`. If none of those are found it will try the default
`redis://localhost:6379`. If you don't need or want redis for local development,
remove `redis-brain.coffee` from `hubot-scripts.json`. *Do not commit that
particular change*. There is single a test to catch that particular error, but
it's best to avoid it up front.


## Adapters

LeeroyBot can work with many chat services. The shell adapter is intended for
local script development and is the default, while the bot itself runs on
irc.mozilla.org using the IRC adapter. It could use any
[Hubot Adapter][hubot-adapters], though, if someone were to fork it.

Adapters are specified with the `-a <adapter>` command line flag. New adapters
will need to be installed to run.

[hubot-adapters]: https://github.com/github/hubot/blob/master/docs/adapters.md


## Deployment

If you want to deploy your own fork, checkout the hubot [deploy docs][deploy].
The primary LeeroyBot is automatically updated automatically when things land on
master.

[deploy]: https://github.com/github/hubot/blob/master/docs/README.md#deploying


### Arguments

See the `Procfile` for how LeeroyBot gets run in production. For local dev,
`bin/hubot` is sufficient -- that will get you going with a shell adapter for
manual testing.


### IRC Variables

If you want to hook this to IRC, you should specify a bunch of environment vars:

    HUBOT_IRC_NICK
    HUBOT_IRC_NICKSERV_PASSWORD
    HUBOT_IRC_NICKSERV_USERNAME
    HUBOT_IRC_PORT
    HUBOT_IRC_ROOMS
    HUBOT_IRC_SERVER
    HUBOT_IRC_UNFLOOD
    HUBOT_IRC_USESSL
    REDISCLOUD_URL

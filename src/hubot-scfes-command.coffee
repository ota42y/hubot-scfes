HubotScfes = require('./scfes/hubot-scfes.coffee').HubotScfes

module.exports = (robot) ->
  scfes = new HubotScfes
  robot.respond /scfes remind stamina (\d+) (\d+)$/, (msg) ->
    now_stamina = parseInt msg.match[1]
    max_stamina = parseInt msg.match[2]

    user = msg.message.user.name
    room = msg.message.user.room

    next_date = scfes.remindMaxStamina(now_stamina, max_stamina, ->
      robot.send {room: room}, "#{user}: stamina max"
    )
    msg.reply "registerd " + next_date

  robot.respond /scfes remind stop/, (msg) ->
    if scfes.remindStop
      msg.reply "remind stop"
    else
      msg.reply "remind stop error"

  robot.respond /scfes remind stamina (\d+) (\d+) (\d+)/, (msg) ->
    now_stamina = parseInt msg.match[1]
    max_stamina = parseInt msg.match[2]
    multiple = parseInt msg.match[3]    

    user = msg.message.user.name
    room = msg.message.user.room

    next_date = scfes.remindMultipleRecoveryTime(now_stamina, max_stamina, multiple, ->
      robot.send {room: room}, "#{user}: stamina gather"
    )
    msg.reply "registerd " + next_date

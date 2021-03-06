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
    if scfes.remindStop()
      msg.reply "remind stop"
    else
      msg.reply "remind stop error"

  robot.respond /scfes remind stamina (\d+) (\d+) (\d+)/, (msg) ->
    now_stamina = parseInt msg.match[1]
    max_stamina = parseInt msg.match[2]
    multiple = parseInt msg.match[3]

    user = msg.message.user.name
    room = msg.message.user.room

    next_date = scfes.remindMultipleRecoveryTime(now_stamina, max_stamina, multiple, (date)->
      robot.send {room: room}, "#{user}: stamina gather #{date}"
    , ->
      robot.send {room: room}, "#{user}: stamina max"
    )
    msg.reply "registerd " + next_date

  robot.respond /scfes levelup time (\d+)( (\w+))?/, (msg) ->
    now_exp = parseInt msg.match[1]
    difficulty = msg.match[3]

    msg.reply "next levelup is " + scfes.getNextLevelupTime(now_exp, difficulty)

  robot.respond /scfes levelup time medley( expup)? (\d+)( (\w+))?( (\d+))?/, (msg) ->
    arrange = false
    arrange = true if msg.match[1]
    now_exp = parseInt msg.match[2]
    difficulty = msg.match[4]
    times =  parseInt msg.match[6]

    msg.reply "next levelup is " + scfes.getNextLevelupTimeByMedley(now_exp, difficulty, times, arrange)

  robot.respond /scfes levelup count (\d+)( (\w+))?/, (msg) ->
    now_exp = parseInt msg.match[1]
    difficulty = msg.match[3]

    msg.reply "next levelup is " + scfes.getNextLevelupCount(now_exp, difficulty)

  robot.respond /scfes levelup count medley( expup)? (\d+)( (\w+))?( (\d+))?/, (msg) ->
    arrange = false
    arrange = true if msg.match[1]

    now_exp = parseInt msg.match[2]
    difficulty = msg.match[4]
    times =  parseInt msg.match[6]
    times = 3 unless times

    msg.reply "next levelup is " + scfes.getNextLevelupCount(now_exp, difficulty, times, arrange)

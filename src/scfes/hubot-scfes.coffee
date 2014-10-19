StaminaCalculator = require('stamina-calculator').StaminaCalculator

STAMINA_RESTORATION_TIME = 6*60

class HubotScfes
  constructor: () ->
    @calc = new StaminaCalculator STAMINA_RESTORATION_TIME
    @timer = null

  remindMaxStamina: (now, max, callback) ->
    @remindStop()

    next_max_time = @calc.getNextMaxStaminaTime(now, max)

    @timer = setTimeout(->
      callback()
      return
    , next_max_time)

    return @calc.convertToDate(next_max_time)

  remindStop: ->
    if @timer != null
      clearTimeout @timer
      @timer = null
      return true
    return false


  # 戻り値とcallbackの引数に次の通知時刻が渡される
  remindMultipleRecoveryTime: (now, max, multiple, callback) ->
    @remindStop()

    next_max_times = @getMultipleRecoveryTime(now, max, multiple)
    return @remindNextMultipleTime(next_max_times, callback)

  getMultipleRecoveryTime: (now, max, multiple) ->
    next_max_times = @calc.getMultipleRecoveryTime(now, max, multiple)

    # 直前との差に変更する
    now_time = 0
    index = 0

    while index < next_max_times.length
      next_max_times[index] -= now_time
      now_time += next_max_times[index]
      index++

    return next_max_times

  remindNextMultipleTime: (next_max_times, callback) ->
    if next_max_times.length != 0
      @remindStop()
      next_max_time = next_max_times[0]
      next_max_times.shift()

      self = this

      @timer = setTimeout( ->
        response = self.remindNextMultipleTime(next_max_times, callback)
        callback(response)
        return
      , next_max_time)
      return @calc.convertToDate(next_max_time)

    return null

module.exports.HubotScfes = HubotScfes

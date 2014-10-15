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

module.exports.HubotScfes = HubotScfes

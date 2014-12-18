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
    , next_max_time * 1000)

    return @calc.convertToDate(next_max_time)

  remindStop: ->
    if @timer != null
      clearTimeout @timer
      @timer = null
      return true
    return false


  # 戻り値とcallbackの引数に次の通知時刻が渡される
  remindMultipleRecoveryTime: (now, max, multiple, callback, end_callback) ->
    @remindStop()

    next_max_times = @getMultipleRecoveryTime(now, max, multiple)
    return @remindNextMultipleTime(next_max_times, callback, end_callback)

  getMultipleRecoveryTime: (now, max, multiple) ->
    next_max_times = @calc.getMultipleRecoveryTime(now, max, multiple)
    stamina_max_time = @calc.getNextMaxStaminaTime(now, max)
    # 最後にmax時の通知をするためにmax時刻を追加する
    next_max_times.push stamina_max_time

    # 直前との差に変更する
    now_time = 0
    index = 0

    while index < next_max_times.length
      next_max_times[index] -= now_time
      now_time += next_max_times[index]
      index++

    return next_max_times

  remindNextMultipleTime: (next_max_times, callback, end_callback) ->
    if next_max_times.length != 0
      @remindStop()
      next_max_time = next_max_times[0]
      next_max_times.shift()

      self = this

      @timer = setTimeout( ->
        response = self.remindNextMultipleTime(next_max_times, callback, end_callback)

        if response
          callback(response)
        else
          end_callback()
        return
      , next_max_time * 1000)
      return @calc.convertToDate(next_max_time)

    return null

  # 指定した難易度で何回クリアするとレベルアップするかを返す
  getNextLevelupCount: (next_exp, difficulty, num, is_exp_up) ->
    # 経験値アップアレンジをしていれば1.1倍
    arrange_rate = 1.0
    arrange_rate = 1.1 if is_exp_up

    # メドレーフェスティバルでも、経験値は変化がない為、かけ算で対応可能
    num = 1 unless num
    return @calc.getNextLevelupCount(next_exp, @getExpFromDifficulty(difficulty) * num * arrange_rate)

  getExpFromDifficulty: (difficulty) ->
    return switch difficulty
      when "expert" then 83.0
      when "hard" then 46.0
      when "normal" then 26.0
      when "easy" then 12.0
      else 83.0

  getStaminaFromDifficulty: (difficulty) ->
    return switch difficulty
      when "expert" then 25
      when "hard" then 15
      when "normal" then 10
      when "easy" then 5
      else 25

  getMedleyStaminaFromDifficulty: (difficulty, num) ->
    num = 1 unless num

    return num * switch difficulty
      when "expert" then 20
      when "hard" then 12
      when "normal" then 8
      when "easy" then 4
      else 20

  getNextLevelupTime: (next_exp, difficulty) ->
    need_stamina = @getStaminaFromDifficulty(difficulty)
    next_levelup_count = @getNextLevelupCount next_exp, difficulty

    @calcStaminaFromPlayTimes(next_levelup_count, need_stamina)

  getNextLevelupTimeByMedley: (next_exp, difficulty, times, is_exp_up) ->
    need_stamina = @getMedleyStaminaFromDifficulty(difficulty, times)
    next_levelup_count = @getNextLevelupCount next_exp, difficulty, times, is_exp_up

    @calcStaminaFromPlayTimes(next_levelup_count, need_stamina)

  calcStaminaFromPlayTimes: (play_times, need_stamina) ->
    if play_times && need_stamina
      return @calc.convertToDate(@calc.getRecoveredTime(play_times * need_stamina))
    else
      return null



module.exports.HubotScfes = HubotScfes

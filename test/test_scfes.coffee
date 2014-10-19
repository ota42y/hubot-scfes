HubotScfes = require('../src/scfes/hubot-scfes.coffee').HubotScfes

describe "scfes test", ->

  describe "remindMaxStamina", ->
    @scfes = null
    @clock = null
    beforeEach (done) ->
      @scfes = new HubotScfes
      @clock = sinon.useFakeTimers(0, "setTimeout", "clearTimeout", "setInterval", "clearInterval", "Date")
      done()

    describe "remindMaxStamina", ->
      it "callback", (done) ->
        @scfes.remindMaxStamina(10, 60, ->
          done()
        )

        @clock.tick(50 * 6 * 60)

  describe "getMultipleRecoveryTime", ->
    beforeEach (done) ->
      @scfes = new HubotScfes
      done()

    it "callback", (done) ->
      multiple_recovery_time = @scfes.getMultipleRecoveryTime(10, 80, 25)
      expect(multiple_recovery_time).to.eql([15*6*60, 25*6*60, 25*6*60])
      done()

  describe "remindMultipleRecoveryTime", ->
    beforeEach (done) ->
      @scfes = new HubotScfes
      @clock = sinon.useFakeTimers(0, "setTimeout", "clearTimeout", "setInterval", "clearInterval", "Date")
      done()

    it "correct return date", (done) ->
      next_max_time = @scfes.remindMultipleRecoveryTime(10, 80, 25, (next_max_time) ->
        return
      )
      expect(next_max_time).to.eql(new Date(15 * 6 * 60 * 1000))
      done()

    it "correct remind", (done) ->
      count = 0

      clock = @clock
      @scfes.remindMultipleRecoveryTime(10, 80, 25, (next_max_time) ->
        count += 1
        if count == 1
          clock.tick(25 * 6 * 60)
        else if count == 2
          clock.tick(25 * 6 * 60)
        else if count == 3
          done()
        return
      )

      clock.tick(15 * 6 * 60)

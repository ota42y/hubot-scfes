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

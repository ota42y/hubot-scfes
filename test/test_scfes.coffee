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

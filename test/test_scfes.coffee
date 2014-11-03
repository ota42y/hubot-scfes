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

        @clock.tick(50 * 6 * 60 * 1000)

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

    it "correct once", (done) ->
      count = 0
      clock = @clock
      @scfes.remindMultipleRecoveryTime(10, 80, 25, (next_max_time) ->
        count += 1
        return
      )
      clock.tick(40 * 6 * 60 * 1000 - 1)
      if count == 1
        done()
      else
        done(new Error("callback " + count + " times called"))

    it "correct remind", (done) ->
      count = 0

      clock = @clock
      @scfes.remindMultipleRecoveryTime(10, 80, 25, (next_max_time) ->
        count += 1
        if count == 1
          clock.tick(25 * 6 * 60 * 1000)
        else if count == 2
          clock.tick(25 * 6 * 60 * 1000)
        else if count == 3
          done()
        return
      )
      clock.tick(15 * 6 * 60 * 1000)

  describe "getNextLevelupTime", ->
    beforeEach (done) ->
      @scfes = new HubotScfes
      @clock = sinon.useFakeTimers(0, "setTimeout", "clearTimeout", "setInterval", "clearInterval", "Date")
      done()

    describe "correct return date", ->
      it "expart", (done) ->
        #e expart is 83 exp
        date = @scfes.getNextlevelupTime(830 + 50, "ex")
        expect(date).to.eql(new Date(6 * 60 * 25 * 11 * 1000))
        done()

      it "hard", (done) ->
        # hard is 46 exp
        date = @scfes.getNextlevelupTime(230, "hard")
        expect(date).to.eql(new Date(6 * 60 * 15 * 5 * 1000))
        done()

      it "normal", (done) ->
        # normal is 26 exp
        date = @scfes.getNextlevelupTime(520, "normal")
        expect(date).to.eql(new Date(6 * 60 * 10 * 20 * 1000))
        done()

      it "easy", (done) ->
        # easy is 12 exp
        date = @scfes.getNextlevelupTime(24, "easy")
        expect(date).to.eql(new Date(6 * 60 * 5 * 2 * 1000))
        done()

      it "small value", (done) ->
        date = @scfes.getNextlevelupTime(1, "ex")
        expect(date).to.eql(new Date(6 * 60 * 25 * 1 * 1000))
        done()

    describe "invalid data", ->
      it "invalid difficulty", (done) ->
        date = @scfes.getNextlevelupTime(1, "Ho.")
        expect(date).to.eql(null)
        done()

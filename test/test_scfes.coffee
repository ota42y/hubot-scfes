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
      expect(multiple_recovery_time).to.eql([15*6*60, 25*6*60, 25*6*60, 5*6*60])
      done()

  describe "getExpFromDifficulty", ->
    beforeEach (done) ->
      @scfes = new HubotScfes
      done()

    it "not set is expert", (done) ->
      assert.equal @scfes.getExpFromDifficulty(), 83.0
      done()

    it "expert", (done) ->
      assert.equal @scfes.getExpFromDifficulty("expert"), 83.0
      done()

    it "hard", (done) ->
      assert.equal @scfes.getExpFromDifficulty("hard"), 46.0
      done()

    it "normal", (done) ->
      assert.equal @scfes.getExpFromDifficulty("normal"), 26.0
      done()

    it "easy", (done) ->
      assert.equal @scfes.getExpFromDifficulty("easy"), 12.0
      done()


  describe "getStaminaFromDifficulty", ->
    beforeEach (done) ->
      @scfes = new HubotScfes
      done()

    describe "medley", (done) ->
      it "default is expert one time", (done) ->
        assert.equal @scfes.getMedleyStaminaFromDifficulty(), 20
        done()

      it "expert", (done) ->
        assert.equal @scfes.getMedleyStaminaFromDifficulty("expert", 3), 60
        done()

      it "hard", (done) ->
        assert.equal @scfes.getMedleyStaminaFromDifficulty("hard", 2), 24
        done()

      it "normal", (done) ->
        assert.equal @scfes.getMedleyStaminaFromDifficulty("normal", 1), 8
        done()

      it "easy", (done) ->
        assert.equal @scfes.getMedleyStaminaFromDifficulty("easy", 1), 4
        done()
        
    describe "not medley", (done)->
      it "default is expert", (done) ->
        assert.equal @scfes.getStaminaFromDifficulty(), 25
        done()

      it "expert", (done) ->
        assert.equal @scfes.getStaminaFromDifficulty("expert"), 25
        done()

      it "hard", (done) ->
        assert.equal @scfes.getStaminaFromDifficulty("hard"), 15
        done()

      it "normal", (done) ->
        assert.equal @scfes.getStaminaFromDifficulty("normal"), 10
        done()

      it "easy", (done) ->
        assert.equal @scfes.getStaminaFromDifficulty("easy"), 5
        done()

  describe "remindMultipleRecoveryTime", ->
    beforeEach (done) ->
      @scfes = new HubotScfes
      @clock = sinon.useFakeTimers(0, "setTimeout", "clearTimeout", "setInterval", "clearInterval", "Date")
      done()

    it "correct return date", (done) ->
      next_max_time = @scfes.remindMultipleRecoveryTime(10, 80, 25, (next_max_time) ->
        return
      , ->
        return
      )

      expect(next_max_time).to.eql(new Date(15 * 6 * 60 * 1000))
      done()

    it "correct once", (done) ->
      count = 0
      flag = true
      clock = @clock
      @scfes.remindMultipleRecoveryTime(10, 80, 25, (next_max_time) ->
        count += 1
        return
      , (next_max_time) ->
        flag = false
        return
      )
      clock.tick(40 * 6 * 60 * 1000 - 1)
      assert.equal flag, true
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
          expect(next_max_time).to.eql(new Date((15 + 25) * 6 * 60 * 1000))
          clock.tick(25 * 6 * 60 * 1000)
        else if count == 2
          expect(next_max_time).to.eql(new Date((40 + 25) * 6 * 60 * 1000))
          clock.tick(25 * 6 * 60 * 1000)
        else if count == 3
          expect(next_max_time).to.eql(new Date((65 + 5) * 6 * 60 * 1000))
          clock.tick(5 * 6 * 60 * 1000)
        return
      , ->
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
      it "expert", (done) ->
        # expert is 83 exp
        date = @scfes.getNextLevelupTime(830 + 50, "expert")
        expect(date).to.eql(new Date(6 * 60 * 25 * 11 * 1000))
        done()

      it "hard", (done) ->
        # hard is 46 exp
        date = @scfes.getNextLevelupTime(230, "hard")
        expect(date).to.eql(new Date(6 * 60 * 15 * 5 * 1000))
        done()

      it "normal", (done) ->
        # normal is 26 exp
        date = @scfes.getNextLevelupTime(520, "normal")
        expect(date).to.eql(new Date(6 * 60 * 10 * 20 * 1000))
        done()

      it "easy", (done) ->
        # easy is 12 exp
        date = @scfes.getNextLevelupTime(24, "easy")
        expect(date).to.eql(new Date(6 * 60 * 5 * 2 * 1000))
        done()

      it "small value", (done) ->
        date = @scfes.getNextLevelupTime(1, "expert")
        expect(date).to.eql(new Date(6 * 60 * 25 * 1 * 1000))
        done()

      it "expert", (done) ->
        date = @scfes.getNextLevelupTimeByMedley(830 + 50, "expert", 3)
        expect(date).to.eql(new Date(6 * 60 * 20 * 12 * 1000))
        done()

    describe "invalid data", ->
      it "invalid difficulty is expert", (done) ->
        date = @scfes.getNextLevelupTime(1, "Ho.")
        expect(date).to.eql(new Date(6 * 60 * 25 * 1 * 1000))
        done()

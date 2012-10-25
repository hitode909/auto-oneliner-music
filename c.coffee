unless context.setup
  context.setup = true

  $.getScript 'http://mohayonao.github.com/timbre/timbre.min.js', (res) ->

    Oneliner = (_args) ->
      @_ = {}
      @_.func = (t) -> t
      @_.phase = 0

    Oneliner.prototype.seq = (seq_id) ->
      _ = @_
      cell = @cell

      if @seq_id != seq_id
        @seq_id = seq_id
        i = 0
        len = cell.length
        while i < len
          cell[i] = (((_.func(_.phase|0) % 256) / 128.0) - 1.0) * _.mul + _.add
          _.phase += 8000 / timbre.samplerate
          i++

      cell

    Object.defineProperty Oneliner.prototype, "func",
      set: (value) ->
        if typeof  value == "function"
          @_.func = value
      get: ->
        @_.func

    timbre.fn.register("oneliner", Oneliner)

    context.oneliner = T("oneliner")

    context.dac = T("*", context.oneliner, 0.7)
    context.dac.play()

    context.set_func = (str) ->
      context.oneliner.func = eval("(function(t){return #{ str } ;})")

context.set_func message.data if context.set_func

if $('pre').length > 80
  $('pre:eq(0)').remove()

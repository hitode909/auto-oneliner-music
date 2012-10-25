if (!context.setup) {
  context.setup = true;
  $.getScript('http://mohayonao.github.com/timbre/timbre.min.js', function(res) {
    var Oneliner;
    Oneliner = function(_args) {
      this._ = {};
      this._.func = function(t) {
        return t;
      };
      return this._.phase = 0;
    };
    Oneliner.prototype.seq = function(seq_id) {
      var cell, i, len, _;
      _ = this._;
      cell = this.cell;
      if (this.seq_id !== seq_id) {
        this.seq_id = seq_id;
        i = 0;
        len = cell.length;
        while (i < len) {
          cell[i] = (((_.func(_.phase | 0) % 256) / 128.0) - 1.0) * _.mul + _.add;
          _.phase += 8000 / timbre.samplerate;
          i++;
        }
      }
      return cell;
    };
    Object.defineProperty(Oneliner.prototype, "func", {
      set: function(value) {
        if (typeof value === "function") {
          return this._.func = value;
        }
      },
      get: function() {
        return this._.func;
      }
    });
    timbre.fn.register("oneliner", Oneliner);
    context.oneliner = T("oneliner");
    context.dac = T("*", context.oneliner, 0.7);
    context.dac.play();
    return context.set_func = function(str) {
      return context.oneliner.func = eval("(function(t){return " + str + " ;})");
    };
  });
}
if (context.set_func) {
  context.set_func(message.data);
}
if ($('pre').length > 80) {
  $('pre:eq(0)').remove();
}
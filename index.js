var through = require("through")
  , parser = require("./parser").parser
  , scope = require("./scope")

parser.yy = scope

function parse (input) {
  return parser.parse(input)
}

module.exports = function () {
  var input = ""
  return through(function write (data) {
    input += data
  }, function end () {
    this.queue(parse(input)).queue(null)
  })
}

module.exports.parse = parse
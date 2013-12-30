var parser = require("./parser").parser
  , scope = require("./scope")

parser.yy = scope

module.exports.parse = function (input) {
  return parser.parse(input)
}
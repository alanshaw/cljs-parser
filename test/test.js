var fs = require("fs")
  , parser = require("../")

var tree = parser.parse(fs.readFileSync(__dirname + "/fixtures/hello.cljs", {encoding: "utf8"}))

console.log(JSON.stringify(tree, null, 2))
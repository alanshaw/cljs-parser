var fs = require("fs")
  , parser = require("../")

var fixturesDir = __dirname + "/fixtures"

fs.readdir(fixturesDir, function (er, srcs) {
  if (er) throw er

  srcs.forEach(function (src) {
    var tree = parser.parse(fs.readFileSync(fixturesDir + "/" + src, {encoding: "utf8"}))

    console.log(JSON.stringify(tree, null, 2))
  })
})

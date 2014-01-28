cljs-parser [![Build Status](https://travis-ci.org/alanshaw/cljs-parser.png)](https://travis-ci.org/alanshaw/cljs-parser) [![devDependency Status](https://david-dm.org/alanshaw/cljs-parser/dev-status.png)](https://david-dm.org/alanshaw/cljs-parser#info=devDependencies)
===========

Clojurescript parser.

If it doesn't work, it's probably because I have no idea what I'm doing. I've never even coded in clojurescript. Help needed and appreciated.

Usage
---
```js
var parser = require("cljs-parser")
  , fs = require("fs")

fs.readFile("/path/to/src.cljs", {encoding: "utf8"}, function (er, input) {
  if (er) throw er
  var tree = parser.parse(input)
  // Do something with the tree
})
```

It creates a tree structure of nodes that have `type`, `left` and `right` properties. The `left` and `right` properties point to other nodes unless the node `type` is "leaf", in which case it's `left` property points to a token, which has a `type` and `val` property.

For the input file hello.cljs:

```clojurescript
(ns hello.core)

; Hello World in clojurescript
(defn -main []
  (println "Hello World"))

(set! *main-cli-fn* -main)
```

output:

```js
{
  "type": "list_list",
  "left": {
    "type": "list_list",
    "left": {
      "type": "list",
      "left": {
        "type": "s_exp_list",
        "left": {
          "type": "leaf",
          "left": {
            "type": "symbol",
            "val": "ns"
          },
          "right": null
        },
        "right": {
          "type": "leaf",
          "left": {
            "type": "symbol",
            "val": "hello.core"
          },
          "right": null
        }
      }
    },
    "right": {
      "type": "list",
      "left": {
        "type": "s_exp_list",
        "left": {
          "type": "leaf",
          "left": {
            "type": "symbol",
            "val": "defn"
          },
          "right": null
        },
        "right": {
          "type": "s_exp_list",
          "left": {
            "type": "leaf",
            "left": {
              "type": "symbol",
              "val": "-main"
            },
            "right": null
          },
          "right": {
            "type": "s_exp_list",
            "left": {
              "type": "param_list"
            },
            "right": {
              "type": "list",
              "left": {
                "type": "s_exp_list",
                "left": {
                  "type": "leaf",
                  "left": {
                    "type": "symbol",
                    "val": "println"
                  },
                  "right": null
                },
                "right": {
                  "type": "leaf",
                  "left": {
                    "type": "string",
                    "val": "Hello World"
                  },
                  "right": null
                }
              }
            }
          }
        }
      }
    }
  },
  "right": {
    "type": "list",
    "left": {
      "type": "s_exp_list",
      "left": {
        "type": "leaf",
        "left": {
          "type": "symbol",
          "val": "set!"
        },
        "right": null
      },
      "right": {
        "type": "s_exp_list",
        "left": {
          "type": "leaf",
          "left": {
            "type": "symbol",
            "val": "*main-cli-fn*"
          },
          "right": null
        },
        "right": {
          "type": "leaf",
          "left": {
            "type": "symbol",
            "val": "-main"
          },
          "right": null
        }
      }
    }
  }
}
```
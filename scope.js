var util = require("util")

/**
 * @param {String} type
 * @param {Node} left
 * @param {Node} right
 * @constructor
 */
function Node (type, left, right) {
  this.type = type
  this.left = left
  this.right = right
}

/**
 * @param {Token} token
 * @constructor
 */
function Leaf (token) {
  Node.call(this, "leaf", token, null)
}

util.inherits(Leaf, Node)

/**
 * @param {String} type
 * @param {*} val
 * @constructor
 */
function Token (type, val) {
  this.type = type
  this.val = val
}

module.exports = {
  createNode: function (type, left, right) {
    return new Node(type, left, right)
  },
  createLeaf: function (type, val) {
    // TODO: Cache and reuse token
    return new Leaf(new Token(type, val))
  }
}
Node = require './node'

###
Initialize a new `Block` with an optional `node`.

@param {Node} node
@private
###
class Block extends Node
	constructor: (node) ->
		@nodes = []
		@push node if node

		#Block flag
		@isBlock = true


	###
	Replace the nodes in `other` with the nodes
	in `this` block.

	@param {Block} other
	@private
	###
	replace: (other) ->
		other.nodes = @nodes


	###
	Push the given `node`.

	@param {Node} node
	@return {Number}
	@private
	###
	push: (node) ->
		@nodes.push node


	###
	Check if this block is empty.

	@return {Boolean}
	@private
	###
	isEmpty: ->
		@nodes.length is 0


	###
	Unshift the given `node`.

	@param {Node} node
	@return {Number}
	@private
	###
	unshift: (node) ->
		@nodes.unshift node


	###
	Return the "last" block, or the first `yield` node.

	@return {Block}
	@private
	###
	includeBlock: ->
		ret = @
		for node in @nodes
			if node.yield_tok
				return node
			else if node.textOnly
				continue
			else if node.includeBlock
				ret = node.includeBlock()
			else if node.block and not node.block.isEmpty()
				ret = node.block.includeBlock()

			if ret.yield_tok
				return ret

		ret

	###
	 * Prune any extends blocks and return this node.
	 *
	 * @return {Block}
	 * @private
	###

	prune: ->
		@nodes = @nodes.filter(
			(node) ->
				return not node.mode
		)
		return @

	###
	Return a clone of this block.

	@return {Block}
	@private
	###
	clone: ->
		clone = new Block
		for node in @nodes
			clone.push node.clone()

		clone


module.exports = Block
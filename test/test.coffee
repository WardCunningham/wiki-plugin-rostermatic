# build time tests for rostermatic plugin
# see http://mochajs.org/

rostermatic = require '../client/rostermatic'
expect = require 'expect.js'

describe 'rostermatic plugin', ->

  describe 'expand', ->

    it 'can make itallic', ->
      result = rostermatic.expand 'hello *world*'
      expect(result).to.be 'hello <i>world</i>'

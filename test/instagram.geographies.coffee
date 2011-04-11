
###
Testing Geographies Methods
###

console.log "\nInstagram API Node.js Lib Tests :: Geographies"

Instagram = require '../lib/class.instagram'
assert = require 'assert'
should = require 'should'
test_helper = require './helpers.js'

module.exports =
  'geographies#recent for id#4167': ->
    test_helper 'geographies#recent for id#4167', Instagram, 'geographies', 'recent', { geography_id: 4167 }, (data) ->
      data.should.not.be.empty

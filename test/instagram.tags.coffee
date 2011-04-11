
###
Testing Tag Methods
###

console.log "\nInstagram API Node.js Lib Tests :: Tags"

Instagram = require '../lib/class.instagram'
assert = require 'assert'
should = require 'should'
test_helper = require './helpers.js'

module.exports =
  'tags#info for blue': ->
    test_helper 'tags#info for blue', Instagram, 'tags', 'info', { name: 'blue' }, (data) ->
      data.should.have.property 'name', 'blue'
      data.media_count.should.be.above 0
  'tags#recent for blue': ->
    test_helper 'tags#recent for blue', Instagram, 'tags', 'recent', { name: 'blue' }, (data, pagination) ->
      data.length.should.equal 20
      data[0].should.have.property 'id'
      pagination.should.have.property 'next_url'
      pagination.should.have.property 'next_max_id'
      pagination.should.have.property 'next_min_id'
  'tags#search for blue': ->
    test_helper 'tags#search for blue', Instagram, 'tags', 'search', { q: 'blue' }, (data) ->
      data.length.should.equal 50
      data[0].should.have.property 'name', 'blue'
      data[0].media_count.should.be.above 0

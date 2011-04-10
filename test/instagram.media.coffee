
###
Testing Media Methods
###

console.log "\nInstagram API Node.js Lib Tests :: Media"

Instagram = require '../lib/class.instagram'
assert = require 'assert'
should = require 'should'
test_helper = require './helpers.js'

module.exports =
  'media#popular': ->
    test_helper 'media#popular', Instagram, 'media', 'popular', {}, (data) ->
      data.length.should.equal 32
      data[0].should.have.property 'id'
  'media#info for id#3': ->
    test_helper 'media#info for id#3', Instagram, 'media', 'info', { media_id: 3 }, (data) ->
      data.should.have.property 'id', '3'
      data.should.have.property 'created_time', '1279315783'
  'media#likes for id#3': ->
    test_helper 'media#likes for id#3', Instagram, 'media', 'likes', { media_id: 3 }, (data) ->
      data.length.should.be.above 0
  'media#comments for id#3': ->
    test_helper 'media#comments for id#3', Instagram, 'media', 'comments', { media_id: 3 }, (data) ->
      data.length.should.be.above 0
  'media#search for 48.858844300000001/2.2943506': ->
    test_helper 'media#search for 48.858844300000001/2.2943506', Instagram, 'media', 'search', { lat: 48.858844300000001, lng: 2.2943506 }, (data) ->
      data.length.should.be.above 0
      data[0].should.have.property 'id'

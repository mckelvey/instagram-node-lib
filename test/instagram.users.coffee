
###
Testing Users Methods
###

console.log "\nInstagram API Node.js Lib Tests :: Users"

Instagram = require '../lib/class.instagram'
assert = require 'assert'
should = require 'should'
test_helper = require './helpers.js'

module.exports =
  'users#info for id#291024': ->
    test_helper 'users#info for id#291024', Instagram, 'users', 'info', { user_id: 291024 }, (data) ->
      data.should.have.property 'id', '291024'
      data.should.have.property 'profile_picture'
  'users#search for mckelvey': ->
    test_helper 'users#search for mckelvey', Instagram, 'users', 'search', { q: 'mckelvey' }, (data) ->
      data.length.should.be.above 0
      data[0].should.have.property 'username', 'mckelvey'
      data[0].should.have.property 'id', '291024'

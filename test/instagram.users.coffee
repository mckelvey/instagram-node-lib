
###
Testing Users Methods
###

console.log "\nInstagram API Node.js Lib Tests :: Users"

Instagram = require '../lib/class.instagram'
assert = require 'assert'
should = require 'should'
test = require './helpers.js'

module.exports =
  'users#info for id#291024': ->
    test.helper 'users#info for id#291024', Instagram, 'users', 'info', { user_id: 291024 }, (data) ->
      data.should.have.property 'id', '291024'
      test.output "data had the property 'id' equal to '291024'"
      data.should.have.property 'profile_picture'
      test.output "data had the property 'profile_picture'", data.profile_picture
  'users#self for mckelvey': ->
    test.helper 'users#self for mckelvey', Instagram, 'users', 'self', {}, (data) ->
      data.length.should.be.above 0
      test.output "data had length greater than 0", data.length
      data[0].should.have.property 'id'
      test.output "data[0] had the property 'id'", data[0].id
      data[0].should.have.property 'user'
      test.output "data[0] had the property 'user'", data[0].user
  'users#recent for mckelvey': ->
    test.helper 'users#recent for mckelvey', Instagram, 'users', 'recent', { user_id: 291024 }, (data) ->
      data.length.should.be.above 0
      data[0].should.have.property 'id'
      data[0]['user'].should.have.property 'username', 'mckelvey'
  'users#search for mckelvey': ->
    test.helper 'users#search for mckelvey', Instagram, 'users', 'search', { q: 'mckelvey' }, (data) ->
      data.length.should.be.above 0
      test.output "data had length greater than 0", data.length
      data[0].should.have.property 'username', 'mckelvey'
      test.output "data had the property 'username' equal to 'mckelvey'"
      data[0].should.have.property 'id', '291024'
      test.output "data had the property 'id' equal to '291024'"
  'users#follows id#291024': ->
    test.helper 'users#follows id#291024', Instagram, 'users', 'follows', { user_id: 291024 }, (data, pagination) ->
      data.length.should.be.above 0
      data.length.should.be.below 51
  'users#followed_by id#291024': ->
    test.helper 'users#followed_by id#291024', Instagram, 'users', 'followed_by', { user_id: 291024 }, (data, pagination) ->
      data.length.should.be.above 0
      test.output "data had length greater than 0"
      data.length.should.be.below 51
      test.output "data had length less than 51", data.length
  'users#requested_by id#291024': ->
    test.helper 'users#requested_by id#291024', Instagram, 'users', 'requested_by', { user_id: 291024 }, (data, pagination) ->
      data.should.have.property 'length'
      test.output "data had the property 'length'", data.length
  'users#relationship with id#291024': ->
    test.helper 'users#relationship with id#291024', Instagram, 'users', 'relationship', { user_id: 291024 }, (data, pagination) ->
      data.should.have.property 'outgoing_status'
      test.output "data had the property 'outgoing_status'", data.outgoing_status
      data.should.have.property 'incoming_status'
      test.output "data had the property 'incoming_status'", data.incoming_status
  'users#unfollow id#291024': ->
    test.helper 'users#unfollow id#291024', Instagram, 'users', 'unfollow', { user_id: 291024 }, (data, pagination) ->
      data.should.have.property 'outgoing_status', 'none'
      test.output "data had the property 'outgoing_status' equal to 'none'", data
      test.helper 'users#block id#291024', Instagram, 'users', 'block', { user_id: 291024 }, (data, pagination) ->
        data.should.have.property 'incoming_status', 'blocked_by_you'
        test.output "data had the property 'incoming_status' equal to 'blocked_by_you'", data
        test.helper 'users#unblock id#291024', Instagram, 'users', 'unblock', { user_id: 291024 }, (data, pagination) ->
          data.should.have.property 'incoming_status', 'none'
          test.output "data had the property 'incoming_status' equal to 'none'", data
          test.helper 'users#ignore id#291024', Instagram, 'users', 'ignore', { user_id: 291024 }, (data, pagination) ->
            data.should.have.property 'incoming_status', 'none'
            test.output "data had the property 'incoming_status' equal to 'none'", data
            test.helper 'users#follow id#291024', Instagram, 'users', 'follow', { user_id: 291024 }, (data, pagination) ->
              data.should.have.property 'outgoing_status', 'follows'
              test.output "data had the property 'outgoing_status' equal to 'follows'", data


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
  'users#self for mckelvey': ->
    test_helper 'users#self for mckelvey', Instagram, 'users', 'self', {}, (data) ->
      data.length.should.be.above 0
      data[0].should.have.property 'id'
      data[0].should.have.property 'user'
  'users#recent for mckelvey': ->
    test_helper 'users#recent for mckelvey', Instagram, 'users', 'recent', { user_id: 291024 }, (data) ->
      data.length.should.be.above 0
      data[0].should.have.property 'id'
      data[0]['user'].should.have.property 'username', 'mckelvey'
  'users#search for mckelvey': ->
    test_helper 'users#search for mckelvey', Instagram, 'users', 'search', { q: 'mckelvey' }, (data) ->
      data.length.should.be.above 0
      data[0].should.have.property 'username', 'mckelvey'
      data[0].should.have.property 'id', '291024'
  'users#follows id#291024': ->
    test_helper 'users#follows id#291024', Instagram, 'users', 'follows', { user_id: 291024 }, (data, pagination) ->
      data.length.should.be.above 0
      data.length.should.be.below 51
  'users#followed_by id#291024': ->
    test_helper 'users#followed_by id#291024', Instagram, 'users', 'followed_by', { user_id: 291024 }, (data, pagination) ->
      data.length.should.be.above 0
      data.length.should.be.below 51
  'users#requested_by id#291024': ->
    test_helper 'users#requested_by id#291024', Instagram, 'users', 'requested_by', { user_id: 291024 }, (data, pagination) ->
      data.should.have.property 'length'
  'users#relationship with id#291024': ->
    test_helper 'users#relationship with id#291024', Instagram, 'users', 'relationship', { user_id: 291024 }, (data, pagination) ->
      data.should.have.property 'outgoing_status'
      data.should.have.property 'incoming_status'
      console.log "   outgoing: #{data['outgoing_status']}, incoming: #{data['incoming_status']}"
  'users#unfollow id#291024': ->
    test_helper 'users#unfollow id#291024', Instagram, 'users', 'unfollow', { user_id: 291024 }, (data, pagination) ->
      data.should.have.property 'outgoing_status', 'none'
      console.log "   outgoing: #{data['outgoing_status']}, incoming: #{data['incoming_status']}"
      test_helper 'users#block id#291024', Instagram, 'users', 'block', { user_id: 291024 }, (data, pagination) ->
        data.should.have.property 'incoming_status', 'blocked_by_you'
        console.log "   outgoing: #{data['outgoing_status']}, incoming: #{data['incoming_status']}"
        test_helper 'users#unblock id#291024', Instagram, 'users', 'unblock', { user_id: 291024 }, (data, pagination) ->
          data.should.have.property 'incoming_status', 'none'
          console.log "   outgoing: #{data['outgoing_status']}, incoming: #{data['incoming_status']}"
          test_helper 'users#ignore id#291024', Instagram, 'users', 'ignore', { user_id: 291024 }, (data, pagination) ->
            data.should.have.property 'incoming_status', 'none'
            console.log "   outgoing: #{data['outgoing_status']}, incoming: #{data['incoming_status']}"
            test_helper 'users#follow id#291024', Instagram, 'users', 'follow', { user_id: 291024 }, (data, pagination) ->
              data.should.have.property 'outgoing_status', 'follows'
              console.log "   outgoing: #{data['outgoing_status']}, incoming: #{data['incoming_status']}"

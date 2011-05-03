
###
Test Setup
###

console.log "\nInstagram API Node.js Lib Tests :: Tags"

Init = require './initialize'
Instagram = Init.Instagram
app = Init.app

assert = require 'assert'
should = require 'should'
test = require './helpers'

completed = 0
to_do = 0

###
Tests
###

module.exports =
  'tags#info for blue': ->
    test.helper 'tags#info for blue', Instagram, 'tags', 'info', { name: 'blue' }, (data) ->
      data.should.have.property 'name', 'blue'
      test.output "data had the property 'name' equal to 'blue'"
      data.media_count.should.be.above 0
      test.output "data had the property 'media_count' greater than zero", data.media_count
      app.finish_test()
  'tags#recent for blue': ->
    test.helper 'tags#recent for blue', Instagram, 'tags', 'recent', { name: 'blue' }, (data, pagination) ->
      data.length.should.equal 20
      test.output "data had length equal to 20"
      data[0].should.have.property 'id'
      test.output "data[0] had the property 'id'", data[0]
      pagination.should.have.property 'next_url'
      test.output "pagination had the property 'next_url'", pagination.next_url
      pagination.should.have.property 'next_max_id'
      test.output "pagination had the property 'next_max_id'", pagination.next_max_id
      pagination.should.have.property 'next_min_id'
      test.output "pagination had the property 'next_min_id'", pagination.next_min_id
      app.finish_test()
  'tags#recent for blue with count of 50': ->
    test.helper 'tags#recent for blue with count of 50', Instagram, 'tags', 'recent', { name: 'blue', count: 50 }, (data, pagination) ->
      data.length.should.equal 50
      test.output "data had length equal to 50"
      app.finish_test()
  'tags#search for blue': ->
    test.helper 'tags#search for blue', Instagram, 'tags', 'search', { q: 'blue' }, (data) ->
      data.length.should.be.above 0
      test.output "data had length greater than 0", data.length
      data[0].should.have.property 'name', 'blue'
      test.output "data[0] had the property 'name' equal to 'blue'"
      data[0].media_count.should.be.above 0
      test.output "data[0] had the property 'media_count' greater than zero", data[0].media_count
      app.finish_test()
  'tags#subscription for blue': ->
    test.helper "tags#subscriptions subscribe to 'blue'", Instagram, 'tags', 'subscribe', { object_id: 'blue' }, (data) ->
      data.should.have.property 'id'
      test.output "data had the property 'id'"
      data.id.should.be.above 0
      test.output "data.id was greater than 0", data.id
      data.should.have.property 'type', 'subscription'
      test.output "data had the property 'type' equal to 'subscription'", data
      subscription_id = data.id
      test.helper 'tags#subscriptions list', Instagram, 'subscriptions', 'list', {}, (data) ->
        data.length.should.be.above 0
        test.output "data had length greater than 0", data.length
        found = false
        for i of data
          found = true if data[i].id is subscription_id
        throw "subscription not found" if !found
        test.output "data had the subscription #{subscription_id}"
        test.helper "tags#subscriptions unsubscribe from 'blue'", Instagram, 'tags', 'unsubscribe', { id: subscription_id }, (data) ->
          throw "tag 'blue' unsubscribe failed" if data isnt null
          test.output "data was null; we unsubscribed from the subscription #{subscription_id}"
          app.finish_test()

app.start_tests module.exports

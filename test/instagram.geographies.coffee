
###
Test Setup
###

console.log "\nInstagram API Node.js Lib Tests :: Geographies"

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
  'geographies#subscriptions': ->
    test.helper "geographies#subscriptions subscribe to geography near Eiffel Tower", Instagram, 'geographies', 'subscribe', { lat: 48.858844300000001, lng: 2.2943506, radius: 1000 }, (data) ->
      data.should.have.property 'id'
      test.output "data had the property 'id'"
      data.id.should.be.above 0
      test.output "data.id was greater than 0", data.id
      data.should.have.property 'type', 'subscription'
      test.output "data had the property 'type' equal to 'subscription'", data
      subscription_id = data.id
      test.helper 'geographies#subscriptions list', Instagram, 'subscriptions', 'list', {}, (data) ->
        data.length.should.be.above 0
        test.output "data had length greater than 0", data.length
        found = false
        for i of data
          found = true if data[i].id is subscription_id
        throw "subscription not found" if !found
        test.output "data had the subscription #{subscription_id}"
        test.helper "geographies#subscriptions unsubscribe from media near Eiffel Tower", Instagram, 'geographies', 'unsubscribe', { id: subscription_id }, (data) ->
          throw "geography near Eiffel Tower unsubscribe failed" if data isnt null
          test.output "data was null; we unsubscribed from the subscription #{subscription_id}"
          app.finish_test()

app.start_tests module.exports

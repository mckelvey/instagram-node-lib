
###
Test Setup
###

console.log "\nInstagram API Node.js Lib Tests :: Subscriptions"

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
  'multi#subscriptions': ->
    subscriptions = []
    test.helper "subscriptions subscribe to tag 'red'", Instagram, 'subscriptions', 'subscribe', { object: 'tag', object_id: 'red' }, (data) ->
      data.should.have.property 'id'
      test.output "data had the property 'id'"
      data.id.should.be.above 0
      test.output "data.id was greater than 0", data.id
      data.should.have.property 'type', 'subscription'
      test.output "data had the property 'type' equal to 'subscription'", data
      subscriptions[subscriptions.length] = data.id
      test.helper "subscriptions subscribe to location '1257285'", Instagram, 'subscriptions', 'subscribe', { object: 'location', object_id: '1257285' }, (data) ->
        data.should.have.property 'id'
        test.output "data had the property 'id'"
        data.id.should.be.above 0
        test.output "data.id was greater than 0", data.id
        data.should.have.property 'type', 'subscription'
        test.output "data had the property 'type' equal to 'subscription'", data
        subscriptions[subscriptions.length] = data.id
        test.helper "subscriptions subscribe to media near Eiffel Tower", Instagram, 'subscriptions', 'subscribe', { object: 'geography', lat: 48.858844300000001, lng: 2.2943506, radius: 1000 }, (data) ->
          data.should.have.property 'id'
          test.output "data had the property 'id'"
          data.id.should.be.above 0
          test.output "data.id was greater than 0", data.id
          data.should.have.property 'type', 'subscription'
          test.output "data had the property 'type' equal to 'subscription'", data
          subscriptions[subscriptions.length] = data.id
          test.helper 'subscriptions list', Instagram, 'subscriptions', 'list', {}, (data) ->
            data.length.should.be.above 0
            test.output "data had length greater than 0", data.length
            subscriptions_list = []
            for i of data
              subscriptions_list[subscriptions_list.length] = data[i].id
            found = true
            for i of subscriptions
              found = false if subscriptions[i] not in subscriptions_list
            throw "subscription not found" if !found
            test.output "data had the subscriptions #{subscriptions.join(', ')}"
            test.helper "subscriptions unsubscribe_all", Instagram, 'subscriptions', 'unsubscribe_all', {}, (data) ->
              throw "unsubscribe_all failed" if data isnt null
              test.output "data was null; we unsubscribed from the subscriptions #{subscriptions_list.join(', ')}"
              app.finish_test()

app.start_tests module.exports

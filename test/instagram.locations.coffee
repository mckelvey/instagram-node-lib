
###
Test Setup
###

console.log "\nInstagram API Node.js Lib Tests :: Locations"

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
  'locations#info for id#1': ->
    test.helper 'locations#info for id#1', Instagram, 'locations', 'info', { location_id: 1 }, (data) ->
      data.should.have.property 'name', 'Dogpatch Labs'
      test.output "data had the property 'name' equal to 'Dogpatch Labs'"
      data.latitude.should.be.above 0
      test.output "data had the property 'latitude' greater than zero", data.latitude
      data.longitude.should.be.below 0
      test.output "data had the property 'longitude' less than zero", data.longitude
      app.finish_test()
  'locations#recent for id#1': ->
    test.helper 'locations#recent for id#1', Instagram, 'locations', 'recent', { location_id: 1 }, (data, pagination) ->
      data.length.should.be.above 0
      test.output "data had length greater than 0", data.length
      data[0].should.have.property 'id'
      test.output "data[0] had the property 'id'", data[0].id
      pagination.should.have.property 'next_url'
      test.output "pagination had the property 'next_url'", pagination.next_url
      pagination.should.have.property 'next_max_id' or pagination.should.have.property 'next_min_id'
      test.output "pagination had the property 'next_max_id' or 'next_min_id'", pagination
      app.finish_test()
  'locations#search for 48.858844300000001/2.2943506': ->
    test.helper 'locations#search for 48.858844300000001/2.2943506', Instagram, 'locations', 'search', { lat: 48.858844300000001, lng: 2.2943506 }, (data) ->
      data.length.should.be.above 0
      test.output "data had length greater than 0", data.length
      data[0].should.have.property 'id'
      test.output "data[0] had the property 'id'", data[0].id
      data[0].should.have.property 'name'
      test.output "data[0] had the property 'name'", data[0].name
      app.finish_test()
  'locations#subscriptions': ->
    test.helper "locations#subscriptions subscribe to location '1257285'", Instagram, 'locations', 'subscribe', { object_id: '1257285' }, (data) ->
      data.should.have.property 'id'
      test.output "data had the property 'id'"
      data.id.should.be.above 0
      test.output "data.id was greater than 0", data.id
      data.should.have.property 'type', 'subscription'
      test.output "data had the property 'type' equal to 'subscription'", data
      subscription_id = data.id
      test.helper 'locations#subscriptions list', Instagram, 'subscriptions', 'list', {}, (data) ->
        data.length.should.be.above 0
        test.output "data had length greater than 0", data.length
        found = false
        for i of data
          found = true if data[i].id is subscription_id
        throw "subscription not found" if !found
        test.output "data had the subscription #{subscription_id}"
        test.helper "locations#subscriptions unsubscribe from location '1257285'", Instagram, 'locations', 'unsubscribe', { id: subscription_id }, (data) ->
          throw "location '1257285' unsubscribe failed" if data isnt null
          test.output "data was null; we unsubscribed from the subscription #{subscription_id}"
          app.finish_test()

app.start_tests module.exports

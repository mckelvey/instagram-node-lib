
###
Setup Lib for Testing
###

Instagram = require '../lib/class.instagram'

###
Setup Temp App for Subscription Testing
###

url = require 'url'

CALLBACK_URL = if process.env['CALLBACK_URL']? then process.env['CALLBACK_URL'] else "http://your.callback/url"
callback = url.parse CALLBACK_URL

if callback?
  HOST = callback['hostname']
  PORT = if typeof callback['port'] isnt 'undefined' then callback['port'] else null
  PATH = callback['pathname']

express = require 'express'
app = express.createServer()

app.configure ->
  app.set 'host', HOST
  app.use app.router

app.configure 'development', ->
  app.set 'port', PORT
  app.use express.logger()
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.get PATH,
  (request, response) ->
    Instagram.subscriptions.handshake request, response

app.listen PORT

###
Tests
###

assert = require 'assert'
should = require 'should'
test = require './helpers.js'

completed = 0
to_do = 0
indent = "   "

module.exports =
  'tags#subscriptions': ->
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
  'media#subscriptions': ->
    test.helper "media#subscriptions subscribe to media near Eiffel Tower", Instagram, 'media', 'subscribe', { lat: 48.858844300000001, lng: 2.2943506, radius: 1000 }, (data) ->
      data.should.have.property 'id'
      test.output "data had the property 'id'"
      data.id.should.be.above 0
      test.output "data.id was greater than 0", data.id
      data.should.have.property 'type', 'subscription'
      test.output "data had the property 'type' equal to 'subscription'", data
      subscription_id = data.id
      test.helper 'media#subscriptions list', Instagram, 'subscriptions', 'list', {}, (data) ->
        data.length.should.be.above 0
        test.output "data had length greater than 0", data.length
        found = false
        for i of data
          found = true if data[i].id is subscription_id
        throw "subscription not found" if !found
        test.output "data had the subscription #{subscription_id}"
        test.helper "media#subscriptions unsubscribe from media near Eiffel Tower", Instagram, 'media', 'unsubscribe', { id: subscription_id }, (data) ->
          throw "media near Eiffel Tower unsubscribe failed" if data isnt null
          test.output "data was null; we unsubscribed from the subscription #{subscription_id}"
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
            test.output "data had the subscription #{subscription_id}"
            test.helper "subscriptions unsubscribe_all", Instagram, 'subscriptions', 'unsubscribe_all', {}, (data) ->
              throw "unsubscribe_all failed" if data isnt null
              test.output "data was null; we unsubscribed from the subscriptions #{subscriptions_list.join(', ')}"


###
App Termination
###

for i of module.exports
  to_do += 1

iterations = 0
waiting = setInterval `function(){if(completed==to_do||iterations>to_do){clearInterval(waiting);app.close();}else{iterations+=1;}}`, 1000

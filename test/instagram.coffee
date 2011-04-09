
###
Setup Lib for Testing
###

Instagram = require '../lib/class.instagram'

###
Setup Temp App for Subscription Testing
###

HOST = if process.env['TEST_HOST']? then process.env['TEST_HOST'] else 'your.callback.app'
PORT = if process.env['TEST_PORT']? then process.env['TEST_PORT'] else 3000
PATH = '/subscribe'
CALLBACK_URL = "http://#{HOST}:#{PORT}#{PATH}"

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

to_do = 0
completed = 0

module.exports =
  'tags#info for blue': ->
    Instagram.tags.info {
      name: 'blue'
      complete: (data) ->
        data.should.have.property 'name', 'blue'
        data.media_count.should.be.above 0
        completed += 1
    }
  'tags#recent for blue': ->
    Instagram.tags.recent {
      name: 'blue'
      complete: (data) ->
        data.length.should.equal 20
        data[0].should.have.property 'id'
        completed += 1
    }
  'tags#search for blue': ->
    Instagram.tags.search {
      q: 'blue'
      complete: (data) ->
        data.length.should.equal 50
        data[0].should.have.property 'name', 'blue'
        data[0].media_count.should.be.above 0
        completed += 1
    }
  'locations#info for id#1': ->
    Instagram.locations.info {
      location_id: 1
      complete: (data) ->
        data.should.have.property 'name', 'Dogpatch Labs'
        data.latitude.should.be.above 0
        data.longitude.should.be.below 0
        completed += 1
    }
  'locations#recent for id#1': ->
    Instagram.locations.recent {
      location_id: 1
      complete: (data) ->
        data.length.should.be.above 0
        data[0].should.have.property 'id'
        completed += 1
    }
  'locations#search for 48.858844300000001/2.2943506': ->
    Instagram.locations.search {
      lat: 48.858844300000001
      lng: 2.2943506
      complete: (data) ->
        data.length.should.be.above 0
        data[0].should.have.property 'id'
        data[0].should.have.property 'name'
        completed += 1
    }
  'media#popular': ->
    Instagram.media.popular {
      complete: (data) ->
        data.length.should.equal 32
        data[0].should.have.property 'id'
        completed += 1
    }
  'media#info for id#3': ->
    Instagram.media.info {
      media_id: 3
      complete: (data) ->
        data.should.have.property 'id', '3'
        data.should.have.property 'created_time', '1279315783'
        completed += 1
    }
  'media#likes for id#3': ->
    Instagram.media.likes {
      media_id: 3
      complete: (data) ->
        data.length.should.be.above 0
        completed += 1
    }
  'media#comments for id#3': ->
    Instagram.media.comments {
      media_id: 3
      complete: (data) ->
        data.length.should.be.above 0
        completed += 1
    }
  'media#search for 48.858844300000001/2.2943506': ->
    Instagram.media.search {
      lat: 48.858844300000001
      lng: 2.2943506
      complete: (data) ->
        data.length.should.be.above 0
        data[0].should.have.property 'id'
        completed += 1
    }
  'users#info for id#291024': ->
    Instagram.users.info {
      user_id: 291024
      complete: (data) ->
        data.should.have.property 'id', '291024'
        data.should.have.property 'profile_picture'
        completed += 1
    }
  'users#search for mckelvey': ->
    Instagram.users.search {
      q: 'mckelvey'
      complete: (data) ->
        data.length.should.be.above 0
        data[0].should.have.property 'username', 'mckelvey'
        data[0].should.have.property 'id', '291024'
        completed += 1
    }
  'tags#subscriptions subscribe#blue, subscriptions, unsubscribe#blue#id': ->
    unsubscribe = (subscription_id) ->
      Instagram.tags.unsubscribe {
        id: subscription_id
        complete: (data) ->
          assert.isNull data
          completed += 1
      }
    list = (subscription_id) ->
      Instagram.subscriptions.list {
        complete: (data) ->
          data.should.not.be.empty
          unsubscribe subscription_id
      }
    Instagram.tags.subscribe {
      object_id: 'blue'
      callback_url: CALLBACK_URL
      complete: (data) ->
        data.should.have.property 'id'
        data.id.should.be.above 0
        data.should.have.property 'type', 'subscription'
        list data['id']
    }
  'locations#subscriptions subscribe#1257285, subscriptions, unsubscribe#1257285#id': ->
    unsubscribe = (subscription_id) ->
      Instagram.locations.unsubscribe {
        id: subscription_id
        complete: (data) ->
          assert.isNull data
          completed += 1
      }
    list = (subscription_id) ->
      Instagram.subscriptions.list {
        complete: (data) ->
          data.should.not.be.empty
          unsubscribe subscription_id
      }
    Instagram.locations.subscribe {
      object_id: '1257285'
      callback_url: CALLBACK_URL
      complete: (data) ->
        data.should.have.property 'id'
        data.id.should.be.above 0
        data.should.have.property 'type', 'subscription'
        list data['id']
    }
  'media#subscriptions subscribe#48.858844300000001/2.2943506, subscriptions, unsubscribe#48.858844300000001/2.2943506#id': ->
    unsubscribe = (subscription_id) ->
      Instagram.media.unsubscribe {
        id: subscription_id
        complete: (data) ->
          assert.isNull data
          completed += 1
      }
    list = (subscription_id) ->
      Instagram.subscriptions.list {
        complete: (data) ->
          data.should.not.be.empty
          unsubscribe subscription_id
      }
    Instagram.media.subscribe {
      lat: 48.858844300000001
      lng: 2.2943506
      radius: 1000
      callback_url: CALLBACK_URL
      complete: (data) ->
        data.should.have.property 'id'
        data.id.should.be.above 0
        data.should.have.property 'type', 'subscription'
        list data['id']
    }

###
Tests Reporting
###

console.log "\n   Instagram API Node.js Lib Tests\n"
for k of module.exports
  to_do += 1
  console.log "   #{k}"

iterations = 0
waiting = setInterval `function(){if(completed==to_do||iterations>to_do){clearInterval(waiting);app.close();}else{iterations+=1;}}`, 1000

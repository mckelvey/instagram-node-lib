
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

completed = 0
to_do = 0
indent = "   "

module.exports =
  'tags#subscriptions': ->
    title = "tags#subscriptions"
    unsubscribe = (subscription_id) ->
      Instagram.tags.unsubscribe {
        id: subscription_id
        complete: (data) ->
          console.log "\n#{title} unsubscribe from #{subscription_id}\n#{indent}connection/parsing succeeded"
          try
            assert.isNull data
            console.log "#{indent}data met assertions"
            completed += 1
          catch e
            console.log "#{indent}data failed to meet the assertion(s): #{e}"
            throw e
        error: (e, data, caller) ->
          console.log "\n#{title} unsubscribe\n#{indent}connection/parsing failed"
          console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
          throw e
      }
    list = (subscription_id) ->
      Instagram.subscriptions.list {
        complete: (data) ->
          console.log "\n#{title} list\n#{indent}connection/parsing succeeded"
          try
            data.should.not.be.empty
            console.log "#{indent}data met assertions"
            unsubscribe subscription_id
          catch e
            console.log "#{indent}data failed to meet the assertion(s): #{e}"
            throw e
        error: (e, data, caller) ->
          console.log "\n#{title} list\n#{indent}connection/parsing failed"
          console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
          throw e
      }
    Instagram.tags.subscribe {
      object_id: 'blue'
      callback_url: CALLBACK_URL
      complete: (data) ->
        console.log "\n#{title} subscribe#blue\n#{indent}connection/parsing succeeded"
        try
          data.should.have.property 'id'
          data.id.should.be.above 0
          data.should.have.property 'type', 'subscription'
          console.log "#{indent}data met assertions"
          list data['id']
        catch e
          console.log "#{indent}data failed to meet the assertion(s): #{e}"
          throw e
      error: (e, data, caller) ->
        console.log "\n#{title} subscribe#blue\n#{indent}connection/parsing failed"
        console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
        throw e
    }
  'locations#subscriptions': ->
    title = "locations#subscriptions"
    unsubscribe = (subscription_id) ->
      Instagram.locations.unsubscribe {
        id: subscription_id
        complete: (data) ->
          console.log "\n#{title} unsubscribe from #{subscription_id}\n#{indent}connection/parsing succeeded"
          try
            assert.isNull data
            console.log "#{indent}data met assertions"
            completed += 1
          catch e
            console.log "#{indent}data failed to meet the assertion(s): #{e}"
            throw e
        error: (e, data, caller) ->
          console.log "\n#{title} unsubscribe\n#{indent}connection/parsing failed"
          console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
          throw e
      }
    list = (subscription_id) ->
      Instagram.subscriptions.list {
        complete: (data) ->
          console.log "\n#{title} list\n#{indent}connection/parsing succeeded"
          try
            data.should.not.be.empty
            console.log "#{indent}data met assertions"
            unsubscribe subscription_id
          catch e
            console.log "#{indent}data failed to meet the assertion(s): #{e}"
            throw e
        error: (e, data, caller) ->
          console.log "\n#{title} list\n#{indent}connection/parsing failed"
          console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
          throw e
      }
    Instagram.locations.subscribe {
      object_id: '1257285'
      callback_url: CALLBACK_URL
      complete: (data) ->
        console.log "\n#{title} subscribe#1257285\n#{indent}connection/parsing succeeded"
        try
          data.should.have.property 'id'
          data.id.should.be.above 0
          data.should.have.property 'type', 'subscription'
          console.log "#{indent}data met assertions"
          list data['id']
        catch e
          console.log "#{indent}data failed to meet the assertion(s): #{e}"
          throw e
      error: (e, data, caller) ->
        console.log "\n#{title} subscribe#1257285\n#{indent}connection/parsing failed"
        console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
        throw e
    }
  'media#subscriptions': ->
    title = "media#subscriptions"
    unsubscribe = (subscription_id) ->
      Instagram.media.unsubscribe {
        id: subscription_id
        complete: (data) ->
          console.log "\n#{title} unsubscribe from #{subscription_id}\n#{indent}connection/parsing succeeded"
          try
            assert.isNull data
            console.log "#{indent}data met assertions"
            completed += 1
          catch e
            console.log "#{indent}data failed to meet the assertion(s): #{e}"
            throw e
        error: (e, data, caller) ->
          console.log "\n#{title} unsubscribe\n#{indent}connection/parsing failed"
          console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
          throw e
      }
    list = (subscription_id) ->
      Instagram.subscriptions.list {
        complete: (data) ->
          console.log "\n#{title} list\n#{indent}connection/parsing succeeded"
          try
            data.should.not.be.empty
            console.log "#{indent}data met assertions"
            unsubscribe subscription_id
          catch e
            console.log "#{indent}data failed to meet the assertion(s): #{e}"
            throw e
        error: (e, data, caller) ->
          console.log "\n#{title} list\n#{indent}connection/parsing failed"
          console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
          throw e
      }
    Instagram.media.subscribe {
      lat: 48.858844300000001
      lng: 2.2943506
      radius: 1000
      callback_url: CALLBACK_URL
      complete: (data) ->
        console.log "\n#{title} subscribe#48.858844300000001/2.2943506\n#{indent}connection/parsing succeeded"
        try
          data.should.have.property 'id'
          data.id.should.be.above 0
          data.should.have.property 'type', 'subscription'
          console.log "#{indent}data met assertions"
          list data['id']
        catch e
          console.log "#{indent}data failed to meet the assertion(s): #{e}"
          throw e
      error: (e, data, caller) ->
        console.log "\n#{title} subscribe#48.858844300000001/2.2943506\n#{indent}connection/parsing failed"
        console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
        throw e
    }
  'subscriptions': ->
    title = "subscriptions"
    unsubscribe = (ids) ->
      Instagram.subscriptions.unsubscribe_all {
        complete: (data) ->
          console.log "\n#{title} unsubscribe_all\n#{indent}connection/parsing succeeded"
          try
            assert.isNull data
            console.log "#{indent}data met assertions"
            completed += 1
          catch e
            console.log "#{indent}data failed to meet the assertion(s): #{e}"
            throw e
        error: (e, data, caller) ->
          console.log "\n#{title} unsubscribe_all\n#{indent}connection/parsing failed"
          console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
          throw e
      }
    list = (ids) ->
      Instagram.subscriptions.list {
        complete: (data) ->
          console.log "\n#{title} list\n#{indent}connection/parsing succeeded"
          try
            data.length.should.equal 2
            console.log "#{indent}data met assertions"
            unsubscribe ids
          catch e
            console.log "#{indent}data failed to meet the assertion(s): #{e}"
            throw e
        error: (e, data, caller) ->
          console.log "\n#{title} list\n#{indent}connection/parsing failed"
          console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
          throw e
      }
    subscribe_again = (ids) ->
      Instagram.subscriptions.subscribe {
        object: 'tag'
        object_id: 'green'
        complete: (data) ->
          console.log "\n#{title} subscribe#green\n#{indent}connection/parsing succeeded"
          try
            data.should.have.property 'id'
            data.id.should.be.above 0
            data.should.have.property 'type', 'subscription'
            console.log "#{indent}data met assertions"
            ids[ids.length] = data['id']
            list ids
          catch e
            console.log "#{indent}data failed to meet the assertion(s): #{e}"
            throw e
        error: (e, data, caller) ->
          console.log "\n#{title} subscribe#green\n#{indent}connection/parsing failed"
          console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
          throw e
      }
    Instagram.subscriptions.subscribe {
      object: 'tag'
      object_id: 'red'
      complete: (data) ->
        console.log "\n#{title} subscribe#red\n#{indent}connection/parsing succeeded"
        try
          data.should.have.property 'id'
          data.id.should.be.above 0
          data.should.have.property 'type', 'subscription'
          console.log "#{indent}data met assertions"
          subscribe_again [data['id']]
        catch e
          console.log "#{indent}data failed to meet the assertion(s): #{e}"
          throw e
      error: (e, data, caller) ->
        console.log "\n#{title} subscribe#red\n#{indent}connection/parsing failed"
        console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
        throw e
    }

###
App Termination
###

for i of module.exports
  to_do += 1

iterations = 0
waiting = setInterval `function(){if(completed==to_do||iterations>to_do){clearInterval(waiting);app.close();}else{iterations+=1;}}`, 1000

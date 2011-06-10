
###
Initialize Instagram
###

Instagram = require '../lib/class.instagram'

###
Setup App for Subscription Callbacks
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

app.get '/oauth',
  (request, response) ->
    Instagram.oauth.ask_for_access_token {
      request: request,
      response: response,
      respond: (response) ->
        response.redirect('/oauth/success')
        response.end()
    }

app.get '/oauth/success',
  (request, response) ->
    response.writeHead 200, {'Content-Type': 'text/plain'}
    response.end('Successful\n')

app.listen PORT

###
Add-on App Test Monitoring
###

app._tests_to_do = 0
app._tests_completed = 0
app._max_execution_time = 10

app.start_tests = (tests) ->
  for i of tests
    app._tests_to_do += 1
  iterations = 0
  monitor = setInterval `function(){if(app.fd==null){clearInterval(monitor);}else if((app._tests_completed==app._tests_to_do&&app._tests_completed!=0)||iterations>app._max_execution_time){clearInterval(monitor);app.close();}else{iterations+=1;}}`, 1000

app.finish_test = ->
  app._tests_completed += 1

###
Exports
###

module.exports = 
  host: HOST
  port: PORT
  app: app
  Instagram: Instagram

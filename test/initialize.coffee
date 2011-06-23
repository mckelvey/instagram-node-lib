
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

app.get '/fake/oauth/authorize',
  (request, response) ->
    params = url.parse(request.url, true).query
    response.writeHead 302, {'Location': "#{params.redirect_uri}?code=some-test-code"}
    response.end()

app.post '/fake/oauth/access_token',
  (request, response) ->
    querystring = require 'querystring'
    util = require 'util'
    should = require 'should'
    fake_response =
      access_token: 'fb2e77d.47a0479900504cb3ab4a1f626d174d2d'
      user:
        id: 1574083
        username: 'snoopdogg'
        full_name: 'Snoop Dogg'
        profile_picture: 'http://distillery.s3.amazonaws.com/profiles/profile_1574083_75sq_1295469061.jpg'
    data = ''
    request.on 'data', (chunk) ->
    	data += chunk
    request.on 'end', ->
      parsed = querystring.parse data
      parsed.should.have.property 'client_id'
      parsed.client_id.should.have.property 'length', 32
      parsed.should.have.property 'client_secret'
      parsed.client_secret.should.have.property 'length', 32
      parsed.should.have.property 'grant_type', 'authorization_code'
      parsed.should.have.property 'redirect_uri', Instagram._config.redirect_uri
      parsed.should.have.property 'code', 'some-test-code'
      console.log "   access_token request data met assertions at /fake/oauth/access_token"
      response.writeHead 200, {'Content-Type': 'application/json'}
      response.end(JSON.stringify(fake_response))

app.get '/oauth',
  (request, response) ->
    Instagram.oauth.ask_for_access_token {
      request: request,
      response: response,
      complete: (access, response) ->
        access.should.have.property 'access_token', 'fb2e77d.47a0479900504cb3ab4a1f626d174d2d'
        console.log "   the fake access token was received", JSON.stringify(access)
        response.writeHead 200, {'Content-Type': 'text/plain'}
        response.end('Successful End-Of-Chain\n')
      error: (e, data, caller, response) ->
        Instagram._error e, data, caller
        response.writeHead 406, {'Content-Type': 'text/plain'}
        response.end('Failure End-Of-Chain\n')
    }
    return null

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

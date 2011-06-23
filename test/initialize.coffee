
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
      meta:
        code: 200
      data:
        access_token: 'fb2e77d.47a0479900504cb3ab4a1f626d174d2d'
        user:
          id: 1574083
          username: 'snoopdogg'
          full_name: 'Snoop Dogg'
          profile_picture: 'http://distillery.s3.amazonaws.com/profiles/profile_1574083_75sq_1295469061.jpg'
      pagination: {}
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
    parsed_query = url.parse(request.url, true).query
    if parsed_query.error?
      @parent._error "#{parsed_query.error}: #{parsed_query.error_reason}: #{parsed_query.error_description}", parsed_query, 'handshake'
    else if parsed_query.code?
      post_data:
        client_id: Instagram._config.client_id
        client_secret: Instagram._config.client_secret
        grant_type: 'authorization_code'
        redirect_uri: Instagram._config.redirect_uri
        code: parsed_query.code
      options = Instagram._clone(Instagram._options)
      options['host'] = if process.env['TEST_HOST']? then process.env['TEST_HOST'] else Instagram._options['host']
      options['port'] = if process.env['TEST_PORT']? then process.env['TEST_PORT'] else Instagram._options['port']
      options['method'] = "POST"
      options['path'] = if process.env['TEST_HOST']? then "/fake/oauth/access_token" else "/oauth/access_token"
      post_data = Instagram._to_querystring post_data
      options['headers']['Content-Length'] = post_data.length
      complete = (access, appResponse) ->
        console.log access
        console.log appResponse
        appResponse.writeHead 200, {'Content-Type': 'text/plain'}
        appResponse.end('Successful End-Of-Chain\n')
      error = Instagram._error
      http_client = require 'http'
      token_request = http_client.request options, (token_response) ->
        data = ''
        response.setEncoding 'utf8'
        response.on 'data', (chunk) ->
        	data += chunk
        response.on 'end', ->
          console.log "HERE"
          try
            parsedResponse = JSON.parse data
            if parsedResponse? and parsedResponse['meta']? and parsedResponse['meta']['code'] isnt 200
              error parsedResponse['meta']['error_type'], parsedResponse['meta']['error_message'], "_request"
            else if parsedResponse['access_token']?
              complete parsedResponse, response
            else
              pagination = if typeof parsedResponse['pagination'] is 'undefined' then {} else parsedResponse['pagination']
              complete parsedResponse['data'], pagination
          catch e
            error e, data, '_request'
      if post_data?
        token_request.write post_data
      token_request.addListener 'error', (connectionException) ->
        if connectionException.code isnt 'ENOTCONN'
          console.log "\n" + connectionException
          throw connectionException
      token_request.end()

    ###
    Instagram.oauth.ask_for_access_token {
      request: request,
      response: response,
      complete: (access, appResponse) ->
        console.log access
        console.log appResponse
        appResponse.writeHead 200, {'Content-Type': 'text/plain'}
        appResponse.end('Successful End-Of-Chain\n')
    }
    fake_response =
      meta:
        code: 200
      data:
        access_token: 'fb2e77d.47a0479900504cb3ab4a1f626d174d2d'
        user:
          id: 1574083
          username: 'snoopdogg'
          full_name: 'Snoop Dogg'
          profile_picture: 'http://distillery.s3.amazonaws.com/profiles/profile_1574083_75sq_1295469061.jpg'
      pagination: {}
    response.writeHead 200, {'Content-Type': 'application/json'}
    response.end(JSON.stringify(fake_response))
    ###

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

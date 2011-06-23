
###
Test Setup
###

console.log "\nInstagram API Node.js Lib Tests :: OAuth"

Init = require './initialize'
Instagram = Init.Instagram
app = Init.app

assert = require 'assert'
should = require 'should'
test = require './helpers'
http_client = require 'http'
http_client.Agent.defaultMaxSockets = 10
url = require 'url'

completed = 0
to_do = 0

###
Tests
###

module.exports =
  'oauth#authorization_url': ->
    console.log "\noauth#authorization_url"
    result = Instagram.oauth.authorization_url {
      scope: 'comments likes'
      display: 'touch'
    }
    result.should.match(/\/oauth\/authorize\//)
    result.should.match(/client_id\=/)
    result.should.match(/redirect_uri\=/)
    result.should.match(/response_type\=code/)
    result.should.not.match(/client_id\=CLIENT\-ID/)
    result.should.not.match(/redirect_uri\=REDIRECT_URI/)
    test.output "result matched authorization url", result
    result = url.parse result
    options =
      host: if process.env['TEST_HOST']? then process.env['TEST_HOST'] else result.hostname
      port: if process.env['TEST_PORT']? then process.env['TEST_PORT'] else result.port
      method: "GET"
      path: "/fake#{result['pathname']}#{result['search']}"
    request = http_client.request options, (response) ->
      response.should.have.property 'statusCode', 302
      response.should.have.property 'headers'
      response.headers.should.have.property 'location'
      test.output "response met redirect criteria", response.headers.location
      token_uri = url.parse response.headers.location
      options =
        host: token_uri['hostname']
        port: if typeof token_uri['port'] isnt 'undefined' then token_uri['port'] else null
        method: "GET"
        path: "#{token_uri['pathname']}#{token_uri['search']}"
      token_request = http_client.request options, (token_response) ->
        data = ''
        token_response.on 'data', (chunk) ->
        	data += chunk
        token_response.on 'end', ->
          test.output "final receipt", data
          ###
          parsedResponse = JSON.parse data
          parsedResponse.should.have.property 'meta'
          parsedResponse.meta.should.have.property 'code', 200
          parsedResponse.should.have.property 'data'
          parsedResponse.data.should.have.property 'access_token', 'fb2e77d.47a0479900504cb3ab4a1f626d174d2d'
          test.output "the fake access token was received", parsedResponse
          ###
          app.finish_test()
      token_request.addListener 'error', (connectionException) ->
        if connectionException.code isnt 'ENOTCONN'
          console.log "\n" + connectionException
          throw connectionException
          app.finish_test()
      token_request.end()
    request.addListener 'error', (connectionException) ->
      if connectionException.code isnt 'ENOTCONN'
        console.log "\n" + connectionException
        throw connectionException
        app.finish_test()
    request.end()

app.start_tests module.exports

###
  'oauth#access_token#fake': ->
    console.log "\noauth#access_token#fake"
    fake_uri = url.parse 'http://filtr.in:3000/fake/oauth/access_token'
    post_data =
      client_id: Instagram._config.client_id
      client_secret: Instagram._config.client_secret
      grant_type: 'authorization_code'
      redirect_uri: Instagram._config.redirect_uri
      code: 'some-test-code'
    options =
      host: fake_uri['hostname']
      port: if typeof fake_uri['port'] isnt 'undefined' then fake_uri['port'] else null
      method: "POST"
      path: "#{fake_uri['pathname']}"
    request = http_client.request options, (response) ->
      data = ''
      response.on 'data', (chunk) ->
      	data += chunk
      response.on 'end', ->
        parsedResponse = JSON.parse data
        parsedResponse.should.have.property 'meta'
        parsedResponse.meta.should.have.property 'code', 200
        parsedResponse.should.have.property 'data'
        parsedResponse.data.should.have.property 'access_token', 'fb2e77d.47a0479900504cb3ab4a1f626d174d2d'
        test.output "the fake access token was received", parsedResponse
        app.finish_test()
    request.write Instagram._to_querystring post_data
    request.addListener 'error', (connectionException) ->
      if connectionException.code isnt 'ENOTCONN'
        console.log "\n" + connectionException
        throw connectionException
    request.end()
###

###
app.get '/fake/oauth/authorize',
  (request, response) ->
    params = url.parse(request.url, true).query
    redirect_uri = url.parse params.redirect_uri
    http_client = require 'http'
    options =
      host: redirect_uri['hostname']
      port: if typeof redirect_uri['port'] isnt 'undefined' then redirect_uri['port'] else null
      method: "GET"
      path: "#{redirect_uri['pathname']}?code=some-test-code"
    testRequest = http_client.request options, (testResponse) ->
      data = ''
      testResponse.on 'data', (chunk) ->
      	data += chunk
      testResponse.on 'end', ->
        console.log "oauth response"
        console.log data
    testRequest.addListener 'error', (connectionException) ->
      if connectionException.code isnt 'ENOTCONN'
        console.log "\n" + connectionException
        throw connectionException
    testRequest.end()
    response.writeHead 200, {'Content-Type': 'text/plain'}
    response.end(' ')
###


###
  'oauth#fake#roundtrip': ->
    console.log "\nooauth#fake#roundtrip"
    result = Instagram.oauth.authorization_url {
      scope: 'comments likes'
      display: 'touch'
    }
    fake_uri = url.parse result
    options =
      host: fake_uri['hostname']
      port: if typeof fake_uri['port'] isnt 'undefined' then fake_uri['port'] else null
      method: "GET"
      path: "#{fake_uri['pathname']}#{fake_uri['search']}"
    request = http_client.request options, (response) ->
      data = ''
      response.on 'data', (chunk) ->
      	data += chunk
      response.on 'end', ->
        test.output "response", data
        app.finish_test()
    request.addListener 'error', (connectionException) ->
      if connectionException.code isnt 'ENOTCONN'
        console.log "\n" + connectionException
        throw connectionException
    request.end()


  'oauth#authorization_url#fake': ->
    console.log "\noauth#authorization_url#fake"
    result = Instagram.oauth.authorization_url {
      scope: 'comments likes'
      display: 'touch'
    }
    result = result.replace(/^https:\/\/api\.instagram\.com/, 'http://filtr.in:3000/fake')
    test.output "fake_uri", result
    http_client = require 'http'
    url = require 'url'
    fake_uri = url.parse result
    options =
      host: fake_uri['hostname']
      port: if typeof fake_uri['port'] isnt 'undefined' then fake_uri['port'] else null
      method: "GET"
      path: "#{fake_uri['pathname']}#{fake_uri['search']}"
    request = http_client.request options, (response) ->
      data = ''
      response.on 'data', (chunk) ->
      	data += chunk
      response.on 'end', ->
        test.output "response", data
        app.finish_test()
    request.addListener 'error', (connectionException) ->
      if connectionException.code isnt 'ENOTCONN'
        console.log "\n" + connectionException
        throw connectionException
    request.end()


  'oauth#ask_for_access_token': ->
    console.log "\noauth#ask_for_access_token"
    http_client = require 'http'
    url = require 'url'
    redirect_uri = url.parse Instagram._config.redirect_uri
    options =
      host: redirect_uri['hostname']
      port: if typeof redirect_uri['port'] isnt 'undefined' then redirect_uri['port'] else null
      method: "GET"
      path: "#{redirect_uri['pathname']}?code=test-code"
    test.output "testing #{Instagram._config.redirect_uri}"
    request = http_client.request options, (response) ->
      data = ''
      response.on 'data', (chunk) ->
      	data += chunk
      response.on 'end', ->
        test.output "result", data
        app.finish_test()
    request.addListener 'error', (connectionException) ->
      if connectionException.code isnt 'ENOTCONN'
        console.log "\n" + connectionException
        throw connectionException
    request.end()
###
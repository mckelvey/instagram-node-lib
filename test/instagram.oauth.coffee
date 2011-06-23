
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
url = require 'url'

completed = 0
to_do = 0

###
Tests
###

module.exports =
  'oauth#roundtrip': ->
    console.log "\noauth#roundtrip"
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
      token_options =
        host: token_uri['hostname']
        port: if typeof token_uri['port'] isnt 'undefined' then token_uri['port'] else null
        method: "GET"
        path: "#{token_uri['pathname']}#{token_uri['search']}"
      token_request = http_client.request token_options, (token_response) ->
        data = ''
        token_response.on 'data', (chunk) ->
        	data += chunk
        token_response.on 'end', ->
          test.output "final receipt", data
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

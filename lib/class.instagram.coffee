
querystring = require 'querystring'

class InstagramAPI
  constructor: ->
    @_api_version = 'v1'
    @_client = require 'https'
    @_config =
      client_id: if process.env['CLIENT_ID']? then process.env['CLIENT_ID'] else 'CLIENT-ID'
      client_secret: if process.env['CLIENT_SECRET']? then process.env['CLIENT_SECRET'] else 'CLIENT-SECRET'
      callback_url: if process.env['CALLBACK_URL']? then process.env['CALLBACK_URL'] else ''
    @_options =
      host: 'api.instagram.com'
      port: null
      method: "GET"
      path: ''
      headers: {
        'User-Agent': 'Instagram JS Lib 0.0.1'
        'Accept': 'application/json'
        'Content-Length': 0
      }
    for module in ['media', 'tags', 'users', 'locations', 'subscriptions']
      moduleClass = require "./class.instagram.#{module}"
      @[module] = new moduleClass.module @

  ###
  Generic Response Methods
  ###

  _error: (e, value, caller) ->
    value = '[undefined]' if value is undefined
    value = '[null]' if value is null
    message = "#{e} occurred: #{value} in #{caller}"
    console.log(message)
    message

  _complete: (data) ->
    for i of data
      console.log data[i].id

  ###
  Shared Data Manipulation Methods
  ###

  _to_querystring: (params) ->
    obj = {}
    for i of params
      obj[i] = params[i] if i isnt 'complete' and i isnt 'error'
    querystring.stringify obj

  _merge: (obj1, obj2) ->
    for i of obj2
      obj1[i] = obj2[i]
    obj1

  _to_value: (key, value) ->
    return value if typeof value isnt 'object'
    return value[key] if value[key]?
    null

  _to_object: (key, value) ->
    return value if typeof value is 'object' and value[key]?
    obj = {}
    obj[key] = value

  _clone: (from_object) ->
    to_object = {}
    for property of from_object
      to_object[property] = from_object[property]
    to_object

  ###
  Generic Methods
  ###

  set: (property, value) ->
    @_config[property] = value if @_config[property] isnt undefined
    @_options[property] = value if @_options[property] isnt undefined

  ###
  Shared Request Methods
  ###

  _request: (params) ->
    options = @_clone(@_options)
    options['path'] = params['path'] if params['path']?
    options['method'] = params['method'] if params['method']?
    complete = params['complete'] ?= @_complete
    error = params['error'] ?= @_error
    if options['method'] isnt "GET" and params['post_data']?
      post_data = @_to_querystring params['post_data']
    else
      post_data = ''
    options['headers']['Content-Length'] = post_data.length
    request = @_client.request options, (response) ->
      data = ''
      response.setEncoding 'utf8'
      response.on 'data', (chunk) ->
      	data += chunk
      response.on 'end', ->
        try
          parsedResponse = JSON.parse data
        catch e
          error e, data, '_request'
        error parsedResponse['meta']['error_type'], parsedResponse['meta']['error_message'], "_request" if parsedResponse? and parsedResponse['meta']? and parsedResponse['meta']['code'] isnt 200
        complete parsedResponse['data']
    if post_data?
      request.write post_data
    request.end()

APIClient = new InstagramAPI
module.exports = APIClient


querystring = require 'querystring'

class InstagramAPI
  constructor: ->
    @_api_version = 'v1'
    @_client = require 'https'
    @_config =
      client_id: if process.env['CLIENT_ID']? then process.env['CLIENT_ID'] else 'CLIENT-ID'
      client_secret: if process.env['CLIENT_SECRET']? then process.env['CLIENT_SECRET'] else 'CLIENT-SECRET'
      callback_url: if process.env['CALLBACK_URL']? then process.env['CALLBACK_URL'] else 'CALLBACK-URL'
      redirect_uri: if process.env['REDIRECT_URI']? then process.env['REDIRECT_URI'] else 'REDIRECT_URI'
      access_token: if process.env['ACCESS_TOKEN']? then process.env['ACCESS_TOKEN'] else null
    @_options =
      host: 'api.instagram.com'
      port: null
      method: "GET"
      path: ''
      headers: {
        'User-Agent': 'Instagram Node Lib 0.0.5'
        'Accept': 'application/json'
        'Content-Length': 0
      }
    for module in ['media', 'tags', 'users', 'locations', 'geographies', 'subscriptions', 'oauth']
      moduleClass = require "./class.instagram.#{module}"
      @[module] = new moduleClass @

  ###
  Generic Response Methods
  ###

  _error: (e, value, caller) ->
    value = '[undefined]' if value is undefined
    value = '[null]' if value is null
    message = "#{e} occurred: #{value} in #{caller}"
    console.log(message)
    message

  _complete: (data, pagination) ->
    for i of data
      console.log data[i]
    console.log pagination if pagination?

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

  _credentials: (params, require = null) ->
    if require? and params[require]? or params['access_token']? or params['client_id']?
      return params
    if require isnt null and @_config[require]?
      params[require] = @_config[require]
    else if @_config['access_token']?
      params['access_token'] = @_config['access_token']
    else if @_config['client_id']?
      params['client_id'] = @_config['client_id']
    return params

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
          if parsedResponse? and parsedResponse['meta']? and parsedResponse['meta']['code'] isnt 200
            error parsedResponse['meta']['error_type'], parsedResponse['meta']['error_message'], "_request"
          else if parsedResponse['access_token']?
            complete parsedResponse
          else
            pagination = if typeof parsedResponse['pagination'] is 'undefined' then {} else parsedResponse['pagination']
            complete parsedResponse['data'], pagination
        catch e
          error e, data, '_request'
    if post_data?
      request.write post_data
    request.addListener 'error', (connectionException) ->
      if connectionException.code isnt 'ENOTCONN'
        console.log "\n" + connectionException
        throw connectionException
    request.end()

APIClient = new InstagramAPI
module.exports = APIClient

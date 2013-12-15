
url = require 'url'
crypto = require 'crypto'

class InstagramSubscriptions
  constructor: (parent) ->
    @parent = parent

  ###
  Verification Methods
  ###

  handshake: (request, response, complete) ->
    parsedRequest = url.parse(request.url, true)
    if parsedRequest['query']['hub.mode'] is 'subscribe' and parsedRequest['query']['hub.challenge']? and parsedRequest['query']['hub.challenge'].length > 0
      body = parsedRequest['query']['hub.challenge']
      headers =
        'Content-Length': body.length
        'Content-Type': 'text/plain'
      response.writeHead 200, headers
      response.write body
      complete(parsedRequest['query']['hub.verify_token']) if parsedRequest['query']['hub.verify_token']? and complete?
    else
      response.writeHead 400
    response.end()

  verified: (request) ->
    return false if request.rawBody is null or request.headers['x-hub-signature'] is undefined or request.headers['x-hub-signature'] is null
    hmac = crypto.createHmac 'sha1', @parent._config.client_secret
    hmac.update request.rawBody
    calculated_signature = hmac.digest(encoding='hex')
    return false if calculated_signature isnt request.headers['x-hub-signature']
    true

  ###
  Shared Subscription Methods
  ###

  _subscribe: (params) ->
    params['method'] = "POST"
    params['path'] = "/#{@parent._api_version}/subscriptions/"
    if (typeof params['callback_url'] is 'undefined' or params['callback_url'] is null) and @parent._config.callback_url isnt null
      params['callback_url'] = @parent._config.callback_url
    params['post_data'] =
      object: params['object']
      aspect: 'media'
      client_id: @parent._config.client_id
      client_secret: @parent._config.client_secret
      callback_url: params['callback_url']
    for i in ['object_id', 'verify_token', 'lat', 'lng', 'radius']
      params['post_data'][i] = params[i] if params[i]?
    @parent._request params

  _unsubscribe: (params) ->
    params['method'] = "DELETE"
    params['path'] = "/#{@parent._api_version}/subscriptions/"
    if params['id']?
      params['path'] += "?id=#{params['id']}"
    else
      params['path'] += "?object=#{params['object']}"
    params['path'] += "&client_secret=#{@parent._config.client_secret}&client_id=#{@parent._config.client_id}"
    @parent._request params

  ###
  Shared Public Methods
  ###

  subscribe: (params) ->
    @_subscribe params

  list: (params) ->
    params = @parent._clone(params)
    params['path'] = "/#{@parent._api_version}/subscriptions?client_secret=#{@parent._config.client_secret}&client_id=#{@parent._config.client_id}"
    @parent._request params

  unsubscribe: (params) ->
    @_unsubscribe params

  unsubscribe_all: (params) ->
    params['object'] = 'all' if params['object'] is undefined or not params['object']?
    @_unsubscribe params

module.exports = InstagramSubscriptions

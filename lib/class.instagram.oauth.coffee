
url = require 'url'

class InstagramOAuth
  constructor: (parent) ->
    @parent = parent

  ask_for_authorization: (params) ->
    params['client_id'] = @parent._config.client_id
    params['redirect_uri'] = if params['redirect_uri'] is undefined or params['redirect_uri'] is null then @parent._config.redirect_uri else params['redirect_uri']
    params['path'] = "/oauth/authorize/?#{@parent._to_querystring(params)}"
    @parent._request params

  ask_for_access_token: (params) ->
    params['method'] = "POST"
    params['post_data'] =
      client_id: @parent._config.client_id
      client_secret: @parent._config.client_secret
      grant_type: 'authorization_code'
      redirect_uri: if params['redirect_uri'] is undefined or params['redirect_uri'] is null then @parent._config.redirect_uri else params['redirect_uri']
      code: params['code']
    params['path'] = "/oauth/access_token"
    @parent._request params

  handshake: (request, response, complete) ->
    parsedRequest = url.parse(request.url, true)
    if parsedRequest['query']['error']?
      @parent._error "#{parsedRequest['query']['error']}: #{parsedRequest['query']['error_reason']}: #{parsedRequest['query']['error_description']}", parsedRequest['query'], 'handshake'
    else if parsedRequest['query']['code']?
      response.writeHead 200, { 'Content-Length': 0, 'Content-Type': 'text/plain' }
      response.end()

module.exports = InstagramOAuth

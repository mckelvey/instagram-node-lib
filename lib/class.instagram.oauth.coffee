
url = require 'url'

class InstagramOAuth
  constructor: (parent) ->
    @parent = parent

  authorization_url: (params) ->
    params['client_id'] = @parent._config.client_id
    params['redirect_uri'] = if params['redirect_uri'] is undefined or params['redirect_uri'] is null then @parent._config.redirect_uri else params['redirect_uri']
    params['response_type'] = 'code'
    return "https://#{@parent._options['host']}/oauth/authorize/?#{@parent._to_querystring(params)}"

  ask_for_access_token: (params) ->
    parsedUrl = url.parse(params['request'].url, true)
    console.log parsedUrl
    if parsedUrl['query']['error']?
      @parent._error "#{parsedUrl['query']['error']}: #{parsedUrl['query']['error_reason']}: #{parsedUrl['query']['error_description']}", parsedUrl['query'], 'handshake'
    else if parsedUrl['query']['code']?
      token_params =
        complete: params['complete']
        method: "POST"
        path: "/oauth/access_token"
        post_data:
          client_id: @parent._config.client_id
          client_secret: @parent._config.client_secret
          grant_type: 'authorization_code'
          redirect_uri: if params['redirect_uri'] is undefined or params['redirect_uri'] is null then @parent._config.redirect_uri else params['redirect_uri']
          code: parsedUrl['query']['code']
      @parent._request token_params
      if params['redirect']?
        params['response'].redirect(params['redirect']);
      params['response'].end()

module.exports = InstagramOAuth


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
    parsed_query = url.parse(params['request'].url, true).query
    if parsed_query.error?
      @parent._error "#{parsed_query.error}: #{parsed_query.error_reason}: #{parsed_query.error_description}", parsed_query, 'handshake'
    else if parsed_query.code?
      console.log "SURPRISE"
      token_params =
        complete: params['complete']
        response: params['response']
        host: if process.env['TEST_HOST']? then process.env['TEST_HOST'] else @parent._options['host']
        port: if process.env['TEST_PORT']? then process.env['TEST_PORT'] else @parent._options['port']
        method: "POST"
        path: if process.env['TEST_HOST']? then "/fake/oauth/access_token" else "/oauth/access_token"
        post_data:
          client_id: @parent._config.client_id
          client_secret: @parent._config.client_secret
          grant_type: 'authorization_code'
          redirect_uri: if params['redirect_uri'] is undefined or params['redirect_uri'] is null then @parent._config.redirect_uri else params['redirect_uri']
          code: parsed_query.code
      @parent._request token_params
      if params['redirect']?
        params['response'].redirect(params['redirect']);
        params['response'].end()

module.exports = InstagramOAuth

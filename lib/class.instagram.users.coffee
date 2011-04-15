
class InstagramUsers
  constructor: (parent) ->
    @parent = parent

  info: (params) ->
    credentials = @parent._credentials {}
    params['path'] = "/#{@parent._api_version}/users/#{params['user_id']}?#{@parent._to_querystring(credentials)}"
    @parent._request params

  self: (params) ->
    params = @parent._credentials params, 'access_token'
    params['path'] = "/#{@parent._api_version}/users/self/feed?#{@parent._to_querystring(params)}"
    @parent._request params

  recent: (params) ->
    params = @parent._credentials params, 'access_token'
    params['path'] = "/#{@parent._api_version}/users/#{params['user_id']}/media/recent?#{@parent._to_querystring(params)}"
    @parent._request params

  search: (params) ->
    params = @parent._credentials params
    params['path'] = "/#{@parent._api_version}/users/search?#{@parent._to_querystring(params)}"
    @parent._request params

module.exports = InstagramUsers

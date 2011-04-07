
class InstagramUsers
  constructor: (parent) ->
    @parent = parent

  info: (params) ->
    params['path'] = "/#{@parent._api_version}/users/#{params['user_id']}?client_id=#{@parent._config.client_id}"
    @parent._request params

  search: (params) ->
    params['client_id'] = @parent._config.client_id
    params['path'] = "/#{@parent._api_version}/users/search?#{@parent._to_querystring(params)}"
    @parent._request params

exports.module = InstagramUsers

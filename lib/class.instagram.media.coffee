
class InstagramMedia
  constructor: (parent) ->
    @parent = parent

  popular: (params) ->
    params['path'] = "/#{@parent._api_version}/media/popular?client_id=#{@parent._config.client_id}"
    @parent._request params

  info: (params) ->
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}?client_id=#{@parent._config.client_id}"
    @parent._request params

  search: (params) ->
    params['client_id'] = @parent._config.client_id
    params['path'] = "/#{@parent._api_version}/media/search?#{@parent._to_querystring(params)}"
    @parent._request params

  likes: (params) ->
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}/likes?client_id=#{@parent._config.client_id}"
    @parent._request params

  comments: (params) ->
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}/comments?client_id=#{@parent._config.client_id}"
    @parent._request params

  subscribe: (params) ->
    params['object'] = 'geography'
    @parent.subscriptions._subscribe params

  unsubscribe: (params) ->
    @parent.subscriptions._unsubscribe params

  unsubscribe_all: (params) ->
    params['object'] = 'geography'
    @parent.subscriptions._unsubscribe params

exports.module = InstagramMedia

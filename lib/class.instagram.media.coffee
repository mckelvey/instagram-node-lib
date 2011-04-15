
class InstagramMedia
  constructor: (parent) ->
    @parent = parent

  popular: (params) ->
    credentials = @parent._credentials {}
    params['path'] = "/#{@parent._api_version}/media/popular?#{@parent._to_querystring(credentials)}"
    @parent._request params

  info: (params) ->
    credentials = @parent._credentials {}
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}?#{@parent._to_querystring(credentials)}"
    @parent._request params

  search: (params) ->
    params = @parent._credentials params
    params['path'] = "/#{@parent._api_version}/media/search?#{@parent._to_querystring(params)}"
    @parent._request params

  likes: (params) ->
    credentials = @parent._credentials {}
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}/likes?#{@parent._to_querystring(credentials)}"
    @parent._request params

  comments: (params) ->
    credentials = @parent._credentials {}
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}/comments?#{@parent._to_querystring(credentials)}"
    @parent._request params

  subscribe: (params) ->
    params['object'] = 'geography'
    @parent.subscriptions._subscribe params

  unsubscribe: (params) ->
    @parent.subscriptions._unsubscribe params

  unsubscribe_all: (params) ->
    params['object'] = 'geography'
    @parent.subscriptions._unsubscribe params

module.exports = InstagramMedia

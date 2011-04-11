
class InstagramTags
  constructor: (parent) ->
    @parent = parent

  info: (params) ->
    params['path'] = "/#{@parent._api_version}/tags/#{params['name']}?client_id=#{@parent._config.client_id}"
    @parent._request params

  recent: (params) ->
    params['client_id'] = @parent._config.client_id
    params['path'] = "/#{@parent._api_version}/tags/#{params['name']}/media/recent?#{@parent._to_querystring(params)}"
    @parent._request params

  search: (params) ->
    params['client_id'] = @parent._config.client_id
    params['path'] = "/#{@parent._api_version}/tags/search?#{@parent._to_querystring(params)}"
    @parent._request params

  subscribe: (params) ->
    params['object'] = 'tag'
    @parent.subscriptions._subscribe params

  unsubscribe: (params) ->
    @parent.subscriptions._unsubscribe params

  unsubscribe_all: (params) ->
    params['object'] = 'tag'
    @parent.subscriptions._unsubscribe params

module.exports = InstagramTags


class InstagramLocations
  constructor: (parent) ->
    @parent = parent

  info: (params) ->
    params['path'] = "/#{@parent._api_version}/locations/#{params['location_id']}?client_id=#{@parent._config.client_id}"
    @parent._request params

  recent: (params) ->
    params['client_id'] = @parent._config.client_id
    params['path'] = "/#{@parent._api_version}/locations/#{params['location_id']}/media/recent?#{@parent._to_querystring(params)}"
    @parent._request params

  search: (params) ->
    params['client_id'] = @parent._config.client_id
    params['path'] = "/#{@parent._api_version}/locations/search?#{@parent._to_querystring(params)}"
    @parent._request params

  subscribe: (params) ->
    params['object'] = 'location'
    @parent.subscriptions._subscribe params

  unsubscribe: (params) ->
    @parent.subscriptions._unsubscribe params

  unsubscribe_all: (params) ->
    params['object'] = 'location'
    @parent.subscriptions._unsubscribe params

module.exports = InstagramLocations

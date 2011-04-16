
class InstagramLocations
  constructor: (parent) ->
    @parent = parent

  info: (params) ->
    credentials = @parent._credentials {}
    params['path'] = "/#{@parent._api_version}/locations/#{params['location_id']}?#{@parent._to_querystring(credentials)}"
    @parent._request params

  recent: (params) ->
    params = @parent._credentials params
    params['path'] = "/#{@parent._api_version}/locations/#{params['location_id']}/media/recent?#{@parent._to_querystring(params)}"
    @parent._request params

  search: (params) ->
    params = @parent._credentials params
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

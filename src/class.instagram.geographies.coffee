
###
Geographies
###

class InstagramGeographies
  constructor: (parent) ->
    @parent = parent

  recent: (params) ->
    params['client_id'] = @parent._config.client_id
    params['path'] = "/#{@parent._api_version}/geographies/#{params['geography_id']}/media/recent?#{@parent._to_querystring(params)}"
    @parent._request params

  ###
  Subscriptions
  ###

  subscribe: (params) ->
    params['object'] = 'geography'
    @parent.subscriptions._subscribe params

  unsubscribe: (params) ->
    @parent.subscriptions._unsubscribe params

  unsubscribe_all: (params) ->
    params['object'] = 'geography'
    @parent.subscriptions._unsubscribe params

module.exports = InstagramGeographies

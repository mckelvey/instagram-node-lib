
###
Geographies Do Not Yet Work
###

class InstagramGeographies
  constructor: (parent) ->
    @parent = parent

  recent: (params) ->
    params['client_id'] = @parent._config.client_id
    params['path'] = "/#{@parent._api_version}/geographies/#{params['geography_id']}/media/recent?#{@parent._to_querystring(params)}"
    @parent._request params

module.exports = InstagramGeographies

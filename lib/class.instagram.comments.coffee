
class InstagramComments
  constructor: (parent) ->
    @parent = parent

  comments: (params) ->
    credentials = @parent._credentials {}
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}/comments?#{@parent._to_querystring(credentials)}"
    @parent._request params

module.exports = InstagramComments

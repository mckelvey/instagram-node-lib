
class InstagramLikes
  constructor: (parent) ->
    @parent = parent

  likes: (params) ->
    credentials = @parent._credentials {}
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}/likes?#{@parent._to_querystring(params)}"
    @parent._request params

module.exports = InstagramLikes

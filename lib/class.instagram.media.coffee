
class InstagramMedia
  constructor: (parent) ->
    @parent = parent

  ###
  Basic Media
  ###

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

  ###
  Likes
  ###

  likes: (params) ->
    credentials = @parent._credentials {}
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}/likes?#{@parent._to_querystring(credentials)}"
    @parent._request params

  like: (params) ->
    params['post_data'] = @parent._credentials {}, 'access_token'
    params['method'] = 'POST'
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}/likes"
    @parent._request params

  unlike: (params) ->
    params = @parent._credentials params, 'access_token'
    params['method'] = 'DELETE'
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}/likes?#{@parent._to_querystring(params)}"
    @parent._request params

  ###
  Comments
  ###

  comments: (params) ->
    credentials = @parent._credentials {}
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}/comments?#{@parent._to_querystring(credentials)}"
    @parent._request params

  comment: (params) ->
    params['post_data'] = @parent._credentials { text: params['text'] }, 'access_token'
    params['method'] = 'POST'
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}/comments"
    @parent._request params

  uncomment: (params) ->
    credentials = @parent._credentials {}, 'access_token'
    params['method'] = 'DELETE'
    params['path'] = "/#{@parent._api_version}/media/#{params['media_id']}/comments/#{params['comment_id']}?#{@parent._to_querystring(credentials)}"
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

module.exports = InstagramMedia

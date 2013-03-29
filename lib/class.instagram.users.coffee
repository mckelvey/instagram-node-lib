class InstagramUsers
  constructor: (parent) ->
    @parent = parent

  ###
  User Basics
  ###

  info: (params) ->
    params = @parent._credentials params, 'access_token'
    params['path'] = "/#{@parent._api_version}/users/#{params['user_id']}?#{@parent._to_querystring(params)}"
    @parent._request params

  search: (params) ->
    params = @parent._credentials params, 'access_token'
    params['path'] = "/#{@parent._api_version}/users/search?#{@parent._to_querystring(params)}"
    @parent._request params

  ###
  Media
  ###

  self: (params) ->
    params = @parent._credentials params, 'access_token'
    params['path'] = "/#{@parent._api_version}/users/self/feed?#{@parent._to_querystring(params)}"
    @parent._request params

  liked_by_self: (params) ->
    params = @parent._credentials params, 'access_token'
    params['path'] = "/#{@parent._api_version}/users/self/media/liked?#{@parent._to_querystring(params)}"
    @parent._request params

  recent: (params) ->
    params = @parent._credentials params, 'access_token'
    params['path'] = "/#{@parent._api_version}/users/#{params['user_id']}/media/recent?#{@parent._to_querystring(params)}"
    @parent._request params

  ###
  Relationships
  ###

  follows: (params) ->
    credentials = @parent._credentials params, 'access_token'
    params['path'] = "/#{@parent._api_version}/users/#{params['user_id']}/follows?#{@parent._to_querystring(credentials)}"
    @parent._request params

  followed_by: (params) ->
    credentials = @parent._credentials params, 'access_token'
    params['path'] = "/#{@parent._api_version}/users/#{params['user_id']}/followed-by?#{@parent._to_querystring(credentials)}"
    @parent._request params
  
  requested_by: (params) ->
    credentials = @parent._credentials params, 'access_token'
    params['path'] = "/#{@parent._api_version}/users/self/requested-by?#{@parent._to_querystring(credentials)}"
    @parent._request params

  relationship: (params) ->
    credentials = @parent._credentials params, 'access_token'
    if params['action']?
      params['method'] = 'POST'
      params['post_data'] =
        access_token: credentials['access_token']
        action: params['action']
      params['path'] = "/#{@parent._api_version}/users/#{params['user_id']}/relationship"
    else
      params['path'] = "/#{@parent._api_version}/users/#{params['user_id']}/relationship?#{@parent._to_querystring(credentials)}"
    @parent._request params
    
  follow: (params) ->
    params['action'] = 'follow'
    @relationship params

  unfollow: (params) ->
    params['action'] = 'unfollow'
    @relationship params

  block: (params) ->
    params['action'] = 'block'
    @relationship params

  unblock: (params) ->
    params['action'] = 'unblock'
    @relationship params

  approve: (params) ->
    params['action'] = 'approve'
    @relationship params

  ignore: (params) ->
    params['action'] = 'ignore'
    @relationship params

  ###
  Subscriptions
  ###

  subscribe: (params) ->
    params['object'] = 'user'
    @parent.subscriptions._subscribe params

  unsubscribe_all: (params) ->
    params['object'] = 'user'
    @parent.subscriptions._unsubscribe params

module.exports = InstagramUsers

(function() {
  var InstagramUsers;
  InstagramUsers = (function() {
    function InstagramUsers(parent) {
      this.parent = parent;
    }
    InstagramUsers.prototype.info = function(params) {
      var credentials;
      credentials = this.parent._credentials({});
      params['path'] = "/" + this.parent._api_version + "/users/" + params['user_id'] + "?" + (this.parent._to_querystring(credentials));
      return this.parent._request(params);
    };
    InstagramUsers.prototype.self = function(params) {
      params = this.parent._credentials(params, 'access_token');
      params['path'] = "/" + this.parent._api_version + "/users/self/feed?" + (this.parent._to_querystring(params));
      return this.parent._request(params);
    };
    InstagramUsers.prototype.recent = function(params) {
      params = this.parent._credentials(params, 'access_token');
      params['path'] = "/" + this.parent._api_version + "/users/" + params['user_id'] + "/media/recent?" + (this.parent._to_querystring(params));
      return this.parent._request(params);
    };
    InstagramUsers.prototype.search = function(params) {
      params = this.parent._credentials(params);
      params['path'] = "/" + this.parent._api_version + "/users/search?" + (this.parent._to_querystring(params));
      return this.parent._request(params);
    };
    return InstagramUsers;
  })();
  module.exports = InstagramUsers;
}).call(this);

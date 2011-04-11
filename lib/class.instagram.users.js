(function() {
  var InstagramUsers;
  InstagramUsers = (function() {
    function InstagramUsers(parent) {
      this.parent = parent;
    }
    InstagramUsers.prototype.info = function(params) {
      params['path'] = "/" + this.parent._api_version + "/users/" + params['user_id'] + "?client_id=" + this.parent._config.client_id;
      return this.parent._request(params);
    };
    InstagramUsers.prototype.search = function(params) {
      params['client_id'] = this.parent._config.client_id;
      params['path'] = "/" + this.parent._api_version + "/users/search?" + (this.parent._to_querystring(params));
      return this.parent._request(params);
    };
    return InstagramUsers;
  })();
  module.exports = InstagramUsers;
}).call(this);

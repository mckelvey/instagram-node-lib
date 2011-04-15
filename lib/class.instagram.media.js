(function() {
  var InstagramMedia;
  InstagramMedia = (function() {
    function InstagramMedia(parent) {
      this.parent = parent;
    }
    InstagramMedia.prototype.popular = function(params) {
      var credentials;
      credentials = this.parent._credentials({});
      params['path'] = "/" + this.parent._api_version + "/media/popular?" + (this.parent._to_querystring(credentials));
      return this.parent._request(params);
    };
    InstagramMedia.prototype.info = function(params) {
      var credentials;
      credentials = this.parent._credentials({});
      params['path'] = "/" + this.parent._api_version + "/media/" + params['media_id'] + "?" + (this.parent._to_querystring(credentials));
      return this.parent._request(params);
    };
    InstagramMedia.prototype.search = function(params) {
      params = this.parent._credentials(params);
      params['path'] = "/" + this.parent._api_version + "/media/search?" + (this.parent._to_querystring(params));
      return this.parent._request(params);
    };
    InstagramMedia.prototype.likes = function(params) {
      var credentials;
      credentials = this.parent._credentials({});
      params['path'] = "/" + this.parent._api_version + "/media/" + params['media_id'] + "/likes?" + (this.parent._to_querystring(credentials));
      return this.parent._request(params);
    };
    InstagramMedia.prototype.comments = function(params) {
      var credentials;
      credentials = this.parent._credentials({});
      params['path'] = "/" + this.parent._api_version + "/media/" + params['media_id'] + "/comments?" + (this.parent._to_querystring(credentials));
      return this.parent._request(params);
    };
    InstagramMedia.prototype.subscribe = function(params) {
      params['object'] = 'geography';
      return this.parent.subscriptions._subscribe(params);
    };
    InstagramMedia.prototype.unsubscribe = function(params) {
      return this.parent.subscriptions._unsubscribe(params);
    };
    InstagramMedia.prototype.unsubscribe_all = function(params) {
      params['object'] = 'geography';
      return this.parent.subscriptions._unsubscribe(params);
    };
    return InstagramMedia;
  })();
  module.exports = InstagramMedia;
}).call(this);

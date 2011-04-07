(function() {
  var InstagramMedia;
  InstagramMedia = (function() {
    function InstagramMedia(parent) {
      this.parent = parent;
    }
    InstagramMedia.prototype.popular = function(params) {
      params['path'] = "/" + this.parent._api_version + "/media/popular?client_id=" + this.parent._config.client_id;
      return this.parent._request(params);
    };
    InstagramMedia.prototype.info = function(params) {
      params['path'] = "/" + this.parent._api_version + "/media/" + params['media_id'] + "?client_id=" + this.parent._config.client_id;
      return this.parent._request(params);
    };
    InstagramMedia.prototype.search = function(params) {
      params['client_id'] = this.parent._config.client_id;
      params['path'] = "/" + this.parent._api_version + "/media/search?" + (this.parent._to_querystring(params));
      return this.parent._request(params);
    };
    InstagramMedia.prototype.likes = function(params) {
      params['path'] = "/" + this.parent._api_version + "/media/" + params['media_id'] + "/likes?client_id=" + this.parent._config.client_id;
      return this.parent._request(params);
    };
    InstagramMedia.prototype.comments = function(params) {
      params['path'] = "/" + this.parent._api_version + "/media/" + params['media_id'] + "/comments?client_id=" + this.parent._config.client_id;
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
  exports.module = InstagramMedia;
}).call(this);

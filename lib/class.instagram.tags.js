(function() {
  var InstagramTags;
  InstagramTags = (function() {
    function InstagramTags(parent) {
      this.parent = parent;
    }
    InstagramTags.prototype.info = function(params) {
      params['path'] = "/" + this.parent._api_version + "/tags/" + params['name'] + "?client_id=" + this.parent._config.client_id;
      return this.parent._request(params);
    };
    InstagramTags.prototype.recent = function(params) {
      params['client_id'] = this.parent._config.client_id;
      params['path'] = "/" + this.parent._api_version + "/tags/" + params['name'] + "/media/recent?" + (this.parent._to_querystring(params));
      return this.parent._request(params);
    };
    InstagramTags.prototype.search = function(params) {
      params['client_id'] = this.parent._config.client_id;
      params['path'] = "/" + this.parent._api_version + "/tags/search?" + (this.parent._to_querystring(params));
      return this.parent._request(params);
    };
    InstagramTags.prototype.subscribe = function(params) {
      params['object'] = 'tag';
      return this.parent.subscriptions._subscribe(params);
    };
    InstagramTags.prototype.unsubscribe = function(params) {
      return this.parent.subscriptions._unsubscribe(params);
    };
    InstagramTags.prototype.unsubscribe_all = function(params) {
      params['object'] = 'tag';
      return this.parent.subscriptions._unsubscribe(params);
    };
    return InstagramTags;
  })();
  module.exports = InstagramTags;
}).call(this);

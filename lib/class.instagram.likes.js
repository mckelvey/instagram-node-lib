(function() {
  var InstagramLikes;
  InstagramLikes = (function() {
    function InstagramLikes(parent) {
      this.parent = parent;
    }
    InstagramLikes.prototype.likes = function(params) {
      var credentials;
      credentials = this.parent._credentials({});
      params['path'] = "/" + this.parent._api_version + "/media/" + params['media_id'] + "/likes?" + (this.parent._to_querystring(params));
      return this.parent._request(params);
    };
    return InstagramLikes;
  })();
  module.exports = InstagramLikes;
}).call(this);

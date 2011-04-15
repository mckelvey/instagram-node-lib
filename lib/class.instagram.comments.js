(function() {
  var InstagramComments;
  InstagramComments = (function() {
    function InstagramComments(parent) {
      this.parent = parent;
    }
    InstagramComments.prototype.comments = function(params) {
      var credentials;
      credentials = this.parent._credentials({});
      params['path'] = "/" + this.parent._api_version + "/media/" + params['media_id'] + "/comments?" + (this.parent._to_querystring(credentials));
      return this.parent._request(params);
    };
    return InstagramComments;
  })();
  module.exports = InstagramComments;
}).call(this);

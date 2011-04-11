(function() {
  /*
  Geographies Do Not Yet Work
  */  var InstagramGeographies;
  InstagramGeographies = (function() {
    function InstagramGeographies(parent) {
      this.parent = parent;
    }
    InstagramGeographies.prototype.recent = function(params) {
      params['client_id'] = this.parent._config.client_id;
      params['path'] = "/" + this.parent._api_version + "/geographies/" + params['geography_id'] + "/media/recent?" + (this.parent._to_querystring(params));
      return this.parent._request(params);
    };
    return InstagramGeographies;
  })();
  module.exports = InstagramGeographies;
}).call(this);

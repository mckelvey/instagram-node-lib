(function() {
  var InstagramOAuth, url;
  url = require('url');
  InstagramOAuth = (function() {
    function InstagramOAuth(parent) {
      this.parent = parent;
    }
    InstagramOAuth.prototype.ask_for_authorization = function(params) {
      params['client_id'] = this.parent._config.client_id;
      params['redirect_uri'] = params['redirect_uri'] === void 0 || params['redirect_uri'] === null ? this.parent._config.redirect_uri : params['redirect_uri'];
      params['path'] = "/oauth/authorize/?" + (this.parent._to_querystring(params));
      return this.parent._request(params);
    };
    InstagramOAuth.prototype.ask_for_access_token = function(params) {
      params['method'] = "POST";
      params['post_data'] = {
        client_id: this.parent._config.client_id,
        client_secret: this.parent._config.client_secret,
        grant_type: 'authorization_code',
        redirect_uri: params['redirect_uri'] === void 0 || params['redirect_uri'] === null ? this.parent._config.redirect_uri : params['redirect_uri'],
        code: params['code']
      };
      params['path'] = "/oauth/access_token";
      return this.parent._request(params);
    };
    InstagramOAuth.prototype.handshake = function(request, response, complete) {
      var parsedRequest;
      parsedRequest = url.parse(request.url, true);
      if (parsedRequest['query']['error'] != null) {
        return this.parent._error("" + parsedRequest['query']['error'] + ": " + parsedRequest['query']['error_reason'] + ": " + parsedRequest['query']['error_description'], parsedRequest['query'], 'handshake');
      } else if (parsedRequest['query']['code'] != null) {
        response.writeHead(200, {
          'Content-Length': 0,
          'Content-Type': 'text/plain'
        });
        return response.end();
      }
    };
    return InstagramOAuth;
  })();
  module.exports = InstagramOAuth;
}).call(this);

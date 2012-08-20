(function() {
  var APIClient, InstagramAPI, querystring;

  querystring = require('querystring');

  InstagramAPI = (function() {

    function InstagramAPI() {
      var module, moduleClass, _i, _len, _ref;
      this._api_version = 'v1';
      this._http_client = require('http');
      this._https_client = require('https');
      this._config = {
        client_id: process.env['CLIENT_ID'] != null ? process.env['CLIENT_ID'] : 'CLIENT-ID',
        client_secret: process.env['CLIENT_SECRET'] != null ? process.env['CLIENT_SECRET'] : 'CLIENT-SECRET',
        callback_url: process.env['CALLBACK_URL'] != null ? process.env['CALLBACK_URL'] : 'CALLBACK-URL',
        redirect_uri: process.env['REDIRECT_URI'] != null ? process.env['REDIRECT_URI'] : 'REDIRECT_URI',
        access_token: process.env['ACCESS_TOKEN'] != null ? process.env['ACCESS_TOKEN'] : null,
        maxSockets: 5
      };
      this._options = {
        host: process.env['TEST_HOST'] != null ? process.env['TEST_HOST'] : 'api.instagram.com',
        port: process.env['TEST_PORT'] != null ? process.env['TEST_PORT'] : null,
        method: "GET",
        path: '',
        headers: {
          'User-Agent': 'Instagram Node Lib 0.0.9',
          'Accept': 'application/json',
          'Content-Length': 0
        }
      };
      _ref = ['media', 'tags', 'users', 'locations', 'geographies', 'subscriptions', 'oauth'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        module = _ref[_i];
        moduleClass = require("./class.instagram." + module);
        this[module] = new moduleClass(this);
      }
    }

    /*
      Generic Response Methods
    */

    InstagramAPI.prototype._error = function(e, value, caller) {
      var message;
      if (value === void 0) value = '[undefined]';
      if (value === null) value = '[null]';
      message = "" + e + " occurred: " + value + " in " + caller;
      console.log(message);
      return message;
    };

    InstagramAPI.prototype._complete = function(data, pagination) {
      var i;
      for (i in data) {
        console.log(data[i]);
      }
      if (pagination != null) return console.log(pagination);
    };

    /*
      Shared Data Manipulation Methods
    */

    InstagramAPI.prototype._to_querystring = function(params) {
      var i, obj;
      obj = {};
      for (i in params) {
        if (i !== 'complete' && i !== 'error') obj[i] = params[i];
      }
      return querystring.stringify(obj);
    };

    InstagramAPI.prototype._merge = function(obj1, obj2) {
      var i;
      for (i in obj2) {
        obj1[i] = obj2[i];
      }
      return obj1;
    };

    InstagramAPI.prototype._to_value = function(key, value) {
      if (typeof value !== 'object') return value;
      if (value[key] != null) return value[key];
      return null;
    };

    InstagramAPI.prototype._to_object = function(key, value) {
      var obj;
      if (typeof value === 'object' && (value[key] != null)) return value;
      obj = {};
      return obj[key] = value;
    };

    InstagramAPI.prototype._clone = function(from_object) {
      var property, to_object;
      to_object = {};
      for (property in from_object) {
        to_object[property] = from_object[property];
      }
      return to_object;
    };

    /*
      Set Methods
    */

    InstagramAPI.prototype._set_maxSockets = function(value) {
      if (parseInt(value) === value && value > 0) {
        this._http_client.Agent.defaultMaxSockets = value;
        return this._https_client.Agent.defaultMaxSockets = value;
      }
    };

    InstagramAPI.prototype.set = function(property, value) {
      if (this._config[property] !== void 0) this._config[property] = value;
      if (this._options[property] !== void 0) this._options[property] = value;
      if (typeof this["_set_" + property] === 'function') {
        return this["_set_" + property](value);
      }
    };

    /*
      Shared Request Methods
    */

    InstagramAPI.prototype._credentials = function(params, require) {
      if (require == null) require = null;
      if( !params) var params = {}
      if ((require != null) && (params[require] != null) || (params['access_token'] != null) || (params['client_id'] != null)) {
        return params;
      }
      if (require !== null && (this._config[require] != null)) {
        params[require] = this._config[require];
      } else if (this._config['access_token'] != null) {
        params['access_token'] = this._config['access_token'];
      } else if (this._config['client_id'] != null) {
        params['client_id'] = this._config['client_id'];
      }
      return params;
    };

    InstagramAPI.prototype._request = function(params) {
      var appResponse, complete, error, http_client, options, post_data, request, _ref, _ref2;
      options = this._clone(this._options);
      if (params['method'] != null) options['method'] = params['method'];
      if (params['path'] != null) options['path'] = params['path'];
      options['path'] = process.env['TEST_PATH_PREFIX'] != null ? "" + process.env['TEST_PATH_PREFIX'] + options['path'] : options['path'];
      complete = (_ref = params['complete']) != null ? _ref : params['complete'] = this._complete;
      appResponse = params['response'];
      error = (_ref2 = params['error']) != null ? _ref2 : params['error'] = this._error;
      if (options['method'] !== "GET" && (params['post_data'] != null)) {
        post_data = this._to_querystring(params['post_data']);
      } else {
        post_data = '';
      }
      options['headers']['Content-Length'] = post_data.length;
      if (process.env['TEST_PROTOCOL'] === 'http') {
        http_client = this._http_client;
      } else {
        http_client = this._https_client;
      }
      request = http_client.request(options, function(response) {
        var data;
        data = '';
        response.setEncoding('utf8');
        response.on('data', function(chunk) {
          return data += chunk;
        });
        return response.on('end', function() {
          var pagination, parsedResponse;
          try {
            parsedResponse = JSON.parse(data);
            if ((parsedResponse != null) && (parsedResponse['meta'] != null) && parsedResponse['meta']['code'] !== 200) {
              return error(parsedResponse['meta']['error_type'], parsedResponse['meta']['error_message'], "_request");
            } else if (parsedResponse['access_token'] != null) {
              return complete(parsedResponse, appResponse);
            } else {
              pagination = typeof parsedResponse['pagination'] === 'undefined' ? {} : parsedResponse['pagination'];
              return complete(parsedResponse['data'], pagination);
            }
          } catch (e) {
            if (appResponse != null) {
              return error(e, data, '_request', appResponse);
            } else {
              return error(e, data, '_request');
            }
          }
        });
      });
      if (post_data != null) request.write(post_data);
      request.addListener('error', function(connectionException) {
        if (connectionException.code !== 'ENOTCONN') {
          if (appResponse != null) {
            return error(connectionException, options, "_request", appResponse);
          } else {
            return error(connectionException, options, "_request");
          }
        }
      });
      return request.end();
    };

    return InstagramAPI;

  })();

  APIClient = new InstagramAPI;

  module.exports = APIClient;

}).call(this);

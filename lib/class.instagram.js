(function() {
  var APIClient, InstagramAPI, querystring;
  querystring = require('querystring');
  InstagramAPI = (function() {
    function InstagramAPI() {
      var module, moduleClass, _i, _len, _ref;
      this._api_version = 'v1';
      this._client = require('https');
      this._config = {
        client_id: process.env['CLIENT_ID'] != null ? process.env['CLIENT_ID'] : 'CLIENT-ID',
        client_secret: process.env['CLIENT_SECRET'] != null ? process.env['CLIENT_SECRET'] : 'CLIENT-SECRET',
        callback_url: process.env['CALLBACK_URL'] != null ? process.env['CALLBACK_URL'] : ''
      };
      this._options = {
        host: 'api.instagram.com',
        port: null,
        method: "GET",
        path: '',
        headers: {
          'User-Agent': 'Instagram JS Lib 0.0.1',
          'Accept': 'application/json',
          'Content-Length': 0
        }
      };
      _ref = ['media', 'tags', 'users', 'locations', 'geographies', 'subscriptions'];
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
      if (value === void 0) {
        value = '[undefined]';
      }
      if (value === null) {
        value = '[null]';
      }
      message = "" + e + " occurred: " + value + " in " + caller;
      console.log(message);
      return message;
    };
    InstagramAPI.prototype._complete = function(data, pagination) {
      var i;
      for (i in data) {
        console.log(data[i].id);
      }
      return console.log(pagination);
    };
    /*
    Shared Data Manipulation Methods
    */
    InstagramAPI.prototype._to_querystring = function(params) {
      var i, obj;
      obj = {};
      for (i in params) {
        if (i !== 'complete' && i !== 'error') {
          obj[i] = params[i];
        }
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
      if (typeof value !== 'object') {
        return value;
      }
      if (value[key] != null) {
        return value[key];
      }
      return null;
    };
    InstagramAPI.prototype._to_object = function(key, value) {
      var obj;
      if (typeof value === 'object' && (value[key] != null)) {
        return value;
      }
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
    Generic Methods
    */
    InstagramAPI.prototype.set = function(property, value) {
      if (this._config[property] !== void 0) {
        this._config[property] = value;
      }
      if (this._options[property] !== void 0) {
        return this._options[property] = value;
      }
    };
    /*
    Shared Request Methods
    */
    InstagramAPI.prototype._request = function(params) {
      var complete, error, options, post_data, request, _ref, _ref2;
      options = this._clone(this._options);
      if (params['path'] != null) {
        options['path'] = params['path'];
      }
      if (params['method'] != null) {
        options['method'] = params['method'];
      }
      complete = (_ref = params['complete']) != null ? _ref : params['complete'] = this._complete;
      error = (_ref2 = params['error']) != null ? _ref2 : params['error'] = this._error;
      if (options['method'] !== "GET" && (params['post_data'] != null)) {
        post_data = this._to_querystring(params['post_data']);
      } else {
        post_data = '';
      }
      options['headers']['Content-Length'] = post_data.length;
      request = this._client.request(options, function(response) {
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
            } else {
              pagination = typeof parsedResponse['pagination'] === 'undefined' ? {} : parsedResponse['pagination'];
              return complete(parsedResponse['data'], pagination);
            }
          } catch (e) {
            return error(e, data, '_request');
          }
        });
      });
      if (post_data != null) {
        request.write(post_data);
      }
      return request.end();
    };
    return InstagramAPI;
  })();
  APIClient = new InstagramAPI;
  module.exports = APIClient;
}).call(this);

(function() {
  /*
  Test Setup
  */  var Init, Instagram, app, assert, completed, should, test, to_do;
  console.log("\nInstagram API Node.js Lib Tests :: OAuth");
  Init = require('./initialize');
  Instagram = Init.Instagram;
  app = Init.app;
  assert = require('assert');
  should = require('should');
  test = require('./helpers');
  completed = 0;
  to_do = 0;
  /*
  Tests
  */
  module.exports = {
    'oauth#authorization_url': function() {
      var result;
      console.log("\noauth#authorization_url");
      result = Instagram.oauth.authorization_url({
        scope: 'comments likes',
        display: 'touch'
      });
      result.should.match(/\/oauth\/authorize\//);
      result.should.match(/client_id\=/);
      result.should.match(/redirect_uri\=/);
      result.should.match(/response_type\=code/);
      result.should.not.match(/client_id\=CLIENT\-ID/);
      result.should.not.match(/redirect_uri\=REDIRECT_URI/);
      test.output("result matched authorization url", result);
      return app.finish_test();
    },
    'oauth#ask_for_access_token': function() {
      var http_client, options, redirect_uri, request, url;
      console.log("\noauth#ask_for_access_token");
      http_client = require('http');
      url = require('url');
      redirect_uri = url.parse(Instagram._config.redirect_uri);
      options = {
        host: redirect_uri['hostname'],
        port: typeof redirect_uri['port'] !== 'undefined' ? redirect_uri['port'] : null,
        method: "GET",
        path: "" + redirect_uri['pathname'] + "?code=test-code"
      };
      test.output("testing " + Instagram._config.redirect_uri);
      request = http_client.request(options, function(response) {
        var data;
        data = '';
        response.on('data', function(chunk) {
          return data += chunk;
        });
        return response.on('end', function() {
          return test.output("result", data);
        });
      });
      request.addListener('error', function(connectionException) {
        if (connectionException.code !== 'ENOTCONN') {
          console.log("\n" + connectionException);
          throw connectionException;
        }
      });
      request.end();
      return app.finish_test();
    }
  };
  app.start_tests(module.exports);
}).call(this);

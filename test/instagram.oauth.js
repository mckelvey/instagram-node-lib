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
    'users#info for id#291024': function() {
      return test.helper('users#info for id#291024', Instagram, 'users', 'info', {
        user_id: 291024
      }, function(data) {
        data.should.have.property('id', '291024');
        test.output("data had the property 'id' equal to '291024'");
        data.should.have.property('profile_picture');
        test.output("data had the property 'profile_picture'", data.profile_picture);
        return app.finish_test();
      });
    }
  };
  app.start_tests(module.exports);
}).call(this);

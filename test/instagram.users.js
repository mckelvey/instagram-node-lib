(function() {
  /*
  Testing Users Methods
  */  var Instagram, assert, should, test_helper;
  console.log("\nInstagram API Node.js Lib Tests :: Users");
  Instagram = require('../lib/class.instagram');
  assert = require('assert');
  should = require('should');
  test_helper = require('./helpers.js');
  module.exports = {
    'users#info for id#291024': function() {
      return test_helper('users#info for id#291024', Instagram, 'users', 'info', {
        user_id: 291024
      }, function(data) {
        data.should.have.property('id', '291024');
        return data.should.have.property('profile_picture');
      });
    },
    'users#search for mckelvey': function() {
      return test_helper('users#search for mckelvey', Instagram, 'users', 'search', {
        q: 'mckelvey'
      }, function(data) {
        data.length.should.be.above(0);
        data[0].should.have.property('username', 'mckelvey');
        return data[0].should.have.property('id', '291024');
      });
    }
  };
}).call(this);

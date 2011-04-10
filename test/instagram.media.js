(function() {
  /*
  Testing Media Methods
  */  var Instagram, assert, should, test_helper;
  console.log("\nInstagram API Node.js Lib Tests :: Media");
  Instagram = require('../lib/class.instagram');
  assert = require('assert');
  should = require('should');
  test_helper = require('./helpers.js');
  module.exports = {
    'media#popular': function() {
      return test_helper('media#popular', Instagram, 'media', 'popular', {}, function(data) {
        data.length.should.equal(32);
        return data[0].should.have.property('id');
      });
    },
    'media#info for id#3': function() {
      return test_helper('media#info for id#3', Instagram, 'media', 'info', {
        media_id: 3
      }, function(data) {
        data.should.have.property('id', '3');
        return data.should.have.property('created_time', '1279315783');
      });
    },
    'media#likes for id#3': function() {
      return test_helper('media#likes for id#3', Instagram, 'media', 'likes', {
        media_id: 3
      }, function(data) {
        return data.length.should.be.above(0);
      });
    },
    'media#comments for id#3': function() {
      return test_helper('media#comments for id#3', Instagram, 'media', 'comments', {
        media_id: 3
      }, function(data) {
        return data.length.should.be.above(0);
      });
    },
    'media#search for 48.858844300000001/2.2943506': function() {
      return test_helper('media#search for 48.858844300000001/2.2943506', Instagram, 'media', 'search', {
        lat: 48.858844300000001,
        lng: 2.2943506
      }, function(data) {
        data.length.should.be.above(0);
        return data[0].should.have.property('id');
      });
    }
  };
}).call(this);

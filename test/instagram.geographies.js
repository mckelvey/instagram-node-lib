(function() {
  /*
  Testing Geographies Methods
  */  var Instagram, assert, should, test_helper;
  console.log("\nInstagram API Node.js Lib Tests :: Geographies");
  Instagram = require('../lib/class.instagram');
  assert = require('assert');
  should = require('should');
  test_helper = require('./helpers.js');
  module.exports = {
    'geographies#recent for id#4167': function() {
      return test_helper('geographies#recent for id#4167', Instagram, 'geographies', 'recent', {
        geography_id: 4167
      }, function(data) {
        return data.should.not.be.empty;
      });
    }
  };
}).call(this);

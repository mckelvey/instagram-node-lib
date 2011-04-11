(function() {
  /*
  Testing Location Methods
  */  var Instagram, assert, should, test_helper;
  console.log("\nInstagram API Node.js Lib Tests :: Locations");
  Instagram = require('../lib/class.instagram');
  assert = require('assert');
  should = require('should');
  test_helper = require('./helpers.js');
  module.exports = {
    'locations#info for id#1': function() {
      return test_helper('locations#info for id#1', Instagram, 'locations', 'info', {
        location_id: 1
      }, function(data) {
        data.should.have.property('name', 'Dogpatch Labs');
        data.latitude.should.be.above(0);
        return data.longitude.should.be.below(0);
      });
    },
    'locations#recent for id#1': function() {
      return test_helper('locations#recent for id#1', Instagram, 'locations', 'recent', {
        location_id: 1
      }, function(data, pagination) {
        data.length.should.be.above(0);
        data[0].should.have.property('id');
        pagination.should.have.property('next_url');
        pagination.should.have.property('next_max_id');
        return pagination.should.have.property('next_min_id');
      });
    },
    'locations#search for 48.858844300000001/2.2943506': function() {
      return test_helper('locations#search for 48.858844300000001/2.2943506', Instagram, 'locations', 'search', {
        lat: 48.858844300000001,
        lng: 2.2943506
      }, function(data) {
        data.length.should.be.above(0);
        data[0].should.have.property('id');
        return data[0].should.have.property('name');
      });
    }
  };
}).call(this);

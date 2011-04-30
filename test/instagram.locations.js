(function() {
  /*
  Testing Location Methods
  */  var Instagram, assert, should, test;
  console.log("\nInstagram API Node.js Lib Tests :: Locations");
  Instagram = require('../lib/class.instagram');
  assert = require('assert');
  should = require('should');
  test = require('./helpers.js');
  module.exports = {
    'locations#info for id#1': function() {
      return test.helper('locations#info for id#1', Instagram, 'locations', 'info', {
        location_id: 1
      }, function(data) {
        data.should.have.property('name', 'Dogpatch Labs');
        test.output("data had the property 'name' equal to 'Dogpatch Labs'");
        data.latitude.should.be.above(0);
        test.output("data had the property 'latitude' greater than zero", data.latitude);
        data.longitude.should.be.below(0);
        return test.output("data had the property 'longitude' less than zero", data.longitude);
      });
    },
    'locations#recent for id#1': function() {
      return test.helper('locations#recent for id#1', Instagram, 'locations', 'recent', {
        location_id: 1
      }, function(data, pagination) {
        data.length.should.be.above(0);
        test.output("data had length greater than 0", data.length);
        data[0].should.have.property('id');
        test.output("data[0] had the property 'id'", data[0].id);
        pagination.should.have.property('next_url');
        test.output("pagination had the property 'next_url'", pagination.next_url);
        pagination.should.have.property('next_max_id' || pagination.should.have.property('next_min_id'));
        return test.output("pagination had the property 'next_max_id' or 'next_min_id'", pagination);
      });
    },
    'locations#search for 48.858844300000001/2.2943506': function() {
      return test.helper('locations#search for 48.858844300000001/2.2943506', Instagram, 'locations', 'search', {
        lat: 48.858844300000001,
        lng: 2.2943506
      }, function(data) {
        data.length.should.be.above(0);
        test.output("data had length greater than 0", data.length);
        data[0].should.have.property('id');
        test.output("data[0] had the property 'id'", data[0].id);
        data[0].should.have.property('name');
        return test.output("data[0] had the property 'name'", data[0].name);
      });
    }
  };
}).call(this);

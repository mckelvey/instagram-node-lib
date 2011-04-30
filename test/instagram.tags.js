(function() {
  /*
  Testing Tag Methods
  */  var Instagram, assert, should, test;
  console.log("\nInstagram API Node.js Lib Tests :: Tags");
  Instagram = require('../lib/class.instagram');
  assert = require('assert');
  should = require('should');
  test = require('./helpers.js');
  module.exports = {
    'tags#info for blue': function() {
      return test.helper('tags#info for blue', Instagram, 'tags', 'info', {
        name: 'blue'
      }, function(data) {
        data.should.have.property('name', 'blue');
        test.output("data had the property 'name' equal to 'blue'");
        data.media_count.should.be.above(0);
        return test.output("data had the property 'media_count' greater than zero", data.media_count);
      });
    },
    'tags#recent for blue': function() {
      return test.helper('tags#recent for blue', Instagram, 'tags', 'recent', {
        name: 'blue'
      }, function(data, pagination) {
        data.length.should.equal(20);
        test.output("data had length equal to 20");
        data[0].should.have.property('id');
        test.output("data[0] had the property 'id'", data[0]);
        pagination.should.have.property('next_url');
        test.output("pagination had the property 'next_url'", pagination.next_url);
        pagination.should.have.property('next_max_id');
        test.output("pagination had the property 'next_max_id'", pagination.next_max_id);
        pagination.should.have.property('next_min_id');
        return test.output("pagination had the property 'next_min_id'", pagination.next_min_id);
      });
    },
    'tags#search for blue': function() {
      return test.helper('tags#search for blue', Instagram, 'tags', 'search', {
        q: 'blue'
      }, function(data) {
        data.length.should.be.above(0);
        test.output("data had length greater than 0", data.length);
        data[0].should.have.property('name', 'blue');
        test.output("data[0] had the property 'name' equal to 'blue'");
        data[0].media_count.should.be.above(0);
        return test.output("data[0] had the property 'media_count' greater than zero", data[0].media_count);
      });
    }
  };
}).call(this);

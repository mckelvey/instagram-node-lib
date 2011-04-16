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
    'media#search for 48.858844300000001/2.2943506': function() {
      return test_helper('media#search for 48.858844300000001/2.2943506', Instagram, 'media', 'search', {
        lat: 48.858844300000001,
        lng: 2.2943506
      }, function(data) {
        data.length.should.be.above(0);
        return data[0].should.have.property('id');
      });
    },
    'media#like id#3': function() {
      return test_helper('media#like id#3', Instagram, 'media', 'like', {
        media_id: 3
      }, function(data) {
        if (data !== null) {
          throw "like failed";
        }
        console.log("   liked media #3");
        return test_helper('media#likes for id#3', Instagram, 'media', 'likes', {
          media_id: 3
        }, function(data) {
          data.length.should.be.above(0);
          return test_helper('media#unlike id#3', Instagram, 'media', 'unlike', {
            media_id: 3
          }, function(data) {
            if (data !== null) {
              throw "unlike failed";
            }
            return console.log("   unliked media #3");
          });
        });
      });
    },
    'media#comment id#53355234': function() {
      return test_helper('media#comment id#53355234', Instagram, 'media', 'comment', {
        media_id: 53355234,
        text: 'Instagame was here.'
      }, function(data) {
        var comment_id;
        data.should.have.property('id');
        data.should.have.property('from');
        data.should.have.property('created_time');
        data.should.have.property('text');
        comment_id = data['id'];
        console.log("   created comment " + comment_id);
        return test_helper('media#comments for id#53355234', Instagram, 'media', 'comments', {
          media_id: 53355234
        }, function(data) {
          data.length.should.be.above(0);
          return test_helper('media#uncomment id#53355234', Instagram, 'media', 'uncomment', {
            media_id: 53355234,
            comment_id: comment_id
          }, function(data) {
            if (data !== null) {
              throw "unlike failed";
            }
            return console.log("   deleted comment " + comment_id);
          });
        });
      });
    }
  };
}).call(this);

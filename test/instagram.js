(function() {
  /*
  Setup Lib for Testing
  */  var CALLBACK_URL, HOST, Instagram, PORT, app, assert, callback, completed, express, iterations, k, should, to_do, url, waiting;
  Instagram = require('../lib/class.instagram');
  /*
  Setup Temp App for Subscription Testing
  */
  url = require('url');
  CALLBACK_URL = process.env['CALLBACK_URL'] != null ? process.env['CALLBACK_URL'] : "http://your.callback/url";
  callback = url.parse(CALLBACK_URL);
  if (callback != null) {
    HOST = callback['hostname'];
    PORT = typeof callback['port'] !== 'undefined' ? callback['port'] : null;
  }
  express = require('express');
  app = express.createServer();
  app.configure(function() {
    app.set('host', HOST);
    return app.use(app.router);
  });
  app.configure('development', function() {
    app.set('port', PORT);
    app.use(express.logger());
    return app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });
  app.get(PATH, function(request, response) {
    return Instagram.subscriptions.handshake(request, response);
  });
  app.listen(PORT);
  /*
  Tests
  */
  assert = require('assert');
  should = require('should');
  to_do = 0;
  completed = 0;
  module.exports = {
    'tags#info for blue': function() {
      return Instagram.tags.info({
        name: 'blue',
        complete: function(data) {
          data.should.have.property('name', 'blue');
          data.media_count.should.be.above(0);
          return completed += 1;
        }
      });
    },
    'tags#recent for blue': function() {
      return Instagram.tags.recent({
        name: 'blue',
        complete: function(data) {
          data.length.should.equal(20);
          data[0].should.have.property('id');
          return completed += 1;
        }
      });
    },
    'tags#search for blue': function() {
      return Instagram.tags.search({
        q: 'blue',
        complete: function(data) {
          data.length.should.equal(50);
          data[0].should.have.property('name', 'blue');
          data[0].media_count.should.be.above(0);
          return completed += 1;
        }
      });
    },
    'locations#info for id#1': function() {
      return Instagram.locations.info({
        location_id: 1,
        complete: function(data) {
          data.should.have.property('name', 'Dogpatch Labs');
          data.latitude.should.be.above(0);
          data.longitude.should.be.below(0);
          return completed += 1;
        }
      });
    },
    'locations#recent for id#1': function() {
      return Instagram.locations.recent({
        location_id: 1,
        complete: function(data) {
          data.length.should.be.above(0);
          data[0].should.have.property('id');
          return completed += 1;
        }
      });
    },
    'locations#search for 48.858844300000001/2.2943506': function() {
      return Instagram.locations.search({
        lat: 48.858844300000001,
        lng: 2.2943506,
        complete: function(data) {
          data.length.should.be.above(0);
          data[0].should.have.property('id');
          data[0].should.have.property('name');
          return completed += 1;
        }
      });
    },
    'media#popular': function() {
      return Instagram.media.popular({
        complete: function(data) {
          data.length.should.equal(32);
          data[0].should.have.property('id');
          return completed += 1;
        }
      });
    },
    'media#info for id#3': function() {
      return Instagram.media.info({
        media_id: 3,
        complete: function(data) {
          data.should.have.property('id', '3');
          data.should.have.property('created_time', '1279315783');
          return completed += 1;
        }
      });
    },
    'media#likes for id#3': function() {
      return Instagram.media.likes({
        media_id: 3,
        complete: function(data) {
          data.length.should.be.above(0);
          return completed += 1;
        }
      });
    },
    'media#comments for id#3': function() {
      return Instagram.media.comments({
        media_id: 3,
        complete: function(data) {
          data.length.should.be.above(0);
          return completed += 1;
        }
      });
    },
    'media#search for 48.858844300000001/2.2943506': function() {
      return Instagram.media.search({
        lat: 48.858844300000001,
        lng: 2.2943506,
        complete: function(data) {
          data.length.should.be.above(0);
          data[0].should.have.property('id');
          return completed += 1;
        }
      });
    },
    'users#info for id#291024': function() {
      return Instagram.users.info({
        user_id: 291024,
        complete: function(data) {
          data.should.have.property('id', '291024');
          data.should.have.property('profile_picture');
          return completed += 1;
        }
      });
    },
    'users#search for mckelvey': function() {
      return Instagram.users.search({
        q: 'mckelvey',
        complete: function(data) {
          data.length.should.be.above(0);
          data[0].should.have.property('username', 'mckelvey');
          data[0].should.have.property('id', '291024');
          return completed += 1;
        }
      });
    },
    'tags#subscriptions subscribe#blue, subscriptions, unsubscribe#blue#id': function() {
      var list, unsubscribe;
      unsubscribe = function(subscription_id) {
        return Instagram.tags.unsubscribe({
          id: subscription_id,
          complete: function(data) {
            assert.isNull(data);
            return completed += 1;
          }
        });
      };
      list = function(subscription_id) {
        return Instagram.subscriptions.list({
          complete: function(data) {
            data.should.not.be.empty;
            return unsubscribe(subscription_id);
          }
        });
      };
      return Instagram.tags.subscribe({
        object_id: 'blue',
        callback_url: CALLBACK_URL,
        complete: function(data) {
          data.should.have.property('id');
          data.id.should.be.above(0);
          data.should.have.property('type', 'subscription');
          return list(data['id']);
        }
      });
    },
    'locations#subscriptions subscribe#1257285, subscriptions, unsubscribe#1257285#id': function() {
      var list, unsubscribe;
      unsubscribe = function(subscription_id) {
        return Instagram.locations.unsubscribe({
          id: subscription_id,
          complete: function(data) {
            assert.isNull(data);
            return completed += 1;
          }
        });
      };
      list = function(subscription_id) {
        return Instagram.subscriptions.list({
          complete: function(data) {
            data.should.not.be.empty;
            return unsubscribe(subscription_id);
          }
        });
      };
      return Instagram.locations.subscribe({
        object_id: '1257285',
        callback_url: CALLBACK_URL,
        complete: function(data) {
          data.should.have.property('id');
          data.id.should.be.above(0);
          data.should.have.property('type', 'subscription');
          return list(data['id']);
        }
      });
    },
    'media#subscriptions subscribe#48.858844300000001/2.2943506, subscriptions, unsubscribe#48.858844300000001/2.2943506#id': function() {
      var list, unsubscribe;
      unsubscribe = function(subscription_id) {
        return Instagram.media.unsubscribe({
          id: subscription_id,
          complete: function(data) {
            assert.isNull(data);
            return completed += 1;
          }
        });
      };
      list = function(subscription_id) {
        return Instagram.subscriptions.list({
          complete: function(data) {
            data.should.not.be.empty;
            return unsubscribe(subscription_id);
          }
        });
      };
      return Instagram.media.subscribe({
        lat: 48.858844300000001,
        lng: 2.2943506,
        radius: 1000,
        callback_url: CALLBACK_URL,
        complete: function(data) {
          data.should.have.property('id');
          data.id.should.be.above(0);
          data.should.have.property('type', 'subscription');
          return list(data['id']);
        }
      });
    }
  };
  /*
  Tests Reporting
  */
  console.log("\n   Instagram API Node.js Lib Tests\n");
  for (k in module.exports) {
    to_do += 1;
    console.log("   " + k);
  }
  iterations = 0;
  waiting = setInterval(function(){if(completed==to_do||iterations>to_do){clearInterval(waiting);app.close();}else{iterations+=1;}}, 1000);
}).call(this);

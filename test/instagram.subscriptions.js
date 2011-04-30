(function() {
  /*
  Setup Lib for Testing
  */  var CALLBACK_URL, HOST, Instagram, PATH, PORT, app, assert, callback, completed, express, i, indent, iterations, should, test, to_do, url, waiting;
  var __indexOf = Array.prototype.indexOf || function(item) {
    for (var i = 0, l = this.length; i < l; i++) {
      if (this[i] === item) return i;
    }
    return -1;
  };
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
    PATH = callback['pathname'];
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
  test = require('./helpers.js');
  completed = 0;
  to_do = 0;
  indent = "   ";
  module.exports = {
    'tags#subscriptions': function() {
      return test.helper("tags#subscriptions subscribe to 'blue'", Instagram, 'tags', 'subscribe', {
        object_id: 'blue'
      }, function(data) {
        var subscription_id;
        data.should.have.property('id');
        test.output("data had the property 'id'");
        data.id.should.be.above(0);
        test.output("data.id was greater than 0", data.id);
        data.should.have.property('type', 'subscription');
        test.output("data had the property 'type' equal to 'subscription'", data);
        subscription_id = data.id;
        return test.helper('tags#subscriptions list', Instagram, 'subscriptions', 'list', {}, function(data) {
          var found, i;
          data.length.should.be.above(0);
          test.output("data had length greater than 0", data.length);
          found = false;
          for (i in data) {
            if (data[i].id === subscription_id) {
              found = true;
            }
          }
          if (!found) {
            throw "subscription not found";
          }
          test.output("data had the subscription " + subscription_id);
          return test.helper("tags#subscriptions unsubscribe from 'blue'", Instagram, 'tags', 'unsubscribe', {
            id: subscription_id
          }, function(data) {
            if (data !== null) {
              throw "tag 'blue' unsubscribe failed";
            }
            return test.output("data was null; we unsubscribed from the subscription " + subscription_id);
          });
        });
      });
    },
    'locations#subscriptions': function() {
      return test.helper("locations#subscriptions subscribe to location '1257285'", Instagram, 'locations', 'subscribe', {
        object_id: '1257285'
      }, function(data) {
        var subscription_id;
        data.should.have.property('id');
        test.output("data had the property 'id'");
        data.id.should.be.above(0);
        test.output("data.id was greater than 0", data.id);
        data.should.have.property('type', 'subscription');
        test.output("data had the property 'type' equal to 'subscription'", data);
        subscription_id = data.id;
        return test.helper('locations#subscriptions list', Instagram, 'subscriptions', 'list', {}, function(data) {
          var found, i;
          data.length.should.be.above(0);
          test.output("data had length greater than 0", data.length);
          found = false;
          for (i in data) {
            if (data[i].id === subscription_id) {
              found = true;
            }
          }
          if (!found) {
            throw "subscription not found";
          }
          test.output("data had the subscription " + subscription_id);
          return test.helper("locations#subscriptions unsubscribe from location '1257285'", Instagram, 'locations', 'unsubscribe', {
            id: subscription_id
          }, function(data) {
            if (data !== null) {
              throw "location '1257285' unsubscribe failed";
            }
            return test.output("data was null; we unsubscribed from the subscription " + subscription_id);
          });
        });
      });
    },
    'media#subscriptions': function() {
      return test.helper("media#subscriptions subscribe to media near Eiffel Tower", Instagram, 'media', 'subscribe', {
        lat: 48.858844300000001,
        lng: 2.2943506,
        radius: 1000
      }, function(data) {
        var subscription_id;
        data.should.have.property('id');
        test.output("data had the property 'id'");
        data.id.should.be.above(0);
        test.output("data.id was greater than 0", data.id);
        data.should.have.property('type', 'subscription');
        test.output("data had the property 'type' equal to 'subscription'", data);
        subscription_id = data.id;
        return test.helper('media#subscriptions list', Instagram, 'subscriptions', 'list', {}, function(data) {
          var found, i;
          data.length.should.be.above(0);
          test.output("data had length greater than 0", data.length);
          found = false;
          for (i in data) {
            if (data[i].id === subscription_id) {
              found = true;
            }
          }
          if (!found) {
            throw "subscription not found";
          }
          test.output("data had the subscription " + subscription_id);
          return test.helper("media#subscriptions unsubscribe from media near Eiffel Tower", Instagram, 'media', 'unsubscribe', {
            id: subscription_id
          }, function(data) {
            if (data !== null) {
              throw "media near Eiffel Tower unsubscribe failed";
            }
            return test.output("data was null; we unsubscribed from the subscription " + subscription_id);
          });
        });
      });
    },
    'multi#subscriptions': function() {
      var subscriptions;
      subscriptions = [];
      return test.helper("subscriptions subscribe to tag 'red'", Instagram, 'subscriptions', 'subscribe', {
        object: 'tag',
        object_id: 'red'
      }, function(data) {
        data.should.have.property('id');
        test.output("data had the property 'id'");
        data.id.should.be.above(0);
        test.output("data.id was greater than 0", data.id);
        data.should.have.property('type', 'subscription');
        test.output("data had the property 'type' equal to 'subscription'", data);
        subscriptions[subscriptions.length] = data.id;
        return test.helper("subscriptions subscribe to location '1257285'", Instagram, 'subscriptions', 'subscribe', {
          object: 'location',
          object_id: '1257285'
        }, function(data) {
          data.should.have.property('id');
          test.output("data had the property 'id'");
          data.id.should.be.above(0);
          test.output("data.id was greater than 0", data.id);
          data.should.have.property('type', 'subscription');
          test.output("data had the property 'type' equal to 'subscription'", data);
          subscriptions[subscriptions.length] = data.id;
          return test.helper("subscriptions subscribe to media near Eiffel Tower", Instagram, 'subscriptions', 'subscribe', {
            object: 'geography',
            lat: 48.858844300000001,
            lng: 2.2943506,
            radius: 1000
          }, function(data) {
            data.should.have.property('id');
            test.output("data had the property 'id'");
            data.id.should.be.above(0);
            test.output("data.id was greater than 0", data.id);
            data.should.have.property('type', 'subscription');
            test.output("data had the property 'type' equal to 'subscription'", data);
            subscriptions[subscriptions.length] = data.id;
            return test.helper('subscriptions list', Instagram, 'subscriptions', 'list', {}, function(data) {
              var found, i, subscriptions_list, _ref;
              data.length.should.be.above(0);
              test.output("data had length greater than 0", data.length);
              subscriptions_list = [];
              for (i in data) {
                subscriptions_list[subscriptions_list.length] = data[i].id;
              }
              found = true;
              for (i in subscriptions) {
                if (_ref = subscriptions[i], __indexOf.call(subscriptions_list, _ref) < 0) {
                  found = false;
                }
              }
              if (!found) {
                throw "subscription not found";
              }
              test.output("data had the subscription " + subscription_id);
              return test.helper("subscriptions unsubscribe_all", Instagram, 'subscriptions', 'unsubscribe_all', {}, function(data) {
                if (data !== null) {
                  throw "unsubscribe_all failed";
                }
                return test.output("data was null; we unsubscribed from the subscriptions " + (subscriptions_list.join(', ')));
              });
            });
          });
        });
      });
    }
  };
  /*
  App Termination
  */
  for (i in module.exports) {
    to_do += 1;
  }
  iterations = 0;
  waiting = setInterval(function(){if(completed==to_do||iterations>to_do){clearInterval(waiting);app.close();}else{iterations+=1;}}, 1000);
}).call(this);

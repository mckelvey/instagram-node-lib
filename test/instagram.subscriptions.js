(function() {
  /*
  Setup Lib for Testing
  */  var CALLBACK_URL, HOST, Instagram, PATH, PORT, app, assert, callback, completed, express, i, indent, iterations, should, to_do, url, waiting;
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
  completed = 0;
  to_do = 0;
  indent = "   ";
  module.exports = {
    'tags#subscriptions': function() {
      var list, title, unsubscribe;
      title = "tags#subscriptions";
      unsubscribe = function(subscription_id) {
        return Instagram.tags.unsubscribe({
          id: subscription_id,
          complete: function(data) {
            console.log("\n" + title + " unsubscribe from " + subscription_id + "\n" + indent + "connection/parsing succeeded");
            try {
              assert.isNull(data);
              console.log("" + indent + "data met assertions");
              return completed += 1;
            } catch (e) {
              console.log("" + indent + "data failed to meet the assertion(s): " + e);
              throw e;
            }
          },
          error: function(e, data, caller) {
            console.log("\n" + title + " unsubscribe\n" + indent + "connection/parsing failed");
            console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
            throw e;
          }
        });
      };
      list = function(subscription_id) {
        return Instagram.subscriptions.list({
          complete: function(data) {
            console.log("\n" + title + " list\n" + indent + "connection/parsing succeeded");
            try {
              data.should.not.be.empty;
              console.log("" + indent + "data met assertions");
              return unsubscribe(subscription_id);
            } catch (e) {
              console.log("" + indent + "data failed to meet the assertion(s): " + e);
              throw e;
            }
          },
          error: function(e, data, caller) {
            console.log("\n" + title + " list\n" + indent + "connection/parsing failed");
            console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
            throw e;
          }
        });
      };
      return Instagram.tags.subscribe({
        object_id: 'blue',
        callback_url: CALLBACK_URL,
        complete: function(data) {
          console.log("\n" + title + " subscribe#blue\n" + indent + "connection/parsing succeeded");
          try {
            data.should.have.property('id');
            data.id.should.be.above(0);
            data.should.have.property('type', 'subscription');
            console.log("" + indent + "data met assertions");
            return list(data['id']);
          } catch (e) {
            console.log("" + indent + "data failed to meet the assertion(s): " + e);
            throw e;
          }
        },
        error: function(e, data, caller) {
          console.log("\n" + title + " subscribe#blue\n" + indent + "connection/parsing failed");
          console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
          throw e;
        }
      });
    },
    'locations#subscriptions': function() {
      var list, title, unsubscribe;
      title = "locations#subscriptions";
      unsubscribe = function(subscription_id) {
        return Instagram.locations.unsubscribe({
          id: subscription_id,
          complete: function(data) {
            console.log("\n" + title + " unsubscribe from " + subscription_id + "\n" + indent + "connection/parsing succeeded");
            try {
              assert.isNull(data);
              console.log("" + indent + "data met assertions");
              return completed += 1;
            } catch (e) {
              console.log("" + indent + "data failed to meet the assertion(s): " + e);
              throw e;
            }
          },
          error: function(e, data, caller) {
            console.log("\n" + title + " unsubscribe\n" + indent + "connection/parsing failed");
            console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
            throw e;
          }
        });
      };
      list = function(subscription_id) {
        return Instagram.subscriptions.list({
          complete: function(data) {
            console.log("\n" + title + " list\n" + indent + "connection/parsing succeeded");
            try {
              data.should.not.be.empty;
              console.log("" + indent + "data met assertions");
              return unsubscribe(subscription_id);
            } catch (e) {
              console.log("" + indent + "data failed to meet the assertion(s): " + e);
              throw e;
            }
          },
          error: function(e, data, caller) {
            console.log("\n" + title + " list\n" + indent + "connection/parsing failed");
            console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
            throw e;
          }
        });
      };
      return Instagram.locations.subscribe({
        object_id: '1257285',
        callback_url: CALLBACK_URL,
        complete: function(data) {
          console.log("\n" + title + " subscribe#1257285\n" + indent + "connection/parsing succeeded");
          try {
            data.should.have.property('id');
            data.id.should.be.above(0);
            data.should.have.property('type', 'subscription');
            console.log("" + indent + "data met assertions");
            return list(data['id']);
          } catch (e) {
            console.log("" + indent + "data failed to meet the assertion(s): " + e);
            throw e;
          }
        },
        error: function(e, data, caller) {
          console.log("\n" + title + " subscribe#1257285\n" + indent + "connection/parsing failed");
          console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
          throw e;
        }
      });
    },
    'media#subscriptions': function() {
      var list, title, unsubscribe;
      title = "media#subscriptions";
      unsubscribe = function(subscription_id) {
        return Instagram.media.unsubscribe({
          id: subscription_id,
          complete: function(data) {
            console.log("\n" + title + " unsubscribe from " + subscription_id + "\n" + indent + "connection/parsing succeeded");
            try {
              assert.isNull(data);
              console.log("" + indent + "data met assertions");
              return completed += 1;
            } catch (e) {
              console.log("" + indent + "data failed to meet the assertion(s): " + e);
              throw e;
            }
          },
          error: function(e, data, caller) {
            console.log("\n" + title + " unsubscribe\n" + indent + "connection/parsing failed");
            console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
            throw e;
          }
        });
      };
      list = function(subscription_id) {
        return Instagram.subscriptions.list({
          complete: function(data) {
            console.log("\n" + title + " list\n" + indent + "connection/parsing succeeded");
            try {
              data.should.not.be.empty;
              console.log("" + indent + "data met assertions");
              return unsubscribe(subscription_id);
            } catch (e) {
              console.log("" + indent + "data failed to meet the assertion(s): " + e);
              throw e;
            }
          },
          error: function(e, data, caller) {
            console.log("\n" + title + " list\n" + indent + "connection/parsing failed");
            console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
            throw e;
          }
        });
      };
      return Instagram.media.subscribe({
        lat: 48.858844300000001,
        lng: 2.2943506,
        radius: 1000,
        callback_url: CALLBACK_URL,
        complete: function(data) {
          console.log("\n" + title + " subscribe#48.858844300000001/2.2943506\n" + indent + "connection/parsing succeeded");
          try {
            data.should.have.property('id');
            data.id.should.be.above(0);
            data.should.have.property('type', 'subscription');
            console.log("" + indent + "data met assertions");
            return list(data['id']);
          } catch (e) {
            console.log("" + indent + "data failed to meet the assertion(s): " + e);
            throw e;
          }
        },
        error: function(e, data, caller) {
          console.log("\n" + title + " subscribe#48.858844300000001/2.2943506\n" + indent + "connection/parsing failed");
          console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
          throw e;
        }
      });
    },
    'subscriptions': function() {
      var list, subscribe_again, title, unsubscribe;
      title = "subscriptions";
      unsubscribe = function(ids) {
        return Instagram.subscriptions.unsubscribe_all({
          complete: function(data) {
            console.log("\n" + title + " unsubscribe_all\n" + indent + "connection/parsing succeeded");
            try {
              assert.isNull(data);
              console.log("" + indent + "data met assertions");
              return completed += 1;
            } catch (e) {
              console.log("" + indent + "data failed to meet the assertion(s): " + e);
              throw e;
            }
          },
          error: function(e, data, caller) {
            console.log("\n" + title + " unsubscribe_all\n" + indent + "connection/parsing failed");
            console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
            throw e;
          }
        });
      };
      list = function(ids) {
        return Instagram.subscriptions.list({
          complete: function(data) {
            console.log("\n" + title + " list\n" + indent + "connection/parsing succeeded");
            try {
              data.length.should.equal(2);
              console.log("" + indent + "data met assertions");
              return unsubscribe(ids);
            } catch (e) {
              console.log("" + indent + "data failed to meet the assertion(s): " + e);
              throw e;
            }
          },
          error: function(e, data, caller) {
            console.log("\n" + title + " list\n" + indent + "connection/parsing failed");
            console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
            throw e;
          }
        });
      };
      subscribe_again = function(ids) {
        return Instagram.subscriptions.subscribe({
          object: 'tag',
          object_id: 'green',
          complete: function(data) {
            console.log("\n" + title + " subscribe#green\n" + indent + "connection/parsing succeeded");
            try {
              data.should.have.property('id');
              data.id.should.be.above(0);
              data.should.have.property('type', 'subscription');
              console.log("" + indent + "data met assertions");
              ids[ids.length] = data['id'];
              return list(ids);
            } catch (e) {
              console.log("" + indent + "data failed to meet the assertion(s): " + e);
              throw e;
            }
          },
          error: function(e, data, caller) {
            console.log("\n" + title + " subscribe#green\n" + indent + "connection/parsing failed");
            console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
            throw e;
          }
        });
      };
      return Instagram.subscriptions.subscribe({
        object: 'tag',
        object_id: 'red',
        complete: function(data) {
          console.log("\n" + title + " subscribe#red\n" + indent + "connection/parsing succeeded");
          try {
            data.should.have.property('id');
            data.id.should.be.above(0);
            data.should.have.property('type', 'subscription');
            console.log("" + indent + "data met assertions");
            return subscribe_again([data['id']]);
          } catch (e) {
            console.log("" + indent + "data failed to meet the assertion(s): " + e);
            throw e;
          }
        },
        error: function(e, data, caller) {
          console.log("\n" + title + " subscribe#red\n" + indent + "connection/parsing failed");
          console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
          throw e;
        }
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

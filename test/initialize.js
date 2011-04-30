(function() {
  /*
  Initialize Instagram
  */  var CALLBACK_URL, HOST, Instagram, PATH, PORT, app, callback, express, url;
  Instagram = require('../lib/class.instagram');
  /*
  Setup App for Subscription Callbacks
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
  Add-on App Test Monitoring
  */
  app._tests_to_do = 0;
  app._tests_completed = 0;
  app._max_execution_time = 10;
  app.start_tests = function(tests) {
    var i, iterations, monitor;
    for (i in tests) {
      app._tests_to_do += 1;
    }
    iterations = 0;
    return monitor = setInterval(function(){if(app.fd==null){clearInterval(monitor);}else if((app._tests_completed==app._tests_to_do&&app._tests_completed!=0)||iterations>app._max_execution_time){clearInterval(monitor);app.close();}else{iterations+=1;}}, 1000);
  };
  app.finish_test = function() {
    return app._tests_completed += 1;
  };
  /*
  Exports
  */
  module.exports = {
    app: app,
    Instagram: Instagram
  };
}).call(this);

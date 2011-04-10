(function() {
  /*
  Setup Lib for Testing
  */  var Instagram, assert, completed, iterations, k, should, to_do, waiting;
  Instagram = require('../lib/class.instagram');
  /*
  Tests
  */
  assert = require('assert');
  should = require('should');
  to_do = 0;
  completed = 0;
  module.exports = {
    'tags#recent for /tags/blue/recent/media': function() {
      return Instagram.tags.recent({
        name: 'blue',
        complete: function(data) {
          var i;
          console.log('/tags/blue/recent/media');
          for (i in data) {
            console.log(data[i]['id']);
          }
          return completed += 1;
        }
      });
    },
    'tags#recent for /tags/blue/recent/media?max_id=50000000': function() {
      return Instagram.tags.recent({
        name: 'blue',
        max_id: 50000000,
        complete: function(data) {
          var i;
          console.log('/tags/blue/recent/media?max_id=50000000');
          for (i in data) {
            console.log(data[i]['id']);
          }
          return completed += 1;
        }
      });
    },
    'tags#recent for /tags/blue/recent/media?max_id=10000000': function() {
      return Instagram.tags.recent({
        name: 'blue',
        max_id: 10000000,
        complete: function(data) {
          var i;
          console.log('/tags/blue/recent/media?max_id=10000000');
          for (i in data) {
            console.log(data[i]['id']);
          }
          return completed += 1;
        }
      });
    },
    'tags#recent for /tags/blue/recent/media?max_id=1000000': function() {
      return Instagram.tags.recent({
        name: 'blue',
        max_id: 1000000,
        complete: function(data) {
          var i;
          console.log('/tags/blue/recent/media?max_id=1000000');
          for (i in data) {
            console.log(data[i]['id']);
          }
          return completed += 1;
        }
      });
    },
    'tags#recent for /tags/blue/recent/media?max_id=100000': function() {
      return Instagram.tags.recent({
        name: 'blue',
        max_id: 100000,
        complete: function(data) {
          var i;
          console.log('/tags/blue/recent/media?max_id=100000');
          for (i in data) {
            console.log(data[i]['id']);
          }
          return completed += 1;
        }
      });
    },
    'tags#recent for /tags/blue/recent/media?max_id=10000': function() {
      return Instagram.tags.recent({
        name: 'blue',
        max_id: 10000,
        complete: function(data) {
          var i;
          console.log('/tags/blue/recent/media?max_id=10000');
          for (i in data) {
            console.log(data[i]['id']);
          }
          return completed += 1;
        }
      });
    },
    'tags#recent for /tags/blue/recent/media?min_id=50000000': function() {
      return Instagram.tags.recent({
        name: 'blue',
        min_id: 50000000,
        complete: function(data) {
          var i;
          console.log('/tags/blue/recent/media?min_id=50000000');
          for (i in data) {
            console.log(data[i]['id']);
          }
          return completed += 1;
        }
      });
    },
    'tags#recent for /tags/blue/recent/media?min_id=10000000': function() {
      return Instagram.tags.recent({
        name: 'blue',
        min_id: 10000000,
        complete: function(data) {
          var i;
          console.log('/tags/blue/recent/media?min_id=10000000');
          for (i in data) {
            console.log(data[i]['id']);
          }
          return completed += 1;
        }
      });
    },
    'tags#recent for /tags/blue/recent/media?min_id=1000000': function() {
      return Instagram.tags.recent({
        name: 'blue',
        min_id: 1000000,
        complete: function(data) {
          var i;
          console.log('/tags/blue/recent/media?min_id=1000000');
          for (i in data) {
            console.log(data[i]['id']);
          }
          return completed += 1;
        }
      });
    },
    'tags#recent for /tags/blue/recent/media?min_id=100000': function() {
      return Instagram.tags.recent({
        name: 'blue',
        min_id: 100000,
        complete: function(data) {
          var i;
          console.log('/tags/blue/recent/media?min_id=100000');
          for (i in data) {
            console.log(data[i]['id']);
          }
          return completed += 1;
        }
      });
    },
    'tags#recent for /tags/blue/recent/media?min_id=10000': function() {
      return Instagram.tags.recent({
        name: 'blue',
        min_id: 10000,
        complete: function(data) {
          var i;
          console.log('/tags/blue/recent/media?min_id=10000');
          for (i in data) {
            console.log(data[i]['id']);
          }
          return completed += 1;
        }
      });
    }
  };
  /*
  Tests Reporting
  */
  console.log("\n   Instagram API Node.js Lib Tests :: Tags\n");
  for (k in module.exports) {
    to_do += 1;
    console.log("   " + k);
  }
  iterations = 0;
  waiting = setInterval(function(){if(completed==to_do||iterations>to_do){clearInterval(waiting);}else{iterations+=1;}}, 1000);
}).call(this);

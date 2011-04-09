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
    }
  };
  /*

    'tags#recent for blue with min_id': ->
      Instagram.tags.recent {
        name: 'blue'
        min_id: 5000000
        complete: (data) ->
          data.length.should.equal 20
          data[0].should.have.property 'id'
          console.log "with max_id: #{data.length}"
          console.log data[0]
          for i of data
            console.log data[i]['id']
          completed += 1
      }
    'tags#recent for blue with min_id': ->
      Instagram.tags.recent {
        name: 'blue'
        complete: (data) ->
          data.length.should.equal 20
          data[0].should.have.property 'id'
          completed += 1
      }

  */
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

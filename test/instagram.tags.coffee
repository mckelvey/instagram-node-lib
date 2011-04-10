
###
Setup Lib for Testing
###

Instagram = require '../lib/class.instagram'

###
Tests
###

assert = require 'assert'
should = require 'should'

to_do = 0
completed = 0

module.exports =
  'tags#info for blue': ->
    Instagram.tags.info {
      name: 'blue'
      complete: (data) ->
        data.should.have.property 'name', 'blue'
        data.media_count.should.be.above 0
        completed += 1
    }
  'tags#recent for blue': ->
    Instagram.tags.recent {
      name: 'blue'
      complete: (data) ->
        data.length.should.equal 20
        data[0].should.have.property 'id'
        completed += 1
    }
  'tags#search for blue': ->
    Instagram.tags.search {
      q: 'blue'
      complete: (data) ->
        data.length.should.equal 50
        data[0].should.have.property 'name', 'blue'
        data[0].media_count.should.be.above 0
        completed += 1
    }

###
Tests Reporting
###

console.log "\n   Instagram API Node.js Lib Tests :: Tags\n"
for k of module.exports
  to_do += 1
  console.log "   #{k}"

iterations = 0
waiting = setInterval `function(){if(completed==to_do||iterations>to_do){clearInterval(waiting);}else{iterations+=1;}}`, 1000

(function() {
  module.exports = function(title, Instagram, type, method, params, assertions) {
    var indent;
    if (title == null) {
      title = '';
    }
    if (params == null) {
      params = {};
    }
    indent = "   ";
    params['complete'] = function(data, pagination) {
      console.log("\n" + title + "\n" + indent + "connection/parsing succeeded");
      try {
        assertions(data, pagination);
        return console.log("" + indent + "data met assertions");
      } catch (e) {
        console.log("" + indent + "data failed to meet the assertion(s): " + e);
        throw e;
      }
    };
    params['error'] = function(e, data, caller) {
      console.log("\n" + title + "\n" + indent + "connection/parsing failed");
      console.log("" + indent + "error: " + e + "\n" + indent + "data: " + data + "\n" + indent + "caller: " + caller);
      throw e;
    };
    return Instagram[type][method](params);
  };
}).call(this);

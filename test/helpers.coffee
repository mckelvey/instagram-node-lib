
module.exports = (title = '', Instagram, type, method, params = {}, assertions) ->
  indent = "   "
  params['complete'] = (data) ->
    console.log "\n#{title}\n#{indent}connection/parsing succeeded"
    try
      assertions data
      console.log "#{indent}data met assertions"
    catch e
      console.log "#{indent}data failed to meet the assertion(s): #{e}"
  params['error'] = (e, data, caller) ->
    console.log "\n#{title}\n#{indent}connection/parsing failed"
    console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
  Instagram[type][method] params

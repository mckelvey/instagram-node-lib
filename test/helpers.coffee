
indent = "   "

module.exports =
  indent: indent
  helper: (title = '', Instagram, type, method, params = {}, assertions) ->
    params['complete'] = (data, pagination) ->
      console.log "\n#{title}\n#{indent}connection/parsing succeeded"
      try
        assertions data, pagination
        console.log "#{indent}data met assertions"
      catch e
        console.log "#{indent}data failed to meet the assertion(s): #{e}"
        throw e
    params['error'] = (e, data, caller) ->
      console.log "#{indent}error: #{e}\n#{indent}data: #{data}\n#{indent}caller: #{caller}"
      throw e
    Instagram[type][method] params
  output: (message, value = null) ->
    console.log "#{indent}#{message}"
    if value?
      if typeof value is 'object'
        console.log "#{indent}#{indent}it was: " + JSON.stringify(value)
      else
        console.log "#{indent}#{indent}it was: #{value}"

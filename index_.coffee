define = require('amdefine')(module)  if typeof define isnt 'function'

define ->
  exports = {}

  untilde = (str) ->
    str.replace /~./g, (m) ->
      switch m
        when "~0"
          return "~"
        when "~1"
          return "/"
      throw new Error("Invalid tilde escape: " + m)


  exports.traverse = (obj, pointer, value) ->
    # assert(isArray(pointer))
    part = untilde pointer.shift()
    return null  unless obj.hasOwnProperty part
    # keep traversin!
    return exports.traverse obj[part], pointer, value  if pointer.length isnt 0

    # we're done

    # just reading
    return obj[part]  if typeof value is "undefined"

    # set new value, return old value
    oldValue = obj[part]
    if value is null
      delete obj[part]
    else
      obj[part] = value
    oldValue


  exports.validateInput = (obj, pointer) ->
    throw new Error("Invalid input object.")  if typeof obj isnt "object"
    return []  if pointer is ""
    throw new Error("Invalid JSON pointer.")  unless pointer
    pointer = pointer.split("/")
    first = pointer.shift()
    throw new Error("Invalid JSON pointer.")  if first isnt ""
    pointer


  exports.get = (obj, pointer) ->
    pointer = exports.validateInput(obj, pointer)
    return obj  if pointer.length is 0
    exports.traverse obj, pointer


  exports.set = (obj, pointer, value) ->
    pointer = exports.validateInput obj, pointer
    throw new Error("Invalid JSON pointer for set.")  if pointer.length is 0
    exports.traverse obj, pointer, value


  exports

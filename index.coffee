define = require('amdefine')(module)  if typeof define isnt 'function'

define () ->
  "use strict"
  exports = {}

  traverse = (obj, pointer, callbackSet, callbackInnerSet) ->
    # assert(isArray(pointer))
    part = pointer.shift()
    [type, key] = part
    key = unescape key
    return obj  if key is ''

    if typeof obj[key] is 'undefined'
      callbackInnerSet obj, part  if typeof callbackInnerSet isnt 'undefined'
      #throw new Error("Value for pointer #{pointer} not found.")  if typeof obj[key] is 'undefined'
      return console.error("Value for pointer #{pointer} not found.")  if typeof obj[key] is 'undefined'
    # keep traversin!
    return traverse(obj[key], pointer, callbackSet, callbackInnerSet)  if pointer.length isnt 0
    previousValue = obj[key]
    callbackSet obj, part  if typeof callbackSet isnt 'undefined'
    previousValue


  validateInput = (obj, pointer) ->
    throw 'Invalid input - object or array needed.'  if typeof obj isnt 'object'
    throw 'Invalid JSON pointer.'  unless pointer


  parseReference = (reference) ->
    reference = reference.replace /\]/g, ''
    result  = []
    re = /[\[\.]?([^\[\.]+)/g
    while (match = re.exec reference) isnt null
      type = 'object'
      type = 'array'  if match[0][0] is '['
      result.push [type, match[1]]
    result


  parsePointer = (pointer) ->
    # maybe reference
    return parseReference(pointer)  if pointer[0] isnt '/'
    pointer = pointer.substring(1)
    pointer = pointer.split '/'
    result = []
    result.push ['unknown', item]  for item in pointer
    result


  exports.get = (obj, pointer) ->
    validateInput obj, pointer
    pointer = parsePointer pointer
    traverse obj, pointer


  exports.silentGet = (obj, pointer) ->
    try
      return exports.get(obj, pointer)
    catch e
      return


  exports.set = (obj, pointer, value, createPath) ->
    validateInput obj, pointer
    pointer = parsePointer pointer
    callbackSet = (obj, [type, key]) -> obj[key] = value
    if createPath
      callbackInnerSet = (obj, [type, key]) ->
        obj[key] = {}  if type is 'object'
        obj[key] = []  if type is 'array'
    traverse obj, pointer, callbackSet, callbackInnerSet


  exports.setCallback = (obj, pointer, callbackSet, callbackInnerSet) ->
    validateInput obj, pointer
    pointer = parsePointer pointer
    traverse obj, pointer, callbackSet, callbackInnerSet


  exports.remove = (obj, pointer) ->
    try
      exports.setCallback obj, pointer, (obj, [type, key]) ->
        if obj instanceof Array
          obj.splice key, 1
        else
          delete obj[key]
    catch e

  exports

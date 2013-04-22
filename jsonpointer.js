var untilde = function(str) {
  return str.replace(/~./g, function(m) {
    switch (m) {
      case "~0":
        return "~";
      case "~1":
        return "/";
    }
    throw new Error("Invalid tilde escape: " + m);
  });
};

var traverse = function(obj, pointer, value) {
  // assert(isArray(pointer))
  var part = untilde(pointer.shift());
  if(!obj.hasOwnProperty(part)) {
    return null;
  }
  if(pointer.length !== 0) { // keep traversin!
    return traverse(obj[part], pointer, value);
  }
  // we're done
  if(typeof value === "undefined") {
    // just reading
    return obj[part];
  }
  // set new value, return old value
  var oldValue = obj[part];
  if(value === null) {
    delete obj[part];
  } else {
    obj[part] = value;
  }
  return oldValue;
};

var validateInput = function(obj, pointer) {
  if(typeof obj !== "object") {
    throw new Error("Invalid input object.");
  }

  if(pointer === "") {
    return [];
  }

  if(!pointer) {
    throw new Error("Invalid JSON pointer.");
  }

  pointer = pointer.split("/");
  var first = pointer.shift();
  if (first !== "") {
    throw new Error("Invalid JSON pointer.");
  }

  return pointer;
};

var get = function(obj, pointer) {
  pointer = validateInput(obj, pointer);
  if (pointer.length === 0) {
    return obj;
  }
  return traverse(obj, pointer);
};

var set = function(obj, pointer, value) {
  pointer = validateInput(obj, pointer);
  if (pointer.length === 0) {
    throw new Error("Invalid JSON pointer for set.");
  }
  return traverse(obj, pointer, value);
};

exports.get = get;
exports.set = set;

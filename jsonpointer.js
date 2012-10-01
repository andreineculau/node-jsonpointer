/*jshint node:true, nonstandard:true*/
var traverse = function(obj, pointer, callbackSet, callbackInnerSet) {
    'use strict';
    var part;

    // assert(isArray(pointer))
    part = unescape(pointer.shift());

    if (typeof obj[part] === 'undefined') {
        if (typeof callbackInnerSet !== 'undefined') {
            callbackInnerSet(obj, part);
        }
        if (typeof obj[part] === 'undefined') {
            throw 'Value for pointer ' + pointer + ' not found.';
        }
    }

    if (pointer.length !== 0) { // keep traversin!
        return traverse(obj[part], pointer, callbackSet, callbackInnerSet);
    }

    if (typeof callbackSet !== 'undefined') {
        callbackSet(obj, part);
    }
    return obj[part];
};

var validateInput = function(obj, pointer) {
    'use strict';

    if (typeof obj !== 'object') {
        throw 'Invalid input - object or array needed.';
    }

    if (!pointer) {
        throw 'Invalid JSON pointer.';
    }
};

exports.get = function(obj, pointer) {
    'use strict';

    validateInput(obj, pointer);
    pointer = pointer.split('/').slice(1);
    return traverse(obj, pointer);
};

exports.silentGet = function(obj, pointer) {
    'use strict';

    try {
        return exports.get(obj, pointer);
    } catch(e) {
        return undefined;
    }
};

exports.set = function(obj, pointer, value) {
    'use strict';

    validateInput(obj, pointer);
    pointer = pointer.split('/').slice(1);
    return traverse(obj, pointer, function(obj, part) {
        obj[part] = value;
    });
};

exports.setCallback = function(obj, pointer, callbackSet, callbackInnerSet) {
    'use strict';

    validateInput(obj, pointer);
    pointer = pointer.split('/').slice(1);

    return traverse(obj, pointer, callbackSet, callbackInnerSet);
};

exports.del = function(obj, pointer) {
    'use strict';

    return exports.setCallback(obj, pointer, function(obj, part) {
        if (obj instanceof Array) {
            obj.splice(part, 1);
        } else {
            delete obj[part];
        }
    });
};

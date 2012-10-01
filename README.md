# JSON Pointer for nodejs

This is an implementation of [JSON Pointer](http://tools.ietf.org/html/draft-ietf-appsawg-json-pointer-04).


## Usage

```js
var jsonpointer = require('jsonpointer'),
    instance = {
        foo: 1,
        bar: {
            baz: 2
        },
        qux: [3, 4, 5]
    };

jsonpointer.get(instance, '/foo');
jsonpointer.get(instance, '/bar/baz');
jsonpointer.get(instance, '/qux/0');

jsonpointer.set(instance, '/qux/0', 6);
jsonpointer.del(instance, '/qux/2');
```


## Author

(c) 2011 Jan Lehnardt <jan@apache.org>
(c) 2012 Andrei Neculau <@andreineculau>


## License

[MIT](http://opensource.org/licenses/MIT)

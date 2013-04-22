# JSON getter and setter

This is an implementation of [JSON Pointer](http://tools.ietf.org/html/rfc6901).

## Usage

```coffee
jsongetset = require "jsongetset"
obj = { foo: 1, bar: { baz: 2}, qux: [3, 4, 5]}
one = jsongetset.get obj, "/foo"
two = jsongetset.get obj, "/bar/baz"
three = jsongetset.get obj, "/qux/0"
four = jsongetset.get obj, "/qux/1"
five = jsongetset.get obj, "/qux/2"
notfound = jsongetset.get obj, "/quo" # returns null

jsongetset.set obj, "/foo", 6 # obj.foo = 6

## License

MIT License.

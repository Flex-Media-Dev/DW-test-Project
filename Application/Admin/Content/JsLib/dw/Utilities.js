'use strict';
/* ++++++ Registering namespace ++++++ */

if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = {};
}

if (typeof (Dynamicweb.Utilities) == 'undefined') {
    Dynamicweb.Utilities = {};
}

/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.Utilities.TypeHelper = {};

Dynamicweb.Utilities.TypeHelper.clone = function (object) {
    /// <summary>Create a copy of the set of matched elements.</summary>
    /// <param name="object">The value to be cloned.</param>

    return this.extend({}, object);
};

Dynamicweb.Utilities.TypeHelper.compare = function () {
    var leftChain, rightChain;

    var compare2Objects = function (x, y) {
        var p;

        // remember that NaN === NaN returns false
        // and isNaN(undefined) returns true
        if (isNaN(x) && isNaN(y) && typeof x === 'number' && typeof y === 'number') {
            return true;
        }

        // Compare primitives and functions.     
        // Check if both arguments link to the same object.
        // Especially useful on step when comparing prototypes
        if (x === y) {
            return true;
        }

        // Works in case when functions are created in constructor.
        // Comparing dates is a common scenario. Another built-ins?
        // We can even handle functions passed across iframes
        if ((typeof x === 'function' && typeof y === 'function') ||
           (x instanceof Date && y instanceof Date) ||
           (x instanceof RegExp && y instanceof RegExp) ||
           (x instanceof String && y instanceof String) ||
           (x instanceof Number && y instanceof Number)) {
            return x.toString() === y.toString();
        }

        // At last checking prototypes as good a we can
        if (!(x instanceof Object && y instanceof Object)) {
            return false;
        }

        if (x.isPrototypeOf(y) || y.isPrototypeOf(x)) {
            return false;
        }

        if (x.constructor !== y.constructor) {
            return false;
        }

        if (x.prototype !== y.prototype) {
            return false;
        }

        // check for infinitive linking loops
        if (leftChain.indexOf(x) > -1 || rightChain.indexOf(y) > -1) {
            return false;
        }

        // Quick checking of one object beeing a subset of another.
        // todo: cache the structure of arguments[0] for performance
        for (p in y) {
            if (y.hasOwnProperty(p) !== x.hasOwnProperty(p)) {
                return false;
            }
            else if (typeof y[p] !== typeof x[p]) {
                return false;
            }
        }

        for (p in x) {
            if (y.hasOwnProperty(p) !== x.hasOwnProperty(p)) {
                return false;
            }
            else if (typeof y[p] !== typeof x[p]) {
                return false;
            }

            switch (typeof (x[p])) {
                case 'object':
                case 'function':

                    leftChain.push(x);
                    rightChain.push(y);

                    if (!compare2Objects(x[p], y[p])) {
                        return false;
                    }

                    leftChain.pop();
                    rightChain.pop();
                    break;

                default:
                    if (x[p] !== y[p]) {
                        return false;
                    }
                    break;
            }
        }

        return true;
    };

    if (arguments.length < 1) {
        return true; //Die silently? Don't know how to handle such case, please help...
        // throw "Need two or more arguments to compare";
    }

    for (var i = 1, l = arguments.length; i < l; i++) {
        leftChain = []; //todo: this can be cached
        rightChain = [];

        if (!compare2Objects(arguments[0], arguments[i])) {
            return false;
        }
    }

    return true;
};

Dynamicweb.Utilities.TypeHelper.extend = function (object, source) {
    /// <summary>Merge the contents of two objects together into the first object.</summary>
    /// <param name="object">The object to extend. It will receive the new properties.</param>
    /// <param name="source">An object containing additional properties to merge in.</param>

    for (var property in source) {
        object[property] = source[property];
    }

    return object;
};

Dynamicweb.Utilities.TypeHelper.isUndefined = function (object) {
    /// <summary>Determines if a reference is an `Undefined`.</summary>
    /// <param name="object">The value to be tested.</param>

    return typeof object === 'undefined';
};

Dynamicweb.Utilities.TypeHelper.isNull = function (object) {
    /// <summary>Determines if a reference is a `Null`.</summary>
    /// <param name="object">The value to be tested.</param>

    return object === null;
};

Dynamicweb.Utilities.TypeHelper.isObject = function (object) {
    /// <summary>Determines if a reference is an `Object`.</summary>
    /// <param name="object">The value to be tested.</param>

    return object !== null && typeof object === 'object';
};

Dynamicweb.Utilities.TypeHelper.isBoolean = function (object) {
    /// <summary>Determines if a reference is an `Boolean`.</summary>
    /// <param name="object">The value to be tested.</param>

    return typeof object === 'boolean';
};

Dynamicweb.Utilities.TypeHelper.isString = function (object) {
    /// <summary>Determines if a reference is an `String`.</summary>
    /// <param name="object">The value to be tested.</param>

    return typeof object === 'string';
};

Dynamicweb.Utilities.TypeHelper.isNumber = function (object) {
    /// <summary>Determines if a reference is an `Number`.</summary>
    /// <param name="object">The value to be tested.</param>

    return typeof object == 'number' ||
      object && typeof object == 'object' && Object.prototype.toString.call(object) == '[object Number]' || false;
};

Dynamicweb.Utilities.TypeHelper.isDate = function (object) {
    return object && typeof object == 'object' && Object.prototype.toString.call(object) == '[object Date]' || false;
};

Dynamicweb.Utilities.TypeHelper.isFunction = function (object) {
    /// <summary>Determines if a reference is an `Function`.</summary>
    /// <param name="object">The value to be tested.</param>

    return typeof object === 'function';
};

Dynamicweb.Utilities.TypeHelper.isArray = function (object) {
    /// <summary>Determines if a reference is an `Array`.</summary>
    /// <param name="object">The value to be tested.</param>

    return Object.prototype.toString.call(object) === '[object Array]';
};

Dynamicweb.Utilities.TypeHelper.isElement = function (object) {
    /// <summary>Determines if a reference is an `HTMLElement`.</summary>
    /// <param name="object">The value to be tested.</param>

    return !!(object && object.nodeType == 1);
};

Dynamicweb.Utilities.TypeHelper.isNodeList = function (value) {
    /// <summary>Determines if a reference is an `Node List`.</summary>
    /// <param name="object">The value to be tested.</param>
    return Object.prototype.toString.call(value) === '[object NodeList]';
}

Dynamicweb.Utilities.TypeHelper.isHTMLCollection = function (value) {
    /// <summary>Determines if a reference is an `HTML Collection`.</summary>
    /// <param name="object">The value to be tested.</param>
    return Object.prototype.toString.call(value) === '[object HTMLCollection]';
}

Dynamicweb.Utilities.TypeHelper.isEnumerable = function (value) {
    return this.isArray(value) || this.isObject(value);
};

Dynamicweb.Utilities.TypeHelper.isEmpty = function (object) {
    /// <summary>Determines if a object is empty.</summary>
    /// <param name="object">The value to be tested.</param>

    var result = false;


    if (this.isUndefined(object) || this.isNull(object)) {
        result = true;
    } else if (this.isString(object)) {
        result = object === '';
    } else if (this.isNumber(object)) {
        result = object === 0;
    } else if (this.isArray(object)) {
        result = object.length === 0;
    } else if (this.isObject(object)) {
        result = true;
        Dynamicweb.Utilities.CollectionHelper.forEach(object, function () { result = false; return false; });
    }

    return result;
};

Dynamicweb.Utilities.TypeHelper.isInstanceOf = function (object, type) {
    /// <summary>Determines if a object is instance of specifed type.</summary>
    /// <param name="object">The value to be tested.</param>
    /// <param name="type">The type to test with.</param>

    return object instanceof type;
};

Dynamicweb.Utilities.CollectionHelper = {};

Dynamicweb.Utilities.CollectionHelper.any = function (source, criteria, thisArg) {
    var result = false;

    if (!Dynamicweb.Utilities.TypeHelper.isFunction(criteria)) {
        return result;
    }

    this.forEach(source, function (value, key) {
        result = criteria.call(this, value, key);

        if (result === true) {
            return false;
        }
    }, thisArg);

    return result;
};

Dynamicweb.Utilities.CollectionHelper.all = function (source, criteria, thisArg) {
    var total = 0,
        valid = 0;

    if (!Dynamicweb.Utilities.TypeHelper.isFunction(criteria)) {
        return false;
    }

    this.forEach(source, function (value, key) {
        if (criteria.call(this, value, key) === true) {
            valid += 1;
        }

        total += 1;
    }, thisArg);

    return total === valid;
};

Dynamicweb.Utilities.CollectionHelper.count = function (source) {
    var typeHelper = Dynamicweb.Utilities.TypeHelper,
        result = 0;

    if (typeHelper.isArray(source)) {
        result = source.length;
    } else if (typeHelper.isObject(source)) {
        result = this.keys(source).length;
    }

    return result;
};

Dynamicweb.Utilities.CollectionHelper.forEach = function (source, callback, thisArg) {
    /// <summary>Iterates over elements of a 'source', executing the 'callback' for each element.</summary>
    var i,
        len,
        typeHelper = Dynamicweb.Utilities.TypeHelper;

    thisArg || (thisArg = source);

    if (typeHelper.isUndefined(source)) {
        return;
    }

    if (!typeHelper.isFunction(callback)) {
        return;
    }

    if (typeHelper.isArray(source) || typeHelper.isNodeList(source)) {
        len = source.length;
        for (i = 0; i < len; i += 1) {
            if (callback.call(thisArg, source[i], i, source) === false) {
                break;
            }
        }
    } else {
        for (i in source) {
            if (source.hasOwnProperty(i)) {
                if (callback.call(thisArg, source[i], i, source) === false) {
                    break;
                }
            }
        }
    }
};

Dynamicweb.Utilities.CollectionHelper.forEachRange = function (source, callback, skip, take, thisArg) {
    /// <summary>Iterates over specified range of elements from a 'source', executing the 'callback' for each element.</summary>
    var typeHelper = Dynamicweb.Utilities.TypeHelper,
        current, startIndex, endIndex, len;

    if (!typeHelper.isFunction(callback)) {
        return;
    }

    if (typeHelper.isUndefined(skip)) {
        skip = 0;
    }

    if (typeHelper.isUndefined(take)) {
        take = this.count(source);
    }

    thisArg || (thisArg = this);

    startIndex = skip;
    endIndex = startIndex + take;

    if (typeHelper.isArray(source) || typeHelper.isNodeList(source)) {

        if (startIndex < 0) {
            startIndex = 0;
        }

        len = source.length;
        if (endIndex > len) {
            endIndex = len;
        }

        for (current = startIndex; current < endIndex; current += 1) {
            if (callback.call(thisArg, source[current], current) === false) {
                break;
            }
        }
    } else {
        source = this.values(source);
        this.forEachRange(source, skip, take, thisArg);
    }
};

Dynamicweb.Utilities.CollectionHelper.first = function (source, criteria, thisArg) {
    var result;

    if (!Dynamicweb.Utilities.TypeHelper.isFunction(criteria)) {
        criteria = function () { return true; };
    }

    this.forEach(source, function (value, key) {
        if (criteria.call(this, value, key) === true) {
            result = value;
            return false;
        }
    }, thisArg);

    return result;
};

Dynamicweb.Utilities.CollectionHelper.last = function (source, criteria, thisArg) {
    var result;

    if (!Dynamicweb.Utilities.TypeHelper.isFunction(criteria)) {
        criteria = function () { return true; };
    }

    this.forEach(source, function (value, key) {
        if (criteria.call(this, value, key) === true) {
            result = value;
        }
    }, thisArg);

    return result;
};

Dynamicweb.Utilities.CollectionHelper.find = function (source, criteria, thisArg) {
    var result;

    if (!Dynamicweb.Utilities.TypeHelper.isFunction(criteria)) {
        return result;
    }

    this.forEach(source, function (value, index) {
        if (criteria.call(this, value, index) === true) {
            result = value;
            return false;
        }
    }, thisArg);

    return result;
};

Dynamicweb.Utilities.CollectionHelper.merge = function () {
    /// <summary>Merges arrays.</summary>
    var index = -1,
        arr,
        args = arguments,
        len = args.length,
        typeHelper = Dynamicweb.Utilities.TypeHelper,
        result = [];

    for (index = 0; index < len; index += 1) {
        arr = args[index];

        if (typeHelper.isArray(arr)) {
            result = result.concat(arr);
        }
    }

    return result;
};

Dynamicweb.Utilities.CollectionHelper.select = function (source, callback, thisArg) {
    /// <summary>Projects each element of a sequence into a new form and returns array.</summary>
    var result = [];

    if (!Dynamicweb.Utilities.TypeHelper.isFunction(callback)) {
        return result;
    }

    this.forEach(source, function (element, index) {
        result.push(callback.call(this, element, index));
    }, thisArg);

    return result;
};

Dynamicweb.Utilities.CollectionHelper.slice = function (source, start, end) {
    /// <summary>Slices the `source` from the `start` index up to, but not including, the `end` index. </summary>
    var typeHelper = Dynamicweb.Utilities.TypeHelper;
    start || (start = 0);

    if (typeHelper.isUndefined(end)) {
        end = source ? source.length : 0;
    }
    var index = -1,
        length = end - start || 0,
        result = new Array(length < 0 ? 0 : length);

    while (++index < length) {
        result[index] = source[start + index];
    }
    return result;
};

Dynamicweb.Utilities.CollectionHelper.keys = function (source) {
    /// <summary>
    /// Returns an array of a given object's own enumerable properties,
    /// in the same order as that provided by a for...in loop
    ///</summary>
    var hasOwnProperty = Object.prototype.hasOwnProperty,
        hasDontEnumBug = !({ toString: null }).propertyIsEnumerable('toString'),
        typeHelper = Dynamicweb.Utilities.TypeHelper,
        dontEnums = [
            'toString',
            'toLocaleString',
            'valueOf',
            'hasOwnProperty',
            'isPrototypeOf',
            'propertyIsEnumerable',
            'constructor'
        ],
        dontEnumsLength = dontEnums.length,
        result = [],
        prop,
        i;

    if (typeHelper.isUndefined(source) || typeHelper.isNull(source) || typeHelper.isFunction(source) || typeHelper.isString(source)) {
        return result;
    }

    for (prop in source) {
        if (hasOwnProperty.call(source, prop)) {
            result.push(prop);
        }
    }

    if (hasDontEnumBug) {
        for (i = 0; i < dontEnumsLength; i++) {
            if (hasOwnProperty.call(source, dontEnums[i])) {
                result.push(dontEnums[i]);
            }
        }
    }
    return result;
};

Dynamicweb.Utilities.CollectionHelper.values = function (source) {
    /// <summary>
    /// Creates a sorted array of property names of all enumerable properties, own
    /// and inherited, of `object` that have function values.
    ///</summary>
    var index = -1,
        props = this.keys(source),
        length = props.length,
        result = new Array(length);

    while (++index < length) {
        result[index] = source[props[index]];
    }
    return result;
},

Dynamicweb.Utilities.CollectionHelper.toArray = function (source) {
    /** Converts the `collection` to an array. **/
    var res,
         typeHelper = Dynamicweb.Utilities.TypeHelper;;

    if (typeHelper.isUndefined(source)) {
        res = [];
    } else if (typeHelper.isString(source)) {
        res = source.split('');
    } else if (typeHelper.isArray(source)) {
        res = this.slice(source);
    } else {
        res = this.values(source);
    }

    return res;
}

Dynamicweb.Utilities.CollectionHelper.where = function (source, criteria, thisArg) {
    var result = [];

    if (!Dynamicweb.Utilities.TypeHelper.isFunction(criteria)) {
        return result;
    }

    this.forEach(source, function (value, key) {
        if (criteria.call(this, value, key) === true) {
            result.push(value);
        }
    }, thisArg);

    return result;
};

Dynamicweb.Utilities.CollectionHelper.reduce = function (source, callback, accumulator, thisArg) {
    var typeHelper = Dynamicweb.Utilities.TypeHelper,
        noaccum = arguments.length < 3;

    if (typeHelper.isArray(source)) {
        var index = -1,
            length = source.length;

        if (noaccum) {
            accumulator = source[++index];
        }

        while (++index < length) {
            accumulator = callback(accumulator, source[index], index, source);
        }
    } else {
        this.forEach(source, function (value, index, collection) {
            accumulator = noaccum
              ? (noaccum = false, value)
              : callback(accumulator, value, index, collection)
        });
    }
    return accumulator;
};

Dynamicweb.Utilities.FuncHelper = {};

Dynamicweb.Utilities.FuncHelper.proxy = function (func, thisArg) {
    if (!Dynamicweb.Utilities.TypeHelper.isFunction(func)) {
        return undefined;
    }

    return (function (callback, context) {
        return function () {
            callback.apply(context || this, arguments);
        };
    })(func, thisArg);
};

Dynamicweb.Utilities.StringHelper = {};

Dynamicweb.Utilities.StringHelper.fileName = function (path) {
    return path.replace(/^.*[\\\/]/, '');
};

Dynamicweb.Utilities.StringHelper.filePath = function (path) {
    return path.replace(this.fileName(path), '');
};

Dynamicweb.Utilities.StringHelper.fileExtension = function (filename) {
    return filename.split('.').pop();
};

Dynamicweb.Utilities.StringHelper.startsWith = function (str1, str2) {
    return str1.substring(0, str2.length) === str2;
};

Dynamicweb.Utilities.StringHelper.endsWith = function (str1, str2) {
    return str1.substr(str1.length - str2.length) === str2;
};

Dynamicweb.Utilities.StringHelper.trim = function (str) {
    var s;

    if (Dynamicweb.Utilities.TypeHelper.isUndefined(str.trim)) {
        s = str.replace(/(^\s*|\s*$)/g, '')
    } else {
        s = str.trim()
    }

    return s;
};

Dynamicweb.Utilities.StringHelper.dasherize = function (str) {
    return this.trim(str).replace(/[_\s]+/g, '-').replace(/([A-Z])/g, '-$1').replace(/-+/g, '-').toLowerCase();
};

Dynamicweb.Utilities.StringHelper.removeLineTerminators = function (str) {
    //info: http://bclary.com/2004/11/07/#a-7.3
    return str.replace(/[\u000A\u000D\u2028\u2029]/g, '');
}

Dynamicweb.Utilities.Hashtable = function () {
    /// <summary>Represents a hashtable.</summary>

    this._data = {};
    this._length = null;
}

Dynamicweb.Utilities.Hashtable.prototype.get_data = function () {
    /// <summary>Gets the underlying data object.</summary>

    this._length = null; //in case of data changing.
    return this._data;
}

Dynamicweb.Utilities.Hashtable.prototype.get_keys = function () {
    /// <summary>Gets the collection of hashtable keys.</summary>

    var ret = [];

    for (var key in this.get_data()) {
        ret[ret.length] = key;
    }

    return ret;
}

Dynamicweb.Utilities.Hashtable.prototype.get_values = function () {
    /// <summary>Gets the collection of hashtable values.</summary>

    var ret = [];
    var keys = this.get_keys();

    for (var i = 0; i < keys.length; i++) {
        ret[ret.length] = this.get(keys[i]);
    }

    return ret;
}

Dynamicweb.Utilities.Hashtable.prototype.get = function (name) {
    /// <summary>Gets the value of the item with the given name.</summary>
    /// <param name="name">Name of the item.</param>

    return this._data[name];
}

Dynamicweb.Utilities.Hashtable.prototype.contains = function (name) {
    /// <summary>Determines whether specified item exists within the hashtable.</summary>
    /// <param name="name">Name of the item.</param>

    var item = null;
    var ret = false;

    if (name) {
        item = this.get(name);
        ret = item != null;
        if (ret && typeof (item.toLowerCase) != 'undefined') {
            ret = item.length > 0;
        }
    }

    return ret;
}

Dynamicweb.Utilities.Hashtable.prototype.set = function (name, value) {
    /// <summary>Sets the given value for the item with the given name.</summary>
    /// <param name="name">Name of the item.</param>
    /// <param name="value">Item value.</param>

    this._length = this.get_count() + 1;
    this._data[name] = value;
}

Dynamicweb.Utilities.Hashtable.prototype.remove = function (name) {
    /// <summary>Removes item with the given name.</summary>
    /// <param name="name">Name of the item.</param>

    this._length = this.get_count() - 1;
    this._data[name] = null;
}

Dynamicweb.Utilities.Hashtable.prototype.merge = function (another) {
    /// <summary>Merges contents of the current object with contents from another object.</summary>
    /// <param name="another">Another object.</param>

    var data = null;
    this._length = null;

    if (another) {
        if (typeof (another.get_data) == 'function') {
            data = another.get_data();
        } else {
            data = another;
        }

        for (var name in another) {
            if (typeof (another[name]) != 'function' && !this._data[name]) {
                this.set(name, another[name]);
            }
        }
    }
}

Dynamicweb.Utilities.Hashtable.prototype.clear = function () {
    /// <summary>Removes all elements from this Hashtable.</summary>

    this._length = 0;
    this._data = {};
};

Dynamicweb.Utilities.Hashtable.prototype.get_count = function () {
    /// <summary>Gets the number of elements in the hashtable.</summary>

    if (typeof this._length !== 'number') {
        this._length = this.get_keys().length;
    }

    return this._length;
};

Dynamicweb.Utilities.Hashtable.prototype.forEach = function (callback, thisArg) {
    /// <summary>Iterates all values and keys.</summary>

    Dynamicweb.Utilities.CollectionHelper.forEach(this.get_data(), callback, thisArg);
};

Dynamicweb.Utilities.Dictionary = function () {
    this.clear();
};

Dynamicweb.Utilities.Dictionary.prototype.add = function (key, value) {
    var pair;

    if (this._indexes[key]) {
        throw 'Key is not unique!';
    }

    pair = { key: key, value: value };
    this._indexes[key] = pair;
    this._storage.push(pair);
};

Dynamicweb.Utilities.Dictionary.prototype.any = function (criteria, thisArg) {
    var result = false;

    if (!Dynamicweb.Utilities.TypeHelper.isFunction(criteria)) {
        return result;
    }

    this.forEach(function (value, key) {
        result = criteria.call(this, value, key);

        if (result === true) {
            return false;
        }
    }, thisArg);

    return result;
};

Dynamicweb.Utilities.Dictionary.prototype.all = function (criteria, thisArg) {
    var total = 0,
        valid = 0;

    if (!Dynamicweb.Utilities.TypeHelper.isFunction(criteria)) {
        return false;
    }

    this.forEach(function (value, key) {
        if (criteria.call(this, value, key) === true) {
            valid += 1;
        }

        total += 1;
    }, thisArg);

    return total === valid;
};

Dynamicweb.Utilities.Dictionary.prototype.clear = function () {
    this._indexes = {},
    this._storage = [];
};

Dynamicweb.Utilities.Dictionary.prototype.containsKey = function (key) {
    return typeof this._indexes[key] !== 'undefined';
};

Dynamicweb.Utilities.Dictionary.prototype.count = function () {
    return this._storage.length;
};

Dynamicweb.Utilities.Dictionary.prototype.first = function (criteria, thisArg) {
    var result;

    if (!Dynamicweb.Utilities.TypeHelper.isFunction(criteria)) {
        result = this._storage[0];

        return result ? result.value : undefined;
    }

    this.forEach(function (value, key) {
        if (criteria.call(this, value, key) === true) {
            result = value;
            return false;
        }
    }, thisArg);

    return result;
};

Dynamicweb.Utilities.Dictionary.prototype.last = function (criteria, thisArg) {
    var result,
        count = 0;

    if (!Dynamicweb.Utilities.TypeHelper.isFunction(criteria)) {
        result = this._storage[this._storage.length - 1];

        return result ? result.value : undefined;
    }

    count = this._storage.length;
    this.forEach(function (value, key) {
        if (criteria.call(this, value, key) === true) {
            count -= 1;

            if (count === 0) {
                result = value;
                return false;
            }
        }
    }, thisArg);

    return result;
};

Dynamicweb.Utilities.Dictionary.prototype.forEach = function (callback, thisArg) {
    if (!Dynamicweb.Utilities.TypeHelper.isFunction(callback)) {
        return;
    }

    Dynamicweb.Utilities.CollectionHelper.forEach(this._storage, function (pair) {
        return callback.call(this, pair.value, pair.key);
    }, thisArg);
};

Dynamicweb.Utilities.Dictionary.prototype.forEachRange = function (callback, skip, take, thisArg) {
    Dynamicweb.Utilities.CollectionHelper.forEachRange(this._storage, function (pair) {
        return callback.call(thisArg || this, pair.value, pair.key);
    }, skip, take, this);
};

Dynamicweb.Utilities.Dictionary.prototype.get = function (key) {
    var result, pair;

    pair = this._indexes[key];

    if (pair) {
        result = pair.value;
    }

    return result;
};

Dynamicweb.Utilities.Dictionary.prototype.select = function (callback, thisArg) {
    thisArg || (thisArg = this);

    return Dynamicweb.Utilities.CollectionHelper.select(this._storage, function (pair) {
        return callback.call(this, pair.value, pair.key);
    }, thisArg);
};

Dynamicweb.Utilities.Dictionary.prototype.keys = function () {
    return Dynamicweb.Utilities.CollectionHelper.keys(this._indexes);
};

Dynamicweb.Utilities.Dictionary.prototype.remove = function (key) {
    var pair, index;
    if (this.containsKey(key)) {
        pair = this._indexes[key];
        delete this._indexes[key];
        index = this._storage.indexOf(pair);

        if (index > -1) {
            this._storage.splice(index, 1);
        }
    }
};

Dynamicweb.Utilities.Dictionary.prototype.values = function () {
    var result = [];

    this.forEach(function (value) { result.push(value); });

    return result;
};

Dynamicweb.Utilities.Dictionary.prototype.where = function (criteria, thisArg) {
    var result = [];

    if (!Dynamicweb.Utilities.TypeHelper.isFunction(criteria)) {
        return result;
    }

    this.forEach(function (value, key) {
        if (criteria.call(this, value, key) === true) {
            result.push(value);
        }
    }, thisArg);

    return result;
};

Dynamicweb.Utilities.Dictionary.prototype.orderBy = function (compareFunction) {
    return this._storage.sort(compareFunction);
};

Dynamicweb.Utilities.Dictionary.prototype.orderByDescending = function (compareFunction) {
    return this.orderBy(compareFunction).reverse();
};

Dynamicweb.Utilities.RequestQueueItem = function (context, callback, args) {
    /// <summary>Represents a queue item.</summary>
    /// <param name="context">Execution context.</param>
    /// <param name="callback">Function to be executed.</param>
    /// <param name="arguments">An array of function arguments.</param>

    this.context = context;
    this.callback = callback;
    this.arguments = args;
}

Dynamicweb.Utilities.RequestQueue = function () {
    /// <summary>Represents a queue that can sequentially execute asynchronous methods.</summary>

    this.list = [];
}

Dynamicweb.Utilities.RequestQueue.prototype.add = function (context, callback, args) {
    /// <summary>Adds new item to the queue.</summary>
    /// <param name="context">Execution context.</param>
    /// <param name="callback">Function to be executed.</param>
    /// <param name="arguments">An array of function arguments.</param>

    this.enqueue(new Dynamicweb.Utilities.RequestQueueItem(context, callback, args));
}

Dynamicweb.Utilities.RequestQueue.prototype.executeAll = function () {
    /// <summary>Executes all requests within the queue.</summary>

    return this.next();
}

Dynamicweb.Utilities.RequestQueue.prototype.execute = function (context, callback, args) {
    /// <summary>Executes specified item.</summary>
    /// <param name="context">Execution context.</param>
    /// <param name="callback">Function to be executed.</param>
    /// <param name="arguments">An array of function arguments.</param>

    if (typeof (callback) == 'function')
        callback.apply(context, args);
}

Dynamicweb.Utilities.RequestQueue.prototype.next = function () {
    /// <summary>Forces the queue to execute next item.</summary>

    var ret = true;
    var next = this.dequeue();

    if (next != null) {
        this.execute(next.context, next.callback, next.arguments);
    } else {
        ret = false;
    }

    return ret;
}

Dynamicweb.Utilities.RequestQueue.prototype.enqueue = function (item) {
    /// <summary>Puts new item into the queue.</summary>
    /// <param name="item">Item to add.</param>

    if (!this.exists(item)) {
        if (!this.list)
            this.list = [];

        this.list[this.list.length] = item;
    }
}

Dynamicweb.Utilities.RequestQueue.prototype.dequeue = function () {
    /// <summary>Returns the first item from the queue.</summary>

    var ret = null;
    var newList = [];

    if (this.list && this.list.length > 0) {
        ret = this.list[0];

        for (var i = 1; i < this.list.length; i++) {
            newList[newList.length] = this.list[i];
        }

        this.list = newList;
    }

    return ret;
}

Dynamicweb.Utilities.RequestQueue.prototype.exists = function (item) {
    /// <summary>Determines whether specified item exists in the queue.</summary>
    /// <param name="item">Item to examine.</param>

    var ret = false;

    if (this.list) {
        for (var i = 0; i < this.list.length; i++) {
            if (this.list[i] == item) {
                ret = true;
                break;
            }
        }
    }

    return ret;
}

Dynamicweb.Utilities.RequestQueue.prototype.clear = function () {
    /// <summary>Clears the queue.</summary>

    this.list = [];
}

Dynamicweb.Utilities.ResizeHandleDirection = {
    Vertical: 1,
    Horizontal: 2
}

Dynamicweb.Utilities.ResizeHandle = function (content, direction) {
    this.content = content;
    this.direction = direction;
    this.prevCoordinates = null;

    this.minimumSize = 0;
    this.maximumSize = 300;
}

Dynamicweb.Utilities.ResizeHandle._handleIDs = [];
Dynamicweb.Utilities.ResizeHandle._activeHandle = null;
Dynamicweb.Utilities.ResizeHandle._globalEventsHandled = false;

Dynamicweb.Utilities.ResizeHandle.attach = function (params) {
    var body = null;
    var handle = null;
    var content = null;
    var handleObj = null;
    var minSize = 0, maxSize = 300;
    var direction = Dynamicweb.Utilities.ResizeHandleDirection.Horizontal;

    if (params) {
        if (params.direction) {
            direction = params.direction;
        }

        if (typeof (params.minimumSize) != 'undefined') {
            minSize = params.minimumSize;
        }

        if (typeof (params.maximumSize) != 'undefined') {
            maxSize = params.maximumSize;
        }

        if (params.handleID && params.contentID) {
            if (!Dynamicweb.Utilities.ResizeHandle.isAttached(params.handleID)) {
                handle = $(params.handleID);
                content = $(params.contentID);

                if (handle && content) {
                    handleObj = new Dynamicweb.Utilities.ResizeHandle(content, direction);

                    handleObj.minimumSize = minSize;
                    handleObj.maximumSize = maxSize;

                    Dynamicweb.Utilities.ResizeHandle._handleIDs[Dynamicweb.Utilities.ResizeHandle._handleIDs.length] = params.handleID;
                    Dynamicweb.Utilities.ResizeHandle.set_handleObject(handle, handleObj);

                    Event.observe(handle, 'mousedown', function (event) {
                        Dynamicweb.Utilities.ResizeHandle._setEnableSelection(false);
                        Dynamicweb.Utilities.ResizeHandle._activeHandle = Dynamicweb.Utilities.ResizeHandle.get_handleObject(Event.element(event));
                    });

                    if (!Dynamicweb.Utilities.ResizeHandle._globalEventsHandled) {
                        body = $(document.body);

                        if (body) {
                            Event.observe(body, 'mousemove', function (event) {
                                var delta = 0;
                                var dimension = 0;
                                var coordinates = {};

                                if (Dynamicweb.Utilities.ResizeHandle._activeHandle != null) {
                                    coordinates = {
                                        x: Event.pointerX(event),
                                        y: event.pointerY(event)
                                    }

                                    if (Dynamicweb.Utilities.ResizeHandle._activeHandle.content != null) {
                                        if (!Dynamicweb.Utilities.ResizeHandle._activeHandle.prevCoordinates) {
                                            Dynamicweb.Utilities.ResizeHandle._activeHandle.prevCoordinates = {
                                                x: coordinates.x,
                                                y: coordinates.y
                                            }

                                            body.style.cursor = 'e-resize';
                                            if (typeof (ContextMenu) != 'undefined') {
                                                ContextMenu.hide();
                                            }
                                        } else {
                                            if (Dynamicweb.Utilities.ResizeHandle._activeHandle.direction == Dynamicweb.Utilities.ResizeHandleDirection.Vertical) {
                                                dimension = Dynamicweb.Utilities.ResizeHandle._activeHandle.content.style.height;
                                                delta = coordinates.y - Dynamicweb.Utilities.ResizeHandle._activeHandle.prevCoordinates.y;
                                            } else {
                                                dimension = Dynamicweb.Utilities.ResizeHandle._activeHandle.content.style.width;
                                                delta = coordinates.x - Dynamicweb.Utilities.ResizeHandle._activeHandle.prevCoordinates.x;
                                            }

                                            if (dimension != null && dimension.length > 0) {
                                                dimension = parseInt(dimension.replace(/px/gi, ''));

                                                if (!isNaN(dimension)) {
                                                    dimension += delta;

                                                    if (dimension >= Dynamicweb.Utilities.ResizeHandle._activeHandle.minimumSize && dimension <= Dynamicweb.Utilities.ResizeHandle._activeHandle.maximumSize) {
                                                        if (Dynamicweb.Utilities.ResizeHandle._activeHandle.direction == Dynamicweb.Utilities.ResizeHandleDirection.Vertical) {
                                                            Dynamicweb.Utilities.ResizeHandle._activeHandle.content.style.height = dimension + 'px';
                                                        } else {
                                                            Dynamicweb.Utilities.ResizeHandle._activeHandle.content.style.width = dimension + 'px';
                                                        }

                                                        Dynamicweb.Utilities.ResizeHandle._activeHandle.prevCoordinates = coordinates;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            });

                            Event.observe(body, 'mouseup', function (event) {
                                Dynamicweb.Utilities.ResizeHandle._setEnableSelection(true);

                                if (Dynamicweb.Utilities.ResizeHandle._activeHandle != null) {
                                    Dynamicweb.Utilities.ResizeHandle._activeHandle.prevCoordinates = null;
                                    Dynamicweb.Utilities.ResizeHandle._activeHandle = null;
                                }

                                body.style.cursor = 'auto';
                            });
                        }

                        Dynamicweb.Utilities.ResizeHandle._globalEventsHandled = true;
                    }
                }
            }
        }
    }
}

Dynamicweb.Utilities.ResizeHandle.detach = function (handleID) {
    Dynamicweb.Utilities.ResizeHandle.set_handleObject(handleID, null);
}

Dynamicweb.Utilities.ResizeHandle.isAttached = function (handleID) {
    var ret = false;

    if (Dynamicweb.Utilities.ResizeHandle._handleIDs) {
        for (var i = 0; i < Dynamicweb.Utilities.ResizeHandle._handleIDs.length; i++) {
            if (Dynamicweb.Utilities.ResizeHandle._handleIDs == handleID) {
                ret = true;
                break;
            }
        }
    }

    return ret;
}

Dynamicweb.Utilities.ResizeHandle.disposeAll = function () {
    if (Dynamicweb.Utilities.ResizeHandle._handleIDs) {
        for (var i = 0; i < Dynamicweb.Utilities.ResizeHandle._handleIDs.length; i++) {
            Dynamicweb.Utilities.ResizeHandle.detach(Dynamicweb.Utilities.ResizeHandle._handleIDs[i]);
        }
    }
}

Dynamicweb.Utilities.ResizeHandle.get_handleObject = function (handle) {
    var ret = null;

    if (typeof (handle) == 'string') {
        handle = $(handle);
    }

    if (handle) {
        ret = handle.__resizeHandler;
    }

    return ret;
}

Dynamicweb.Utilities.ResizeHandle.set_handleObject = function (handle, handleObj) {
    if (typeof (handle) == 'string') {
        handle = $(handle);
    }

    if (handle) {
        handle.__resizeHandler = handleObj;
    }
}

Dynamicweb.Utilities.ResizeHandle._setEnableSelection = function (isEnabled) {
    var useMozillaApproach = typeof (document.body.style.MozUserSelect) != 'undefined';

    if (isEnabled) {
        if (useMozillaApproach) {
            document.body.style.MozUserSelect = '';
        } else {
            Event.stopObserving(document.body, 'selectstart', Dynamicweb.Utilities.ResizeHandle._disableSelection);
        }
    } else {
        if (useMozillaApproach) {
            document.body.style.MozUserSelect = 'none';
        } else {
            Event.observe(document.body, 'selectstart', Dynamicweb.Utilities.ResizeHandle._disableSelection);
        }
    }
}

Dynamicweb.Utilities.ResizeHandle._disableSelection = function (event) {
    event.cancelBubble = true;
    Event.stop(event);
    return false;
};

Dynamicweb.Utilities.EventEmitter = function (errorsHandler) {
    this._subscribers = {};
    this._onError = errorsHandler || function (ex) { throw ex; };
};

Dynamicweb.Utilities.EventEmitter.prototype.on = function (eventName, eventHandler) {
    eventName = eventName || 'any';
    if (!this._subscribers[eventName]) {
        this._subscribers[eventName] = [];
    }

    this._subscribers[eventName].push(eventHandler);
};

Dynamicweb.Utilities.EventEmitter.prototype.off = function (eventName, eventHandler) {
    var i, max, subs;
    eventName = eventName || 'any';
    subs = this._subscribers[eventName];

    if (!subs) {
        return;
    }

    max = subs.length;

    for (i = 0; i < max; i += 1) {
        if (subs[i] === eventHandler) {
            subs.pop(i);
            break;
        }
    }
};

Dynamicweb.Utilities.EventEmitter.prototype.fire = function (eventName, args, thisArg) {
    var i,
        max,
        subs,
        callbackException = null;

    eventName = eventName || 'any';

    if (!this._subscribers[eventName]) {
        return;
    }

    subs = this._subscribers[eventName];
    max = subs.length;

    for (i = 0; i < max; i += 1) {
        callbackException = null;

        try {
            subs[i].call(thisArg || this, eventName, args);
        } catch (ex) {
            callbackException = ex;
        }

        /* Preventing "Unable to execute code from freed script" errors to raise */
        if (callbackException && callbackException.number != -2146823277) {
            this._onError(callbackException);
        }
    }
};

Dynamicweb.Utilities.EventEmitter.prototype.reset = function () {
    this._subscribers = {};
};

Dynamicweb.Utilities.TimeoutChain = function () {
    //taken from http://stackoverflow.com/questions/6921275/is-it-possible-to-chain-settimeout-functions-in-javascript
    var This = this;
    this._timeoutHandler = null;
    this.chain = new Array();
    this.currentStep = 0;
    this.isRunning = false;
    this.nextStep = function () {
        This.currentStep = This.currentStep + 1;
        if (This.currentStep == This.chain.length) {
            This.stop();
        } else {
            This.processCurrentStep();
        }
    };
    this.processCurrentStep = function () {
        This._timeoutHandler = window.setTimeout(function () {
            This.chain[This.currentStep].func();
            This.nextStep();
        }, This.chain[This.currentStep].time);
    };
    this.start = function () {
        if (This.chain.length == 0) {
            return;
        }
        if (This.isRunning == true) {
            return;
        }
        This.isRunning = true;
        This.currentStep = 0;
        This.processCurrentStep();
    };
    this.stop = function () {
        This.isRunning = false;
        window.clearTimeout(This._timeoutHandler)
    };
    this.add = function (_function, _timeout) {
        This.chain[This.chain.length] = { func: _function, time: _timeout };
    };
}

Dynamicweb.Utilities.Events = {
    fire: function (element, eventName, args) {
        if ("createEvent" in document) {
            var evt = document.createEvent("HTMLEvents");
            evt.initEvent(eventName, false, true);
            element.dispatchEvent(evt);
        }
        else
            element.fireEvent("on" + eventName);
    }
};

Dynamicweb.Utilities.defineNamespace = function (strNm, parent) {
    parent = parent || window;
    var parts = strNm.split('.');
    for (var i = 0; i < parts.length; i++) {
        var part = parts[i].trim();
        if (part) {
            var ns = parent[part];
            if (!ns) {
                ns = {};
                parent[part] = ns;
            }
            parent = ns;
        }
    }
    return parent;
}

/*
* Collapsible Groupboxes
*/

Dynamicweb.Utilities.GroupBox = {
    isCollapsed: function (groupBox) {
        return groupBox.getElementsByClassName("groupbox-content")[0].hasClassName("collapsed");        
    },

    toggleCollapse: function (groupBox, skipStateSaving) {
        var collapseIcon = groupBox.getElementsByClassName("groupbox-icon-collapse");
        if (collapseIcon.length < 1) {
            return;
        }

        var collapsedContent = groupBox.getElementsByClassName("groupbox-content")[0];
        collapsedContent.classList.toggle('collapsed');

        collapseIcon[0].classList.toggle('fa-minus');
        collapseIcon[0].classList.toggle('fa-plus');

        var subtitle = groupBox.getElementsByClassName("gbSubtitle");
        if (subtitle.length > 0) {
            subtitle[0].classList.toggle('hidden');
        }

        if (!skipStateSaving && groupBox.id.length > 0) {
            var id = groupBox.id;
            Dynamicweb.Ajax.doPostBack({
                eventTarget: id || "",
                eventArgument: "Collapsed:" + collapsedContent.hasClassName("collapsed")
            });
        }
    }
};

document.addEventListener("DOMContentLoaded", function (event) {
    var buttons = document.getElementsByClassName("groupbox-button-collapse");
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].onclick = function () {
            var elm = this;
            Dynamicweb.Utilities.GroupBox.toggleCollapse(elm.parentNode.parentNode);
        };
    }
});


/*
* Make it possible to style html checkboxes and radiobuttons. Adding it to the Utilities may not be the correct way to do this. - Karsten Thuen
*/

//document.addEventListener("DOMContentLoaded", function (event) {
//    var inputs = document.getElementsByTagName("input");
//    for (var i = 0; i < inputs.length; i++) {
//        if (inputs[i].type == "checkbox" || inputs[i].type == "radio") {
//            inputs[i].className = "std";

//            var NewElement = document.createElement('label');
//            NewElement.htmlFor = inputs[i].id;

//            if (inputs[i].hasAttribute("onclick")) {
//                NewElement.setAttribute("onclick", inputs[i].onclick);
//            }

//            NewElement.appendAfter(document.getElementById(inputs[i].id));
//        }
//    }
//});

//Element.prototype.appendAfter = function (element) {
//    element.parentNode.insertBefore(this, element.nextSibling);
//}, false;
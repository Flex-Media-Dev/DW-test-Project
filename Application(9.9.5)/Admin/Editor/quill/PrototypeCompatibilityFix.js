
// Issue details: https://github.com/quilljs/quill/issues/1261
// Method copied from: https://github.com/quilljs/quill/issues/1261#issuecomment-316367166

(function _closure_youShouldReallyMigrateAwayFromPrototypeButUnderstandThatYouMightBeUnderTheCoshToGetItWorkingQuickly(global) {
    var hasOwn = Object.prototype.hasOwnProperty;
    var duckPunch = {
        _each: function __each(callback, thisArg) {
            if (this == null) { // jshint ignore:line
                throw new TypeError('this is null or not defined');
            }

            if (typeof callback !== 'function') {
                throw new TypeError(callback + ' is not a function');
            }

            var key, value, context,
                O = Object(this),
                index = 0;

            if (1 < arguments.length) {
                context = thisArg;
            }

            for (key in this) {
                if (hasOwn.call(this, key)) {
                    value = this[key];
                    callback.call(context, value, index, O);

                    index += 1;
                }
            }
        }
    };

    duckPunch.each = Enumerable.each; // jshint ignore:line
    duckPunch.forEach = duckPunch.each;

    var duckPunchList = 'NodeList NamedNodeMap DOMTokenList HTMLOptionsCollection HTMLCollection'.split(' ');
    duckPunchList.forEach(function _forEach(quack) {
        Object.extend(global[quack].prototype, duckPunch);
    });
}(window));

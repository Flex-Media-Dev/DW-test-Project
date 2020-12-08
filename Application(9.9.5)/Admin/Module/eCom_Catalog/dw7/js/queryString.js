var queryString = {
    params: null,

    init: function(loc) {
        if (loc.indexOf('?') >= 0) {
            this.params = $H(loc.replace(/\+/g, '%20').toQueryParams());
        }
        else {
            this.params = $H();
        }
    },

    get: function(key, defaultValue) {
        if (defaultValue == null) defaultValue = null;
        var value = this.params.get(key);
        if (value == null) value = defaultValue;
        return value;
    },

    set: function(key, value) {
        this.params.set(key, value);
    },

    remove: function(key) {
        this.params = this.params.collect(function(param) {
            if (key != param.key) return param;
        }).compact();
    },

    make: function() {
        return "?" + this.params.collect(function(param) {
            return encodeURIComponent(param.key) + "=" + encodeURIComponent(param.value);
        }).join("&");
    },

    toString: function() {
        return location.pathname + this.make();
    }
}
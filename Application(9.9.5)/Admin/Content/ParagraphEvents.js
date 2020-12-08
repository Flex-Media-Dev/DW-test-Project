
var paragraphEvents = {
    beforeSaveFunc: null,
    validateFunc: null,

    setBeforeSave: function (func) {
        paragraphEvents.beforeSaveFunc = func;
    },
    setValidator: function (func) {
        window["paragraphEvents"] = paragraphEvents;
        paragraphEvents.validateFunc = func;
    },
    beforeSaveInvoke: function () {
        if (paragraphEvents.beforeSaveFunc != null && Object.isFunction(paragraphEvents.beforeSaveFunc)) {
            paragraphEvents.beforeSaveFunc();
        }
    },
    validateInvoke: function () {
        if (paragraphEvents.validateFunc != null && Object.isFunction(paragraphEvents.validateFunc)) {
            return paragraphEvents.validateFunc();
        }
        return true;
    }
}

window["paragraphEvents"] = paragraphEvents;
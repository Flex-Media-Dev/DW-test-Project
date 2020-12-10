/* Represents an upload manager event handlers list */
var EventHandlerList = function(eventName) {
    /* Gets or sets the name of the event */
    this.name = eventName;
    
    /* Gets or sets an array of event handlers */
    this.handlers = [];
}

/* Adds new handler  */
EventHandlerList.prototype.addHandler = function(handler) {
    if (!this.handlers)
        this.handlers = [];

    if (this.indexOf(handler) < 0) {
        this.handlers[this.handlers.length] = handler;
    }
}

/* Removes existing handler  */
EventHandlerList.prototype.removeHandler = function(handler) {
    var index = -1;
    var newList = [];
    
    if (!this.handlers)
        this.handlers = [];

    index = this.indexOf(handler);
    if (index >= 0) {
        for (var i = 0; i < this.handlers.length; i++) {
            if (i != index) {
                newList[newList.length] = this.handlers[i];
            }
        }

        this.handlers = newList;
    }
}

/* Gets a 0-based position of the specified handler */
EventHandlerList.prototype.indexOf = function(handler) {
    var ret = -1;

    if (this.handlers && this.handlers.length > 0) {
        for (var i = 0; i < this.handlers.length; i++) {
            if (this.handlers[i] == handler) {
                ret = i;
                break;
            }
        }
    }

    return ret;
}

/* Represents an events manager */
var EventsManager = function() {
    this.allEvents = [];
}

EventsManager.prototype.registerEvent = function(eventName) {
    this.allEvents[eventName] = new EventHandlerList(eventName);
}

/* Adds new handler to specified event */
EventsManager.prototype.addHandler = function(eventName, f) {
    if (typeof (this.allEvents[eventName]) == 'undefined')
        this.allEvents[eventName] = new UploadManagerEventHandlerList(eventName);
        
    this.allEvents[eventName].addHandler(f);
}

/* Removes existing handler from specified event */
EventsManager.prototype.removeHandler = function(eventName, f) {
    if (typeof (this.allEvents[eventName]) != 'undefined') {
        this.allEvents[eventName].removeHandler(f);
    }
}

/* Removes all handlers from the specified event */
EventsManager.prototype.removeAllHandlers = function(eventName) {
    if (typeof (this.allEvents[eventName]) != 'undefined') {
        this.allEvents[eventName] = null;
        this.allEvents[eventName] = new EventHandlerList(eventName);
    }
}

/* Executes all event handlers for specified event name */
EventsManager.prototype.notify = function(eventName, sender, args) {
    var obj = null;

    for (var i = 0; i < this.allEvents[eventName].handlers.length; i++) {
        try {
            if (typeof (this.allEvents[eventName].handlers[i]) == 'function')
                this.allEvents[eventName].handlers[i](sender, args);
            else if (typeof (this.allEvents[eventName].handlers[i]) == 'object') {
                obj = this.allEvents[eventName].handlers[i];
                obj.apply(this);
            }
        } catch (ex) { }
    }
}

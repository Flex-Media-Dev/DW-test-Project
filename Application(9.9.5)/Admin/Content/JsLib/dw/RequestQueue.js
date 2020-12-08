var RequestQueueItem = function(context, callback, arguments) {
    this.context = context;
    this.callback = callback;
    this.arguments = arguments;
}

var RequestQueue = function() {
    this.list = [];
    this.canExecute = true;
    this.capacity = 0;
}

RequestQueue.prototype.add = function(context, callback, arguments) {
    if (this.canExecute) {
        this.canExecute = false;
        this.execute(context, callback, arguments);
    } else {
        this.enqueue(new RequestQueueItem(context, callback, arguments));
    }
}

RequestQueue.prototype.execute = function(context, callback, arguments) {
    if (typeof (callback) == 'function')
        callback.apply(context, arguments);
}

RequestQueue.prototype.next = function() {
    var next = this.dequeue();

    this.canExecute = true;

    if (next != null)
        this.execute(next.context, next.callback, next.arguments);
}

RequestQueue.prototype.enqueue = function(item) {
    if (!this.exists(item)) {
        if (!this.list)
            this.list = [];

        this.list[this.list.length] = item;
    }
}

RequestQueue.prototype.dequeue = function() {
    var ret = null;
    var newList = [];

    if (this.list && this.list.length > 0) {
        ret = this.list[0];

        for (var i = 1; i < this.list.length; i++) {
            newList[newList.length] = this.list[i];
        }

        this.list = newList;
    }

    if (this.capacity > 0)
        this.capacity--;

    return ret;
}

RequestQueue.prototype.exists = function(item) {
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

RequestQueue.prototype.clear = function() {
    this.list = [];
    this.canExecute = true;
    this.capacity = 0;
}
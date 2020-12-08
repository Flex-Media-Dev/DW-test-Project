var queue = new Array;
var isExecuting = false;

var AjaxQueueItem = function(provider, func) {
    this.provider = provider;
    this.func = func;
}

var AjaxQueue = new Object();

AjaxQueue.onComplete = function() {}

AjaxQueue.beginRequest = function(provider, request) {
    if (isExecuting == true) {
        AjaxQueue.add(new AjaxQueueItem(provider, request));
    }else{
        isExecuting = true;
        request(provider);
    }
}

AjaxQueue.endRequest = function() {
    isExecuting = false;
    if (queue.length > 0) {
        var queueItem = queue.pop();
        AjaxQueue.beginRequest(queueItem.provider, queueItem.func);
    }else{
        if (typeof(AjaxQueue.onComplete) == 'function') {
            AjaxQueue.onComplete();
        }
    }
}

AjaxQueue.add = function(queueItem) {
    queue.push(queueItem);
}
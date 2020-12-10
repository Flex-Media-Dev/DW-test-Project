function showMessageBox(msg, title) {
    Action.ShowMessage({
        Caption: title,
        Message: msg
    });
}

function toQueryString(obj, urlEncode) {
    var str = JSON.stringify(obj);
    if (urlEncode) {
        str = encodeURIComponent(str);
    }
    return str;
}

function sanitazeId(str) {
    let ret = str;
    if (ret && ret.length) {
        ret = ret.replace(/[^0-9a-zA-Z_\s]/gi, '_'); // Replacing non alphanumeric characters with underscores
        while (ret.indexOf('_') == 0) ret = ret.substr(1); // Removing leading underscores

        ret = ret.replace(/\s+/g, ' '); // Replacing multiple spaces with single ones
        ret = ret.replace(/\s/g, '_'); // Removing spaces
    }
    return ret;
}
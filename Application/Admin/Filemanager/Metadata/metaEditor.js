
var metaEditor = {

    save: function (validate, close) {
        if (validate && !validate()) return;
        var cmd = close === false ? "save" : "saveAndClose";
        document.getElementById('cmd').value = cmd;
        document.getElementById('form1').submit();
    },

    close: function () {
        window.close();
    },

    makeSystemName: function (name) {
        var ret = name;

        if (ret && ret.length) {
            ret = ret.replace(/[^0-9a-zA-Z_\s]/gi, '_'); // Replacing non alphanumeric characters with underscores
            while (ret.indexOf('_') === 0) ret = ret.substr(1); // Removing leading underscores

            ret = ret.replace(/\s+/g, ' '); // Replacing multiple spaces with single ones
            ret = ret.replace(/\s/g, '_'); // Removing spaces
        }

        return ret;
    }
}
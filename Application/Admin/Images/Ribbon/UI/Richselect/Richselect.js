// Old 
var RichSelect = {

    selectElementBoxid: null,
    selectElementShowed: null,
    onItemSelect: null,

    drop: function (drop, boxid) {
        if (RichSelect.selectElementBoxid != null) {
            RichSelect.hideIt(RichSelect.selectElementBoxid);
        }
        RichSelect.selectElementBoxid = boxid;
        RichSelect.selectElementShowed = new Date().getTime()
        RichSelect.showhide(boxid);
        
        RichSelect._attachEvent(document, 'click', RichSelect.hide);
        RichSelect._attachEvent(document, 'contextmenu', RichSelect.hide);
    },

    hide: function () {
        if ((new Date().getTime() - RichSelect.selectElementShowed) < 200) {
            return;
        }
        RichSelect.hideIt(RichSelect.selectElementBoxid);
    },

    hideIt: function (id) {
        if (document.getElementById(id + "_selectbox") && document.getElementById(id + "_selectitems")) {
            var box = document.getElementById(id + "_selectbox");
            var items = document.getElementById(id + "_selectitems");
            items.classList.remove('open');
            box.classList.remove('selected');
        }
    },

    showhide: function (id) {
        var box = document.getElementById(id + "_selectbox");
        var items = document.getElementById(id + "_selectitems");
        var element = document.getElementById(id + "_selectitems");
        items.classList.toggle('open');
        box.classList.toggle('selected');
    },

    setselected: function (item, boxid) {
        //alert(item);
        var id = '';
        var value = '';
        var p = RichSelect._parent(item);
        var box = document.getElementById(boxid + "_selectbox");
        var content = document.getElementById(boxid + "_selectboxcontent");
        var items = document.getElementById(boxid + "_selectitems");

        if (p) {
            id = p.id.toString();
            value = p.getAttribute('data-value').toString();
        }

        /* Fire onMouseMoving event if it is a functino */
        if (typeof (this.onItemSelect) == 'function') {
            var e = {cancel: false};
            this.onItemSelect(value, e, boxid);
            if (e.cancel) return;
        }

        for (i = 0; i < items.children.length; i++) {
            if (items.children[i]) {
                items.children[i].className = "richselectitem";
            }
        }

        if (p) {
            p.className = "richselectitem selecteditem";
        }

        if (value.indexOf('dwrichselectitem') > -1) {
            document.getElementById(boxid).value = '';
        } else {
            document.getElementById(boxid).value = value;
        }
        document.getElementById(boxid + '_selected').value = value;

        document.getElementById(boxid + 'Container').title = p ? p.title : "";

        content.innerHTML = item ? item.innerHTML : "";
    },

    getSelectedValue: function(ctrlId) {
        var el = document.getElementById(ctrlId + '_selected');
        if (el) {
            return el.value;
        }
        return null;
    },

    select: function (item, boxid) {
        RichSelect.setselected(item, boxid);
        RichSelect.showhide(boxid);
    },

    _parent: function (obj) {
        var ret = null;

        if (obj) {
            if (typeof (obj.toLowerCase) != 'undefined') {
                obj = document.getElementById(obj);
            }

            if (obj) {
                if (obj.parentElement) {
                    ret = obj.parentElement;
                } else if (obj.parentNode) {
                    ret = obj.parentNode;
                }
            }
        }

        return ret;
    },

    _attachEvent: function (el, eventType, handler) {
        if (el.addEventListener) {
            el.addEventListener(eventType, handler, false);
        } else if (el.attachEvent) {
            el.attachEvent('on' + eventType, handler);
        }
    },

    _detachEvent: function (el, eventType, handler) {
        if (el.removeEventListener) {
            el.removeEventListener(eventType, handler, false);
        } else if (el.detachEvent) {
            el.detachEvent('on' + eventType, handler);
        }
    }
}

//new
/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.Controls.Richselect = function (params) {
    /// <summary>Provides custom list control.</summary>
    /// <param name="params">Initialization parameters.</param>
    this._items = null;
}

Dynamicweb.Controls.Richselect.prototype = new Dynamicweb.Ajax.Control();

Dynamicweb.Controls.Richselect.TemplateEdit = function (event, fileName, fullName, caller) {
    event = event || window.event;
    event.stopPropagation ? event.stopPropagation() : (event.cancelBubble = true);

    var genUrl = function (_url, _params) {
        var prop,
            pair,
            result = _url;

        for (prop in _params) {
            if (_params[prop] && _params.hasOwnProperty(prop)) {
                pair = prop + "=" + _params[prop];
                if (result.indexOf('?') !== -1) {
                    result += '&' + pair;
                } else {
                    result += '?' + pair;
                }
            }
        }

        return result;
    };

    var params = {};
    params['File'] = fileName;
    params['Folder'] = fullName;
    params['CallerReload'] = caller.attributes['data-caller-reload'] ? caller.attributes['data-caller-reload'].value : '';

    url = genUrl('/Admin/FileManager/FileEditor/FileManager_FileEditorV2.aspx', params);
    var wnd = window.open(url, '', 'scrollbars=no,toolbar=no,location=no,directories=no,status=no,resizable=yes');
    wnd.focus();
}

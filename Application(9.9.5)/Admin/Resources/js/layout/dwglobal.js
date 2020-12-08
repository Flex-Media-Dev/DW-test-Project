var dwGlobal = dwGlobal || {};
dwGlobal.getNavigatorWindow = dwGlobal.getNavigatorWindow || function (navigatorName) {
    return window.top[navigatorName];
};

dwGlobal.getContentNavigatorWindow = dwGlobal.getContentNavigatorWindow || function () {
    var wnd = dwGlobal.getNavigatorWindow("Content");
    return wnd;
};

dwGlobal.getContentNavigator = dwGlobal.getContentNavigator || function () {
    var wnd = dwGlobal.getContentNavigatorWindow();
    return wnd.dwGlobal ? wnd.dwGlobal.currentNavigator : null;
};

dwGlobal.getFilesNavigatorWindow = dwGlobal.getFilesNavigatorWindow || function () {
    var wnd = dwGlobal.getNavigatorWindow("Files");
    return wnd;
};

dwGlobal.getFilesNavigator = dwGlobal.getFilesNavigator || function () {
    var wnd = dwGlobal.getFilesNavigatorWindow();
    return wnd.dwGlobal.currentNavigator;
};

dwGlobal.getUsersNavigatorWindow = dwGlobal.getUsersNavigatorWindow || function () {
    var wnd = dwGlobal.getNavigatorWindow("Users");
    return wnd;
};

dwGlobal.getUsersNavigator = dwGlobal.getUsersNavigator || function () {
    var wnd = dwGlobal.getUsersNavigatorWindow();
    return wnd.dwGlobal.currentNavigator;
};

dwGlobal.getPimNavigatorWindow = dwGlobal.getPimNavigatorWindow || function () {
    var wnd = dwGlobal.getNavigatorWindow("PIM");
    return wnd;
};

dwGlobal.getPimNavigator = dwGlobal.getPimNavigator || function () {
    var wnd = dwGlobal.getPimNavigatorWindow();
    return wnd.dwGlobal.currentNavigator;
};

dwGlobal.getSettingsNavigatorWindow = dwGlobal.getSettingsNavigatorWindow || function () {
    var wnd = dwGlobal.getNavigatorWindow("Settings");
    return wnd;
};

dwGlobal.getMarketingNavigator = dwGlobal.getMarketingNavigator || function () {
    var wnd = dwGlobal.getMarketingNavigatorWindow();
    return wnd.dwGlobal.currentNavigator;
};

dwGlobal.getMarketingNavigatorWindow = dwGlobal.getMarketingNavigatorWindow || function () {
    var wnd = dwGlobal.getNavigatorWindow("Marketing");
    return wnd;
};

dwGlobal.getSettingsNavigator = dwGlobal.getSettingsNavigator || function () {
    var wnd = dwGlobal.getSettingsNavigatorWindow();
    return wnd.dwGlobal.currentNavigator;
};


dwGlobal.fileUpload = dwGlobal.fileUpload || function (folderToUpload, onSuccessCallback, decodeFolderPath, createUploadFolderIfNotExists, allowedExtensions) {
    var wnd = window.top;
    var currentWindow = window.self;
    wnd.startFilesUpload({
        // The known problem of Unicode for base64 encode/decode operations
        // https://developer.mozilla.org/en-US/docs/Web/API/WindowBase64/Base64_encoding_and_decoding#The_Unicode_Problem
        folder: decodeFolderPath ? decodeURIComponent(atob(folderToUpload).split('').map(function (c) { return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2); }).join('')) : folderToUpload,
        createFolderIfNotExists: createUploadFolderIfNotExists,
        contextWnd: currentWindow,
        allowedExtensions: allowedExtensions,
        uploaded: function (objResponse) {
            if (objResponse.success) {
                if (onSuccessCallback) {
                    var dataObj = {
                        Folder: folderToUpload,
                        Files: objResponse.files
                    };
                    if (typeof onSuccessCallback == 'function') {
                        onSuccessCallback(dataObj);
                    }
                    else {
                        currentWindow.Action.Execute(onSuccessCallback, dataObj);
                    }
                }
            }
            else {
                currentWindow.Action.Execute({
                    Name: "ShowMessage",
                    Message: objResponse.message
                });
            }
        }
    });
    return false;
};

dwGlobal.Dom = dwGlobal.Dom || {};
/// closest polifill
(function(ELEMENT) {
    ELEMENT.matches = ELEMENT.matches || ELEMENT.mozMatchesSelector || ELEMENT.msMatchesSelector || ELEMENT.oMatchesSelector || ELEMENT.webkitMatchesSelector;
    ELEMENT.closest = ELEMENT.closest || function closest(selector) {
        if (!this) return null;
        if (this.matches(selector)) return this;
        if (!this.parentElement) {return null}
        else return this.parentElement.closest(selector)
    };
}(Element.prototype));

dwGlobal.Dom.hasClass = function(elem, className) {
    return new RegExp(' ' + className + ' ').test(' ' + elem.className + ' ');
}

dwGlobal.Dom.addClass = function(elem, className) {
    if (!dwGlobal.Dom.hasClass(elem, className)) {
        elem.className += ' ' + className;
    }
}

dwGlobal.Dom.removeClass = function(elem, className) {
    var newClass = ' ' + elem.className.replace( /[\t\r\n]/g, ' ') + ' ';
    if (dwGlobal.Dom.hasClass(elem, className)) {
        while (newClass.indexOf(' ' + className + ' ') >= 0 ) {
            newClass = newClass.replace(' ' + className + ' ', ' ');
        }
        elem.className = newClass.replace(/^\s+|\s+$/g, '');
    }
}

dwGlobal.Dom.triggerEvent = function (el, type) {
    if ('createEvent' in document) {
        // modern browsers, IE9+
        var e = document.createEvent('HTMLEvents');
        e.initEvent(type, false, true);
        el.dispatchEvent(e);
    } else {
        // IE 8
        var e = document.createEventObject();
        e.eventType = type;
        el.fireEvent('on' + e.eventType, e);
    }
}

dwGlobal.controlErrors = dwGlobal.controlErrors || function(control, showOrHide, msg) {
    if (typeof control == 'string') {
        control = document.getElementById(control);
    }
    if (!control) {
        return;
    }

    var frmGroupEl = control.closest(".form-group");
    if (!frmGroupEl) {
        return;
    }

    if (showOrHide) {
        dwGlobal.Dom.addClass(frmGroupEl, "has-error");
    }
    else {
        dwGlobal.Dom.removeClass(frmGroupEl, "has-error");
    }

    if (typeof msg !== 'undefined') {
        var errorBlocks = frmGroupEl.querySelectorAll(".help-block.error")
        var forEach = Array.prototype.forEach;
        var message = msg;
        forEach.call(errorBlocks, function (el) {
            el.innerHTML = message;
        });
    }
};

dwGlobal.showControlErrors = dwGlobal.showControlErrors || function(control, msg) {
    dwGlobal.controlErrors(control, true, msg);
};

dwGlobal.hideControlErrors = dwGlobal.hideControlErrors || function(control, msg) {
    dwGlobal.controlErrors(control, false, msg);
};

dwGlobal.hideAllControlsErrors = dwGlobal.hideAllControlsErrors || function (container, msg) {
    container = container || document.body;
    var errorControls = container.querySelectorAll(".has-error")
    var forEach = Array.prototype.forEach;
    forEach.call(errorControls, function (el) {
        dwGlobal.hideControlErrors(el, msg)
    });
}

dwGlobal.addAddonButtonToControl = dwGlobal.addAddonButtonToControl || function (control, fillAddonFn) {
    if (typeof control == 'string') {
        control = document.getElementById(control);
    }
    if (!control) {
        return null;
    }

    const frmGroupEl = control.closest(".form-group");
    if (!frmGroupEl) {
        return null;
    }
    let inputGroupEl = frmGroupEl.querySelector(".input-group");
    const formGroupInputEl = frmGroupEl.querySelector(".form-group-input");
    let helpItems = null;
    if (!inputGroupEl) {
        helpItems = formGroupInputEl.querySelectorAll(".help-block");
        inputGroupEl = document.createElement("div");
        inputGroupEl.className = "input-group";
        inputGroupEl.appendChild(formGroupInputEl);
        frmGroupEl.appendChild(inputGroupEl);
    }
    let btn = document.createElement("span");
    btn.className = "input-group-addon";
    fillAddonFn(btn);
    const addons = inputGroupEl.querySelectorAll(".input-group-addon");
    if (addons.length > 0) {
        btn = addons[addons.length - 1].insertAdjacentElement('afterend', btn);
    }
    else {
        inputGroupEl.appendChild(btn);
    }
    
    if (helpItems) {
        for (var i = 0; i < helpItems.length; i++) {
            inputGroupEl.appendChild(helpItems[i]);
        }
    }
    return btn;
}

dwGlobal.FieldAddOn = dwGlobal.FieldAddOn || {};

/**
 * Add field addon to control
 * @control {string|element} 
 * @obj - addon configuration object: {id: "id", text: "text", disabled: <bool>, click: function}
 * @returns addon button element.
 */
dwGlobal.FieldAddOn.addToControl = dwGlobal.FieldAddOn.addToControl || function (control, obj) {
    const btn = dwGlobal.addAddonButtonToControl(control, function (addon) {
        dwGlobal.FieldAddOn.disable(addon, !!obj.disabled);
        if (!!obj.id) {
            addon.setAttribute("id", obj.id);
        }
        addon.innerHTML = obj.text;
        if (obj.click) {
            dwGlobal.FieldAddOn.setOnClick(control, addon, obj.click);
        }
    });
    return btn;
}

dwGlobal.FieldAddOn.removeById = dwGlobal.FieldAddOn.removeById || function (control, addonId) {
    let addon = dwGlobal.FieldAddOn.getById(control, addonId);
    if (addon) {
        dwGlobal.FieldAddOn.remove(control, addon);
    }
}

dwGlobal.FieldAddOn.removeByIndex = dwGlobal.FieldAddOn.removeByIndex || function (control, index) {
    let addon = dwGlobal.FieldAddOn.getByIndex(control, index);
    if (addon) {
        dwGlobal.FieldAddOn.remove(control, addon);
    }
}

dwGlobal.FieldAddOn.remove = dwGlobal.FieldAddOn.remove || function (control, addon) {
    addon.remove();
    const arr = dwGlobal.FieldAddOn.getAll(control);
    if (!arr.length) {
        if (typeof control == 'string') {
            control = document.getElementById(control);
        }
        const frmGroupEl = control.closest(".form-group");
        if (!frmGroupEl) {
            return null;
        }

        let groupBlock = frmGroupEl.querySelector(".input-group");
        const helpItems = groupBlock.querySelectorAll(".help-block");
        let inputBlock = frmGroupEl.querySelector(".form-group-input");
        for (var i = 0; i < helpItems.length; i++) {
            inputBlock.appendChild(helpItems[i]);
        }
        frmGroupEl.appendChild(inputBlock);
        groupBlock.remove();
    }
}

dwGlobal.FieldAddOn.getAll = dwGlobal.FieldAddOn.getAll || function (control) {
    if (typeof control == 'string') {
        control = document.getElementById(control);
    }
    if (!control) {
        return null;
    }

    const frmGroupEl = control.closest(".form-group");
    if (!frmGroupEl) {
        return null;
    }

    return Array.from(frmGroupEl.querySelectorAll(".input-group-addon"));
}

dwGlobal.FieldAddOn.getById = dwGlobal.FieldAddOn.getById || function (control, addonId) {
    if (typeof control == 'string') {
        control = document.getElementById(control);
    }
    if (!control) {
        return null;
    }

    const frmGroupEl = control.closest(".form-group");
    if (!frmGroupEl) {
        return null;
    }
    return frmGroupEl.querySelector(".input-group-addon#" + addonId);
}

dwGlobal.FieldAddOn.getByIndex = dwGlobal.FieldAddOn.getByIndex || function (control, index) {
    const arr = dwGlobal.FieldAddOn.getAll(control);
    return arr[index];
}

dwGlobal.FieldAddOn.isDisabled = dwGlobal.FieldAddOn.isDisabled || function (addon) {
    const val = !!addon.readAttribute("disabled");
    return val;
}

dwGlobal.FieldAddOn.disable = dwGlobal.FieldAddOn.disable || function (addon, value) {
    if (value) {
        addon.setAttribute("disabled", "disabled");
    } else {
        addon.removeAttribute("disabled");
    }
}

dwGlobal.FieldAddOn.setOnClick = dwGlobal.FieldAddOn.setOnClick || function (control, addon, fnClick) {
    if (typeof addon == 'string') {
        addon = dwGlobal.FieldAddOn.getById(control, addon)
    }
    if (addon) {
        addon.addEventListener("click", function () {
            fnClick(addon);
        });
    }
}

dwGlobal.generateBreadcrumbs = dwGlobal.generateBreadcrumbs || function (segments, separator, removeEndSeparator, lastSegmentBold) {
    var result = "";
    if (!segments) {
        return result;
    }
    removeEndSeparator = removeEndSeparator || false;
    lastSegmentBold = lastSegmentBold || false;
    for (var i = 0; i < segments.length; i++) {
        if (lastSegmentBold && i == segments.length - 1) {
            result += "<b>" + segments[i] + "</b>";
        } else {
            result += segments[i];
        }
        if (removeEndSeparator && i == segments.length - 1) {
            break;
        }
        result += separator;
    }

    return result;
};

dwGlobal.sortTableByColumn = dwGlobal.sortTableByColumn || function (table, columnIndex, sortAsc, cellDataFn) {
    // table - table id or table dom element
    // Sorts the table by column.
    // int columnIndex - index of the column.
    // bool sortAsc - direction of the sort: true - ASC; false - DESC.
    // cellDataFn - function which get cell data from cell element or null. If null cell.innerText used for comparing
    if (typeof table == 'string') {
        table = document.getElementById(table);
    }
    if (!table) {
        return;
    }
    let bodyEl = table.tBodies[0];
    if (!bodyEl) {
        return;
    }

    var rows = bodyEl.childElements();
    var reverse = sortAsc ? 1 : -1;
    cellDataFn = cellDataFn || function (cell) { return cell.innerText.trim(); };

    rows.sort(function (a, b) {
        return reverse * (cellDataFn(a.cells[columnIndex]).localeCompare(cellDataFn(b.cells[columnIndex])));
    });

    for (var i = 0; i < rows.length; ++i) {
        bodyEl.appendChild(rows[i]);
    }
};

dwGlobal.extendObject = dwGlobal.extendObject || function () {
    var extended = {};
    for(key in arguments) {
        var argument = arguments[key];
        for (prop in argument) {
            if (Object.prototype.hasOwnProperty.call(argument, prop)) {
                extended[prop] = argument[prop];
            }
        }
    }
    return extended;
};

/*worked with jquery only*/
(function ($) {
    if (!$) {
        return;
    }

    $.extend(dwGlobal, {
        jqIdSelector: function(id) {
            return "#" + id.replace(/(:|\.|\[|\]|,|\|| |=|\/)/g, "\\$1");
        },
        getNavigatorTree: function (navigatorName) {
            var wnd = this.getNavigatorWindow(navigatorName);
            if (wnd) {
                return this.getTree(wnd);
            }
            return [];
        },
        getTree: function (wnd) {
            wnd = wnd || window;
            return $(".navigator-treeview.tree", wnd.document);
        },
        currentNavigator: {
            hasRootSelector: function() {
                return !!$("#rootSelector").length;
            },
            refreshRootSelector: function (callback) {
                var selector = $("#rootSelector").Selector("get")[0];
                selector.reload(callback);
            },
            changeRootSelectorVal: function (val, force, fn, doReload) {
                var selector = $("#rootSelector").Selector("get")[0];
                selector.select(val, force).done(fn);
            },
            expandAncestors: function (ancestorsIds, ancestorsIdsToForceReload, execNodeActionWhenSelect) {
                if (!ancestorsIds || !ancestorsIds.length) {
                    return;
                }
                ancestorsIdsToForceReload = ancestorsIdsToForceReload || [];
                var tree = dwGlobal.getTree();
                if (this.hasRootSelector()) {
                    var rootNodeToSelect = ancestorsIds.shift();
                    this.changeRootSelectorVal(rootNodeToSelect, ancestorsIdsToForceReload.indexOf(rootNodeToSelect) != -1, function () {
                        tree.treeView("expandNodes", execNodeActionWhenSelect, ancestorsIds, ancestorsIdsToForceReload);
                    });
                }
                else {
                    tree.treeView("expandNodes", execNodeActionWhenSelect, ancestorsIds, ancestorsIdsToForceReload);
                }
            },
            selectNode: function (nodeId) {
                var tree = dwGlobal.getTree();
                tree.treeView("selectNode", nodeId);
                tree.treeView("expandNode", nodeId);
            },
            reload: function (fn) {
                fn = fn || function() {};
                var tree = dwGlobal.getTree();
                tree.treeView("reload", fn);
            },
            refreshNode: function (parentNodeId, nodeId) {
                var tree = dwGlobal.getTree();
                tree.treeView("refreshNode", {
                    nodeId: parentNodeId,
                    forceExpandNode: false,
                    childNodeToSelect: nodeId
                });
            },
            reloadChildNodes: function (nodeId, forceLoad) {
                var tree = dwGlobal.getTree();
                tree.treeView("reloadChildNodes", {
                    nodeId: nodeId,
                    forceLoad: forceLoad
                });
            }
        }
    });
   
})(window.jQuery);

String.prototype.format = String.prototype.format || function () {
    var args = arguments;
    return this.replace(/{(\d+)}/g, function (match, number) {
        return typeof args[number] != 'undefined'
          ? args[number]
          : match
        ;
    });
};

dwGlobal.debounce = dwGlobal.debounce || function (func, wait, immediate) {
    var timeout;
    return function () {
        var context = this, args = arguments;
        var later = function () {
            timeout = null;
            if (!immediate) func.apply(context, args);
        };
        var callNow = immediate && !timeout;
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
        if (callNow) func.apply(context, args);
    };
};
/*fetch polyfill https://github.com/github/fetch#browser-support*/
(function (self) {
    'use strict';

    if (self.fetch) {
        return
    }

    var support = {
        searchParams: 'URLSearchParams' in self,
        iterable: 'Symbol' in self && 'iterator' in Symbol,
        blob: 'FileReader' in self && 'Blob' in self && (function () {
            try {
                new Blob()
                return true
            } catch (e) {
                return false
            }
        })(),
        formData: 'FormData' in self,
        arrayBuffer: 'ArrayBuffer' in self
    }

    if (support.arrayBuffer) {
        var viewClasses = [
          '[object Int8Array]',
          '[object Uint8Array]',
          '[object Uint8ClampedArray]',
          '[object Int16Array]',
          '[object Uint16Array]',
          '[object Int32Array]',
          '[object Uint32Array]',
          '[object Float32Array]',
          '[object Float64Array]'
        ]

        var isDataView = function (obj) {
            return obj && DataView.prototype.isPrototypeOf(obj)
        }

        var isArrayBufferView = ArrayBuffer.isView || function (obj) {
            return obj && viewClasses.indexOf(Object.prototype.toString.call(obj)) > -1
        }
    }

    function normalizeName(name) {
        if (typeof name !== 'string') {
            name = String(name)
        }
        if (/[^a-z0-9\-#$%&'*+.\^_`|~]/i.test(name)) {
            throw new TypeError('Invalid character in header field name')
        }
        return name.toLowerCase()
    }

    function normalizeValue(value) {
        if (typeof value !== 'string') {
            value = String(value)
        }
        return value
    }

    // Build a destructive iterator for the value list
    function iteratorFor(items) {
        var iterator = {
            next: function () {
                var value = items.shift()
                return { done: value === undefined, value: value }
            }
        }

        if (support.iterable) {
            iterator[Symbol.iterator] = function () {
                return iterator
            }
        }

        return iterator
    }

    function Headers(headers) {
        this.map = {}

        if (headers instanceof Headers) {
            headers.forEach(function (value, name) {
                this.append(name, value)
            }, this)
        } else if (Array.isArray(headers)) {
            headers.forEach(function (header) {
                this.append(header[0], header[1])
            }, this)
        } else if (headers) {
            Object.getOwnPropertyNames(headers).forEach(function (name) {
                this.append(name, headers[name])
            }, this)
        }
    }

    Headers.prototype.append = function (name, value) {
        name = normalizeName(name)
        value = normalizeValue(value)
        var oldValue = this.map[name]
        this.map[name] = oldValue ? oldValue + ',' + value : value
    }

    Headers.prototype['delete'] = function (name) {
        delete this.map[normalizeName(name)]
    }

    Headers.prototype.get = function (name) {
        name = normalizeName(name)
        return this.has(name) ? this.map[name] : null
    }

    Headers.prototype.has = function (name) {
        return this.map.hasOwnProperty(normalizeName(name))
    }

    Headers.prototype.set = function (name, value) {
        this.map[normalizeName(name)] = normalizeValue(value)
    }

    Headers.prototype.forEach = function (callback, thisArg) {
        for (var name in this.map) {
            if (this.map.hasOwnProperty(name)) {
                callback.call(thisArg, this.map[name], name, this)
            }
        }
    }

    Headers.prototype.keys = function () {
        var items = []
        this.forEach(function (value, name) { items.push(name) })
        return iteratorFor(items)
    }

    Headers.prototype.values = function () {
        var items = []
        this.forEach(function (value) { items.push(value) })
        return iteratorFor(items)
    }

    Headers.prototype.entries = function () {
        var items = []
        this.forEach(function (value, name) { items.push([name, value]) })
        return iteratorFor(items)
    }

    if (support.iterable) {
        Headers.prototype[Symbol.iterator] = Headers.prototype.entries
    }

    function consumed(body) {
        if (body.bodyUsed) {
            return Promise.reject(new TypeError('Already read'))
        }
        body.bodyUsed = true
    }

    function fileReaderReady(reader) {
        return new Promise(function (resolve, reject) {
            reader.onload = function () {
                resolve(reader.result)
            }
            reader.onerror = function () {
                reject(reader.error)
            }
        })
    }

    function readBlobAsArrayBuffer(blob) {
        var reader = new FileReader()
        var promise = fileReaderReady(reader)
        reader.readAsArrayBuffer(blob)
        return promise
    }

    function readBlobAsText(blob) {
        var reader = new FileReader()
        var promise = fileReaderReady(reader)
        reader.readAsText(blob)
        return promise
    }

    function readArrayBufferAsText(buf) {
        var view = new Uint8Array(buf)
        var chars = new Array(view.length)

        for (var i = 0; i < view.length; i++) {
            chars[i] = String.fromCharCode(view[i])
        }
        return chars.join('')
    }

    function bufferClone(buf) {
        if (buf.slice) {
            return buf.slice(0)
        } else {
            var view = new Uint8Array(buf.byteLength)
            view.set(new Uint8Array(buf))
            return view.buffer
        }
    }

    function Body() {
        this.bodyUsed = false

        this._initBody = function (body) {
            this._bodyInit = body
            if (!body) {
                this._bodyText = ''
            } else if (typeof body === 'string') {
                this._bodyText = body
            } else if (support.blob && Blob.prototype.isPrototypeOf(body)) {
                this._bodyBlob = body
            } else if (support.formData && FormData.prototype.isPrototypeOf(body)) {
                this._bodyFormData = body
            } else if (support.searchParams && URLSearchParams.prototype.isPrototypeOf(body)) {
                this._bodyText = body.toString()
            } else if (support.arrayBuffer && support.blob && isDataView(body)) {
                this._bodyArrayBuffer = bufferClone(body.buffer)
                // IE 10-11 can't handle a DataView body.
                this._bodyInit = new Blob([this._bodyArrayBuffer])
            } else if (support.arrayBuffer && (ArrayBuffer.prototype.isPrototypeOf(body) || isArrayBufferView(body))) {
                this._bodyArrayBuffer = bufferClone(body)
            } else {
                throw new Error('unsupported BodyInit type')
            }

            if (!this.headers.get('content-type')) {
                if (typeof body === 'string') {
                    this.headers.set('content-type', 'text/plain;charset=UTF-8')
                } else if (this._bodyBlob && this._bodyBlob.type) {
                    this.headers.set('content-type', this._bodyBlob.type)
                } else if (support.searchParams && URLSearchParams.prototype.isPrototypeOf(body)) {
                    this.headers.set('content-type', 'application/x-www-form-urlencoded;charset=UTF-8')
                }
            }
        }

        if (support.blob) {
            this.blob = function () {
                var rejected = consumed(this)
                if (rejected) {
                    return rejected
                }

                if (this._bodyBlob) {
                    return Promise.resolve(this._bodyBlob)
                } else if (this._bodyArrayBuffer) {
                    return Promise.resolve(new Blob([this._bodyArrayBuffer]))
                } else if (this._bodyFormData) {
                    throw new Error('could not read FormData body as blob')
                } else {
                    return Promise.resolve(new Blob([this._bodyText]))
                }
            }

            this.arrayBuffer = function () {
                if (this._bodyArrayBuffer) {
                    return consumed(this) || Promise.resolve(this._bodyArrayBuffer)
                } else {
                    return this.blob().then(readBlobAsArrayBuffer)
                }
            }
        }

        this.text = function () {
            var rejected = consumed(this)
            if (rejected) {
                return rejected
            }

            if (this._bodyBlob) {
                return readBlobAsText(this._bodyBlob)
            } else if (this._bodyArrayBuffer) {
                return Promise.resolve(readArrayBufferAsText(this._bodyArrayBuffer))
            } else if (this._bodyFormData) {
                throw new Error('could not read FormData body as text')
            } else {
                return Promise.resolve(this._bodyText)
            }
        }

        if (support.formData) {
            this.formData = function () {
                return this.text().then(decode)
            }
        }

        this.json = function () {
            return this.text().then(JSON.parse)
        }

        return this
    }

    // HTTP methods whose capitalization should be normalized
    var methods = ['DELETE', 'GET', 'HEAD', 'OPTIONS', 'POST', 'PUT']

    function normalizeMethod(method) {
        var upcased = method.toUpperCase()
        return (methods.indexOf(upcased) > -1) ? upcased : method
    }

    function Request(input, options) {
        options = options || {}
        var body = options.body

        if (input instanceof Request) {
            if (input.bodyUsed) {
                throw new TypeError('Already read')
            }
            this.url = input.url
            this.credentials = input.credentials
            if (!options.headers) {
                this.headers = new Headers(input.headers)
            }
            this.method = input.method
            this.mode = input.mode
            if (!body && input._bodyInit != null) {
                body = input._bodyInit
                input.bodyUsed = true
            }
        } else {
            this.url = String(input)
        }

        this.credentials = options.credentials || this.credentials || 'omit'
        if (options.headers || !this.headers) {
            this.headers = new Headers(options.headers)
        }
        this.method = normalizeMethod(options.method || this.method || 'GET')
        this.mode = options.mode || this.mode || null
        this.referrer = null

        if ((this.method === 'GET' || this.method === 'HEAD') && body) {
            throw new TypeError('Body not allowed for GET or HEAD requests')
        }
        this._initBody(body)
    }

    Request.prototype.clone = function () {
        return new Request(this, { body: this._bodyInit })
    }

    function decode(body) {
        var form = new FormData()
        body.trim().split('&').forEach(function (bytes) {
            if (bytes) {
                var split = bytes.split('=')
                var name = split.shift().replace(/\+/g, ' ')
                var value = split.join('=').replace(/\+/g, ' ')
                form.append(decodeURIComponent(name), decodeURIComponent(value))
            }
        })
        return form
    }

    function parseHeaders(rawHeaders) {
        var headers = new Headers()
        // Replace instances of \r\n and \n followed by at least one space or horizontal tab with a space
        // https://tools.ietf.org/html/rfc7230#section-3.2
        var preProcessedHeaders = rawHeaders.replace(/\r?\n[\t ]+/g, ' ')
        preProcessedHeaders.split(/\r?\n/).forEach(function (line) {
            var parts = line.split(':')
            var key = parts.shift().trim()
            if (key) {
                var value = parts.join(':').trim()
                headers.append(key, value)
            }
        })
        return headers
    }

    Body.call(Request.prototype)

    function Response(bodyInit, options) {
        if (!options) {
            options = {}
        }

        this.type = 'default'
        this.status = options.status === undefined ? 200 : options.status
        this.ok = this.status >= 200 && this.status < 300
        this.statusText = 'statusText' in options ? options.statusText : 'OK'
        this.headers = new Headers(options.headers)
        this.url = options.url || ''
        this._initBody(bodyInit)
    }

    Body.call(Response.prototype)

    Response.prototype.clone = function () {
        return new Response(this._bodyInit, {
            status: this.status,
            statusText: this.statusText,
            headers: new Headers(this.headers),
            url: this.url
        })
    }

    Response.error = function () {
        var response = new Response(null, { status: 0, statusText: '' })
        response.type = 'error'
        return response
    }

    var redirectStatuses = [301, 302, 303, 307, 308]

    Response.redirect = function (url, status) {
        if (redirectStatuses.indexOf(status) === -1) {
            throw new RangeError('Invalid status code')
        }

        return new Response(null, { status: status, headers: { location: url } })
    }

    self.Headers = Headers
    self.Request = Request
    self.Response = Response

    self.fetch = function (input, init) {
        return new Promise(function (resolve, reject) {
            var request = new Request(input, init)
            var xhr = new XMLHttpRequest()

            xhr.onload = function () {
                var options = {
                    status: xhr.status,
                    statusText: xhr.statusText,
                    headers: parseHeaders(xhr.getAllResponseHeaders() || '')
                }
                options.url = 'responseURL' in xhr ? xhr.responseURL : options.headers.get('X-Request-URL')
                var body = 'response' in xhr ? xhr.response : xhr.responseText
                resolve(new Response(body, options))
            }

            xhr.onerror = function () {
                reject(new TypeError('Network request failed'))
            }

            xhr.ontimeout = function () {
                reject(new TypeError('Network request failed'))
            }

            xhr.open(request.method, request.url, true)

            if (request.credentials === 'include') {
                xhr.withCredentials = true
            } else if (request.credentials === 'omit') {
                xhr.withCredentials = false
            }

            if ('responseType' in xhr && support.blob) {
                xhr.responseType = 'blob'
            }

            request.headers.forEach(function (value, name) {
                xhr.setRequestHeader(name, value)
            })

            xhr.send(typeof request._bodyInit === 'undefined' ? null : request._bodyInit)
        })
    }
    self.fetch.polyfill = true
})(typeof self !== 'undefined' ? self : this);

//.finally is not supported by promise for EDGE + iOS: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/finally
if (!Promise.prototype.finally) {
    Promise.prototype.finally = function (callback) {
        return this.then(callback)
          .catch(callback);
    };
}

dwGlobal.documentReady = dwGlobal.documentReady || function(callback) {
    // in case the document is already rendered
    if (document.readyState != 'loading') {
        callback();
    }
    else {
        document.addEventListener('DOMContentLoaded', callback);
    }
}
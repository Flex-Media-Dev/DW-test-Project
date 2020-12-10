(function () {
    const pickerClassName = "dw-select-picker";

    const toBoolean = (val) => {
        if (!val || val === "false") {
            return false;
        }
        return !!val;
    }

    const toFunction = (fn) => {
        if (fn) {
            if (typeof fn != "function") {
                fn = window[fn];
            }
        }
        if (typeof fn != "function") {
            fn = function () { };
        }
        return fn;
    }

    const createOption = (nObj, parentEl) => {
        let itemId = nObj.Id;
        if (nObj.Attributes) {
            itemId = nObj.Attributes["id"] || itemId;
        }
        let icon = (nObj.Icon || "").trim();
        let flag = (nObj.Country || "").trim();

        if (icon) {
            icon = `<i class="${icon} ${nObj.IconColor}"></i>`;
        }

        if (flag) {
            flag = `<i class="flag-icon flag-icon-${flag}"></i>`;
        }
        const opt = document.createElement("option");
        opt.innerHTML = icon + flag + nObj.Title;
        if (nObj.Attributes) {
            for (let attributeName in nObj.Attributes) {
                opt.setAttribute(attributeName, nObj.Attributes[attributeName]);
            }
        }

        /* Create the action data object */
        Object.defineProperty(opt, "_dwData", {
            get: function () {
                return nObj;
            }
        });
        opt.setAttribute("value", nObj.Id);
        parentEl.append(opt);
        return opt;
    }

    const createSelectElement = (id, name, container) => {
        const innerList = document.createElement("select");
        name = name || container.getAttribute("name") || "";
        id = id || container.getAttribute("id") || "";
        if (!id) {
            id = name;
        }
        innerList.setAttribute("id", id);
        innerList.setAttribute("name", name);
        container.appendChild(innerList);
        return innerList;
    }

    // Generate list from data
    const generateList = (selectorObj, data) => {
        const self = selectorObj;
        const innerList = self._selectEl;
        const isDisabled = innerList.getAttribute("disabled") === "disabled";

        let itemsCount = 0;
        let fragment = new DocumentFragment();
        let firstOption = null;
        //Create the all option
        if (self._addSelectAllOption) {
            itemsCount++;
            let opt = createOption({
                Id: "",
                Title: "All",
                Attributes: {
                    id: "selector-all"
                }
            }, fragment);
            if (!firstOption) {
                firstOption = opt;
            }
        }

        //Create the options
        let optGroup = null;
        for (let i = 0; i < data.length; i++) {
            itemsCount++;
            let nObj = data[i];
            if (nObj.IsOptGroup) {
                optGroup = document.createElement("optgroup");
                optGroup.setAttribute('label', nObj.Title);
                fragment.appendChild(optGroup);
            } else {
                if (!self._showOnlyHasNodes || data[i].HasNodes == true) {
                    let opt = createOption(nObj, optGroup || fragment);
                    if (!firstOption) {
                        firstOption = opt;
                    }
                }
            }
        }
        innerList.appendChild(fragment);

        //initial select
        let optionDataObj = self._dataObject;
        if (!optionDataObj && firstOption) {
            optionDataObj = firstOption.getAttribute("value");
            self._dataObject = optionDataObj;
        }
        let showSearch = isSearchable(self, innerList, itemsCount);
        return initializeSelect({ ctrl: self, innerList, showSearch, isDisabled, val: optionDataObj});
    }

    const isSearchable = (ctrl, innerList, itemsCount) => {
        if (typeof itemsCount === 'undefined') {
            itemsCount = innerList.querySelectorAll("option, optgroup").length;
        }
        return itemsCount > 10;
    }

    const initializeSelect = ({ ctrl, innerList, showSearch, isDisabled, val }) => {
        let self = ctrl;
        let config = {
            select: innerList,
            isEnabled: !isDisabled,
            showSearch,
            addToBody: true
        };
        let sp = new SlimSelect(config);
        if (val !== undefined) {
            sp.set(val);
        }
        if (self._itemChangedFn) {
            let dataObject = sp.selected();
            self._itemChangedFn(val, dataObject);
        }
        sp.onChange = () => {
            let dataObject = sp.selected();
            self._dataObject = dataObject;
            if (self._itemChangedFn) {
                self._itemChangedFn(dataObject);
            }
        };
        return sp;
    }

    class Selector {
        constructor({ select, id, name, container, datasource, dataobject, itemchanged, selectall, showOnlyHasnodes, allowSearch }) {
            this._selectEl = select;
            if (!this._selectEl) {
                this._selectEl = createSelectElement(id, name, container);
            }
            this._selectEl.classList.add(pickerClassName);
            this._dataSource = datasource;
            this._dataObject = dataobject;
            this._itemChangedFn = toFunction(itemchanged);
            this._addSelectAllOption = toBoolean(selectall);
            this._showOnlyHasNodes = toBoolean(showOnlyHasnodes);
            this._dataSource = datasource;
            this.allowSearch = allowSearch;
            if (this._dataSource) {
                this.reload();
            }
            else {
                let showSearch = allowSearch;
                if (showSearch == undefined) {
                    showSearch = isSearchable(this, this._selectEl);
                }
                else {
                    showSearch = showSearch === "false" ? false : Boolean(showSearch);
                }
                this._picker = initializeSelect({ ctrl: this, innerList: this._selectEl, showSearch, val: this._dataObject });
            }
        }

        reload(afterLoadCallback) {
            this._selectEl.innerHTML = ''
            fetch(this._dataSource, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json;charset=utf-8'
                },
            }).then((response) => {
                if (response.status >= 200 && response.status < 300) {
                    return response.json();
                }
                else {
                    var error = new Error(response.statusText);
                    error.response = response;
                    throw error;
                }
            }).then((data) => {
                if (data != null) {
                    // Generate the list
                    this._picker = generateList(this, data);
                }
                if (afterLoadCallback) {
                    afterLoadCallback();
                }
            });
        }

        select(val, forceSelect) {
            const selectPromise = new Promise((resolve, reject) => {
                let curVal = this._picker.selected();
                if (curVal == val && !forceSelect) {
                    resolve();
                }
                else {
                    this._picker.set(val);
                    this._dataObject = val;
                    this._itemChangedFn(val, function () {
                        defer.resolve();
                    });
                }
            });
            return selectPromise;
        }
        get isEnabled() {
            return this._picker.config.isEnabled;
        }

        set isEnabled(newValue) {
            if (newValue) {
                this._picker.enable();
            } else {
                this._picker.disable();
            }
        }

        get value() {
            return this._picker.selected();
        }

        set value(newValue) {
            this._picker.set(newValue);
        }

        get selectedData() {
            let selectorEl = this._picker.select.element;
            let opt = selectorEl.options[selectorEl.selectedIndex];
            return opt ? opt._dwData : null;
        }
    }

    dwGlobal.createSelector = dwGlobal.createSelector || function (options) {
        let el = options.select;
        if (el && el.dwSelector) {
            return el.dwSelector;
        }
        const selectorObj = new Selector(options);
        Object.defineProperty(selectorObj._selectEl, 'dwSelector', {
            get: function () {
                return selectorObj;
            }
        });
        return selectorObj;
    };

    dwGlobal.documentReady = dwGlobal.documentReady || function (callback) {
        // in case the document is already rendered
        if (document.readyState != 'loading') {
            callback();
        }
        else {
            document.addEventListener('DOMContentLoaded', callback);
        }
    }

    /*
     * Auto link the plugin to any selector
     */
    dwGlobal.documentReady(function () {
        const suppressAutoInitialization = document.body.dataset.dwselectorSuppressAutoInitialization;
        if (suppressAutoInitialization !== "true") {
            document.querySelectorAll(".selector.searchable").forEach(function (el) {
                const options = el.dataset;
                const select = el.querySelector("select");
                if (select && select.classList.contains(pickerClassName)) {
                    return; // suppress double initialization
                }
                const opts = Object.assign({ select, container: el }, options); // Edge still doesn't support ...rest
                dwGlobal.createSelector(opts);
            });
            document.querySelectorAll(`.dw-ctrl.select-picker-ctrl.searchable select:not(.${pickerClassName})`).forEach(function (el) {
                const options = el.dataset;
                const select = el;
                const opts = Object.assign({ select }, options); // Edge still doesn't support ...rest
                //if (el.multiple) {
                //    opts.itemchanged = function (selectedValues) {
                //        if (typeof selectedValues !== "undefined") {
                //            for (let i = 0; i < el.options.length; i++) {
                //                el.options[i].selected = selectedValues.indexOf(el.options[i].value) != -1;
                //            }
                //        }
                //    }
                //}
                dwGlobal.createSelector(opts);
            });
        }
    });
})();
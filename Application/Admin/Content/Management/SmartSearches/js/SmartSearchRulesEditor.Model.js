Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.error = function (message) {
    /// <summary>Displays an error message.</summary>
    /// <param name="message">Error message.</param>

    var er = null;

    if (typeof (Error) != 'undefined') {
        er = new Error();

        er.message = message;
        er.description = message;

        throw (er);
    } else {
        throw (message);
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ComponentManager = function () {
    /// <summary>Represents a component manager.</summary>

    this._idCounter = {};
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ComponentManager._instance = null;

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ComponentManager.get_current = function () {
    /// <summary>Gets the current instance of the control manager.</summary>

    if (!Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ComponentManager._instance) {
        Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ComponentManager._instance = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ComponentManager();
    }

    return Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ComponentManager._instance;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ComponentManager.prototype.generateComponentID = function (prefix) {
    /// <summary>Generates a unique identifier for the component.</summary>
    /// <param name="prefix">Identifier prefix.</param>

    var ret = '';

    prefix = (prefix && prefix.length) ? prefix : 'component';

    if (typeof (this._idCounter[prefix]) != 'number') {
        this._idCounter[prefix] = 0;
    }

    ret = prefix + '_' + this._idCounter[prefix];
    this._idCounter[prefix] += 1;

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Enumeration = {
    /// <summary>Represents an enumeration.</summary>

    extend: function (o) {
        /// <summary>Extends the given object with methods from enumeration object.</summary>
        /// <param name="o">Target object.</param>

        if (o) {
            for (var m in this) {
                o[m] = this[m];
            }
        }
    },

    parse: function (v) {
        /// <summary>Parses the enumeration from the given value.</summary>
        /// <param name="v">Either a string or a number representing enumeration value.</param>
        /// <returns>Enumeration value.</returns>

        var name = '';
        var ret = null;

        if (typeof (v) != 'undefined') {
            if (typeof (v) == 'number') {
                name = this.getName(v);
            } else if (typeof (v) == 'string') {
                name = this.camelCaseField(v);
            }

            if (name && name.length) {
                ret = this[name];
            }
        }

        return ret;
    },

    getName: function (v) {
        /// <summary>Returns the enumeration field name that corresponds to the given value.</summary>
        /// <param name="v">Enumeration value.</param>
        /// <returns>Enumeration field name.</returns>

        var ret = '';

        if (typeof (v) != 'undefined') {
            v = parseInt(v);
            if (v != null && !isNaN(v)) {
                for (var f in this) {
                    if (typeof (this[f]) != 'function' && this[f] == v) {
                        ret = f;
                        break;
                    }
                }
            }
        }

        return ret;
    },

    getNames: function () {
        /// <summary>Returns the array of all item names within this enumeration.</summary>

        var ret = [];

        for (var f in this) {
            if (typeof (this[f]) != 'function') {
                ret[ret.length] = f;
            }
        }

        return ret;
    },

    getValues: function () {
        /// <summary>Returns the array of all item values within this enumeration.</summary>

        var ret = [];

        for (var f in this) {
            if (typeof (this[f]) != 'function') {
                ret[ret.length] = this[f];
            }
        }

        return ret;
    },

    camelCaseField: function (str) {
        /// <summary>Normalizes the given enumeration field name by lowercasing the first letter.</summary>
        /// <param name="str">Field name to normalize.</param>
        /// <returns>Normalized field name.</returns>
        /// <private />

        var ret = '';

        if (typeof (str) != 'undefined') {
            ret = str.toString();
            if (ret && ret.length > 1) {
                ret = ret.substr(0, 1).toLowerCase() + ret.substr(1);
            }
        }

        return ret;
    },

    pascalCaseField: function (str) {
        /// <summary>Normalizes the given enumeration field name by uppercasing the first letter.</summary>
        /// <param name="str">Field name to normalize.</param>
        /// <returns>Normalized field name.</returns>
        /// <private />

        var ret = '';

        if (typeof (str) != 'undefined') {
            ret = str.toString();
            if (ret && ret.length > 1) {
                ret = ret.substr(0, 1).toUpperCase() + ret.substr(1);
            }
        }

        return ret;
    }
};

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Operator = {
    /// <summary>Represents a rule constraint operator.</summary>

    equals: 0,
    /// <summary>Equals.</summary>

    greaterThan: 1,
    /// <summary>Greater than.</summary>

    lessThan: 2,
    /// <summary>Less than.</summary>

    greaterThanOrEqualTo: 3,
    /// <summary>Greater than or equal to.</summary>

    lessThanOrEqualTo: 4,
    /// <summary>Less than or equal to.</summary>

    notEqualTo: 5,
    /// <summary>Not equal to.</summary>

    contains: 6,
    /// <summary>Contains.</summary>

    doesNotContain: 7,
    /// <summary>Does not contain.</summary>

    startsWith: 8,
    /// <summary>Starts with.</summary>

    doesNotStartWith: 9,
    /// <summary>Does not start with.</summary>

    endsWith: 10,
    /// <summary>Ends with.</summary>

    doesNotEndWith: 11,
    /// <summary>Does not end with.</summary>

    isBefore: 12,
    /// <summary>Is before.</summary>

    isAfter: 13,
    /// <summary>Is after.</summary>

    isInRange: 14,
    /// <summary>Is in range.</summary>

    isUnder: 15,
    /// <summary>Is under.</summary>

    doesNotOccurBefore: 16,
    /// <summary>Not is before.</summary>

    doesNotOccurAfter: 17,
    /// <summary>Not is after.</summary>

    isEmpty: 18,
    /// <summary>Is empty.</summary>

    isNotEmpty: 19
    /// <summary>Is not empty.</summary>
};

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Enumeration.extend(Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Operator);

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CombineMethod = {
    /// <summary>Represents a combine method for expression tree nodes.</summary>

    none: 0,
    /// <summary>Do not combine expression nodes meaning that they will evaluate individually.</summary>

    or: 1,
    /// <summary>Combine nodes using logical OR.</summary>

    and: 2
    /// <summary>Combine nodes using logical AND.</summary>
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Enumeration.extend(Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CombineMethod);

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CtrlType = {
    /// <summary>Represents the control type of rule value.</summary>

    TextBox: 0,
    /// <summary>Text box control.</summary>

    NumericBox: 1,
    /// <summary>Numeric box control.</summary>

    FloatNumericBox: 2,
    /// <summary>Float numeric box control.</summary>

    DropDownList: 3,
    /// <summary>Drop down list.</summary>

    BooleanCtrl: 4,
    /// <summary>Boolean control.</summary>

    RateCtrl: 5,
    /// <summary>Rate control.</summary>

    FileSelectorCtrl: 6,
    /// <summary>File selector control.</summary>

    LinkSelectorCtrl: 7,
    /// <summary>Link selector control.</summary>

    DateTimeCtrl: 8,
    /// <summary>Date time selector control.</summary>

    EmailCtrl: 9,
    /// <summary>Email selector control.</summary>

    EmailLinkCtrl: 14,
    /// <summary>Email link selector control.</summary>

    PageCtrl: 10,
    /// <summary>Page selector control.</summary>

    ProductCtrl: 11,
    /// <summary>Product selector control.</summary>

    DateCtrl: 12,
    /// <summary>Product selector control.</summary>

    AnoterTimeCtrl: 13,
    /// <summary>Date time selector control with additional "not" operators.</summary>

    UserCtrl: 15
    /// <summary>User selector control.</summary>
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Enumeration.extend(Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CtrlType);

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ListItem = function (text, value, group) {
    /// <summary>Represents a recognition rule.</summary>

    this._text = text ? (text + '') : text;
    this._value = value ? (value + '') : value;
    this._group = group ? (group + '') : group;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ListItem.prototype.get_text = function () {
    /// <summary>Gets the text of list item.</summary>

    return this._text;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ListItem.prototype.set_text = function (value) {
    /// <summary>Sets the texts of list item.</summary>
    /// <param name="value">The values of text.</param>

    this._text = value ? (value + '') : value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ListItem.prototype.get_group = function () {
    /// <summary>Gets the text of list item.</summary>

    return this._group;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ListItem.prototype.set_group = function (value) {
    /// <summary>Sets the texts of list item.</summary>
    /// <param name="value">The values of text.</param>

    this._group = value ? (value + '') : value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ListItem.prototype.get_value = function () {
    /// <summary>Gets the value of list item.</summary>

    return this._value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ListItem.prototype.set_value = function (value) {
    /// <summary>Sets the value of list item.</summary>
    /// <param name="value">The values of value.</param>

    this._value = value ? (value + '') : value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.FillDropDown = function (ddl, items, selVal, config) {
    config || (config = {});

    /// <summary>Fill drop down list control.</summary>
    /// <param name="ddl">Drop down list control.</param>
    /// <param name="items">List items.</param>
    /// <param name="selVal">Default value.</param>
    /// <private />

    if (ddl && items && items.length) {
        ddl.options.length = 0; // clear options

        if (config.allowExpression && selVal && (typeof selVal === 'string') && selVal.startsWith('@'))
            ddl.options[ddl.options.length] = new Option(selVal, selVal);

        if (config && config.grouped) {
            var groups = new Object();

            for (var i = 0; i < items.length; i++) {
                var groupName = items[i].get_group();

                if (groupName != '' && !groups[groupName]) {
                    var optgroup = document.createElement("optgroup");
                    optgroup.label = groupName;
                    groups[groupName] = optgroup;
                    ddl.appendChild(optgroup);
                }
            }

            for (var i = 0; i < items.length; i++) {
                var groupName = items[i].get_group();
                var newOption = new Option(items[i].get_text(), items[i].get_value());

                if (groupName == '')
                    ddl.appendChild(newOption);
                else {
                    var optgroup = groups[groupName];
                    optgroup.appendChild(newOption);
                }

                if (selVal && items[i].get_value() == selVal) newOption.selected = true;
            }
        }
        else {
            for (var i = 0; i < items.length; i++) {
                ddl.options[ddl.options.length] = new Option(items[i].get_text(), items[i].get_value());
                if (selVal && items[i].get_value() == selVal) ddl.options[i].selected = true;
            }
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TextBoxCtrl = function (id, val, onChange) {
    /// <summary>Create text box control.</summary>
    /// <param name="id">Control id.</param>
    /// <param name="val">Default value.</param>
    /// <param name="onChange">Change handler.</param>
    /// <returns>Control instance.</returns>
    /// <private />

    var result = null;

    if (id != "") {
        result = document.createElement('input');
        result.id = id;
        result.type = 'text';
        result.className = 'std';
        result.value = val;

        if (onChange) {
            Event.observe(result, 'change', function (e) {
                var el = Event.element(e);
                onChange(el.value);
            });
        }
    }

    return result;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.NumericBoxCtrl = function (id, val, onChange) {
    /// <summary>Create numeric box control.</summary>
    /// <param name="id">Control id.</param>
    /// <param name="val">Default value.</param>
    /// <param name="onChange">Change handler.</param>
    /// <returns>Control instance.</returns>
    /// <private />

    var result = null;

    if (id != "") {
        result = document.createElement('input');
        result.id = id;
        result.type = 'text';
        result.className = 'std';
        result.maxlength = 15;
        result.value = val;

        result.onkeypress = function validate(evt) {
            var theEvent = evt || window.event;
            var key = theEvent.keyCode || theEvent.which;

            // Allow @ at start of input and allow anything if first character in value is @
            if ((this.value == '' && String.fromCharCode(key) == '@') || (this.value[0] == '@')) {
                return;
            }

            if (key != 35 && key != 36 && key != 37 && key != 38 && key != 39 && key != 40 && key != 8) {
                key = String.fromCharCode(key);
                var regex = /[0-9]|\-/;
                if (!regex.test(key)) {
                    theEvent.returnValue = false;
                    if (theEvent.preventDefault) theEvent.preventDefault();
                }
            }
        };

        if (onChange) {
            Event.observe(result, 'change', function (e) {
                var el = Event.element(e);
                onChange(el.value);
            });
        }
    }

    return result;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.FloatNumericBoxCtrl = function (id, val, onChange) {
    /// <summary>Create float numeric box control.</summary>
    /// <param name="id">Control id.</param>
    /// <param name="val">Default value.</param>
    /// <param name="onChange">Change handler.</param>
    /// <returns>Control instance.</returns>
    /// <private />

    var result = null;

    if (id != "") {
        result = document.createElement('input');
        result.id = id;
        result.type = 'text';
        result.className = 'std';
        result.maxlength = 18;
        result.value = val;

        result.onkeypress = function validate(evt) {
            var theEvent = evt || window.event;
            var key = theEvent.keyCode || theEvent.which;

            // Allow @ at start of input and allow anything if first character in value is @
            if ((this.value == '' && String.fromCharCode(key) == '@') || (this.value[0] == '@')) {
                return;
            }

            if (key != 35 && key != 36 && key != 37 && key != 38 && key != 39 && key != 40 && key != 46 && key != 8) {
                key = String.fromCharCode(key);
                var regex = /[0-9]|\-|\./;
                if (!regex.test(key)) {
                    theEvent.returnValue = false;
                    if (theEvent.preventDefault) theEvent.preventDefault();
                }
            }
        };

        if (onChange) {
            Event.observe(result, 'change', function (e) {
                var el = Event.element(e);
                onChange(el.value);
            });
        }
    }

    return result;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.DropDownListCtrl = function (id, val, ds, onChange, config) {
    config || (config = {});

    /// <summary>Create float numeric box control.</summary>
    /// <param name="id">Control id.</param>
    /// <param name="val">Default value.</param>
    /// <param name="ds">Data source.</param>
    /// <param name="onChange">Change handler.</param>
    /// <returns>Control instance.</returns>
    /// <private />

    var result = null;

    if (id != "") {
        result = document.createElement('select');
        result.id = id;
        result.className = 'std';
        if (config.allowExpression) {
            result.className += ' allow-expression';
        }

        if (!ds || (ds && ds == null)) ds = new Array();

        Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.FillDropDown(result, ds, val, config);

        if (onChange) {
            Event.observe(result, 'change', function (e) {
                var el = Event.element(e);
                var val = el.options[el.selectedIndex].value;

                onChange(val);
            });
        }

        if (config.allowExpression) {
            var container = document.createElement('div');
            container.className = "field-group";
            container.appendChild(result);
            var addExpression = document.createElement('i');
            addExpression.className = 'smartsearch-expression fa fa-bolt color-primary';
            addExpression.title = 'Add expression';
            Event.observe(addExpression, 'click', function () {
                var i, option;
                var list = result;
                var options = list.options;

                var defaultExpression = '';
                if (options && options.length > 0) {
                    if (list.selectedIndex > -1 && options[list.selectedIndex].value[0] == '@') {
                        defaultExpression = options[list.selectedIndex].value;
                    }
                    if (!defaultExpression && options[0].value[0] == '@') {
                        defaultExpression = options[0].value;
                    }
                }
                var expression = prompt('Enter expression', defaultExpression);
                if (expression !== null && expression[0] == '@') {
                    var isNewExpression = true;
                    for (i = 0; option = options[i]; i++) {
                        if (option.value == expression) {
                            list.selectedIndex = i;
                            isNewExpression = false;
                            break;
                        }
                    }
                    if (isNewExpression) {
                        // Add new option
                        option = document.createElement('option');
                        // option.value = expression;
                        option.innerHTML = expression;
                        list.insertBefore(option, list.firstChild);
                        list.selectedIndex = 0;
                    }

                    // Event.fire(result, 'change');
                    if (onChange) {
                        onChange(expression);
                    }
                }
            });
            container.appendChild(addExpression);
            return container;
        }
    }

    return result;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.BooleanCtrl = function (id, val, onChange) {
    /// <summary>Create the boolean ctrl.</summary>
    /// <param name="id">Control id.</param>
    /// <param name="val">Default value.</param>
    /// <param name="onChange">Change handler.</param>
    /// <returns>Control instance.</returns>
    /// <private />

    var result = null;

    if (id != "") {
        result = document.createElement('select');
        result.id = id;
        result.className = 'std';

        var items = new Array();

        items.push(new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ListItem("True", "1"));
        items.push(new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ListItem("False", "0"));

        Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.FillDropDown(result, items, val);

        if (onChange) {
            Event.observe(result, 'change', function (e) {
                var el = Event.element(e);
                var val = el.options[el.selectedIndex].value;

                onChange(val);
            });
        }
    }

    return result;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.RateCtrl = function (id, val, isFiveStars, onChange) {
    /// <summary>Create the rate ctrl.</summary>
    /// <param name="id">Control id.</param>
    /// <param name="val">Default value.</param>
    /// <param name="onChange">Change handler.</param>
    /// <returns>Control instance.</returns>
    /// <private />

    var result = null;

    if (id != "") {
        var nVal = parseInt(val);
        if (isNaN(nVal) || !isFinite(nVal)) nVal = 0;

        result = document.createElement('div');
        result.id = id;

        var ul = document.createElement('ul');
        ul.className = 'star-rating';

        var rootPath = "";

        var hidden = document.createElement('input');
        hidden.type = "hidden";
        hidden.id = id;
        hidden.value = "0";

        var starsNumber = isFiveStars ? 5 : 4;

        for (var i = 1; i <= starsNumber; i++) {
            var el_li = document.createElement('li');
            var el_a = document.createElement('a');
            var el_img = document.createElement('img');

            el_a.id = i + "-" + id;
            el_a.href = "#";
            el_a.title = i + " / " + starsNumber;

            el_img.id = i + "-ri-" + id;
            el_img.src = rootPath + ((nVal >= i) ? "/Admin/Content/Management/SmartSearches/img/star.png"
                                                 : "/Admin/Content/Management/SmartSearches/img/star_empty.png");
            el_img.border = 0;

            el_a.appendChild(el_img);
            el_li.appendChild(el_a);

            ul.appendChild(el_li);

            Event.observe(el_a, 'click', function (e) {
                var ids = Event.element(e).id.split("-ri-");

                if (ids && ids.length == 2 && ids[1] != "") {
                    var rateVal = parseInt(ids[0]);

                    if (!isNaN(rateVal) && isFinite(rateVal)) {
                        document.getElementById(ids[1]).value = rateVal.toString();

                        for (var i = 1; i <= starsNumber; i++) {
                            document.getElementById((i + "-ri-" + ids[1])).src = ((rateVal >= i)
                            ? "/Admin/Content/Management/SmartSearches/img/star.png"
                            : "/Admin/Content/Management/SmartSearches/img/star_empty.png");
                        }
                    }

                    if (onChange) onChange(rateVal);
                }
            });
        }

        result.appendChild(hidden);
        result.appendChild(ul);
    }

    return result;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.FileSelectorCtrl = function (id, val, ds, onChange) {
    /// <summary>Create the new file selector ctrl.</summary>
    /// <param name="id">Control id.</param>
    /// <param name="val">Default value.</param>
    /// <param name="onChange">Change handler.</param>
    /// <returns>Control instance.</returns>
    /// <private />

    var result = null;

    if (id != "") {
        result = document.createElement('div');
        result.align = "left";
        result.style.display = "block";
        result.style.width = '230px';

        var selector = document.createElement('select');
        selector.id = "FM_" + id;
        selector.name = id;
        selector.className = 'FileManagerSelect';
        selector.setAttribute('style', 'width:200px !important; float: left;');

        if (!ds || (ds && ds == null)) ds = new Array();
        ds.splice(0, 0, new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ListItem("Nothing selected", ""));

        if (ds.length == 1 && val != "") ds.push(new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ListItem(val, val));

        Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.FillDropDown(selector, ds, val);

        selector.onchange = function (e) {
            var e = e ? e : window.event;

            var el = null;
            if (!e) el = this;
            else el = Event.element(e);

            var value = el.options[el.selectedIndex].value;

            morefiles(value, el.id, 'Files/', value); updateHiddenPath(el.name);

            if (onChange) onChange(value);
        };

        result.appendChild(selector);

        var hidden = document.createElement('input');
        hidden.type = "hidden";
        hidden.id = id + "_path";
        hidden.name = id + "_path";
        hidden.value = val;

        result.appendChild(hidden);

        var img = document.createElement('img');
        img.id = id + "_img";
        img.src = "/Admin/Images/Browse.gif";
        img.align = "absMiddle";
        img.className = "H";
        img.alt = "Browse";

        Event.observe(img, 'click', function (e) {
            var el = Event.element(e);
            var id = el.id.replace("_img", "");

            browseFullPath(("FM_" + id), 'Files/', document.getElementById(("FM_" + id)).value, '*');
        });

        result.appendChild(img);
    }

    return result;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.LinkSelectorCtrl = function (id, val, onChange, onlyPageSelector) {
    /// <summary>Create the new link selector ctrl.</summary>
    /// <param name="id">Control id.</param>
    /// <param name="val">Default value.</param>
    /// <param name="onChange">Change handler.</param>
    /// <returns>Control instance.</returns>
    /// <private />

    var result = null;

    if (id != "") {
        result = document.createElement('div');
        result.className = "field-group";

        var hidden = document.createElement('input');
        hidden.type = "hidden";
        hidden.id = id;
        hidden.name = id;
        hidden.value = val;

        result.appendChild(hidden);

        var input = document.createElement('input');
        input.type = "text";
        input.maxlength = 255;
        input.className = 'std';
        input.id = "Link_" + id;
        input.name = id;
        input.value = val;

        try {
            input.setAttribute('smartsearchctrl', 'true');
            input.setAttributeNode('smartsearchctrl', 'true');
        }
        catch (e) {; };

        input.onchange = function (e) {
            var value = input.value;

            document.getElementById(id).value = value;
            if (onChange) onChange(value);
        };

        result.appendChild(input);

        var btnPage = document.createElement('span');
        btnPage.innerHTML = "<a onclick=internal(0,'','Link_" + id + "',false);><i class='fa fa-file-o' alt='Page' title='Page'></i></a>";
        result.appendChild(btnPage);

        if (!onlyPageSelector) {
            //var btnParagraph = document.createElement('span');
            //btnParagraph.className = "input-group-addon last";
            //btnParagraph.innerHTML = "<a onclick=internal(0,'','Link_" + id + "',true);><i class='fa fa-file-text-o color-primary h' alt='Paragraph' title='Paragraph'></i></a>";
            //result.appendChild(btnParagraph);

            var btnFile = document.createElement('span');
            btnFile.innerHTML = "<a onclick=browseFullPath('Link_" + id + "',null,document.getElementById('" + id + "').value,null,null);><i class='fa fa-folder-open-o color-folder' alt='Browse' title='Browse'></i></a>";
            result.appendChild(btnFile);
        }

    }

    return result;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.EmailCtrl = function (id, val, onChange) {
    var result = null,
        hiddenValue,
        displayValue,
        value = (function () {
            try {
                return val.evalJSON(true);
            } catch (ex) { }
            return {};
        }()),
        storeValue = function (value) {
            if (onChange) {
                try {
                    value = Object.toJSON(value);
                    onChange(value);
                    return true;
                } catch (ex) { }
            }
            return false;
        },
        renderValue = function (value) {
            return value.name || '';
        };

    if (id != "") {
        result = new Element('div', {
            className: "field-group",
        });

        hiddenValue = new Element('input', {
            type: "hidden",
            id: id,
            value: val
        });
        let valChanged = function (obj) {
            if (storeValue(obj)) {
                displayValue.value = renderValue(obj);
            }
        };

        result.appendChild(hiddenValue);

        displayValue = new Element('input', {
            id: 'Title_' + id,
            value: renderValue(value),
            className: 'std',
            disabled: true
        });
        result.appendChild(displayValue);

        var button = new Element("i", {
            className: "fa fa-file-o color-primary"
        });
        button.on('click', function () {
            let editorEl = hiddenValue;
            let dlgUrl = '/Admin/Marketing/Dialogs/EmailMarketing/SelectEmail';
            if (editorEl.value) {
                dlgUrl += '?emailId=' + editorEl.value;
            }
            Action.Execute({
                'Name': 'OpenDialog',
                'Url': dlgUrl,
                'OnSubmitted': {
                    'Name': 'ScriptFunction',
                    'Function': function (act, model) {
                        valChanged({
                            id: model.SelectedEmailId,
                            name: model.SelectedEmailTitle
                        });
                    }
                }
            });
        });

        result.appendChild(button);
    }

    return result;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.EmailLinkCtrl = function (id, val, onChange) {
    var result = null,
        hiddenValue,
        displayValue,
        value = (function () {
            try {
                return val.evalJSON(true);
            } catch (ex) { }
            return {};
        }()),
        storeValue = function (v) {
            if (onChange) {
                try {
                    value = v;
                    onChange(Object.toJSON(value));
                    return true;
                } catch (ex) { }
            }
            return false;
        },
        renderValue = function () {
            var s = value.linkUrl || '';
            if (value.emailSubject) {
                s += ' (' + value.emailSubject + ')';
            }
            return s;
        };

    if (id != "") {
        result = new Element('div', {
            className: "field-group"
        });

        hiddenValue = new Element('input', {
            type: "hidden",
            id: id,
            value: val
        });

        result.appendChild(hiddenValue);

        displayValue = new Element('input', {
            id: 'Title_' + id,
            value: renderValue(),
            className: 'std',
            disabled: true
        });
        result.appendChild(displayValue);

        const button = new Element("i", {
            className: "fa fa-file-o color-primary"
        });
        button.on('click', function () {
            let setEmailLink = function (data) {
                hiddenValue.value = data.linkId;
                storeValue(data);
                displayValue.value = renderValue();
            };
            let linkId = hiddenValue.value;
            if (value.linkId) {
                linkId = value.linkId;
            }
            let url = '/Admin/Content/Management/SmartSearches/misc/SelectEmailLink.aspx';
            if (linkId) {
                url += '?linkId=' + linkId;
            }
            Action.Execute({
                'Name': 'OpenDialog',
                'Url': url,
                'OnSubmitted': {
                    'Name': 'ScriptFunction',
                    'Function': function (act, model) {
                        console.log(arguments);
                        setEmailLink(model);
                    }
                }
            });
        });
        result.appendChild(button);
    }

    return result;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.PageCtrl = function (id, val, onChange) {
    return Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.LinkSelectorCtrl(id, val, onChange, true);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ProductCtrl = function (id, val, onChange) {
    var result = null,
        hiddenValue,
        displayValue,
        selection, // Filled in callback
        value = (function () {
            try {
                return val.evalJSON(true);
            } catch (ex) { }
            return {};
        }()),
        storeValue = function (value) {
            if (onChange) {
                try {
                    value = Object.toJSON(value);
                    onChange(value);
                    return true;
                } catch (ex) { }
            }
            return false;
        },
        renderValue = function (items) {
            var s = [];
            var i, item;
            for (i = 0; item = items[i]; i++) {
                var text = item.name;
                var type = '';
                type = item.id[0];
                if (item.id[0] == 'p') {
                }
                if (type) {
                    text += ' (' + type + ')';
                }
                s.push(text);
            }
            return s.join(', ');
        };

    if (id != "") {
        result = new Element('div', {
            className: 'field-group'
        });

        hiddenValue = new Element('input', {
            type: "hidden",
            id: id,
            value: val
        });

        hiddenValue.onchange = function () {
            if (storeValue(selection)) {
                displayValue.value = renderValue(selection);
                displayValue.title = renderValue(selection);
            }
        }

        result.appendChild(hiddenValue);

        displayValue = new Element('input', {
            id: id + '_display',
            value: renderValue(value),
            title: renderValue(value),
            className: 'std',
            disabled: true
        });
        result.appendChild(displayValue);

        var button = new Element("i", {
            className: "fa fa-archive color-primary"
        });

        button.on('click', function () {
            var cmd = 'ProductsAndGroupsSelector';
            var caller = 'opener.document.getElementById(\'' + hiddenValue.id + '\')';

            // Reset the selection
            selection = [];

            window.addProductDivContent = function (id, name) {
                selection.push({ id: id, name: name });
            }

            var url = '/Admin/Module/eCom_Catalog/dw7/Edit/EcomGroupTree.aspx?'
                    + 'CMD=' + encodeURIComponent(cmd)
                    + '&Caller=' + encodeURIComponent(caller)
                    + '&showSearches=True'
                    + '&InvokeOnChangeOnID=true';
            var win = window.open(url, '_blank', "displayWindow,width=460,height=400,scrollbars=no");
        });

        result.appendChild(button);
    }

    return result;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.UserCtrl = function (id, val, onChange) {
    var result = null,
        hiddenValue,
        displayValue,
        selection, // Filled in callback
        value = (function () {
            try {
                return val.evalJSON(true);
            } catch (ex) { }
            return {};
        }()),
        storeValue = function (value) {
            if (onChange) {
                try {
                    value = Object.toJSON(value);
                    onChange(value);
                    return true;
                } catch (ex) { }
            }
            return false;
        };

    if (id != "") {
        result = new Element('div', {
            align: "left",
            display: "block",
            style: "width: 230px"
        });

        hiddenValue = new Element('input', {
            type: "hidden",
            id: id,
            value: val
        });

        result.appendChild(hiddenValue);

        displayValue = new Element('input', {
            id: id + '_display',
            value: value[0] == null ? '' : value[0].name,
            title: value[0] == null ? '' : value[0].name,
            style: 'width: 200px !important',
            disabled: true
        });
        result.appendChild(displayValue);

        var button = new Element("i", {
            className: "md md-person editor-cell-btn"
        });
        button.on('click', function () {
            var afterPopupClose = function (returnValue) {
                if (returnValue && returnValue.userID && returnValue.userName) {
                    var newid = returnValue.userID;
                    var newname = decodeURIComponent(returnValue.userName);

                    selection = [];
                    selection.push({ id: newid, name: newname });
                    document.getElementById(hiddenValue.id).value = Object.toJSON(selection);

                    if (storeValue(selection)) {
                        displayValue.value = newname;
                        displayValue.title = newname;
                    }
                }
            }
            var url = '/Admin/Module/UserManagement/SelectUserPopup.aspx' +
                     '?UserCallBack=Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.addUserWithID' +
                     '&OnlyBackend=false' +
                     '&CompatibleWithOldExtranet=false' +
                     '&HideAdmins=false';
            if (window.showModalDialog) {
                var returnValue = window.showModalDialog(url, 'AddUserPopup', 'dialogHeight: 600px; dialogWidth: 400px;');
                afterPopupClose(returnValue);
            } else {
                var popupWnd = window.open(url, 'AddUserPopup', 'status=0,toolbar=0,menubar=0,resizable=0,directories=0,titlebar=0,modal=yes,width=400,height=600');
                popupWnd.onunload = function () {
                    afterPopupClose(popupWnd.returnValue);
                }
            }
        });

        result.appendChild(button);
    }

    return result;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.DateFormatter = function (format, terminology) {
    /// <summary>Represents a date formatter.</summary>
    /// <param name="format">Date format.</param>

    this._format = format || '';
    this._index = 0;
    this._tokens = null;

    this._evaluators = [
        { token: 'd', materialize: function (date) { return date.getDate().toString(); } },
        { token: 'dd', materialize: function (date) { var d = date.getDate(); return (d < 10) ? ('0' + d) : d.toString(); } },
        { token: 'D', materialize: function (date) { var h = date.getDay(); return isFinite(h) ? terminology.DaysShort[h] : ""; } },
        { token: 'h', materialize: function (date) { var h = date.getHours() + 1; if (h > 12) h -= 12; return h.toString(); } },
        { token: 'hh', materialize: function (date) { var h = date.getHours() + 1; if (h > 12) h -= 12; return (h < 10) ? ('0' + h) : h.toString(); } },
        { token: 'H', materialize: function (date) { return date.getHours().toString(); } },
        { token: 'HH', materialize: function (date) { var h = date.getHours(); return (h < 10) ? ('0' + h) : h.toString(); } },
        { token: 'm', materialize: function (date) { return date.getMinutes().toString(); } },
        { token: 'mm', materialize: function (date) { var m = date.getMinutes(); return (m < 10) ? ('0' + m) : m.toString(); } },
        { token: 'M', materialize: function (date) { return (date.getMonth() + 1).toString(); } },
        { token: 'MM', materialize: function (date) { var m = date.getMonth() + 1; return (m < 10) ? ('0' + m) : m.toString(); } },
        { token: 'MN', materialize: function (date) { var m = date.getMonth(); return isFinite(m) ? terminology.MonthsShort[m] : ""; } },
        { token: 's', materialize: function (date) { return date.getSeconds().toString(); } },
        { token: 'ss', materialize: function (date) { var s = date.getSeconds(); return (s < 10) ? ('0' + s) : s.toString(); } },
        { token: 'yy', materialize: function (date) { var y = date.getFullYear(); return y.toString().substr(2); } },
        { token: 'yyyy', materialize: function (date) { return date.getFullYear().toString(); } }
    ];
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.DateFormatter.prototype.format = function (date) {
    /// <summary>Formats the given date.</summary>
    /// <param name="date">Date to format.</param>

    var ret = '';
    var evaluator = null;

    if (date && typeof (date.getTime) == 'function') {
        if (this._tokens == null || !this._tokens.length) {
            this._tokens = this._tokenize();
        }

        if (this._tokens != null && this._tokens.length) {
            for (var i = 0; i < this._tokens.length; i++) {
                evaluator = null;

                for (var j = 0; j < this._evaluators.length; j++) {
                    if (this._evaluators[j].token == this._tokens[i]) {
                        evaluator = this._evaluators[j];
                        break;
                    }
                }

                if (evaluator) {
                    ret += evaluator.materialize(date);
                } else {
                    ret += this._tokens[i];
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.DateFormatter.prototype._tokenize = function () {
    /// <summary>Tokenizes the current date format.</summary>
    /// <private />

    var ret = [];
    var token = null;

    this._index = 0;

    if (!this._format || typeof (this._format) != 'string') {
        this._format = '';
    }

    if (this._format.length) {
        do {
            token = this._nextToken();
            if (!token) {
                break;
            } else {
                ret[ret.length] = token;
            }
        } while (true);
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.DateFormatter.prototype._nextToken = function () {
    /// <summary>Returns the next token or null if no more tokens can be retrieved.</summary>
    /// <private />

    var code = 0;
    var token = '';
    var isAlpha = false;
    var wasAlpha = false;
    var format = this._format || '';
    var bounds = [
        { from: 'A'.charCodeAt(), to: 'Z'.charCodeAt() },
        { from: 'a'.charCodeAt(), to: 'z'.charCodeAt() }
    ];

    if (this._index < format.length) {
        for (var i = this._index; i < format.length; i++) {
            code = format.charCodeAt(i);
            isAlpha = (code >= bounds[0].from && code <= bounds[0].to) ||
                (code >= bounds[1].from && code <= bounds[1].to);

            if (isAlpha) {
                if (!wasAlpha) {
                    if (token.length > 0) {
                        break;
                    } else {
                        wasAlpha = true;
                    }
                }

                token += format.charAt(i);
            } else {
                if (wasAlpha) {
                    break;
                } else {
                    token += format.charAt(i);
                }
            }
        }

        this._index = i;
    }

    return token;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.DateTimeCtrl = function (id, val, nameOfMonths, onChange, showTime, showDynamicValues, terminology) {
    /// <summary>Create the boolean ctrl.</summary>
    /// <param name="id">Control id.</param>
    /// <param name="val">Default value.</param>
    /// <param name="nameOfMonths">String with months names separated by coma, sample: Jan,Feb...</param>
    /// <param name="onChange">Change handler.</param>
    /// <returns>Control instance.</returns>
    /// <private />

    var result = null;
    var mainDateFormat = 'D, dd MN yyyy'; // You can change this date format.
    var mainDateFormatWithTime = mainDateFormat + ' HH:mm';
    var storeDateFormat = 'yyyy-MM-dd HH:mm'; // Do not change!

    var formatDate = function (date, format) {
        var formater = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.DateFormatter(format, terminology);
        return formater.format(date);
    }

    var convertToDate = function (stringValue, format) {
        var dateIsValid;
        var d = new Date(stringValue);

        if (Object.prototype.toString.call(d) === "[object Date]") {
            if (isNaN(d.getDate())) {
                dateIsValid = false;
            } else {
                dateIsValid = true;
            }
        } else {
            dateIsValid = false;
        }

        if (dateIsValid) {
            return d;
        }

        return "Never";
    }

    var dateSelectorOnChange = function (element, dynamicValuesInit) {
        var el = this;
        var ctrlId = el.id.replace("_calendar", "");
        var timeCtrl = document.getElementById(ctrlId + "_calendar_time_btn");
        var value = el.value || '';
        var isNotSet = document.getElementById(ctrlId + "_notSet").value;

        var dynamicValuesSelector = document.getElementById(ctrlId + "_dynamicDatesSelector");

        if (dynamicValuesInit == true) {
            timeCtrl.disabled = true;
        } else if (value.charAt(0) == '@' || value.toLowerCase() == "never" || value == "") {
            onChange(value);
            timeCtrl.disabled = true;
        } else if (isNotSet.toLowerCase() === 'true') {
            onChange('Never');
            timeCtrl.disabled = true;
            dynamicValuesSelector.selectedIndex = 1;
        } else {
            timeCtrl.disabled = false;
            var dateValue = convertToDate(value, mainDateFormatWithTime);
            onChange(formatDate(dateValue, storeDateFormat));
            dynamicValuesSelector.selectedIndex = -1;
        }
    };

    if (id != "") {
        var displayedDate = '';
        var notSet = 'True';
        var isDynamicValue = (val.charAt(0) === "@" || val.toLowerCase() === "never");
        var date = new Date();

        if (!!val && val != "" && !isDynamicValue) {
            try {
                date = convertToDate(val, storeDateFormat);
            } catch (e) {
                date = new Date();
            }
            notSet = 'False';
            displayedDate = formatDate(date, showTime ? mainDateFormatWithTime : mainDateFormat)
            displayedHour = date.getHours();
            displayedMinute = date.getMinutes();
        } else if (!!val && val != "" && isDynamicValue) {
            displayedDate = val;
            displayedHour = 0;
            displayedMinute = 0;
            notSet = 'False';
        }

        var currentDate = val.toLowerCase() == "never" ? "2999-12-31T00:00" : val;

        result = document.createElement('div');
        result.className = "ajax-rich-control";
        result["data-control-instance"] = "DateTime_DateSelector";
        result.innerHTML =
        '<div class="input-group date-picker">' +
        '    <div class="fg-line">' +
        '        <span id="' + id + '_label" class="std DateSelectorLabel form-control">' + (val.toLowerCase() == "never" ? (terminology.Never || "never") : displayedDate) + '</span>' +
        '        <input type="text" class="std form-control CustomValueTextEditor" style="display: none; max-width: 180px;" autocomplete="off" />' +
        '    </div>' +
            (showDynamicValues ? '<span class="input-group-addon date-selector-btn"><a class="date-selector-dynamic-values" title="Select date"><i class="fa fa-bars"></i></a></span>' : '') +
        '    <span class="input-group-addon date-selector-btn pika-calendar-button" id="' + id + '_calendar_btn" title="Choose date">' +
        '        <i class="fa fa-calendar"></i>' +
        '    </span>' +
        '    <span class="input-group-addon date-selector-btn pika-time-button" id="' + id + '_calendar_time_btn" title="Choose time">' +
        '        <i class="fa fa-clock-o"></i>' +
        '    </span>' +
        '    <input type="hidden" id="DWCalendarNotSetString" value="' + terminology.Never + '" />' +
        '    <input type="hidden" value="' + currentDate + '" id="' + id + '_datepicker" />' +
        '    <input type="hidden" value="' + currentDate + '" id="' + id + '_calendar" name="' + id + '" class="date-selector-date" />' +
        '    <span class="input-group-addon date-selector-btn pika-remove-button ClearDateImage" title="Clear date" onclick="DWClearDate(\'' + id + '\')">' +
        '        <i class="fa fa-remove color-danger"></i>' +
        '    </span>' +
        '    <input type="hidden" name="' + id + '_notSet" id="' + id + '_notSet" value="' + notSet + '" />' +
        '</div>';

        var days = '["' + terminology.Days.join('", "') + '"]';
        var months = '["' + terminology.Months.join('", "') + '"]';

        var jScript = document.createElement('script');
        jScript.type = "text/javascript";
        jScript.text =
        'function getDayNames() { return ' + days + '; }; \n' +
        'function getMonthNames() { return ' + months + '; }; \n' +
        'SetupCalendarOnfocus("' + id + '", 1900, 2021, "2999-12-31T00:00", ' + '"' + displayedDate + '"' + ', ' + days + ', ' + months + ', ' +
        'function () { ' +
        'document.getElementById("' + id + '_calendar").onchange(); ' +
        '}); \n' +
        'if (' + isDynamicValue + ') { ' +
        'document.getElementById("' + id + '_calendar").onchange(null, true); ' +
        '} ';
        result.appendChild(jScript);

        var regDates = null;
        if (showDynamicValues) {

            regDates = [{ 'key': terminology.Now || "now", 'value': "@Code(System.DateTime.Now)" },
                        { 'key': terminology.Never || "never", 'value': "Never" },
                        { 'key': terminology.Tomorrow || "tomorrow", 'value': "@Code(System.DateTime.Today.AddDays(1))" },
                        { 'key': terminology.Today || "today", 'value': "@Code(System.DateTime.Today)" },
                        { 'key': terminology.Yesterday || "yesterday", 'value': "@Code(System.DateTime.Today.AddDays(-1))" },
                        { 'key': terminology.TwoDaysAgo || "two days ago", 'value': "@Code(System.DateTime.Today.AddDays(-2))" },
                        { 'key': terminology.OneWeekAgo || "one week ago", 'value': "@Code(System.DateTime.Today.AddDays(-7))" },
                        { 'key': terminology.TwoWeeksAgo || "two weeks ago", 'value': "@Code(System.DateTime.Today.AddDays(-14))" },
                        { 'key': terminology.OneMonthAgo || "one month ago", 'value': "@Code(System.DateTime.Today.AddMonths(-1))" },
                        { 'key': terminology.TwoMonthsAgo || "two months ago", 'value': "@Code(System.DateTime.Today.AddMonths(-2))" },
                        { 'key': terminology.Custom || "custom", 'value': "@Code(System.DateTime.Today.AddDays(-1))" }];

            var dynamicDateSelector = document.createElement('select');
            dynamicDateSelector.className = "dynamicDatesSelector";
            dynamicDateSelector.id = id + "_dynamicDatesSelector";
            dynamicDateSelector.style.display = "none";
            dynamicDateSelector.style.position = "absolute";
            var opt;
            for (var i = 0; i < regDates.length; i++) {
                opt = document.createElement('option');
                opt.value = regDates[i].value;
                opt.text = regDates[i].key;
                opt.isCustom = (opt.text == terminology.Custom || opt.text == "custom");
                dynamicDateSelector.appendChild(opt);
            }
            dynamicDateSelector.selectedIndex = -1;
            dynamicDateSelector.size = regDates.length;
            dynamicDateSelector.isShown = false;
            dynamicDateSelector.onblur = function (e) {
                e.target.style.display = "none";
                dynamicDateSelector.isShown = false;
            };

            var customEditor = result.select('.CustomValueTextEditor')[0];
            var hiddenValue = result.select('.date-selector-date')[0];
            dynamicDateSelector.onchange = function (e) {
                var dSelector = e.target;
                dSelector.style.display = "none";
                var p = dSelector.parentElement;
                var lbl = p.select('.DateSelectorLabel')[0];
                var selectedOpt = dSelector.selectedIndex ? dSelector[dSelector.selectedIndex] : dSelector.selectedOptions[0];
                var selectedOptValue = dSelector.value;

                if (selectedOpt.isCustom) {
                    lbl.style.display = 'none';
                    customEditor.style.display = 'block';
                    customEditor.value = selectedOptValue
                    customEditor.title = customEditor.value;
                    customEditor.onchange();
                } else {
                    lbl.style.display = 'block';
                    customEditor.style.display = 'none';
                    lbl.textContent = selectedOpt.text;
                }

                hiddenValue.value = selectedOptValue;
                onChange(selectedOptValue)
            };

            customEditor.onchange = function () {
                hiddenValue.value = customEditor.value;
                onChange(customEditor.value);
            }

            var regValueBtn = result.select('.date-selector-dynamic-values')[0];
            Event.observe(regValueBtn, 'click', function (e) {
                var selectors = document.getElementsByClassName('dynamicDatesSelector');
                for (var i = 0; i < selectors.length; i++) {
                    selectors[i].style.display = "none";
                }
                if (dynamicDateSelector.isShown) {
                    dynamicDateSelector.style.display = "none";
                    dynamicDateSelector.isShown = false;
                } else {
                    dynamicDateSelector.style.display = "";
                    dynamicDateSelector.isShown = true;
                    dynamicDateSelector.focus();
                };
            });

            result.appendChild(dynamicDateSelector);
        };

        var calendar = result.getElementsByClassName('date-selector-date')[0];
        calendar.onchange = dateSelectorOnChange;

        var date_label = result.getElementsByClassName('DateSelectorLabel')[0];

        if (regDates) {
            for (var i = 0; i < regDates.length; i++) {
                if (regDates[i].value == calendar.value) {
                    date_label.textContent = regDates[i].key;
                    break;
                }
            }

            if (date_label.textContent.toString().startsWith("@Code")) { // is custom value
                var customEditor = result.select('.CustomValueTextEditor')[0];
                date_label.style.display = 'none';
                customEditor.style.display = 'block';
                customEditor.value = calendar.value;
                customEditor.title = customEditor.value;
            }
        }
    }

    return result;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule = function () {
    /// <summary>Represents a recognition rule.</summary>

    this._id = '';
    this._fieldId = '';
    this._fieldName = '';
    this._fieldType = '';
    this._controlType = '';
    this._dataSource = null;
    this._operator = Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Operator.equals;
    this._groupName = '';


    this._values = new Array();
    this._values.push('');
    this._values.push(null);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.get_id = function () {
    /// <summary>Gets the unique identifier of the rule.</summary>

    return this._id;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.set_id = function (value) {
    /// <summary>Sets the unique identifier of the rule.</summary>
    /// <param name="value">The unique identifier of the rule.</param>

    this._id = value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.get_fieldId = function () {
    /// <summary>Gets the unique identifier of the rule.</summary>

    return this._fieldId;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.set_fieldId = function (value) {
    /// <summary>Sets the unique identifier of the rule.</summary>
    /// <param name="value">The unique identifier of the rule.</param>

    this._fieldId = value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.get_fieldName = function () {
    /// <summary>Gets the rule name.</summary>

    return this._fieldName;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.set_fieldName = function (value) {
    /// <summary>Sets the rule name.</summary>
    /// <param name="value">The rule name.</param>

    this._fieldName = value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.get_fieldType = function () {
    /// <summary>Gets the assembly-qualified name of the CLR type that corresponds to this rule.</summary>

    return this._fieldType;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.set_fieldType = function (value) {
    /// <summary>Sets the assembly-qualified name of the CLR type that corresponds to this rule.</summary>
    /// <param name="value">The assembly-qualified name of the CLR type that corresponds to this rule.</param>

    this._fieldType = value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.get_controlType = function () {
    /// <summary>Gets the rule description.</summary>

    return this._controlType;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.set_controlType = function (value) {
    /// <summary>Sets the rule description.</summary>
    /// <param name="value">The rule description.</param>

    this._controlType = value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.get_dataSource = function () {
    /// <summary>Gets the rule constraint.</summary>

    return this._dataSource;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.set_dataSource = function (value) {
    /// <summary>Sets the rule constraint.</summary>
    /// <param name="value">The rule constraint.</param>

    this._dataSource = value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.get_operator = function () {
    /// <summary>Gets the rule operator.</summary>

    return this._operator;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.get_groupName = function () {
    /// <summary>Gets the rule operator.</summary>

    return this._groupName;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.set_operator = function (value) {
    /// <summary>Sets the rule operator.</summary>
    /// <param name="value">The rule constraint.</param>

    this._operator = value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.set_groupName = function (value) {
    /// <summary>Sets the rule operator.</summary>
    /// <param name="value">The rule constraint.</param>

    this._groupName = value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.get_value = function () {
    /// <summary>Gets the rule operator.</summary>
    this._values[1] = null;

    return this._values[0];
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.set_value = function (value) {
    /// <summary>Sets the rule operator.</summary>
    /// <param name="value">The rule constraint.</param>

    this._values[1] = null;
    this._values[0] = value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.get_valueFrom = function () {
    /// <summary>Gets the rule operator.</summary>
    return this._values[0];
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.set_valueFrom = function (value) {
    /// <summary>Sets the rule operator.</summary>
    /// <param name="value">The rule constraint.</param>
    this._values[0] = value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.get_valueTo = function () {
    /// <summary>Gets the rule operator.</summary>
    return this._values[1];
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.set_valueTo = function (value) {
    /// <summary>Sets the rule operator.</summary>
    /// <param name="value">The rule constraint.</param>
    this._values[1] = value;
}
Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.get_isRangeValues = function () {
    /// <summary>Sets the rule operator.</summary>
    /// <param name="value">The rule constraint.</param>

    return (this._values[1] != null);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule.prototype.load = function (data) {
    /// <summary>Replaces the state of the current object with the state of the given one.</summary>
    /// <param name="data">New state.</param>

    var constraint = null;
    var dataConstraint = null;

    if (data) {
        if (typeof (data.get_id) == 'function') {
            this.set_id(data.get_id());
            this.set_fieldId(data.get_fieldId());
            this.set_fieldName(data.get_fieldName());
            this.set_fieldType(data.get_fieldType());
            this.set_controlType(data.get_controlType());
            this.set_dataSource(data.get_dataSource());
            this.set_operator(data.get_operator());
            this.set_groupName(data.get_groupName());

            if (data.get_isRangeValues()) {
                this.set_valueFrom(data.get_valueFrom());
                this.set_valueTo(data.get_valueTo());
            }
            else {
                this.set_value(data.get_value());
            }
        } else {
            this.set_id(data.id);
            this.set_fieldId(data.fieldId);
            this.set_fieldName(data.fieldName);
            this.set_fieldType(data.fieldType);
            this.set_controlType(data.controlType);
            this.set_groupName(data.groupName);

            if (data.dataSource && data.dataSource != null && data.dataSource.length) {
                var ds = new Array();

                for (var i = 0; i < data.dataSource.length; i++) {
                    ds.push(new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ListItem(data.dataSource[i].text, data.dataSource[i].value));
                }

                this.set_dataSource(ds);
            }
            else {
                this.set_dataSource(null);
            }


            this.set_operator(Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Operator.equals);
            this.set_value('');
        }
    } else {
        this.set_id('');
        this.set_fieldId('');
        this.set_fieldName('');
        this.set_fieldType('');
        this.set_controlType(Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CtrlType.TextBox);
        this.set_dataSource(null);
        this.set_operator(Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Operator.equals);
        this.set_value('');
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeComponentComparator = function () {
    /// <summary>Represents an expression tree component comparator.</summary>
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeComponentComparator.prototype.compare = function (c1, c2) {
    /// <summary>Compares two expression tree components and returns the interer value representing a result of the comparison.</summary>
    /// <param name="c1">First component.</param>
    /// <param name="c1">Second component.</param>

    return (c1 == c2) ? 0 : -1;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeSerializer = function () {
    /// <summary>Represents an expression tree serializer.</summary>

    this.xmlEncode = function (s) {
        if (s) {
            if (typeof s != 'string') {
                s = s.toString();
            }
            s = s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&apos;');
        }
        return s;
    };
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeSerializer.prototype.toXml = function (tree) {
    /// <summary>Serializes the tree to XML string.</summary>
    /// <param name="tree">Tree to serialize.</param>

    var components = [];
    var ret = '<?xml version="1.0" encoding="utf-8"?>';

    if (tree && typeof (tree.get_components) == 'function') {
        components = tree.get_components();
    }

    if (components && components.length) {
        ret += '<RulesGroups>';
        ret += this._serializeGroup(tree, '');
        ret += '</RulesGroups>';
    } else {
        ret += '<RulesGroups/>';
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeSerializer.prototype._serializeGroup = function (group, ovnerCombine) {
    /// <summary>Serializes the given expression group to XML.</summary>
    /// <param name="group">Group to serialize.</param>
    /// <private />

    var ret = '';
    var rule = null;
    var combine = '';
    var operator = '';
    var components = [];

    if (group) {
        components = group.get_components();

        if (components && components.length) {
            var groupXML = "";
            var groups = new Array();

            for (var i = 0; i < components.length; i++) {
                combine = 'None';

                if (typeof (components[i].get_method) == 'function') {
                    combine = Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CombineMethod.getName(components[i].get_method());
                    combine = Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Enumeration.pascalCaseField(combine);

                    groupXML = this._serializeGroup(components[i], combine);

                    if (groupXML != '')
                        groups.push(groupXML);

                } else if (typeof (components[i].get_rule) == 'function') {
                    rule = components[i].get_rule();

                    operator = Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Operator.getName(rule.get_operator());
                    operator = Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Enumeration.pascalCaseField(operator);

                    ret += '<Rule fieldID="' + rule.get_fieldId() + '" fieldType="' + rule.get_fieldType()
                        + '" ctrlTypeID="' + rule.get_controlType() + '" fieldName="' + this.xmlEncode(rule.get_fieldName())
                        + '" operator="' + rule.get_operator() + '" ruleValueFrom="' + this.xmlEncode(rule.get_valueFrom())
                        + '" ruleValueTo="' + this.xmlEncode(rule.get_isRangeValues() ? rule.get_valueTo() : 'Nothing') + '" /> ';
                }
            }

            var container = "";

            if (ret != '') {
                if (ovnerCombine != '')
                    container = '<RulesGroup CombineMethod="' + ovnerCombine + '">' + ret + '</RulesGroup>';
                else if (ret.indexOf("RulesGroup") == -1)
                    container = '<RulesGroup CombineMethod="' + combine + '">' + ret + '</RulesGroup>';
                ret = container;
            }

            if (groups.length > 0) {
                container = '';
                for (var i = 0; i < groups.length; i++) {
                    container += groups[i];
                }

                ret += container;
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeSerializer.prototype.fromXml = function (xml) {
    /// <summary>Deserializes the tree from XML string.</summary>
    /// <param name="xml">XML string.</param>
    var tag = '';
    var ret = null;
    var doc = null;
    var children = [];

    if (xml && xml.length) {
        doc = Try.these(
            function () { return new DOMParser().parseFromString(xml, 'text/xml'); },
            function () {
                var xmlDom = new ActiveXObject('Microsoft.XMLDOM');
                xmlDom.loadXML(xml);

                return xmlDom;
            });

        if (doc) {
            doc = doc.documentElement;
            children = typeof (doc.childNodes) != 'undefined' ? doc.childNodes : doc.childElements;

            if (children && children.length) {
                ret = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTree();

                for (var i = 0; i < children.length; i++) {
                    tag = (children[i].tagName || children[i].nodeName).toLowerCase();

                    if (tag == 'rulesgroup')
                        this._deserializeGroup(children[i], ret);
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeSerializer.prototype._deserializeGroup = function (data, appendTo) {
    /// <summary>Deserializes the given expression group.</summary>
    /// <param name="data">Group to deserialize.</param>
    /// <param name="appendTo">Parent group to append to.</param>
    /// <private />

    var tag = '';
    var group = null;
    var children = [];

    if (data && appendTo) {
        group = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeGroup();

        group.set_method(Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CombineMethod.parse(this._deserializedReadAttribute(data, 'CombineMethod')));

        children = typeof (data.childNodes) != 'undefined' ? data.childNodes : data.childElements;
        if (children && children.length) {
            for (var i = 0; i < children.length; i++) {
                tag = (children[i].tagName || children[i].nodeName).toLowerCase();
                if (tag == 'rule') this._deserializeNode(children[i], group);
            }
        }

        if (group.get_count() > 0) {
            if (group.get_method() != Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CombineMethod.none) {
                appendTo.add(group);
            }
            else {
                for (var i = 0; i < group.get_count() ; i++) {
                    appendTo.add(group.get_components()[i]);
                }
            }
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeSerializer.prototype._deserializeNode = function (data, appendTo) {
    /// <summary>Deserializes the given expression node.</summary>
    /// <param name="data">Node to deserialize.</param>
    /// <param name="appendTo">Parent group to append to.</param>
    /// <private />

    var tag = '';
    var node = null;
    var rule = null;
    var val = "";
    var constraint = null;
    var constraintNode = null;

    if (data && appendTo) {
        rule = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule();
        node = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeNode();

        /* The following information is not available and should be filled out by calling code */
        rule.set_id('');

        rule.set_fieldId(this._deserializedReadAttribute(data, 'fieldID'));
        rule.set_fieldType(this._deserializedReadAttribute(data, 'fieldType'));
        rule.set_fieldName(this._deserializedReadAttribute(data, 'fieldName'));

        val = parseInt(this._deserializedReadAttribute(data, 'ctrlTypeID'));
        if (isNaN(val) || !isFinite(val)) val = Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CtrlType.TextBox;
        rule.set_controlType(val);

        rule.set_operator(Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Operator.parse(this._deserializedReadAttribute(data, 'operator')));

        val = this._deserializedReadAttribute(data, 'ruleValueTo');

        if (val == "Nothing") {
            rule.set_value(this._deserializedReadAttribute(data, 'ruleValueFrom'));
        }
        else {
            rule.set_valueFrom(this._deserializedReadAttribute(data, 'ruleValueFrom'));
            rule.set_valueTo(val);
        }

        /* The following information is not available and should be filled out by calling code */
        rule.set_dataSource(null);

        node.set_rule(rule);
        appendTo.add(node);
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeSerializer.prototype._deserializedReadAttribute = function (node, name) {
    /// <summary>Reads the value of the given attribute.</summary>
    /// <param name="node">Target node.</param>
    /// <param name="name">Attribute name.</param>
    /// <private />

    var ret = '';
    var attr = null;

    if (node && name && name.length) {
        if (node.attributes) {
            try {
                attr = node.attributes.getNamedItem(name);
                if (attr && typeof (attr.value) != 'undefined') {
                    ret = attr.value;
                }
            } catch (ex) { }
        }
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeGroup = function () {
    /// <summary>Represents an expression tree group.</summary>

    this._method = null;
    this._components = [];
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeGroup.prototype.get_count = function () {
    /// <summary>Gets the total number of elements within the group.</summary>

    return this._components.length;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeGroup.prototype.get_method = function () {
    /// <summary>Gets the combine method for this group.</summary>

    return this._method;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeGroup.prototype.set_method = function (value) {
    /// <summary>Sets the combine method for this group.</summary>
    /// <param name="value">The combine method for this group.</param>

    this._method = Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CombineMethod.parse(value) ||
        Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CombineMethod.none;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeGroup.prototype.get_components = function () {
    /// <summary>Gets group contents.</summary>

    return this._components;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeGroup.prototype.add = function (component) {
    /// <summary>Adds new component to the group.</summary>
    /// <param name="component">Component to add.</param>

    this._components[this._components.length] = component;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeGroup.prototype.remove = function (component) {
    /// <summary>Removes the given component from the group.</summary>
    /// <param name="component">Component to remove.</param>

    var newComponents = [];
    var index = this.indexOf(component);

    if (index >= 0 && index < this._components.length) {
        for (var i = 0; i < this._components.length; i++) {
            if (i != index) {
                newComponents[newComponents.length] = this._components[i];
            }
        }

        this._components = newComponents;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeGroup.prototype.clear = function () {
    /// <summary>Removes all components from the group.</summary>

    this._components = [];
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeGroup.prototype.indexOf = function (component) {
    /// <summary>Returns a zero-based index of the given component within the components collection of -1 if the component cannot be found.</summary>
    /// <param name="component">Component to search for.</param>

    var ret = -1;
    var comparator = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeComponentComparator();

    for (var i = 0; i < this._components; i++) {
        if (comparator.compare(this._components[i], component) == 0) {
            ret = i;
            break;
        }
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeNode = function () {
    /// <summary>Represents an expression tree node.</summary>

    this._rule = null;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeNode.prototype.get_rule = function () {
    /// <summary>Gets the associated recognition rule.</summary>

    return this._rule;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeNode.prototype.set_rule = function (value) {
    /// <summary>Sets the associated recognition rule.</summary>
    /// <param name="value">The associated recognition rule.</param>

    this._rule = value;

    if (this._rule == null || typeof (this._rule.get_value) != 'function') {
        this._rule = null;
        Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.error('Expression tree node must be associated with valid recognition rule.');
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTree = function () {
    /// <summary>Represents an expression tree.</summary>

    this._components = [];
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTree.prototype.get_count = function () {
    /// <summary>Gets the total number of elements within the group.</summary>

    return this._components.length;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTree.prototype.get_components = function () {
    /// <summary>Gets tree contents.</summary>

    return this._components;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTree.prototype.add = function (component) {
    /// <summary>Adds new component to the tree.</summary>
    /// <param name="component">Component to add.</param>

    this._components[this._components.length] = component;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTree.prototype.remove = function (component) {
    /// <summary>Removes the given component from the tree.</summary>
    /// <param name="component">Component to remove.</param>

    var newComponents = [];
    var index = this.indexOf(component);

    if (index >= 0 && index < this._components.length) {
        for (var i = 0; i < this._components.length; i++) {
            if (i != index) {
                newComponents[newComponents.length] = this._components[i];
            }
        }

        this._components = newComponents;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTree.prototype.clear = function () {
    /// <summary>Removes all components from the tree.</summary>

    this._components = [];
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTree.prototype.indexOf = function (component) {
    /// <summary>Returns a zero-based index of the given component within the components collection of -1 if the component cannot be found.</summary>
    /// <param name="component">Component to search for.</param>

    var ret = -1;
    var comparator = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeComponentComparator();

    for (var i = 0; i < this._components; i++) {
        if (comparator.compare(this._components[i], component) == 0) {
            ret = i;
            break;
        }
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode = function () {
    /// <summary>Represents a tree node.</summary>

    this._id = 0;
    this._isSelected = false;
    this._rule = '';
    this._ruleFieldId = '';
    this._constraintOperator = null;
    this._constraintValues = ["", null];
    this._selected = '';
    this._order = 0;

    this._handlers = {
        stateChanged: [],
        selectedChanged: [],
        ruleChanged: [],
        ruleFieldIdChanged: [],
        constraintOperatorChanged: [],
        constraintValueChanged: [],
        orderChanged: []
    };
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.get_id = function () {
    /// <summary>Gets the node ID.</summary>

    return this._id;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.set_id = function (value) {
    /// <summary>Sets the node ID.</summary>
    /// <param name="value">Node ID.</param>

    this._id = value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.get_isSelected = function () {
    /// <summary>Gets value indicating whether node is selected.</summary>

    return !!this._isSelected;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.set_isSelected = function (value) {
    /// <summary>Sets value indicating whether node is selected.</summary>
    /// <param name="value">Value indicating whether node is selected.</param>

    var origValue = !!this._isSelected;

    value = !!value;
    this._isSelected = value;

    if (origValue != value) {
        this.onSelectedChanged({ oldValue: origValue, newValue: value });
        this.onStateChanged({ name: 'selected', oldValue: origValue, newValue: value });
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.get_rule = function () {
    /// <summary>Gets the ID of the associated rule.</summary>

    return this._rule;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.set_rule = function (value) {
    /// <summary>Sets the ID of the associated rule.</summary>
    /// <param name="value">The ID of the associated rule.</param>

    var origValue = this._rule;

    this._rule = value;

    if (origValue != value) {
        this.onRuleChanged({ oldValue: origValue, newValue: value });
        this.onStateChanged({ name: 'rule', oldValue: origValue, newValue: value });
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.get_ruleFieldId = function () {
    /// <summary>Gets the rule field id.</summary>
    return this._ruleFieldId;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.set_ruleFieldId = function (value) {
    /// <summary>Sets the rule field id.</summary>
    /// <param name="value">The constraint operator.</param>

    var origValue = this._ruleFieldId;

    this._ruleFieldId = value;

    if (origValue != value) {
        this.onRuleFieldIdChanged({ oldValue: origValue, newValue: value });
        this.onStateChanged({ name: 'ruleFieldId', oldValue: origValue, newValue: value });
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.get_constraintOperator = function () {
    /// <summary>Gets the constraint operator.</summary>

    return this._constraintOperator;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.set_constraintOperator = function (value) {
    /// <summary>Sets the constraint operator.</summary>
    /// <param name="value">The constraint operator.</param>

    var origValue = this._constraintOperator;

    this._constraintOperator = value;

    if (origValue != value) {
        this.onConstraintOperatorChanged({ oldValue: origValue, newValue: value });
        this.onStateChanged({ name: 'constraintOperator', oldValue: origValue, newValue: value });
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.get_constraintValue = function () {
    /// <summary>Gets the constraint value.</summary>

    return this._constraintValues;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.set_constraintValue = function (value) {
    /// <summary>Sets the constraint value.</summary>
    /// <param name="value">The constraint value.</param>

    var origValue = this._constraintValues;

    this._constraintValues = value;

    if (origValue != value) {
        this.onConstraintValueChanged({ oldValue: origValue, newValue: value });
        this.onStateChanged({ name: 'constraintValues', oldValue: origValue, newValue: value });
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.get_order = function () {
    /// <summary>Gets the sort order.</summary>

    return this._order;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.set_order = function (value) {
    /// <summary>Sets the sort order.</summary>
    /// <param name="value">The sort order.</param>

    var origValue = this._order;

    this._order = value;

    if (origValue != value) {
        this.onOrderChanged({ oldValue: origValue, newValue: value });
        this.onStateChanged({ name: 'order', oldValue: origValue, newValue: value });
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.add_stateChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the state of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.stateChanged[this._handlers.stateChanged.length] = callback;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.add_selectedChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the "Selected" state of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.selectedChanged[this._handlers.selectedChanged.length] = callback;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.add_ruleChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the associated rule of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.ruleChanged[this._handlers.ruleChanged.length] = callback;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.add_ruleFieldIdChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the constraint operator of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.ruleFieldIdChanged[this._handlers.ruleFieldIdChanged.length] = callback;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.add_constraintOperatorChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the constraint operator of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.constraintOperatorChanged[this._handlers.constraintOperatorChanged.length] = callback;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.add_constraintValueChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the constraint value of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.constraintValueChanged[this._handlers.constraintValueChanged.length] = callback;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.add_orderChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the order of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.orderChanged[this._handlers.orderChanged.length] = callback;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.onStateChanged = function (e) {
    /// <summary>Raises "stateChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('stateChanged', e);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.onSelectedChanged = function (e) {
    /// <summary>Raises "selectedChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('selectedChanged', e);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.onRuleChanged = function (e) {
    /// <summary>Raises "ruleChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('ruleChanged', e);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.onRuleFieldIdChanged = function (e) {
    /// <summary>Raises "constraintRuleFieldIdChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('ruleFieldIdChanged', e);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.onConstraintOperatorChanged = function (e) {
    /// <summary>Raises "constraintOperatorChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('constraintOperatorChanged', e);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.onConstraintValueChanged = function (e) {
    /// <summary>Raises "constraintValueChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('constraintValueChanged', e);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.onOrderChanged = function (e) {
    /// <summary>Raises "orderChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('orderChanged', e);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.load = function (data, silent) {
    /// <summary>Replaces the state of the current object with the state of the given one.</summary>
    /// <param name="data">New state.</param>
    /// <param name="silent">Indicates whether to prohibit any events from firing.</param>

    if (data) {
        if (typeof (data.get_rule) != 'undefined') {
            if (!silent) {
                this.set_isSelected(data.get_isSelected());
                this.set_rule(data.get_rule());
                this.set_ruleFieldId(data.get_ruleFieldId());
                this.set_constraintOperator(data.get_constraintOperator());
                this.set_constraintValue(data.get_constraintValue());
                this.set_order(data.get_order());
            } else {
                this._isSelected = data.get_isSelected();
                this._rule = data.get_rule();
                this._ruleFieldId = data.get_ruleFieldId();
                this._constraintOperator = data.get_constraintOperator();
                this._constraintValues = data.get_constraintValue();
                this._order = data.get_order();
            }
        } else {
            if (!silent) {
                this.set_isSelected(data.isSelected);
                this.set_rule(data.rule);
                this.set_ruleFieldId(data.ruleFieldId);
                this.set_constraintOperator(data.constraintOperator);
                this.set_constraintValue(data.constraintValues);
                this.set_order(data.order);
            } else {
                this._isSelected = !!data.isSelected;
                this._rule = data.rule;
                this._ruleFieldId = data.ruleFieldId;
                this._constraintOperator = data.constraintOperator;
                this._constraintValues = data.constraintValues;
                this._order = data.order;
            }
        }
    } else {
        this._isSelected = false;
        this._rule = '';
        this._ruleFieldId = '';
        this._constraintOperator = null;
        this._constraintValues = ["", null];
        this._order = 0;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode.prototype.notify = function (eventName, args) {
    /// <summary>Notifies clients about the specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>

    var callbacks = [];
    var callbackException = null;

    if (eventName && eventName.length) {
        callbacks = this._handlers[eventName];

        if (callbacks && callbacks.length) {
            if (typeof (args) == 'undefined' || args == null) {
                args = {};
            }

            for (var i = 0; i < callbacks.length; i++) {
                callbackException = null;

                try {
                    callbacks[i](this, args);
                } catch (ex) {
                    callbackException = ex;
                }

                /* Preventing "Unable to execute code from freed script" errors to raise */
                if (callbackException && callbackException.number != -2146823277) {
                    Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.error(callbackException.message);
                }
            }
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination = function () {
    /// <summary>Represents a combination of tree nodes.</summary>

    this._id = null;
    this._components = [];
    this._componentsHash = new Hash();
    this._method = Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CombineMethod.and;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.isCombination = function (id) {
    /// <summary>Determines whether the given ID references to another combination.</summary>
    /// <param name="id">ID to examine.</param>

    var ret = false;

    if (id && id.length) {
        ret = id.indexOf('(') == 0 && id.lastIndexOf(')') == (id.length - 1);
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.containsNode = function (combinationID, nodeID) {
    /// <summary>Gets value indicating whether given combination contains the given node.</summary>
    /// <param name="combinationID">An ID of the combination.</param>
    /// <param name="nodeID">An ID of the tree node.</param>

    var ret = false;

    if (combinationID && combinationID.length && nodeID && nodeID.length) {
        ret = combinationID.indexOf('(' + nodeID + ',') >= 0 ||
            combinationID.indexOf(',' + nodeID + ',') >= 0 ||
            combinationID.indexOf(',' + nodeID + ')') >= 0;
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.parseComponents = function (id) {
    /// <summary>Parses the list of components by using the given combination ID.</summary>
    /// <param name="id">Combination id to examine.</param>

    var ret = [];
    var component = '';
    var components = [];
    var nestedComponentDepth = 0;

    if (id && id.length) {
        if (Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.isCombination(id)) {
            id = id.substr(1, id.length - 2);

            for (var i = 0; i < id.length; i++) {
                if (id[i] == ',') {
                    if (nestedComponentDepth == 0) {
                        if (component && component.length) {
                            ret[ret.length] = component;
                            component = '';
                        }
                    } else {
                        component += id[i];
                    }
                } else if (id[i] == '(') {
                    nestedComponentDepth += 1;
                    component += id[i];
                } else if (id[i] == ')') {
                    nestedComponentDepth -= 1;
                    component += id[i];

                    if (nestedComponentDepth <= 0) {
                        nestedComponentDepth = 0;

                        ret[ret.length] = component;
                        component = '';
                    }
                } else {
                    component += id[i];
                }
            }

            if (component && component.length) {
                ret[ret.length] = component;
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.prototype.get_id = function () {
    /// <summary>Gets the unique identifier of this combination.</summary>

    this._id = '(';

    for (var i = 0; i < this._components.length; i++) {
        if (this._components[i]) {
            if (typeof (this._components[i]) == 'string') {
                this._id += this._components[i];
            } else if (typeof (this._components[i].get_id) == 'function') {
                this._id += this._components[i].get_id();
            }

            if (i < (this._components.length - 1)) {
                this._id += ',';
            }
        }
    }

    this._id += ')';

    return this._id;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.prototype.get_components = function () {
    /// <summary>Gets the list of tree components (nodes and child combinations) that are part of this combination.</summary>

    return this._components;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.prototype.get_componentsDistribution = function () {
    /// <summary>Gets an object that contains information about all the components of this combination (on all levels) and their distribution across nested combinations.</summary>

    var parsedNodes = {};
    var ret = { nodes: [], map: new Hash() };

    var processComponents = function (id) {
        var existingComponents = [];
        var components = Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.parseComponents(id);

        if (components && components.length) {
            for (var i = 0; i < components.length; i++) {
                if (!ret.map.get(id)) {
                    ret.map.set(id, []);
                }

                existingComponents = ret.map.get(id);
                existingComponents[existingComponents.length] = components[i];
                ret.map.set(id, existingComponents);

                if (!Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.isCombination(components[i])) {
                    if (!parsedNodes[components[i]]) {
                        parsedNodes[components[i]] = true;
                        ret.nodes[ret.nodes.length] = components[i];
                    }
                } else {
                    processComponents(components[i]);
                }
            }
        }
    }

    processComponents(this.get_id());

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.prototype.get_method = function () {
    /// <summary>Gets the combine method.</summary>

    return this._method;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.prototype.set_method = function (value) {
    /// <summary>Sets the combine method.</summary>
    /// <param name="value">Combine method.</param>

    this._method = value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.prototype.add = function (component) {
    /// <summary>Adds new component to the combination.</summary>
    /// <param name="component">Component to add.</param>

    var id = '';
    var pattern = /[a-zA-Z0-9_]+/gi;

    if (component && !this.contains(component)) {
        if (typeof (component) == 'string') {
            id = component;
        } else if (typeof (component.get_id) == 'function') {
            id = component.get_id();
        }

        /* Preventing empty sub-combinations to be added */
        if (id && id.length && pattern.test(id)) {
            this._components[this._components.length] = component;
            this._componentsHash.set(id, true);
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.prototype.remove = function (component) {
    /// <summary>Removes the given component from the combination.</summary>
    /// <param name="component">Component to remove.</param>

    var matches = false;
    var newComponents = [];
    var componentIdentity = '';

    if (component) {
        if (typeof (component) == 'string') {
            componentIdentity = component;
        } else if (typeof (component.get_id) == 'function') {
            componentIdentity = component.get_id();
        }

        this._componentsHash.unset(componentIdentity);

        for (var i = 0; i < this._components.length; i++) {
            if (this._components[i]) {
                if (typeof (this._components[i]) == 'string') {
                    matches = (this._components[i] == componentIdentity);
                } else if (typeof (this._components[i].get_id) == 'function') {
                    matches = (this._components[i].get_id() == componentIdentity);
                }

                if (!matches) {
                    newComponents[newComponents.length] = this._components[i];
                }
            }
        }

        this._components = newComponents;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.prototype.contains = function (component) {
    /// <summary>Determines whether combination contains the given component.</summary>
    /// <param name="value">Component to search for.</param>

    var ret = false;
    var matches = false;
    var componentIdentity = '';

    if (component) {
        if (typeof (component) == 'string') {
            componentIdentity = component;
        } else if (typeof (component.get_id) == 'function') {
            componentIdentity = component.get_id();
        }

        ret = !!this._componentsHash.get(componentIdentity);
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.prototype.sortComponents = function (sorting) {
    /// <summary>Sorts components according to the given sorting rules and returns the sorted version.</summary>
    /// <param name="sorting">A hash that contains the sort number for each component.</param>

    var ret = [];
    var keys = [];

    var sortValue = function (component) {
        var result = 0;
        var componentIdentity = '';

        if (typeof (component) == 'string') {
            componentIdentity = component;
        } else if (typeof (component.get_id) == 'function') {
            componentIdentity = component.get_id();
        }

        if (componentIdentity) {
            result = sorting.get(componentIdentity);
            if (result == null || isNaN(result) || result < 0) {
                result = 0;
            }
        }

        return result;
    }

    for (var i = 0; i < this._components.length; i++) {
        ret[ret.length] = this._components[i];
    }

    if (sorting && typeof (sorting.keys) == 'function') {
        keys = sorting.keys();
        for (var i = 0; i < ret.length; i++) {
            for (var j = 0; j < keys.length; j++) {
                if (Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.containsNode(ret[i], keys[j])) {
                    sorting.set(ret[i], sorting.get(keys[j]));
                }
            }
        }

        ret.sort(function (c1, c2) {
            return sortValue(c1) - sortValue(c2);
        });
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeConverter = function () {
    /// <summary>Represents a tree converter.</summary>

    this._tree = null;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeConverter.prototype.toExpression = function (tree) {
    /// <summary>Converts the given tree to recognition expression.</summary>
    /// <param name="tree">Tree to convert.</param>

    var rootNodes = [];
    var combination = null;
    var topCombinations = new Hash();
    var ret = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTree();

    if (tree != null && typeof (tree.root) == 'function') {
        this._tree = tree;

        /* Getting a list of root nodes */
        rootNodes = this._tree.root();

        if (rootNodes && rootNodes.length) {
            for (var i = 0; i < rootNodes.length; i++) {
                /* Checking whether node is part of a combination */
                if (!this._tree.isCombined(rootNodes[i].node.get_id())) {
                    /* This is "free" node - simply adding it to the group */
                    ret.add(this._createNode(rootNodes[i].node));
                } else {
                    /* Getting the reference to outer most combination */
                    combination = this._tree.topOwningCombination(rootNodes[i].node.get_id());

                    /* Checking whether we already processed this combination */
                    if (!topCombinations.get(combination.get_id())) {
                        topCombinations.set(combination.get_id(), true);

                        /* Recursively adding groups */
                        this._addGroupsRecursive(ret, combination);
                    }
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeConverter.prototype.fromExpression = function (expression, onNodeCreate) {
    /// <summary>Loads the tree from the given recognition expression.</summary>
    /// <param name="expression">Recognition expression.</param>
    /// <param name="onNodeCreate">Callback that is called when the new node is created.</param>

    var nodes = [];
    var combinations = [];
    var combination = null;
    var combinationsInfos = [];
    var combinationComponents = [];
    var ret = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree('imported');

    onNodeCreate = onNodeCreate || function () { }

    var collectNodesRecursive = function (parent) {
        var n = null;
        var r = null;
        var result = [];
        var combo = null;
        var comboComponents = [];
        var components = parent.get_components();

        for (var i = 0; i < components.length; i++) {
            if (typeof (components[i].get_rule) == 'function') {
                n = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode();

                r = components[i].get_rule();
                n.set_id(ret.generateNodeID());
                n.set_rule(r.get_id());
                n.set_ruleFieldId(r.get_fieldId());
                n.set_constraintOperator(r.get_operator());
                n.set_constraintValue([r.get_valueFrom(), r.get_valueTo()]);
                n.set_isSelected(false);
                n.set_order(0);

                onNodeCreate(n, components[i]);

                nodes[nodes.length] = n;
                result[result.length] = n.get_id();
            } else if (typeof (components[i].get_components) == 'function') {
                combo = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination();

                comboComponents = collectNodesRecursive(components[i]);

                for (var j = 0; j < comboComponents.length; j++) {
                    combo.add(comboComponents[j]);
                }

                result[result.length] = combo.get_id();
                combinationsInfos[combinationsInfos.length] = { id: combo.get_id(), method: components[i].get_method() };
            }
        }

        return result;
    }

    if (expression && typeof (expression.get_components) == 'function') {
        collectNodesRecursive(expression);

        ret.appendRange(nodes, null);

        for (var i = 0; i < combinationsInfos.length; i++) {
            combination = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination();

            combination.set_method(combinationsInfos[i].method);
            combinationComponents = Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.parseComponents(combinationsInfos[i].id);

            for (var j = 0; j < combinationComponents.length; j++) {
                combination.add(combinationComponents[j]);
            }

            combinations[combinations.length] = combination;
        }

        ret._combinations = combinations;
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeConverter.prototype._addGroupsRecursive = function (parent, combination) {
    /// <summary>Recursively adds groups to the given parent group.</summary>
    /// <param name="parent">Parent group.</param>
    /// <param name="combination">Corresponding tree node combination.</param>

    var n = null;
    var group = null;
    var components = [];
    var distribution = null;
    var sorting = new Hash();

    if (parent && combination) {
        distribution = combination.get_componentsDistribution();

        if (distribution && distribution.nodes && distribution.nodes.length) {
            group = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeGroup();

            group.set_method(combination.get_method());

            for (var i = 0; i < distribution.nodes.length; i++) {
                sorting.set(distribution.nodes[i], this._tree.node(distribution.nodes[i]).get_order());
            }

            components = combination.sortComponents(sorting);

            for (var i = 0; i < components.length; i++) {
                if (!Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination.isCombination(components[i])) {
                    group.add(this._createNode(this._tree.node(components[i])));
                } else {
                    this._addGroupsRecursive(group, this._tree.combination(components[i]));
                }
            }

            parent.add(group);
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeConverter.prototype._createNode = function (n) {
    /// <summary>Creates an expression node from the given tree node.</summary>
    /// <param name="n">Reference to tree node.</param>

    var ret = null;
    var rule = null;

    if (!n || typeof (n.get_id) != 'function') {
        Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.error('Unable to create an expression tree node from non-existant tree node.');
    } else {
        rule = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Rule();
        ret = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ExpressionTreeNode();

        /* The following information is not available and should be filled out by calling code */
        rule.set_id(n.get_rule());
        rule.set_fieldId(n.get_ruleFieldId());
        rule.set_operator(n.get_constraintOperator());
        rule.set_fieldName('');
        rule.set_fieldType('');
        rule.set_dataSource(null);
        rule.set_controlType(Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CtrlType.TextBox);

        var values = n.get_constraintValue();

        if (values != null && values.length == 2) {
            rule.set_valueFrom(values[0]);
            rule.set_valueTo(values[1]);
        }

        ret.set_rule(rule);
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree = function (id) {
    /// <summary>Represents a tree.</summary>
    /// <param name="id">Optional. Identifier of the tree.</param>

    this._id = id;
    this._nodes = [];                   // index -> node
    this._combinations = [];            // An array of combinations
    this._nodeIdentityIndex = {};       // node ID -> node index
    this._childToParentRelation = {};   // node ID -> parent node ID
    this._parentToChildRelation = {};   // node ID -> array of child node IDs
    this._isSilent = false;

    this._handlers = {
        update: [],
        afterNodeAppend: [],
        afterNodeRemove: [],
        selectionChanged: []
    };
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.get_id = function () {
    /// <summary>Gets the identifier of the tree.</summary>

    return this._id;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.get_size = function () {
    /// <summary>Gets the total number of nodes within the tree.</summary>

    return this._nodes.length;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.get_isSilent = function () {
    /// <summary>Gets value indicating whether all events are disabled and won't be fired.</summary>

    return this._isSilent;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.set_isSilent = function (value) {
    /// <summary>Sets value indicating whether all events are disabled and won't be fired.</summary>
    /// <param name="value">Value indicating whether all events are disabled and won't be fired.</param>

    this._isSilent = !!value;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.toExpression = function (tree) {
    /// <summary>Converts the given tree to recognition expression.</summary>
    /// <param name="tree">Tree to convert.</param>

    return new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeConverter().toExpression(this);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.fromExpression = function (expression, onNodeCreate) {
    /// <summary>Loads the tree from the given recognition expression.</summary>
    /// <param name="expression">Recognition expression.</param>
    /// <param name="onNodeCreate">Callback that is called when the new node is created.</param>

    this.copyFrom(new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeConverter().fromExpression(expression, onNodeCreate));
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.copyFrom = function (tree) {
    /// <summary>Copies data from the given tree to the current one.</summary>
    /// <param name="tree">Tree to copy data from.</param>

    var self = this;
    var originalIsSilent = this.get_isSilent();

    this.set_isSilent(true);

    this.clear();

    if (tree && typeof (tree.root) == 'function') {
        this._nodes = tree._nodes;
        this._combinations = tree._combinations;
        this._nodeIdentityIndex = tree._nodeIdentityIndex;
        this._childToParentRelation = tree._childToParentRelation;
        this._parentToChildRelation = tree._parentToChildRelation;

        for (var i = 0; i < this._nodes.length; i++) {
            this._nodes[i].add_stateChanged(function (sender, args) { self.onUpdate({ type: 'node', parameters: args }); });
            this._nodes[i].add_selectedChanged(function (sender, args) { self.onSelectionChanged({ selection: self.selection(null, true) }); });
        }
    }

    this.set_isSilent(originalIsSilent);

    this.onUpdate({ type: 'structure' });
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.clear = function () {
    /// <summary>Removes all nodes from the tree and clears the internal state.</summary>

    this._nodes = [];
    this._combinations = [];
    this._nodeIdentityIndex = {};
    this._childToParentRelation = {};
    this._parentToChildRelation = {};

    this.onUpdate({ type: 'structure' });
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.root = function () {
    /// <summary>Returns the list of root nodes.</summary>

    var ret = [];
    var nodeIndex = -1;
    var nodes = this._parentToChildRelation['root'];

    if (nodes && nodes.length) {
        for (var i = 0; i < nodes.length; i++) {
            nodeIndex = this._nodeIdentityIndex[nodes[i]];

            if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
                ret[ret.length] = { index: nodeIndex, node: this._nodes[nodeIndex] }
            }
        }
    }

    this._sort(ret);

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.combine = function (nodes, method) {
    /// <summary>Combines the given nodes using the given combine method.</summary>
    /// <param name="nodes">The list of node IDs/child combinations.</param>
    /// <param name="method">Combine method.</param>

    var self = this;
    var topNode = '';
    var nodeIndex = -1;
    var combined = false;
    var combination = null;
    var originalSilent = false;
    var existingCombinationCount = 0;
    var existingCombinationIndex = -1;
    var originalExistingCombinationID = '';

    /* Finds the ID of the top node as seen in the tree hierarchy */
    var topNodeID = function () {
        var prev = [];
        var result = '';
        var nodesCount = 0;
        var minNodesCount = 65536;

        /* Returns a list of previous siblings of the given node */
        var prevSiblings = function (n) {
            var nodeID = '';
            var innerResult = [];
            var siblings = self.siblings(n);

            if (siblings && siblings.length) {
                if (typeof (n) == 'string') {
                    nodeID = n;
                } else if (typeof (n.get_id) == 'function') {
                    nodeID = n.get_id();
                }

                if (nodeID && nodeID.length) {
                    for (var i = 0; i < siblings.length; i++) {
                        /* Nodes are already sorted so we just loop through until we reach our node */
                        if (siblings[i].node.get_id() != nodeID) {
                            innerResult[innerResult.length] = siblings[i].node;
                        } else {
                            break;
                        }
                    }
                }
            }

            return innerResult;
        }

        /* Returns the total number of child nodes (including all children of children on all levels) */
        var childrenCount = function (n) {
            var innerResult = 0;
            var children = self.children(n);

            if (children && children.length) {
                innerResult += children.length;
                for (var i = 0; i < children.length; i++) {
                    innerResult += childrenCount(children[i].node);
                }
            }

            return innerResult;
        }

        if (nodes && nodes.length) {
            for (var i = 0; i < nodes.length; i++) {
                nodesCount = 0;
                prev = prevSiblings(nodes[i]);

                nodesCount += prev.length;
                if (prev.length) {
                    for (var j = 0; j < prev.length; j++) {
                        nodesCount += childrenCount(prev[j]);
                    }
                }

                /* Finding a node with a minimum number of "previous" nodes */
                if (nodesCount < minNodesCount) {
                    minNodesCount = nodesCount;
                    result = nodes[i];
                }
            }
        }

        if (typeof (result) != 'string' && typeof (result.get_id) == 'function') {
            result = result.get_id();
        }

        return result;
    }

    var modifyParentCombinationsRecursive = function (oldComponent, newComponent) {
        var originalCombinationID = '';

        for (var i = 0; i < self._combinations.length; i++) {
            if (self._combinations[i].contains(oldComponent)) {
                originalCombinationID = self._combinations[i].get_id();

                self._combinations[i].remove(oldComponent);
                self._combinations[i].add(newComponent);

                modifyParentCombinationsRecursive(originalCombinationID, self._combinations[i].get_id());

                break;
            }
        }
    }

    if (nodes && nodes.length) {
        if (method < 0) {
            method = Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CombineMethod.and;
        }

        /* Checking whether we need to break existing combination instead of creating/editing one */
        if (method == Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CombineMethod.none) {
            this.breakCombination(nodes);
        } else {
            /* First, checking whether all nodes are part of the same existing combination */
            for (var i = 0; i < this._combinations.length; i++) {
                existingCombinationCount = 0;

                for (var j = 0; j < nodes.length; j++) {
                    if (this._combinations[i].contains(nodes[j])) {
                        existingCombinationCount += 1;
                    } else {
                        break;
                    }
                }

                if (existingCombinationCount == nodes.length) {
                    existingCombinationIndex = i;
                    break;
                }
            }

            /* All nodes are part of one existing combination - simply changing method (if needed) */
            if (existingCombinationIndex >= 0 && existingCombinationCount == this._combinations[existingCombinationIndex].get_components().length) {
                if (this._combinations[existingCombinationIndex].get_method() != method) {
                    this._combinations[existingCombinationIndex].set_method(method);
                    combined = true;
                }
            } else {
                topNode = topNodeID();
                nodeIndex = this._nodeIdentityIndex[topNode];

                originalSilent = this.get_isSilent();
                this.set_isSilent(true);

                for (var i = nodes.length - 1; i >= 0; i--) {
                    if (nodes[i] != topNode) {
                        this.move(nodes[i], this._childToParentRelation[topNode], topNode);
                        nodeIndex = this._nodeIdentityIndex[nodes[i]];
                    }
                }

                this.set_isSilent(originalSilent);

                combination = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNodeCombination();

                combination.set_method(method);
                for (var i = 0; i < nodes.length; i++) {
                    combination.add(nodes[i]);
                }

                this._combinations[this._combinations.length] = combination;

                if (existingCombinationIndex >= 0) {
                    originalExistingCombinationID = this._combinations[existingCombinationIndex].get_id();

                    for (var i = 0; i < nodes.length; i++) {
                        this._combinations[existingCombinationIndex].remove(nodes[i]);
                    }

                    this._combinations[existingCombinationIndex].add(this._combinations[this._combinations.length - 1].get_id());
                    modifyParentCombinationsRecursive(originalExistingCombinationID, this._combinations[existingCombinationIndex].get_id());
                }

                combined = true;
            }
        }
    }

    if (combined) {
        this.onUpdate({ type: 'structure' });
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.breakCombination = function (nodes, moveNodes) {
    /// <summary>Removes the combinations from the given nodes.</summary>
    /// <param name="nodes">The list of node IDs.</param>
    /// <param name="moveNodes">Value indicating whether to move nodes within the tree according to other combinations.</param>

    var self = this;
    var oldOrder = -1;
    var newOrder = -1;
    var nodeIndex = -1;
    var childIndex = -1;
    var newChildren = [];
    var nodeParent = null;
    var nodeFound = false;
    var moveNodeIndex = -1;
    var newCombinations = [];
    var keepCombinations = [];
    var minComponentOrder = 0;
    var newCombinationID = '';
    var processedCombinations = [];
    var combinationComponents = [];
    var breakFullCombinations = [];
    var children = this.children(null);
    var modifiedParentCombinations = [];

    /* Merges two arrays */
    var mergeResults = function (result1, result2) {
        var result = [];
        var found = false;

        if (result1 && result1.length) {
            for (var i = 0; i < result1.length; i++) {
                result[result.length] = result1[i];
            }
        }

        if (result2 && result2.length) {
            for (var i = 0; i < result2.length; i++) {
                found = false;

                for (var j = 0; j < result.length; j++) {
                    if (result[j] == result2[i]) {
                        found = true;
                        break;
                    }
                }

                if (!found) {
                    result[result.length] = result2[i];
                }
            }
        }

        return result;
    }

    /* Substracts one array from another one */
    var substractResults = function (result1, result2) {
        var result = [];
        var found = false;

        if (result1 && result1.length) {
            if (result2 && result2.length) {
                for (var i = 0; i < result1.length; i++) {
                    found = false;

                    for (var j = 0; j < result2.length; j++) {
                        if (result1[i] == result2[j]) {
                            found = true;
                            break;
                        }
                    }

                    if (!found) {
                        result[result.length] = result1[i];
                    }
                }
            } else {
                result = result1;
            }
        }

        if (!result) {
            result = [];
        }

        return result;
    }

    /* Gets the nearly (or completely) empty combination indexes from the given list of combination indexes */
    var nearlyEmptyCombinations = function (targetCombinations) {
        var result = [];

        if (targetCombinations && targetCombinations.length) {
            for (var i = 0; i < targetCombinations.length; i++) {
                if (targetCombinations[i] >= 0 && targetCombinations[i] < self._combinations.length) {
                    if (self._combinations[targetCombinations[i]].get_components().length <= 1) {
                        result[result.length] = targetCombinations[i];
                    }
                }
            }
        }

        return result;
    }

    /* Reduces the number of combinations by removing nearly (or completely) empty combinations */
    var reduceParentCombinations = function (targetCombinations) {
        var newCombinations = [];
        var combinationFound = false;
        var allCombinationsIndexes = [];
        var nearlyEmpty = nearlyEmptyCombinations(targetCombinations);

        while (nearlyEmpty.length > 0) {
            newCombinations = [];
            allCombinationsIndexes = [];

            for (var i = 0; i < self._combinations.length; i++) {
                combinationFound = false;

                for (var j = 0; j < nearlyEmpty.length; j++) {
                    if (i == nearlyEmpty[j]) {
                        combinationFound = true;
                        break;
                    }
                }

                if (!combinationFound) {
                    newCombinations[newCombinations.length] = self._combinations[i];
                    allCombinationsIndexes[allCombinationsIndexes.length] = i;
                }
            }

            self._combinations = newCombinations;
            nearlyEmpty = nearlyEmptyCombinations(allCombinationsIndexes);
        }
    }

    var modifyParentCombinationsRecursive = function (oldComponent, newComponent) {
        var result = [];
        var originalCombinationID = '';

        for (var i = 0; i < self._combinations.length; i++) {
            if (self._combinations[i].contains(oldComponent)) {
                originalCombinationID = self._combinations[i].get_id();

                self._combinations[i].remove(oldComponent);
                self._combinations[i].add(newComponent);

                result[result.length] = i;
                result = mergeResults(result, modifyParentCombinationsRecursive(originalCombinationID, self._combinations[i].get_id()));

                break;
            }
        }

        return result;
    }

    if (nodes && nodes.length) {
        for (var i = 0; i < this._combinations.length; i++) {
            processedCombinations[i] = { combination: i, id: this._combinations[i].get_id(), isAffected: false, nodes: [] };

            /* Distributing nodes by combinations */
            for (var j = 0; j < nodes.length; j++) {
                if (this._combinations[i].contains(nodes[j])) {
                    processedCombinations[i].isAffected = true;
                    processedCombinations[i].nodes[processedCombinations[i].nodes.length] = nodes[j];
                }
            }
        }

        for (var i = 0; i < nodes.length; i++) {
            breakFullCombinations[breakFullCombinations.length] = nodes[i];
        }

        for (var i = 0; i < processedCombinations.length; i++) {
            /* Checking whether we have nearly empty combinations (the ones that will have only one element after reduction and therefore are not valid) */
            if (processedCombinations[i].isAffected && (processedCombinations[i].nodes.length == (this._combinations[processedCombinations[i].combination].get_components().length - 1))) {
                for (var j = 0; j < processedCombinations[i].nodes.length; j++) {
                    nodeFound = false;

                    for (var k = 0; k < breakFullCombinations.length; k++) {
                        if (breakFullCombinations[k] == processedCombinations[i].nodes[j]) {
                            nodeFound = true;
                            break;
                        }
                    }

                    if (!nodeFound) {
                        breakFullCombinations[breakFullCombinations.length] = processedCombinations[i].nodes[j];
                    }
                }
            }
        }

        if (breakFullCombinations.length != nodes.length) {
            this.breakCombination(breakFullCombinations);
        } else {
            for (var i = 0; i < processedCombinations.length; i++) {
                /* Removing nodes from the corresponding combinations */
                if (processedCombinations[i].isAffected) {
                    for (var j = 0; j < processedCombinations[i].nodes.length; j++) {
                        this._combinations[processedCombinations[i].combination].remove(processedCombinations[i].nodes[j]);
                    }

                    /* This combination is still not empty (contains more then one element) - it will be kept */
                    if (this._combinations[processedCombinations[i].combination].get_components().length > 1) {
                        keepCombinations[keepCombinations.length] = processedCombinations[i].combination;
                    }

                    newCombinationID = this._combinations[processedCombinations[i].combination].get_id();
                    if (this._combinations[processedCombinations[i].combination].get_components().length == 1) {
                        newCombinationID = this._combinations[processedCombinations[i].combination].get_components()[0];
                    }

                    /* Modifying parent combinations */
                    modifiedParentCombinations = mergeResults(modifiedParentCombinations,
                        modifyParentCombinationsRecursive(processedCombinations[i].id, newCombinationID));
                } else {
                    keepCombinations[keepCombinations.length] = processedCombinations[i].combination;
                }
            }

            /* Reducing the amount of parent combinations */
            if (modifiedParentCombinations.length) {
                reduceParentCombinations(modifiedParentCombinations);
            }

            if (this._combinations.length) {
                if (keepCombinations.length != this._combinations.length) {
                    /* All combinations must be removed */
                    if (keepCombinations.length == 0) {
                        this._combinations = [];
                    } else {
                        newCombinations = [];

                        for (var i = 0; i < keepCombinations.length; i++) {
                            if (this._combinations[keepCombinations[i]]) {
                                newCombinations[newCombinations.length] = this._combinations[keepCombinations[i]];
                            }
                        }

                        this._combinations = newCombinations;
                    }
                }
            }

            if (typeof (moveNodes) == 'undefined' || moveNodes == null || !!moveNodes) {
                if (children.length) {
                    moveNodeIndex = children.length - 1;

                    for (var i = children.length - 1; i >= 0; i--) {
                        if (!this.owningCombination(children[i].node.get_id())) {
                            moveNodeIndex = (i - 1);
                        } else {
                            break;
                        }
                    }

                    if (moveNodeIndex < 0) {
                        moveNodeIndex = 0;
                    }

                    for (var i = 0; i < nodes.length; i++) {
                        this.move(nodes[i], null, children[moveNodeIndex].node.get_id());
                    }
                }
            }

            this.onUpdate({ type: 'structure' });
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.UpdateAll = function () {
    this.onUpdate({ type: 'structure' });
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.combinationDepth = function (id) {
    /// <summary>Gets the number representing the amount of combinations that this node is a part of.</summary>
    /// <param name="id">Node ID.</param>

    var ret = 0;
    var self = this;
    var closestCombinationID = '';

    var collectParentCombinationsCount = function (combinationID) {
        var ret = 0;

        for (var i = 0; i < self._combinations.length; i++) {
            if (self._combinations[i].contains(combinationID)) {
                ret += collectParentCombinationsCount(self._combinations[i].get_id()) + 1;
                break;
            }
        }

        return ret;
    }

    for (var i = 0; i < this._combinations.length; i++) {
        if (this._combinations[i].contains(id)) {
            closestCombinationID = this._combinations[i].get_id();
            break;
        }
    }

    if (closestCombinationID && closestCombinationID.length) {
        ret = collectParentCombinationsCount(closestCombinationID) + 1;
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.moveToCombination = function (id, combination) {
    /// <summary>Moves the given node to the different combination.</summary>
    /// <param name="id">Node ID.</param>
    /// <param name="combination">Combination reference.</param>

    var self = this;
    var nodeIndex = -1;
    var canProcess = true;
    var combinationIndex = -1;
    var combinationNodes = null;
    var originalCombinationID = '';
    var originalIsSilent = this.get_isSilent();

    var modifyParentCombinationsRecursive = function (oldComponent, newComponent) {
        var originalCombinationID = '';

        for (var i = 0; i < self._combinations.length; i++) {
            if (self._combinations[i].contains(oldComponent)) {
                originalCombinationID = self._combinations[i].get_id();

                self._combinations[i].remove(oldComponent);
                self._combinations[i].add(newComponent);

                modifyParentCombinationsRecursive(originalCombinationID, self._combinations[i].get_id());

                break;
            }
        }
    }

    var conditionalBreakCombination = function () {
        var result = true;
        var comboIndex = getCombinationIndex(combination);

        if (comboIndex >= 0 && comboIndex < self._combinations.length) {
            if (self._combinations[comboIndex].contains(id) && self._combinations[comboIndex].get_components().length < 3) {
                result = false;
            }
        }

        if (result) {
            self.breakCombination([id], false);
        }

        return result;
    }

    var getCombinationIndex = function (ref) {
        var result = -1;
        var refComboID = '';

        if (ref != null) {
            if (typeof (ref) == 'string') {
                refComboID = ref;
            } else if (typeof (ref.get_id) == 'function') {
                refComboID = ref.get_id();
            } else if (typeof (ref) == 'number') {
                result = ref;
            }

            if (result < 0 && refComboID && refComboID.length) {
                for (var i = 0; i < self._combinations.length; i++) {
                    if (self._combinations[i].get_id() == refComboID) {
                        result = i;
                        break;
                    }
                }
            }
        }

        return result;
    }

    if (id && id.length) {
        this.set_isSilent(true);

        canProcess = conditionalBreakCombination();

        this.set_isSilent(originalIsSilent);

        if (canProcess) {
            if (combination != null) {
                combinationIndex = getCombinationIndex(combination);

                if (combinationIndex >= 0 && combinationIndex < this._combinations.length) {
                    combinationNodes = this._combinations[combinationIndex].get_componentsDistribution().nodes;
                    if (combinationNodes && combinationNodes.length) {
                        nodeIndex = this._nodeIdentityIndex[combinationNodes[0]];
                    }

                    nodeIndex = this._nodeIdentityIndex[id];
                    if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
                        this.set_isSilent(true);
                        this.set_isSilent(originalIsSilent);
                    }

                    originalCombinationID = this._combinations[combinationIndex].get_id();

                    this._combinations[combinationIndex].add(id);

                    modifyParentCombinationsRecursive(originalCombinationID, this._combinations[combinationIndex].get_id());
                }

                this.onUpdate({ type: 'structure' });
            }
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.combination = function (id) {
    /// <summary>Returns the tree node combination by its ID.</summary>
    /// <param name="id">Combination ID.</param>

    var ret = null;

    if (id && id.length) {
        for (var i = 0; i < this._combinations.length; i++) {
            if (this._combinations[i].get_id() == id) {
                ret = this._combinations[i];
                break;
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.topOwningCombination = function (id) {
    /// <summary>Returns the reference to the top owning combination of the given node.</summary>
    /// <param name="id">Node ID.</param>

    var ret = null;
    var self = this;
    var combinationIndex = -1;

    var parentCombinationIndexRecursive = function (component) {
        var result = -1;
        var parentResult = -1;

        for (var i = 0; i < self._combinations.length; i++) {
            if (self._combinations[i].contains(component)) {
                result = i;
                parentResult = parentCombinationIndexRecursive(self._combinations[i].get_id());

                if (parentResult >= 0) {
                    result = parentResult;
                }

                break;
            }
        }

        return result;
    }

    combinationIndex = parentCombinationIndexRecursive(id);
    if (combinationIndex >= 0 && combinationIndex < this._combinations.length) {
        ret = this._combinations[combinationIndex];
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.owningCombination = function (id) {
    /// <summary>Returns the reference to the owning combination of the given node.</summary>
    /// <param name="id">Node ID.</param>

    var ret = null;

    if (id && id.length) {
        for (var i = 0; i < this._combinations.length; i++) {
            if (this._combinations[i].contains(id)) {
                ret = this._combinations[i];
                break;
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.isCombined = function (id) {
    /// <summary>Returns value indicating whether the given node is part of any combination.</summary>
    /// <param name="id">Node ID.</param>

    var ret = false;

    for (var i = 0; i < this._combinations.length; i++) {
        if (this._combinations[i].contains(id)) {
            ret = true;
            break;
        }
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.moveUp = function (id) {
    /// <summary>Moves the given node one position up in the tree hierarchy.</summary>
    /// <param name="id">Node ID.</param>

    var children = [];
    var parent = null;
    var nodeOrder = -1;
    var nodeIndex = -1;
    var childIndex = -1;
    var siblings = null;
    var newChildren = [];
    var combination = null;
    var changeOrder = false;
    var isFirstChild = false;
    var parentOfParent = null;
    var selfCombination = null;
    var originalIsSilent = false;
    var previousSiblingIndex = -1;

    nodeIndex = this._nodeIdentityIndex[id];

    if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
        /* Saving the order of the node (will use it later) */
        nodeOrder = this._nodes[nodeIndex].get_order();

        /* Getting the ID of the parent node */
        parent = this._childToParentRelation[id];

        /* First, determining if it's a first child node of its parent */
        siblings = this.siblings(id);

        /* Checking for first child */
        if (siblings && siblings.length) {
            isFirstChild = siblings[0].node.get_id() == id;
        }

        if (isFirstChild) {
            /* Parent can't be null in case of first child = can't move the top node further up */
            if (parent != null) {
                /* Moving to the parent of parent */
                parentOfParent = this._childToParentRelation[parent];

                /* Attaching to a new node */
                this._childToParentRelation[id] = parentOfParent;

                /* Removing relation to the old parent node */
                if (this._parentToChildRelation[parent]) {
                    /* Collecting new children */
                    for (var i = 0; i < this._parentToChildRelation[parent].length; i++) {
                        if (this._parentToChildRelation[parent][i] != id) {
                            newChildren[newChildren.length] = this._parentToChildRelation[parent][i];
                        }
                    }

                    /* Changing the sort oder */
                    for (var i = 0; i < newChildren.length; i++) {
                        childIndex = this._nodeIdentityIndex[newChildren[i]];

                        if (this._nodes[childIndex].get_order() > nodeOrder) {
                            this._nodes[childIndex]._order -= 1;
                        }
                    }

                    /* Commited new children of the old parent */
                    this._parentToChildRelation[parent] = newChildren;
                }

                /* Might be a new root node */
                if (parentOfParent == null) {
                    parentOfParent = 'root';
                }

                if (!this._parentToChildRelation[parentOfParent]) {
                    this._parentToChildRelation[parentOfParent] = [];
                }

                /* Adding new children to the new parent */
                this._parentToChildRelation[parentOfParent][this._parentToChildRelation[parentOfParent].length] = id;

                /* Changing the sort order (the last sibling) */
                this._nodes[nodeIndex]._order = this.children(parentOfParent).length - 1;

                this.onUpdate({ type: 'structure' });
            }
        } else {
            nodeOrder -= 1;
            changeOrder = true;
            children = this.children(parent);

            /* Retrieving the index of the previous sibling */
            for (var i = 0; i < children.length; i++) {
                if (this._nodes[children[i].index].get_order() == nodeOrder && children[i].node.get_id() != id) {
                    previousSiblingIndex = children[i].index;
                    break;
                }
            }

            /* Examining the previous sibling's combination (if it's within the combination) */
            if (previousSiblingIndex >= 0) {
                selfCombination = this.owningCombination(id);
                combination = this.owningCombination(this._nodes[previousSiblingIndex].get_id());

                if (combination) {
                    /* Nodes are part of different combinations */
                    if (selfCombination == null || selfCombination.get_id() != combination.get_id()) {
                        changeOrder = false;

                        originalIsSilent = this.get_isSilent();
                        this.set_isSilent(true);

                        /*
                        By moving this node up it will be a prt of different combination.
                        Don't change the sort order, simply changing the combination.
                        */
                        if (selfCombination) {
                            this.breakCombination([id], false);
                        }

                        this.moveToCombination(id, combination);

                        this.set_isSilent(originalIsSilent);
                    }
                }
            }

            if (changeOrder) {
                for (var i = 0; i < children.length; i++) {
                    /* Moving the previous sibling down (increasing sort order) */
                    if (this._nodes[children[i].index].get_order() == nodeOrder && children[i].node.get_id() != id) {
                        this._nodes[children[i].index]._order += 1;

                        break;
                    }
                }

                /* Moving one position up (by simply changing the sort order) */
                this._nodes[nodeIndex]._order = nodeOrder;

                /* Taking combinations into account (moving to combination) */
                if (previousSiblingIndex >= 0) {
                    combination = this.owningCombination(this._nodes[previousSiblingIndex].get_id());

                    if (combination) {
                        originalIsSilent = this.get_isSilent();
                        this.set_isSilent(true);

                        this.moveToCombination(id, combination);

                        this.set_isSilent(originalIsSilent);
                    }
                }
            }

            this.onUpdate({ type: 'structure' });
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.moveDown = function (id) {
    /// <summary>Moves the given node one position down in the tree hierarchy.</summary>
    /// <parm name="id">Node ID.</param>

    var self = this;
    var children = [];
    var parent = null;
    var nodeOrder = -1;
    var nodeIndex = -1;
    var siblings = null;
    var newChildren = [];
    var combination = null;
    var isLastChild = false;
    var changeOrder = false;
    var parentOfParent = null;
    var nextSiblingIndex = -1;
    var selfCombination = null;
    var originalIsSilent = false;

    nodeIndex = this._nodeIdentityIndex[id];

    var finalizeMove = function (tryChangeCombination) {
        if ((typeof (tryChangeCombination) == 'undefined' || tryChangeCombination == null || !!tryChangeCombination) && nextSiblingIndex >= 0) {
            combination = self.owningCombination(self._nodes[nextSiblingIndex].get_id());

            if (combination) {
                originalIsSilent = self.get_isSilent();
                self.set_isSilent(true);

                self.moveToCombination(id, combination);

                self.set_isSilent(originalIsSilent);
            }
        }

        self.onUpdate({ type: 'structure' });
    }

    if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
        /* Saving the order of the node (will use it later) */
        nodeOrder = this._nodes[nodeIndex].get_order();

        /* Getting the ID of the parent node */
        parent = this._childToParentRelation[id];

        /* First, determining if it's a last child node of its parent */
        siblings = this.siblings(id);

        if (siblings && siblings.length) {
            isLastChild = siblings[siblings.length - 1].node.get_id() == id;
        }

        if (isLastChild) {
            /* Parent can't be null in case of last child = can't move the bottom node further down */
            if (parent != null) {
                /* Moving to the parent of parent */
                parentOfParent = this._childToParentRelation[parent];
                children = this.children(parentOfParent);

                /* Attaching to a new node */
                this._childToParentRelation[id] = parentOfParent;

                /* Removing relation to the old parent node */
                if (this._parentToChildRelation[parent]) {
                    /* Collecting new children */
                    for (var i = 0; i < this._parentToChildRelation[parent].length; i++) {
                        if (this._parentToChildRelation[parent][i] != id) {
                            newChildren[newChildren.length] = this._parentToChildRelation[parent][i];
                        }
                    }

                    /* Commited new children of the old parent */
                    this._parentToChildRelation[parent] = newChildren;
                }

                /* Might be a new root node */
                if (parentOfParent == null) {
                    parentOfParent = 'root';
                }

                if (!this._parentToChildRelation[parentOfParent]) {
                    this._parentToChildRelation[parentOfParent] = [];
                }

                /* Adding new children to the new parent */
                this._parentToChildRelation[parentOfParent][this._parentToChildRelation[parentOfParent].length] = id;

                /* Changing the sort order (the first sibling) */
                this._nodes[nodeIndex]._order = 0;

                /* Moving all other siblings one position down */
                for (var i = 0; i < children.length; i++) {
                    if (i == 0) {
                        nextSiblingIndex = children[i].index;
                    }

                    this._nodes[children[i].index]._order += 1;
                }

                finalizeMove();
            }
        } else {
            nodeOrder += 1;
            changeOrder = true;
            children = this.children(parent);

            /* Retrieving the index of the next sibling */
            for (var i = 0; i < children.length; i++) {
                if (this._nodes[children[i].index].get_order() == nodeOrder && children[i].node.get_id() != id) {
                    nextSiblingIndex = children[i].index;
                    break;
                }
            }

            /* Examining the next sibling's combination (if it's within the combination) */
            if (nextSiblingIndex >= 0) {
                selfCombination = this.owningCombination(id);
                combination = this.owningCombination(this._nodes[nextSiblingIndex].get_id());

                if (combination) {
                    /* Nodes are part of different combinations */
                    if (selfCombination == null || selfCombination.get_id() != combination.get_id()) {
                        changeOrder = false;

                        originalIsSilent = this.get_isSilent();
                        this.set_isSilent(true);

                        /*
                        By moving this node down it will be a prt of different combination.
                        Don't change the sort order, simply changing the combination.
                        */
                        if (selfCombination) {
                            this.breakCombination([id], false);
                        }

                        this.moveToCombination(id, combination);

                        this.set_isSilent(originalIsSilent);
                    }
                } else if (selfCombination) {
                    changeOrder = false;

                    /*
                    Sibling is part of any combinations but the target node is.
                    Don't change the sort order, simply breaking the combination.
                    */
                    this.breakCombination([id], false);

                    finalizeMove(false);
                }
            }

            if (changeOrder) {
                for (var i = 0; i < children.length; i++) {
                    /* Moving the next sibling up (decreasing sort order) */
                    if (this._nodes[children[i].index].get_order() == nodeOrder && children[i].node.get_id() != id) {
                        this._nodes[children[i].index]._order -= 1;

                        nextSiblingIndex = children[i].index;

                        break;
                    }
                }

                /* Moving one position down (by simply changing the sort order) */
                this._nodes[nodeIndex]._order = nodeOrder;
            }

            finalizeMove();
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.move = function (node, newParent, refNode) {
    /// <summary>Moves the node from one location to another.</summary>
    /// <param name="node">Node to move.</param>
    /// <param name="newParent">New parent node.</param>
    /// <param name="refNode">Node to place the target node after.</param>

    var self = this;
    var oldOrder = 0;
    var children = [];
    var nodeOrder = 0;
    var nodeIndex = -1;
    var orderDelta = 0;
    var childIndex = 0;
    var newChildren = [];
    var oldParent = null;
    var refNodeIndex = -1;
    var appendToRelation = null;

    var finalizeMove = function (modifyCombination) {
        var originalSilent = false;
        var refNodeCombination = null;

        if (refNode && modifyCombination) {
            originalSilent = self.get_isSilent();

            self.set_isSilent(true);

            refNodeCombination = self.owningCombination(refNode);
            self.moveToCombination(node, refNodeCombination);

            self.set_isSilent(originalSilent);
        }

        self.onUpdate({ type: 'structure' });
    }

    if (node) {
        /* Normalizing input parameters */
        if (typeof (node) != 'string' && typeof (node.get_id) == 'function') node = node.get_id();
        if (newParent && typeof (newParent) != 'string' && typeof (newParent.get_id) == 'function') newParent = newParent.get_id();
        if (refNode != null && typeof (refNode) != 'string' && typeof (refNode.get_id) == 'function') refNode = refNode.get_id();

        nodeIndex = this._nodeIdentityIndex[node];
        if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
            if (this._childToParentRelation[node] == newParent) {
                /* The old and the new parent node is the same node */
                if (refNode) {
                    /* Reference node specified - chaing the sort order */
                    refNodeIndex = this._nodeIdentityIndex[refNode];
                    if (refNodeIndex >= 0 && refNodeIndex < this._nodes.length) {
                        children = this.children(newParent);
                        orderDelta = this._nodes[refNodeIndex].get_order() - this._nodes[nodeIndex].get_order();

                        if (orderDelta < 0) {
                            /* Moving node up */
                            for (var i = 0; i < children.length; i++) {
                                if (children[i].node.get_id() == node) {
                                    break;
                                } else if (children[i].node.get_order() > this._nodes[refNodeIndex].get_order()) {
                                    this._nodes[children[i].index]._order += 1;
                                }
                            }
                        } else {
                            /* Moving node down */
                            for (var i = 0; i < children.length; i++) {
                                if (children[i].node.get_id() != node && children[i].node.get_order() > this._nodes[nodeIndex].get_order()) {
                                    if (children[i].node.get_order() <= this._nodes[refNodeIndex].get_order()) {
                                        this._nodes[children[i].index]._order -= 1;
                                    } else {
                                        /*this._nodes[children[i].index]._order += 1;*/
                                        break;
                                    }
                                }
                            }
                        }

                        /* Changing the sort order and finalizing the move process (firing notifications) */
                        this._nodes[nodeIndex]._order = this._nodes[refNodeIndex]._order + 1;

                        finalizeMove(false);
                    }
                }
            } else {
                appendToRelation = newParent;
                children = this.children(newParent);
                oldParent = this._childToParentRelation[node];
                oldOrder = this._nodes[nodeIndex].get_order();

                /* Determining new sort order and the reference node */
                if (children && children.length) {
                    nodeOrder = children.length - 1;

                    if (!refNode) {
                        refNode = children[0].node.get_id();
                    }
                }

                if (!newParent || !newParent.length) appendToRelation = 'root';
                if (!oldParent || !oldParent.length) oldParent = 'root';
                if (!this._parentToChildRelation[appendToRelation]) this._parentToChildRelation[appendToRelation] = [];

                this._nodes[nodeIndex]._order = nodeOrder;

                /* Attaching node to a new parent */
                this._childToParentRelation[node] = newParent;
                this._parentToChildRelation[appendToRelation][this._parentToChildRelation[appendToRelation].length] = node;

                /* Removing relations to old parent */
                if (this._parentToChildRelation[oldParent]) {
                    if (this._parentToChildRelation[oldParent].length <= 1) {
                        this._parentToChildRelation[oldParent] = [];
                    } else {
                        for (var i = 0; i < this._parentToChildRelation[oldParent].length; i++) {
                            if (this._parentToChildRelation[oldParent][i] != node) {
                                newChildren[newChildren.length] = this._parentToChildRelation[oldParent][i];
                            }
                        }

                        this._parentToChildRelation[oldParent] = newChildren;

                        /* Changing the sort order */
                        for (var i = 0; i < newChildren.length; i++) {
                            childIndex = this._nodeIdentityIndex[newChildren[i]];
                            if (childIndex >= 0 && childIndex < this._nodes.length) {
                                if (this._nodes[childIndex].get_order() > oldOrder) {
                                    this._nodes[childIndex]._order -= 1;
                                }
                            }
                        }
                    }
                }

                finalizeMove(true);
            }
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.node = function (id) {
    /// <summary>Returns the reference to a tree node by its ID.</summary>
    /// <param name="id">Node ID.</param>

    var ret = null;
    var nodeIndex = this._nodeIdentityIndex[id];

    if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
        ret = this._nodes[nodeIndex];
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.nodes = function (ids) {
    /// <summary>Returns the list of nodes with given IDs.</summary>
    /// <param name="ids">Node IDs.</param>

    var ret = [];
    var nodeIndex = -1;

    if (ids && ids.length) {
        for (var i = 0; i < ids.length; i++) {
            nodeIndex = this._nodeIdentityIndex[ids[i]];
            if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
                ret[ret.length] = { index: nodeIndex, node: this._nodes[nodeIndex] };
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.children = function (parent) {
    /// <summary>Returns a list of all top-level child nodes of a given node.</summary>
    /// <param name="parent">Parent node ID.</param>

    var ret = [];
    var children = [];
    var nodeIndex = -1;

    if (parent != null && (typeof (parent) != 'string' && typeof (parent.get_id) == 'function')) {
        parent = parent.get_id();
    }

    if (!parent || !parent.length) {
        parent = 'root';
    }

    if (this._parentToChildRelation[parent] && this._parentToChildRelation[parent].length) {
        children = this._parentToChildRelation[parent];

        for (var i = 0; i < children.length; i++) {
            nodeIndex = this._nodeIdentityIndex[children[i]];
            if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
                ret[ret.length] = { index: nodeIndex, node: this._nodes[nodeIndex] };
            }
        }
    }

    this._sort(ret);

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.selection = function (parent, recursive) {
    /// <summary>Gets all selected nodes of the given parent node.</summary>
    /// <param name="parent">An ID of the parent node. If omitted, the selection within the entire tree will be retrieved.</param>
    /// <param name="recusrive">Value indicating whether to recursively collect all child selected nodes of the given parent. Only takes effect if parent node is specified.</param>

    return this._collectSelection(parent, recursive);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.setSelection = function (parent, selected, recursive) {
    /// <summary>Changes the "selected" mode of the given tree nodes.</summary>
    /// <param name="parent">An ID of the parent node. If omitted, the selection within the entire tree will be retrieved.</param>
    /// <param name="selected">Value indicating whether nodes are selected.</param>
    /// <param name="recusrive">Value indicating whether to recursively collect all child selected nodes of the given parent. Only takes effect if parent node is specified.</param>

    var originalSilent = this.get_isSilent();

    this.set_isSilent(true);
    this._collectSetSelection(parent, selected, recursive);
    this.set_isSilent(originalSilent);

    var self = this;
    this.onSelectionChanged({ selection: self.selection(null, true) });
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.siblings = function (node) {
    /// <summary>Returns a list of all siblings of a given node, including the given node.</summary>
    /// <param name="parent">Node reference.</param>

    var ret = [];
    var parentID = this._childToParentRelation[node];

    if (parentID == null) {
        ret = this.root();
    } else {
        ret = this.children(parentID);
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.firstChild = function (parent) {
    /// <summary>Gets the reference to first child of the given parent node.</summary>
    /// <param name="parent">Parent node ID.</param>

    var ret = null;
    var children = this.children(parent);

    if (children && children.length) {
        ret = { index: children[0].index, node: children[0].node };
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.lastChild = function (parent) {
    /// <summary>Gets the reference to last child of the given parent node.</summary>
    /// <param name="parent">Parent node ID.</param>

    var ret = null;
    var children = this.children(parent);

    if (children && children.length) {
        ret = { index: children[children.length - 1].index, node: children[children.length - 1].node };
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.clearChildren = function (parent) {
    /// <summary>Removes all child nodes of the given parent node.</summary>
    /// <param name="parent">An ID of the parent node.</param>

    var nodeIDs = [];
    var children = this.children(parent);

    if (children && children.length) {
        for (var i = 0; i < children.length; i++) {
            nodeIDs[nodeIDs.length] = children[i].node.get_id();
        }

        this.removeRange(nodeIDs);
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.append = function (node, appendTo) {
    /// <summary>Adds new node to the tree.</summary>
    /// <param name="node">Node to add.</param>
    /// <param name="appendTo">An ID of the parent node.</param>

    this._append(node, appendTo, false);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.appendRange = function (nodes, appendTo) {
    /// <summary>Adds given list of nodes to the tree.</summary>
    /// <param name="nodes">Nodes to add.</param>
    /// <param name="appendTo">An ID of the parent node.</param>

    this._appendRange(nodes, appendTo, false);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.remove = function (nodeID) {
    /// <summary>Removes the given node from the tree.</summary>
    /// <param name="nodeID">Node ID.</param>

    this._remove(nodeID, false);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.removeRange = function (nodes) {
    /// <summary>Removes the given list of nodes from the tree.</summary>
    /// <param name="nodes">A list of node IDs to remove.</param>

    this._removeRange(nodes, false);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.add_update = function (callback) {
    /// <summary>Registers a new callback that is executed when the tree updates.</summary>

    if (callback && typeof (callback) == 'function') {
        this._handlers.update[this._handlers.update.length] = callback;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.add_afterNodeAppend = function (callback) {
    /// <summary>Registers a new callback that is executed after tree node has been added.</summary>

    if (callback && typeof (callback) == 'function') {
        this._handlers.afterNodeAppend[this._handlers.afterNodeAppend.length] = callback;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.add_afterNodeRemove = function (callback) {
    /// <summary>Registers a new callback that is executed when after tree node has been removed.</summary>

    if (callback && typeof (callback) == 'function') {
        this._handlers.afterNodeRemove[this._handlers.afterNodeRemove.length] = callback;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.add_selectionChanged = function (callback) {
    /// <summary>Registers a new callback that is executed after tree selection changes.</summary>

    if (callback && typeof (callback) == 'function') {
        this._handlers.selectionChanged[this._handlers.selectionChanged.length] = callback;
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.onUpdate = function (e) {
    /// <summary>Raises "update" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('update', e);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.onAfterNodeAppend = function (e) {
    /// <summary>Raises "afterNodeAppend" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('afterNodeAppend', e);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.onAfterNodeRemove = function (e) {
    /// <summary>Raises "afterNodeRemove" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('afterNodeRemove', e);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.onSelectionChanged = function (e) {
    /// <summary>Raises "selectionChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('selectionChanged', e);
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.notify = function (eventName, args) {
    /// <summary>Notifies clients about the specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>

    var callbacks = [];
    var callbackException = null;

    if (!this.get_isSilent()) {
        if (eventName && eventName.length) {
            callbacks = this._handlers[eventName];

            if (callbacks && callbacks.length) {
                if (typeof (args) == 'undefined' || args == null) {
                    args = {};
                }

                for (var i = 0; i < callbacks.length; i++) {
                    callbackException = null;

                    try {
                        callbacks[i](this, args);
                    } catch (ex) {
                        callbackException = ex;
                    }

                    /* Preventing "Unable to execute code from freed script" errors to raise */
                    if (callbackException && callbackException.number != -2146823277) {
                        Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.error(callbackException.message);
                    }
                }
            }
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype.generateNodeID = function () {
    /// <summary>Generates the unique numeric identifier.</summary>

    var prefix = this.get_id();

    if (typeof (prefix) == 'undefined' || typeof (prefix) != 'string') {
        prefix = '';
    } else {
        prefix = prefix + '_';
    }

    return Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.ComponentManager.get_current().generateComponentID(prefix + 'node');
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype._append = function (node, appendTo, silent) {
    /// <summary>Adds new node to the tree.</summary>
    /// <param name="node">Node to add.</param>
    /// <param name="appendTo">An ID of the parent node.</param>
    /// <param name="silent">Indicates whether to prohibit any events from firing.</param>
    /// <private />

    var n = null;
    var nodeID = 0;
    var self = this;
    var nodeIndex = -1;
    var childrenMap = [];
    var appendToIndex = -1;
    var appendToRelation = appendTo;

    if (node) {
        if (typeof (node.id) == 'string') {
            nodeID = node.id;
        } else if (typeof (node.get_id) == 'function') {
            nodeID = node.get_id();
        }

        if (!nodeID || !nodeID.length) {
            nodeID = this.generateNodeID();
        }

        childrenMap = this.children(appendTo);
        n = new Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.TreeNode();

        n.load(node, true);
        n.set_id(nodeID);
        n._order = childrenMap.length;
        n.add_stateChanged(function (sender, args) { self.onUpdate({ type: 'node', parameters: args }); });

        nodeIndex = this._nodes.length;

        this._nodes[nodeIndex] = n;
        this._nodeIdentityIndex[nodeID] = nodeIndex;
        this._childToParentRelation[nodeID] = appendTo;

        if (!appendTo || !appendTo.length) {
            appendToRelation = 'root';
        }

        if (!this._parentToChildRelation[appendToRelation]) {
            this._parentToChildRelation[appendToRelation] = [];
        }

        this._parentToChildRelation[appendToRelation][this._parentToChildRelation[appendToRelation].length] = nodeID;

        this._parentToChildRelation[nodeID] = [];

        n.add_selectedChanged(function (sender, args) {
            self.onSelectionChanged({ selection: self.selection(null, true) });
        });

        if (!silent) {
            this.onAfterNodeAppend({ nodes: [this._nodes[nodeIndex]] });
            this.onUpdate({ type: 'structure' });
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype._appendRange = function (nodes, appendTo, silent) {
    /// <summary>Adds the given range of nodes to the tree.</summary>
    /// <param name="nodes">Nodes to add.</param>
    /// <param name="appendTo">An ID of the parent node.</param>
    /// <param name="silent">Indicates whether to prohibit any events from firing.</param>
    /// <private />

    var target = null;
    var targetNodes = [];

    if (nodes && nodes.length) {
        for (var i = 0; i < nodes.length; i++) {
            this._append(nodes[i], appendTo, true);
        }

        target = this.nodes(nodes);

        for (var i = 0; i < target.length; i++) {
            targetNodes[targetNodes.length] = target[i].node;
        }

        if (!silent) {
            this.onAfterNodeAppend({ nodes: targetNodes });
            this.onUpdate({ type: 'structure' });
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype._remove = function (nodeID, silent) {
    /// <summary>Removes the given node from the tree.</summary>
    /// <param name="nodeID">Node ID.</param>
    /// <param name="silent">Indicates whether to prohibit any events from firing.</param>
    /// <private />

    var node = null;
    var parentID = '';
    var children = [];
    var newNodes = [];
    var nodeIndex = -1;
    var nodeOrder = -1;
    var affectedIDs = [];
    var siblingsMap = [];
    var newChildren = [];

    if (typeof (this._nodeIdentityIndex[nodeID]) != 'undefined' && this._nodeIdentityIndex[nodeID] != null) {
        nodeIndex = this._nodeIdentityIndex[nodeID];

        if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
            node = this._nodes[nodeIndex];

            for (var i = 0; i < this._nodes.length; i++) {
                if (this._nodes[i].get_id() != nodeID) {
                    newNodes[newNodes.length] = this._nodes[i];
                } else {
                    nodeOrder = this._nodes[i].get_order();
                }

                if (i > nodeIndex) {
                    affectedIDs[affectedIDs.length] = this._nodes[i].get_id();
                }
            }

            if (typeof (this._childToParentRelation[nodeID]) != 'undefined') {
                parentID = this._childToParentRelation[nodeID];
                if (!parentID || !parentID.length) {
                    parentID = 'root';
                }

                if (this._parentToChildRelation[parentID]) {
                    for (var i = 0; i < this._parentToChildRelation[parentID].length; i++) {
                        if (this._parentToChildRelation[parentID][i] != nodeID) {
                            newChildren[newChildren.length] = this._parentToChildRelation[parentID][i];
                        }
                    }

                    this._parentToChildRelation[parentID] = newChildren;
                }
            }

            for (var childID in this._childToParentRelation) {
                if (typeof (this._childToParentRelation[childID]) != 'function' && this._childToParentRelation[childID] == nodeID) {
                    children[children.length] = childID;
                }
            }

            this._nodes = newNodes;

            delete this._nodeIdentityIndex[nodeID];
            delete this._parentToChildRelation[nodeID];

            for (var i = 0; i < affectedIDs.length; i++) {
                this._nodeIdentityIndex[affectedIDs[i]] -= 1;
            }

            for (var i = 0; i < children.length; i++) {
                this._remove(children[i], true);
            }

            siblingsMap = this.siblings(nodeID);

            if (siblingsMap && siblingsMap.length) {
                for (var i = 0; i < siblingsMap.length; i++) {
                    if (this._nodes[siblingsMap[i].index].get_order() > nodeOrder) {
                        this._nodes[siblingsMap[i].index]._order -= 1;
                    }
                }
            }

            this.breakCombination([nodeID]);

            if (!silent) {
                this.onAfterNodeRemove({ nodes: [node] });
                this.onUpdate({ type: 'structure' });
            }
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype._removeRange = function (nodes, silent) {
    /// <summary>Removes the given range of nodes from the tree.</summary>
    /// <param name="nodes">Nodes to remove.</param>
    /// <param name="silent">Indicates whether to prohibit any events from firing.</param>
    /// <private />

    var target = null;
    var targetNodes = [];

    if (nodes && nodes.length) {
        target = this.nodes(nodes);

        for (var i = 0; i < target.length; i++) {
            targetNodes[targetNodes.length] = target[i].node;
        }

        for (var i = 0; i < nodes.length; i++) {
            this._remove(nodes[i], true);
        }

        if (!silent) {
            this.onAfterNodeRemove({ nodes: targetNodes });
            this.onUpdate({ type: 'structure' });
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype._collectSelection = function (parent, recursive) {
    /// <summary>Collects selected tree nodes.</summary>
    /// <param name="parent">Parent node ID.</param>
    /// <param name="recursive">Value indicating whether to recursively collect all child nodes that are selected.</param>
    /// <private />

    var ret = [];
    var root = [];
    var children = [];
    var collected = [];

    if (parent && parent.length) {
        children = this.children(parent);

        if (children && children.length) {
            for (var i = 0; i < children.length; i++) {
                if (children[i].node.get_isSelected()) {
                    ret[ret.length] = children[i];
                }

                if (recursive) {
                    collected = this._collectSelection(children[i].node.get_id(), true);
                    if (collected && collected.length) {
                        for (var j = 0; j < collected.length; j++) {
                            ret[ret.length] = collected[j];
                        }
                    }
                }
            }
        }
    } else {
        root = this.root();
        if (root && root.length) {
            for (var i = 0; i < root.length; i++) {
                if (root[i].node.get_isSelected()) {
                    ret[ret.length] = root[i];
                }

                if (recursive) {
                    collected = this._collectSelection(root[i].node.get_id(), true);
                    if (collected && collected.length) {
                        for (var j = 0; j < collected.length; j++) {
                            ret[ret.length] = collected[j];
                        }
                    }
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype._collectSetSelection = function (parent, selected, recursive) {
    /// <summary>Changes the "selected" mode of the given tree nodes.</summary>
    /// <param name="parent">An ID of the parent node. If omitted, the selection within the entire tree will be retrieved.</param>
    /// <param name="selected">Value indicating whether nodes are selected.</param>
    /// <param name="recusrive">Value indicating whether to recursively collect all child selected nodes of the given parent. Only takes effect if parent node is specified.</param>
    /// <private />

    var root = [];
    var children = [];

    selected = !!selected;

    if (parent && parent.length) {
        children = this.children(parent);

        if (children && children.length) {
            for (var i = 0; i < children.length; i++) {
                children[i].node.set_isSelected(selected);
                if (recursive) {
                    this._collectSetSelection(children[i].node.get_id(), selected, true);
                }
            }
        }
    } else {
        root = this.root();

        if (root && root.length) {
            for (var i = 0; i < root.length; i++) {
                root[i].node.set_isSelected(selected);
                if (recursive) {
                    this._collectSetSelection(root[i].node.get_id(), selected, true);
                }
            }
        }
    }
}

Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.Tree.prototype._sort = function (items) {
    /// <summary>Sorts the given array.</summary>
    /// <param name="items">Items to sort.</param>
    /// <private />

    var sortValue = function (item) {
        var ret = 0;

        if (typeof (item) == 'number') {
            ret = item;
        } else if (typeof (item.node) != 'undefined' && typeof (item.node.get_order) == 'function') {
            ret = item.node.get_order();
        }

        return ret;
    }

    items.sort(function (n1, n2) {
        return sortValue(n1) - sortValue(n2);
    });
}
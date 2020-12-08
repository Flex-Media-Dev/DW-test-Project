/* ++++++ Registering namespace ++++++ */

if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Validation) == 'undefined') {
    Dynamicweb.Validation = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.Validation.setFocusToValidateField = true;

Dynamicweb.Validation.Validator = function () {
    /// <summary>Represents a base class for creating validators.</summary>
}

Dynamicweb.Validation.Validator.prototype.beginValidate = function (context, onComplete) {
    /// <summary>Begins validation.</summary>
    /// <param name="context">Validation context.</param>
    /// <param name="onComplete">A callback that must be called by the validator when validation finishes.</param>

    onComplete({ isValid: true, errorMessage: '' });
}

Dynamicweb.Validation.SimpleValidator = function (target, errorMessage) {
    /// <summary>Represents a simple validator.</summary>
    /// <param name="target">Target element.</param>
    /// <param name="errorMessage">Error message.</param>

    this._target = target;
    this._errorMessage = errorMessage;
}

// Inheritance
Dynamicweb.Validation.SimpleValidator.prototype = new Dynamicweb.Validation.Validator();

Dynamicweb.Validation.SimpleValidator.prototype.get_target = function () {
    /// <summary>Gets the target element.</summary>

    return this._target;
}

Dynamicweb.Validation.SimpleValidator.prototype.set_target = function (value) {
    /// <summary>Sets the target element.</summary>
    /// <param name="value">Target element.</param>

    this._target = value;
}

Dynamicweb.Validation.SimpleValidator.prototype.get_errorMessage = function () {
    /// <summary>Gets the error message.</summary>

    return this._errorMessage;
}

Dynamicweb.Validation.SimpleValidator.prototype.set_errorMessage = function (value) {
    /// <summary>Sets the error message.</summary>
    /// <param name="value">Error message.</param>

    this._errorMessage = value;
}

Dynamicweb.Validation.RequiredFieldValidator = function (target, errorMessage) {
    /// <summary>Represents a required field validator.</summary>
    /// <param name="target">Target element.</param>
    /// <param name="errorMessage">Error message.</param>

    this.set_target(target);
    this.set_errorMessage(errorMessage);
}

// Inheritance
Dynamicweb.Validation.RequiredFieldValidator.prototype = new Dynamicweb.Validation.SimpleValidator();

Dynamicweb.Validation.RequiredFieldValidator.prototype.beginValidate = function (context, onComplete) {
    /// <summary>Begins validation.</summary>
    /// <param name="context">Validation context.</param>
    /// <param name="onComplete">A callback that must be called by the validator when validation finishes.</param>

    var result = {
        isValid: false,
        errorMessage: this.get_errorMessage()
    };

    var t = context.manager.getField(this.get_target());
    var v = context.manager.getValue(this.get_target());

    if (t) {
        result.isValid = v && v.length;

        if (!result.isValid) {
            try {
                if (Dynamicweb.Validation.setFocusToValidateField) {
                    t.focus();
                }
            } catch (ex) { }
        }
    }

    return onComplete(result);
}

Dynamicweb.Validation.ZeroFieldValidator = function (target, errorMessage) {
    /// <summary>Represents a required field validator.</summary>
    /// <param name="target">Target element.</param>
    /// <param name="errorMessage">Error message.</param>

    this.set_target(target);
    this.set_errorMessage(errorMessage);
}

// Inheritance
Dynamicweb.Validation.ZeroFieldValidator.prototype = new Dynamicweb.Validation.SimpleValidator();

Dynamicweb.Validation.ZeroFieldValidator.prototype.beginValidate = function (context, onComplete) {
    /// <summary>Begins validation.</summary>
    /// <param name="context">Validation context.</param>
    /// <param name="onComplete">A callback that must be called by the validator when validation finishes.</param>

    var result = {
        isValid: false,
        errorMessage: this.get_errorMessage()
    };

    var t = context.manager.getField(this.get_target());
    var v = context.manager.getValue(this.get_target());

    if (t) {
        result.isValid = (v != 0.0 && v!= "0" && v!= "0,00" && v!= "0.00" );

        if (!result.isValid) {
            try {
                if (Dynamicweb.Validation.setFocusToValidateField) {
                    t.focus();
                }
            } catch (ex) { }
        }
    }

    return onComplete(result);
}

Dynamicweb.Validation.RegExValidator = function (target, errorMessage, pattern) {
    /// <summary>Represents a required field validator.</summary>
    /// <param name="target">Target element.</param>
    /// <param name="errorMessage">Error message.</param>
    /// <param name="pattern">Regular expression pattern.</param>

    this._pattern = '';

    this.set_target(target);
    this.set_errorMessage(errorMessage);
    this.set_pattern(pattern);
}

// Inheritance
Dynamicweb.Validation.RegExValidator.prototype = new Dynamicweb.Validation.SimpleValidator();

Dynamicweb.Validation.RegExValidator.prototype.get_pattern = function () {
    /// <summary>Gets the regular expression pattern.</summary>

    return this._pattern;
}

Dynamicweb.Validation.RegExValidator.prototype.set_pattern = function (value) {
    /// <summary>Sets the regular expression pattern.</summary>
    /// <param name="value">Regular expression pattern.</param>

    this._pattern = value;
}

Dynamicweb.Validation.RegExValidator.prototype.beginValidate = function (context, onComplete) {
    /// <summary>Begins validation.</summary>
    /// <param name="context">Validation context.</param>
    /// <param name="onComplete">A callback that must be called by the validator when validation finishes.</param>

    var pattern = '';

    var result = {
        isValid: false,
        errorMessage: this.get_errorMessage()
    };

    var t = context.manager.getField(this.get_target());
    var v = context.manager.getValue(this.get_target());

    if (t) {
        pattern = this.get_pattern();

        if (pattern.indexOf('^') != 0) pattern = '^' + pattern;
        if (pattern.lastIndexOf('$') != (pattern.length - 1)) pattern += '$';

        result.isValid = new RegExp(pattern, 'g').test(v || '');

        if (!result.isValid) {
            try {
                if (Dynamicweb.Validation.setFocusToValidateField) {
                    t.focus();
                    t.select();
                }
            } catch (ex) { }
        }
    }

    return onComplete(result);
}

// File extensions validator
Dynamicweb.Validation.ExtensionValidator = function (target, errorMessage, extensions) {
    /// <summary>Represents a required field validator.</summary>
    /// <param name="target">Target element.</param>
    /// <param name="errorMessage">Error message.</param>
    /// <param name="extensions">Extensions.</param>

    this._extensions = '';

    this.set_target(target);
    this.set_errorMessage(errorMessage);
    this.set_extensions(extensions);
}

Dynamicweb.Validation.ExtensionValidator.prototype = new Dynamicweb.Validation.SimpleValidator();

Dynamicweb.Validation.ExtensionValidator.prototype.get_extensions = function () {
    /// <summary>Gets the regular expression pattern.</summary>

    return this._extensions;
}

Dynamicweb.Validation.ExtensionValidator.prototype.set_extensions = function (value) {
    /// <summary>Sets the regular expression pattern.</summary>
    /// <param name="value">Regular expression pattern.</param>

    this._extensions = value;
}

Dynamicweb.Validation.ExtensionValidator.prototype.beginValidate = function (context, onComplete) {
    /// <summary>Begins validation.</summary>
    /// <param name="context">Validation context.</param>
    /// <param name="onComplete">A callback that must be called by the validator when validation finishes.</param>

    var extensions = '';

    var result = {
        isValid: false,
        errorMessage: this.get_errorMessage()
    };

    var t = context.manager.getField(this.get_target());
    var v = context.manager.getValue(this.get_target()) || "";

    if (t) {
        extensions = this.get_extensions();

        if (extensions !== '') {
            let extension = v.toLowerCase().split('.').pop();
            let focalPoint = extension.indexOf("?x=");
            if (focalPoint !== -1) {
                extension = extension.substring(0, focalPoint);
            }
            result.isValid = extensions.toLowerCase().indexOf(extension) !== -1 || false;
        } else {
            result.isValid = true;
        }        

        if (!result.isValid) {
            try {
                if (Dynamicweb.Validation.setFocusToValidateField) {
                    t.focus();
                    t.select();
                }
            } catch (ex) { }
        }
    }

    onComplete(result);
}


Dynamicweb.Validation.LengthValidator = function (target, errorMessage, minLength, maxLength, tracking) {
    var self = this;
    self._minLength = 0;
    self._maxLength = 0;
    self._tracking = false;
    self._tracker = function (event) {
        var context = 
        self.beginValidate({
            // little hack
            manager: {
                getField: function () {
                    return event.target;
                },
                getValue: function () {
                    return event.target.value;
                }
            }
        }, function (result) {
            var element = event.target;
            if (!result.isValidMaxLength) {
                element.value = element.value.substring(0, self._maxLength);
            }
        });
    }

    self.set_target(target);
    self.set_errorMessage(errorMessage);
    self.set_minLength(minLength);
    self.set_maxLength(maxLength);
    self.set_tracking(tracking);
}

// Inheritance
Dynamicweb.Validation.LengthValidator.prototype = new Dynamicweb.Validation.SimpleValidator();

Dynamicweb.Validation.LengthValidator.prototype.beginValidate = function (context, onComplete) {
    /// <summary>Begins validation.</summary>
    /// <param name="context">Validation context.</param>
    /// <param name="onComplete">A callback that must be called by the validator when validation finishes.</param>

    var result = {
        isValid: true,
        errorMessage: this.get_errorMessage(),
        isValidMinLength: true,
        isValidMaxLength: true
    };

    var t = context.manager.getField(this.get_target());
    var v = context.manager.getValue(this.get_target());

    if (t) {

        if (this._minLength > 0 && this._minLength > v.length) {
            result.isValidMinLength = false;
        }

        if (this._maxLength > 0 && this._maxLength < v.length) {
            result.isValidMaxLength = false;
        }

        if (!result.isValid) {
            try {
                if (Dynamicweb.Validation.setFocusToValidateField) {
                    t.focus();
                }
            } catch (ex) { }
        }
    }

    onComplete(result);
}

Dynamicweb.Validation.LengthValidator.prototype.set_minLength = function (value) {
    /// <summary>Sets the min length of allowed characters.</summary>
    /// <param name="value">Min number of allowed characters.</param>

    if (typeof (value) === 'string') {
        value = parseInt(value, 10);
    }

    if (typeof (value) === 'number') {
        this._minLength = Math.floor(value);
    }
}

Dynamicweb.Validation.LengthValidator.prototype.set_maxLength = function (value) {
    /// <summary>Sets the max length of allowed characters.</summary>
    /// <param name="value">Max number of allowed characters.</param>

    if (typeof (value) === 'string') {
        value = parseInt(value, 10);
    }

    if (typeof (value) === 'number') {
        this._maxLength = Math.floor(value);
    }
}

Dynamicweb.Validation.LengthValidator.prototype.set_tracking = function (value) {
    /// <summary>Sets the value indicating whether keep track of the target to truncate value if input lenght is not valid in real time.</summary>
    /// <param name="value">Truncate or not.</param>
    var doc, targetElement;

    doc = document;

    if (typeof (value) === 'string') {
        value = value.toLowerCase();

        if (value === 'true') {
            value = true;
        } else {
            value = false;
        }
    }

    if (typeof (value) === 'boolean') {
        this._tracking = value;
    }

    var targetElement = doc.getElementById(this._target);

    if (!targetElement) {
        targetElement = doc.getElementsByName(this._target);

        if (targetElement != null && targetElement.length) {
            targetElement = targetElement[0];
        }

        if (!targetElement) {
            return;
        }
    }

    if (this._tracking) {
        targetElement.addEventListener("keydown", this._tracker);
        targetElement.addEventListener("change", this._tracker);
    } else {
        targetElement.removeEventListener("keydown", this._tracker);
        targetElement.removeEventListener("change", this._tracker);
    }
}

Dynamicweb.Validation.ItemListMinValidator = function (target, errorMessage, minNumber) {
    /// <summary>Represents a min rows number field validator.</summary>
    /// <param name="target">Target element.</param>
    /// <param name="errorMessage">Error message.</param>
    this._minNumber = minNumber;
    this.set_target(target);
    this.set_errorMessage(errorMessage);
}

// Inheritance
Dynamicweb.Validation.ItemListMinValidator.prototype = new Dynamicweb.Validation.SimpleValidator();

Dynamicweb.Validation.ItemListMinValidator.prototype.beginValidate = function (context, onComplete) {
    /// <summary>Begins validation.</summary>
    /// <param name="context">Validation context.</param>
    /// <param name="onComplete">A callback that must be called by the validator when validation finishes.</param>

    var result = {
        isValid: false,
        errorMessage: this.get_errorMessage()
    };

    var t = context.manager.getField(this.get_target() + '_body');
    var itemIds = $$('#' + this.get_target() + '_body tr[itemid]').collect(function (e) {
        return e.readAttribute('itemID');
    });

    if (t) {
        result.isValid = (this._minNumber == 0) || (itemIds && itemIds.length >= this._minNumber);

        if (!result.isValid) {
            try {
                if (Dynamicweb.Validation.setFocusToValidateField) {
                    t.focus();
                }
            } catch (ex) { }
        }
    }

    return onComplete(result);
}

Dynamicweb.Validation.ItemListMaxValidator = function (target, errorMessage, maxNumber) {
    /// <summary>Represents a min rows number field validator.</summary>
    /// <param name="target">Target element.</param>
    /// <param name="errorMessage">Error message.</param>
    this._maxNumber = maxNumber;
    this.set_target(target);
    this.set_errorMessage(errorMessage);
}

// Inheritance
Dynamicweb.Validation.ItemListMaxValidator.prototype = new Dynamicweb.Validation.SimpleValidator();

Dynamicweb.Validation.ItemListMaxValidator.prototype.beginValidate = function (context, onComplete) {
    /// <summary>Begins validation.</summary>
    /// <param name="context">Validation context.</param>
    /// <param name="onComplete">A callback that must be called by the validator when validation finishes.</param>

    var result = {
        isValid: false,
        errorMessage: this.get_errorMessage()
    };

    var t = context.manager.getField(this.get_target() + '_body');
    var itemIds = $$('#' + this.get_target() + '_body tr[itemid]').collect(function (e) {
        return e.readAttribute('itemID');
    });

    if (t) {
        result.isValid = (this._maxNumber == 0) || (itemIds && itemIds.length <= this._maxNumber);

        if (!result.isValid) {
            try {
                if (Dynamicweb.Validation.setFocusToValidateField) {
                    t.focus();
                }
            } catch (ex) { }
        }
    }

    return onComplete(result);
}

Dynamicweb.Validation.CustomValidator = function (target, errorMessage, validationFunction) {
    /// <summary>Represents a custom validator.</summary>
    /// <param name="target">Target element.</param>
    /// <param name="errorMessage">Error message.</param>
    /// <param name="validationFunction">This custom function should return validation result.</param>
    this.set_target(target);
    this.set_errorMessage(errorMessage);
    this._validationFunction = validationFunction;
}

// Inheritance
Dynamicweb.Validation.CustomValidator.prototype = new Dynamicweb.Validation.SimpleValidator();

Dynamicweb.Validation.CustomValidator.prototype.beginValidate = function (context, onComplete) {
    /// <summary>Begins validation.</summary>
    /// <param name="context">Validation context.</param>
    /// <param name="onComplete">A callback that must be called by the validator when validation finishes.</param>

    var result = {
        isValid: false,
        errorMessage: this.get_errorMessage()
    };

    if (this._validationFunction) {
        result.isValid = this._validationFunction(this.get_target())
    }

    return onComplete(result);
}

Dynamicweb.Validation.ValidationManager = function () {
    /// <summary>Represents a validation manager.</summary>

    this._validators = [];
}

Dynamicweb.Validation.ValidationManager.prototype.get_validators = function () {
    /// <summary>Gets the list of all validators.</summary>

    return this._validators;
}

Dynamicweb.Validation.ValidationManager.prototype.addValidator = function (validator) {
    /// <summary>Adds new validator.</summary>
    /// <param name="validator">Validator to add.</param>

    if (validator != null && typeof (validator.beginValidate) == 'function') {
        this._validators[this._validators.length] = validator;
    }
}

Dynamicweb.Validation.ValidationManager.prototype.beginValidate = function (onComplete) {
    /// <summary>Begins validation procedure.</summary>
    /// <param name="onComplete">A callback that is called when validaton finishes.</param>

    var queue = null;
    var context = { manager: this };
    var validators = this.get_validators();

    onComplete = onComplete || function () { };

    if (validators && validators.length) {
        queue = new Dynamicweb.Utilities.RequestQueue();

        for (var i = 0; i < validators.length; i++) {
            queue.add(validators[i], validators[i].beginValidate, [context, function (result) {
                if (!result || !result.isValid) {
                    if (result.errorMessage) {
                        alert(result.errorMessage);
                    }

                    queue.clear();

                    onComplete({ isValid: false });
                } else {
                    if (!queue.next()) {
                        onComplete({ isValid: true });
                    }
                }
            } ]);
        }

        queue.executeAll();
    } else {
        onComplete({ isValid: true });
    }
}

Dynamicweb.Validation.ValidationManager.prototype.getField = function (qualifier) {
    /// <summary>Returns the field by its qualifier.</summary>
    /// <param name="qualifier">Field qualifier.</param>

    var ret = document.getElementById(qualifier);

    if (!ret) {
        ret = this.getFieldByName(qualifier);
    }

    return ret;
}

Dynamicweb.Validation.ValidationManager.prototype.getFieldByName = function (name) {
    /// <summary>Returns the first form field with the given name.</summary>
    /// <param name="name">Field name.</param>

    var ret = null;
    var elements = document.getElementsByName(name);

    if (elements != null && elements.length) {
        ret = elements[0];
    }

    return ret;
}

Dynamicweb.Validation.ValidationManager.prototype.getValue = function (field) {
    /// <summary>Returns the value of a given field.</summary>
    /// <param name="field">Field.</param>

    var ret = '';
    var self = this;

    if (field) {
        ret = (function (fld) {
            var result = null, f = null;

            var getFCKValue = function (i) {
                var r = i != null && typeof (i.GetXHTML) == 'function' ? i.GetXHTML(false) : null;

                if (r != null) {
                    if (r.toLowerCase() == '<br />') { // FF fix
                        r = '';
                    }
                }

                return r;
            }

            var getCKValue = function (i) {
                var r = i != null && typeof (i.getData) == 'function' ? i.getData() : null;

                return r;
            }

            if (typeof (fld) == 'string') {
                result = self._tryGetValue([
                    {
                        instance: field + '_NumberSelector',
                        getter: 'get_selectedValue'
                    },
                    {
                        instance: field + '_FloatingPointNumberSelector',
                        getter: 'get_selectedValue'
                    },
                    {
                        instance: field + '_DateSelector',
                        getter: 'get_selectedDate'
                    },
                    {
                        instance: field + '_EditableListBox',
                        getter: 'get_values'
                    },
                    {
                        instance: 'UserSelector' + field,
                        getter: 'GetValue'
                    },
                    {
                        instance: function () { return typeof (FCKeditorAPI) != 'undefined' ? FCKeditorAPI.GetInstance(fld) : null; },
                        getter: getFCKValue
                    },
                    {
                        instance: function () { return typeof (CKEDITOR) != 'undefined' ? (function (name) { for (var i in CKEDITOR.instances) { if (CKEDITOR.instances[i].name == name) return CKEDITOR.instances[i]; } })(fld) : null; },
                        getter: getCKValue
                    },
                    {
                        instance: field + '_ProductListBox',
                        getter: 'get_dataSource'
                    }
                ]);

                if (result == null) {
                    result = self._getFormValue(fld);
                }
            } else {
                result = self._tryInvokeGetter(fld, [
                    'get_selectedValue',
                    'get_selectedDate',
                    'get_values',
                    getFCKValue
                ]);

                if (result == null) {
                    result = self._getFormValue(fld);
                }
            }

            return result;
        })(field);
    }

    return ret;
}

Dynamicweb.Validation.ValidationManager.prototype._tryGetValue = function (attempts) {
    /// <summary>Tries to get the value of a current field.</summary>
    /// <param name="attempts">A list of attempts.</param>

    var n = null;
    var ret = null;

    if (attempts && attempts.length) {
        for (var i = 0; i < attempts.length; i++) {
            n = attempts[i];

            if (n && typeof (n.instance) != 'undefined' && typeof (n.getter) != 'undefined') {
                ret = this._tryInvokeGetter(n.instance, n.getter);
                if (ret != null) {
                    break;
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Validation.ValidationManager.prototype._getFormValue = function (field) {
    /// <summary>Returns the value of the form field.</summary>
    /// <param name="field">Form field.</param>

    var f = null;
    var val = null;
    var ret = null;
    var fieldName = '';
    var otherFields = [];
    var collectedValues = [];

    if (field) {
        f = this.getField(field);

        if (f) {
            fieldName = f.name;

            if (fieldName) {
                otherFields = document.getElementsByName(fieldName);
                if (otherFields.length > 1) {
                    for (var i = 0; i < otherFields.length; i++) {
                        val = this._getSingleFieldValue(otherFields[i]);
                        if (val && val.length) {
                            collectedValues[collectedValues.length] = val;
                        }
                    }

                    if (collectedValues.length) {
                        ret = this._join(',', collectedValues);
                    }
                } else {
                    ret = this._getSingleFieldValue(f);
                }
            } else {
                ret = this._getSingleFieldValue(f);
            }
        }
    }

    return ret;
}

Dynamicweb.Validation.ValidationManager.prototype._getSingleFieldValue = function (field) {
    /// <summary>Returns the value of the single form field.</summary>
    /// <param name="field">Form field.</param>

    var f = null;
    var type = '';
    var ret = null;
    var tag = null;

    if (field) {
        if (typeof (field) == 'string') {
            f = this.getField(field);
        } else {
            f = field;
        }

        if (f) {
            tag = (f.tagName || f.nodeName || '').toLowerCase();

            if (tag == 'input') {
                type = (f.type || '').toLowerCase();

                if (type == 'checkbox' || type == 'radio') {
                    ret = !!f.checked ? f.value || '' : '';
                } else {
                    ret = f.value || '';
                }
            } else if (tag == 'select') {
                if (f.selectedIndex >= 0 && f.options && f.options.length > 0) {
                    ret = f.options[f.selectedIndex].value || '';
                }
            } else if (tag == 'textarea') {
                ret = f.value || '';
            }
        }
    }

    return ret;
}

Dynamicweb.Validation.ValidationManager.prototype._tryInvokeGetter = function (instance, getter) {
    /// <summary>Tries to invoke value getter on a given object.</summary>
    /// <param name="instance">A reference to an object instance.</param>
    /// <param name="getter">A getter function (or an array of getter functions).</param>

    var g = null;
    var o = null;
    var ret = null;
    var getters = [getter];

    if (getter && Object.isArray(getter)) {
        getters = getter;
    }

    if (instance && getters && getters.length) {
        // First, trying to get an actual object instance
        if (typeof (instance) == 'function') {
            o = instance();
        } else if (typeof (instance) == 'string') {
            o = window[instance];
        } else {
            o = instance;
        }

        if (typeof (o) != 'undefined') {
            for (var i = 0; i < getters.length; i++) {
                g = getters[i];

                // Next, figuring out how to execute the getter
                if (typeof (g) == 'function') {
                    ret = g(o);
                } else if (typeof (o[g]) == 'function') {
                    ret = o[g]();

                    if (ret != null) {
                        if (Object.isArray(ret)) {
                            ret = this._join(',', ret);
                        } else {
                            ret = ret.toString();
                        }
                    } else {
                        ret = '';
                    }
                }

                if (ret != null) {
                    break;
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Validation.ValidationManager.prototype._join = function (separator, values) {
    /// <summary>Joins the components of a given array with the given separator.</summary>
    /// <param name="separator"Separator.</param>
    /// <param name="values">Source array.</param>

    var ret = '';

    if (values && values.length) {
        for (var i = 0; i < values.length; i++) {
            ret += values[i];
            if (i < (values.length - 1)) {
                ret += ',';
            }
        }
    }

    return ret;
}
/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.ElementData = function (element) {
    /// <summary>Allows associating custom data with DOM elements.</summary>
    /// <param name="element">Element reference.</param>

    this._elementID = element;
    this._element = null;
    this._context = null;
}

Dynamicweb.ElementData.prototype.get_element = function () {
    /// <summary>Gets the reference to target element.</summary>

    var matches = [];

    if (!this._element) {
        if (this._elementID) {
            if (typeof (this._elementID) == 'string') {
                this._element = this.get_context().getElementById(this._elementID);
                if (!this._element && typeof ($) != 'undefined') {
                    matches = $(this.get_context().body).select(this._elementID);
                    if (matches && matches.length > 0) {
                        this._element = matches[0];
                    }
                }
            } else {
                this._element = this._elementID;
            }
        }
    }

    return this._element;
}

Dynamicweb.ElementData.prototype.get_context = function () {
    /// <summary>Gets the element context.</summary>

    if (!this._context) {
        this._context = document;
    } else if (typeof (this._context.document) != 'undefined') {
        this._context = this._context.document;
    }

    return this._context;
}

Dynamicweb.ElementData.prototype.set_context = function (value) {
    /// <summary>Sets the element context.</summary>
    /// <param name="value">Element context.</param>

    this._context = value;

}

Dynamicweb.ElementData.prototype.getValue = function (key) {
    /// <summary>Gets the value for specified key.</summary>
    /// <param name="key">Data key.</param>

    return this._attr(this._key(key));
}

Dynamicweb.ElementData.prototype.setValue = function (key, value) {
    /// <summary>Sets the value for specified key.</summary>
    /// <param name="key">Data key.</param>
    /// <param name="value">Data value.</param>

    this._attr(this._key(key), value);
}

Dynamicweb.ElementData.prototype._key = function (name) {
    /// <summary>Returns the full data key.</summary>
    /// <param name="name">Value key.</param>
    /// <private />

    var ret = '';

    if (name && name.length) {
        if (name.toLowerCase().indexOf('data-') == 0) {
            ret = name.toLowerCase();
        } else {
            ret = 'data-' + name.toLowerCase();
        }
    }

    return ret;
}

Dynamicweb.ElementData.prototype._attr = function (name, value) {
    /// <summary>Gets or sets element's attribute value.</summary>
    /// <param name="name">Attribute name.</param>
    /// <param name="value">Attribute value (leave unspecified in case of retrieving attribute value).</param>
    /// <private />

    var ret = '';
    var elm = this.get_element();

    if (elm && name && name.length) {
        if (typeof (value) == 'undefined' || value == null) {
            if (elm.readAttribute) {
                ret = elm.readAttribute(name);
            } else if (elm.getAttribute) {
                ret = elm.getAttribute(name);
            }
        } else {
            if (typeof (value) != 'string') {
                if (typeof (value.toString) == 'function') {
                    value = value.toString();
                } else {
                    value = '';
                }
            }

            if (elm.writeAttribute) {
                elm.writeAttribute(name, value);
            } else if (elm.setAttribute) {
                elm.setAttribute(name, value);
            }
        }
    }

    if (ret == null) {
        ret = '';
    }

    return ret;
}

Dynamicweb.Observable = function (target) {
    /// <summary>Establishes a proxy on top of the given object that allows getting notifications whenever object property is changed.</summary>
    /// <param name="target">Target object.</param>

    this._target = target;
    this._initialized = false;

    this._propertyChanged = [];
    this._methodCalled = [];

    this.initialize();
}

Dynamicweb.Observable.prototype.get_target = function () {
    /// <summary>Gets the target object.</summary>

    return this._target;
}

Dynamicweb.Observable.prototype.set_target = function (value) {
    /// <summary>Sets the target object.</summary>
    /// <param name="value">Target object.</param>

    this._target = value;
    this._initialized = false;

    this.initialize();
}

Dynamicweb.Observable.prototype.add_propertyChanged = function (callback) {
    /// <summary>Register a new callback that is fired whenever property of the target object is changed.</summary>
    /// <param name="callback">Callback to fire.</param>

    if (callback && typeof (callback) == 'function') {
        this._propertyChanged[this._propertyChanged.length] = callback;
    }
}

Dynamicweb.Observable.prototype.add_methodCalled = function (callback) {
    /// <summary>Register a new callback that is fired whenever method of the target object is called.</summary>
    /// <param name="callback">Callback to fire.</param>

    if (callback && typeof (callback) == 'function') {
        this._methodCalled[this._methodCalled.length] = callback;
    }
}

Dynamicweb.Observable.prototype.notifyPropertyChanged = function (name, value) {
    /// <summary>Notifies subscribers that the given property has been changed.</summary>
    /// <param name="name">Name of the property.</param>
    /// <param name="value">Property value.</param>
    
    if (name && name.length) {
        for (var i = 0; i < this._propertyChanged.length; i++) {
            this._propertyChanged[i](this, { name: name, value: value, target: this.get_target() });
        }
    }
}

Dynamicweb.Observable.prototype.notifyMethodCalled = function (name, parameters) {
    /// <summary>Notifies subscribers that the given method has been called.</summary>
    /// <param name="name">Name of the property.</param>
    /// <param name="parameters">Method parameters.</param>

    if (name && name.length) {
        for (var i = 0; i < this._methodCalled.length; i++) {
            this._methodCalled[i](this, { name: name, parameters: parameters, target: this.get_target() });
        }
    }
}

Dynamicweb.Observable.prototype.initialize = function () {
    /// <summary>Initializes the object.</summary>

    var name = '';
    var self = this;
    var backingMethod = '';

    if (!this._initialized) {
        if (this.get_target()) {
            for (var prop in this.get_target()) {
                if (prop) {
                    name = prop.toString().toLowerCase();
                    backingMethod = 'backing_' + prop.toString().toLowerCase();

                    if (name.indexOf('set_') == 0 && typeof (this.get_target()[prop]) == 'function') {
                        (function (p, m) {
                            self.get_target()[m] = self.get_target()[p];
                            self.get_target()[p] = function () {
                                var args = Array.prototype.slice.call(arguments);

                                self.get_target()[m].apply(self.get_target(), args);
                                self.notifyPropertyChanged(p.toString().substr(4), args[0]);
                            }
                        })(prop, backingMethod);
                    } else if (typeof (this.get_target()[prop]) == 'function') {
                        (function (p, m) {
                            self.get_target()[m] = self.get_target()[p];
                            self.get_target()[p] = function () {
                                var methodResult = null;
                                var args = Array.prototype.slice.call(arguments);

                                methodResult = self.get_target()[m].apply(self.get_target(), args);
                                self.notifyMethodCalled(p.toString(), args);

                                return methodResult;
                            }
                        })(prop, backingMethod);
                    }
                }
            }
        }

        this._initialized = true;
    }
}

Dynamicweb.UIBinder = function (target) {
    /// <summary>Allows binding the object properties to UI elements.</summary>
    /// <param name="target">Target object.</param>

    this._target = target;
    this._initialized = false;
    this._observable = null;
    this._actions = [];

    this.initialize();
}

Dynamicweb.UIBinder.prototype.get_target = function () {
    /// <summary>Gets the target object.</summary>

    return this._target;
}

Dynamicweb.UIBinder.prototype.set_target = function (value) {
    /// <summary>Sets the target object.</summary>
    /// <param name="value">Target object.</param>

    this._target = value;
    this._initialized = false;

    this.initialize();
}

Dynamicweb.UIBinder.prototype.bindProperty = function (propertyName, actions) {
    /// <summary>Binds specified property to one or more UI actions. Specified actions will be triggered whenever property value changes.</summary>
    /// <param name="propertyName">Property name.</param>
    /// <param name="actions">An array of actions to trigger. Each element must contain an "action" property pointing to an action as well as an "elements" property pointing to an array of UI elements that the given action is applied to.</param>

    if (propertyName && propertyName.length && typeof (actions) != 'undefined' && actions.length) {
        this._actions['set_' + propertyName] = actions;
    }
}

Dynamicweb.UIBinder.prototype.bindMethod = function (methodName, actions) {
    /// <summary>Binds specified method to one or more UI actions. Specified actions will be triggered whenever method is called.</summary>
    /// <param name="methodName">Method name.</param>
    /// <param name="actions">An array of actions to trigger. Each element must contain an "action" property pointing to an action as well as an "elements" property pointing to an array of UI elements that the given action is applied to.</param>

    if (methodName && methodName.length && typeof (actions) != 'undefined') {
        if (typeof (actions.length) == 'undefined') {
            actions = [actions];
        }

        if (actions.length) {
            this._actions[methodName] = actions;
        }
    }
}

Dynamicweb.UIBinder.prototype.initialize = function () {
    /// <summary>Initializes the object.</summary>

    var self = this;

    if (!this._initialized) {
        this._observable = new Dynamicweb.Observable(this.get_target());
        
        this._observable.add_propertyChanged(function (sender, args) {
            self._onPropertyChanged(sender, args);
        });

        this._observable.add_methodCalled(function (sender, args) {
            self._onMethodCalled(sender, args);
        });

        this._initialized = true;
    }
}

Dynamicweb.UIBinder.prototype._onPropertyChanged = function (sender, args) {
    /// <summary>Handles Observable "propertyChanged" event.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>
    /// <private />

    var n = '';
    var act = null;
    var actions = null;
    var elements = null;

    if (args && args.name) {
        n = args.name;
        actions = this._actions['set_' + n];

        if (actions && actions.length) {
            for (var i = 0; i < actions.length; i++) {
                act = actions[i].action;
                elements = actions[i].elements;

                if (typeof (act) == 'function') {
                    act(this, { elements: elements, name: n, value: args.value, target: args.target });
                } else if (typeof (act.invoke) == 'function') {
                    act.invoke(this, { elements: elements, name: n, value: args.value, target: args.target });
                }
            }
        }
    }
}

Dynamicweb.UIBinder.prototype._onMethodCalled = function (sender, args) {
    /// <summary>Handles Observable "methodCalled" event.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>
    /// <private />

    var n = '';
    var act = null;
    var actions = null;
    var elements = null;

    if (args && args.name) {
        n = args.name;
        actions = this._actions[n];

        if (actions && actions.length) {
            for (var i = 0; i < actions.length; i++) {
                act = actions[i].action;
                elements = actions[i].elements;

                if (typeof (act) == 'function') {
                    act(this, { elements: elements, name: n, parameters: args.parameters, target: args.target });
                } else if (typeof (act.invoke) == 'function') {
                    act.invoke(this, { elements: elements, name: n, parameters: args.parameters, target: args.target });
                }
            }
        }
    }
}

Dynamicweb.UIBinder.error = function (message) {
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

Dynamicweb.UIBinder.Actions = function () {
    /// <summary>Represents standard actions.</summary>
}

Dynamicweb.UIBinder.Helpers = function () {
    /// <summary>Provides a set of helper methods.</summary>
}

Dynamicweb.UIBinder.Helpers.isTrue = function (value) {
    /// <summary>Determines whether specified value can be interpreted as boolean "true".</summary>
    /// <param name="value">Value to process.</param>

    var ret = false;

    if (typeof (value) != 'undefined' && value != null) {
        ret = (value === 1 || value === true);

        if (!ret) {
            if (typeof (value) == 'string') {
                ret = value.toLowerCase() == '1' ||
                            value.toLowerCase() == 'true';

                if (!ret) {
                    ret = value.length > 0;
                }
            } else {
                ret = !!value;
            }
        }
    }

    return ret;
}

Dynamicweb.UIBinder.Actions.ToggleClass = function (className, invert) {
    /// <summary>Toggles specified class on an element depending on the boolean value of the property.</summary>
    /// <param name="className">Class name to toggle.</param>
    /// <param name="invert">Indicates whether to invert the meaning the property value.</param>

    this._className = className;
    this._invert = !!invert;
}

Dynamicweb.UIBinder.Actions.ToggleClass.prototype.invoke = function (sender, args) {
    /// <summary>Invokes the action.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>

    var addClass = false;

    if (this._className && this._className.length) {
        if (args && args.elements && args.elements.length) {
            addClass = Dynamicweb.UIBinder.Helpers.isTrue(args.value);

            if (this._invert) {
                addClass = !addClass;
            }

            for (var i = 0; i < args.elements.length; i++) {
                if (addClass) {
                    $(args.elements[i]).addClassName(this._className);
                } else {
                    $(args.elements[i]).removeClassName(this._className);
                }
            }
        }
    }
}

Dynamicweb.UIBinder.Actions.ToggleVisibility = function (invert) {
    /// <summary>Toggles visibility an element depending on the boolean value of the property.</summary>
    /// <param name="invert">Indicates whether to invert the meaning the property value.</param>

    this._invert = !!invert;
}

Dynamicweb.UIBinder.Actions.ToggleVisibility.prototype.invoke = function (sender, args) {
    /// <summary>Invokes the action.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>

    var isVisible = false;

    if (args && args.elements && args.elements.length) {
        isVisible = Dynamicweb.UIBinder.Helpers.isTrue(args.value);

        if (this._invert) {
            isVisible = !isVisible;
        }

        for (var i = 0; i < args.elements.length; i++) {
            if (isVisible) {
                $(args.elements[i]).show();
            } else {
                $(args.elements[i]).hide();
            }
        }
    }
}

Dynamicweb.UIBinder.Actions.ToggleEffect = function (trueEffect, falseEffect, invert) {
    /// <summary>Toggles specified Scriptaculous effect on an element depending on the boolean value of the property.</summary>
    /// <param name="trueEffect">Name of the effect to apply when the value of the property is "true".</param>
    /// <param name="falseEffect">Name of the effect to apply when the value of the property is "false".</param>
    /// <param name="invert">Indicates whether to invert the meaning the property value.</param>

    this._trueEffect = trueEffect;
    this._falseEffect = falseEffect;
    this._invert = !!invert;

    this._effectMap = [
        { whenTrue: 'Appear', whenFalse: 'Fade' },
        { whenTrue: 'BlindDown', whenFalse: 'BlindUp' },
        { whenTrue: 'SlideDown', whenFalse: 'SlideUp' },
        { whenTrue: 'Grow', whenFalse: 'Shrink' }
    ];
}

Dynamicweb.UIBinder.Actions.ToggleEffect.prototype.invoke = function (sender, args) {
    /// <summary>Invokes the action.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>

    var obj = null;
    var isTrue = false;

    if (args && args.elements && args.elements.length) {
        if (this._trueEffect && this._trueEffect.length) {
            if (!this._falseEffect || !this._falseEffect.length) {

                /* Normal effect lookup */
                for (var i = 0; i < this._effectMap.length; i++) {
                    if (this._effectMap[i].whenTrue.toLowerCase() == this._trueEffect.toLowerCase()) {
                        this._trueEffect = this._effectMap[i].whenTrue;
                        this._falseEffect = this._effectMap[i].whenFalse;

                        break;
                    }
                }

                /* Reverse effect lookup */
                if (!this._falseEffect || !this._falseEffect.length) {
                    for (var i = 0; i < this._effectMap.length; i++) {
                        if (this._effectMap[i].whenFalse.toLowerCase() == this._trueEffect.toLowerCase()) {
                            this._trueEffect = this._effectMap[i].whenTrue;
                            this._falseEffect = this._effectMap[i].whenFalse;

                            break;
                        }
                    }
                }
            }

            if (this._falseEffect && this._falseEffect.length) {
                if (typeof (Effect) != 'undefined') {
                    obj = Effect;
                }

                if (obj && typeof (obj[this._trueEffect]) == 'function' && typeof (obj[this._falseEffect]) == 'function') {
                    isTrue = Dynamicweb.UIBinder.Helpers.isTrue(args.value);

                    if (this._invert) {
                        isTrue = !isTrue;
                    }

                    for (var i = 0; i < args.elements.length; i++) {
                        if (isTrue) {
                            obj[this._trueEffect](args.elements[i]);
                        } else {
                            obj[this._falseEffect](args.elements[i]);
                        }
                    }
                }
            }
        }
    }
}

Dynamicweb.UIBinder.Actions.ToggleStyle = function (trueStyle, falseStyle, invert) {
    /// <summary>Toggles styles on an element depending on the boolean value of the property.</summary>
    /// <param name="trueStyle">Styles to apply when the value of the property is "true".</param>
    /// <param name="falseStyle">Styles to apply when the value of the property is "false".</param>
    /// <param name="invert">Indicates whether to invert the meaning the property value.</param>

    this._trueStyle = trueStyle;
    this._falseStyle = falseStyle;
    this._invert = !!invert;
}

Dynamicweb.UIBinder.Actions.ToggleStyle.prototype.invoke = function (sender, args) {
    /// <summary>Invokes the action.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>

    var isTrue = false;

    if (args && args.elements && args.elements.length) {
        isTrue = Dynamicweb.UIBinder.Helpers.isTrue(args.value);

        if (this._invert) {
            isTrue = !isTrue;
        }

        for (var i = 0; i < args.elements.length; i++) {
            if (isTrue) {
                if (typeof (this._trueStyle) != 'undefined') {
                    $(args.elements[i]).setStyle(this._trueStyle);
                }
            } else {
                if (typeof (this._falseStyle) != 'undefined') {
                    $(args.elements[i]).setStyle(this._falseStyle);
                }
            }
        }
    }
}

Dynamicweb.UIBinder.Actions.ToggleToolbarEnabled = function (invert) {
    /// <summary>Toggles the "Enabled" state of the specified Toolbar buttons.</summary>
    /// <param name="invert">Indicates whether to invert the meaning the property value.</param>

    this._invert = !!invert;
}

Dynamicweb.UIBinder.Actions.ToggleToolbarEnabled.prototype.invoke = function (sender, args) {
    /// <summary>Invokes the action.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>

    var instance = null;
    var isEnabled = false;
    var isEnabled = false;

    if (typeof (Toolbar) != 'undefined') {
        instance = Toolbar;
    } else if (typeof (parent.Toolbar) != 'undefined') {
        instance = parent.Toolbar;
    }

    if (instance && args && args.elements && args.elements.length) {
        isEnabled = Dynamicweb.UIBinder.Helpers.isTrue(args.value);

        if (this._invert) {
            isEnabled = !isEnabled;
        }

        for (var i = 0; i < args.elements.length; i++) {
            instance.setButtonIsDisabled(args.elements[i], !isEnabled);
        }
    }
}

Dynamicweb.UIBinder.Actions.ToggleRibbonEnabled = function (invert) {
    /// <summary>Toggles the "Enabled" state of the specified Ribbon buttons.</summary>
    /// <param name="invert">Indicates whether to invert the meaning the property value.</param>

    this._invert = !!invert;
}

Dynamicweb.UIBinder.Actions.ToggleRibbonEnabled.prototype.invoke = function (sender, args) {
    /// <summary>Invokes the action.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>

    var data = null;
    var instance = null;
    var context = window;
    var isEnabled = false;
    var wasEnabled = true;

    if (typeof (Ribbon) != 'undefined') {
        instance = Ribbon;
    } else if (typeof (parent.Ribbon) != 'undefined') {
        instance = parent.Ribbon;
        context = parent;
    }

    if (instance && args && args.elements && args.elements.length) {
        isEnabled = Dynamicweb.UIBinder.Helpers.isTrue(args.value);

        if (this._invert) {
            isEnabled = !isEnabled;
        }
        
        for (var i = 0; i < args.elements.length; i++) {
            data = new Dynamicweb.ElementData(args.elements[i]);
            data.set_context(context);

            if (isEnabled) {
                wasEnabled = data.getValue('ui-enabled').toLowerCase() == 'true';

                if (wasEnabled) {
                    instance.enableButton(args.elements[i]);
                }
            } else {
                data.setValue('ui-enabled', instance.buttonIsEnabled(args.elements[i]));
                instance.disableButton(args.elements[i]);
            }
        }
    }
}

Dynamicweb.UIBinder.Actions.ToggleRibbonChecked = function (invert) {
    /// <summary>Toggles the "Checked" state of the specified Ribbon buttons.</summary>
    /// <param name="invert">Indicates whether to invert the meaning the property value.</param>

    this._invert = !!invert;
}

Dynamicweb.UIBinder.Actions.ToggleRibbonChecked.prototype.invoke = function (sender, args) {
    /// <summary>Invokes the action.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>

    var instance = null;
    var isEnabled = false;

    if (typeof (Ribbon) != 'undefined') {
        instance = Ribbon;
    } else if (typeof (parent.Ribbon) != 'undefined') {
        instance = parent.Ribbon;
    }

    if (instance && args && args.elements && args.elements.length) {
        isEnabled = Dynamicweb.UIBinder.Helpers.isTrue(args.value);

        if (this._invert) {
            isEnabled = !isEnabled;
        }

        for (var i = 0; i < args.elements.length; i++) {
            if ((isEnabled && !instance.isChecked(args.elements[i])) ||
            (!isEnabled && instance.isChecked(args.elements[i]))) {

                instance.checkBox(args.elements[i]);
            }
        }
    }
}

Dynamicweb.UIBinder.Actions.Effect = function (effect) {
    /// <summary>Executes the given effect whenever the value of the object property changes.</summary>
    /// <param name="effect">Name of the effect.</param>

    this._effect = effect;
}

Dynamicweb.UIBinder.Actions.Effect.prototype.invoke = function (sender, args) {
    /// <summary>Invokes the action.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>

    var obj = null;

    if (args && args.elements && args.elements.length) {
        if (typeof (Effect) != 'undefined') {
            obj = Effect;
        }

        if (typeof (obj[this._effect]) == 'function') {
            for (var i = 0; i < args.elements.length; i++) {
                obj[this._effect](args.elements[i]);
            }
        }
    }
}
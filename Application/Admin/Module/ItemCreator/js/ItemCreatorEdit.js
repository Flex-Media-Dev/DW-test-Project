if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = {};
}

if (typeof (Dynamicweb.Items) == 'undefined') {
    Dynamicweb.Items = {};
}

Dynamicweb.Items.ParagraphSettings = Class.create({
    initialize: function(params) {
        var self = this, parameters, methods, controls, validators, modelHandlers, eventHandlers, eventRouter;

        if (!params || !params.areaId || !params.pageId || !params.paragraphId) {
            throw 'Invalid initialization parameters!';
        }

        parameters = { areaId: params.areaId, pageId: params.pageId, paragraphId: params.paragraphId, translations: params.translations || {} };

        methods = {
            fillDropdown: function (control, elements) {
                var option,
                    prop,
                    add = function (v, t) {
                        option = document.createElement('option');
                        option.innerHTML = t;
                        option.value = v;
                        control.options.add(option);
                    };

                control.options.length = 0;
                add('', self.get_translation('NothingSelected'));

                if (Array.isArray(elements)) {
                    elements.each(function (val) {
                        add(val, val);
                    });
                } else if (typeof (elements) === 'object') {
                    for (prop in elements) {
                        if (elements[prop] && elements.hasOwnProperty(prop)) {
                            add(prop, elements[prop]);
                        }
                    }
                }
            },
            request: function (options) {
                var params, data;

                if (!options) {
                    throw 'Parameters are required!';
                }

                if (!options.action) {
                    throw 'Action name is required!';
                }

                options.data = options.data || {};
                options.data.AreaId = parameters.areaId;
                options.data.PageId = parameters.pageId;
                options.data.Id = parameters.paragraphId;

                new Ajax.Request('/Admin/Module/ItemCreator/ItemCreator_Edit.aspx', {
                    method: 'POST',
                    parameters: {
                        AjaxAction: options.action,
                        AjaxData: JSON.stringify(options.data)
                    },
                    onCreate: function () {
                        if (controls.showOverlay() && controls.overlay) {
                            controls.overlay.show();
                        }
                    },
                    onSuccess: function (transport) {
                        var json;

                        if (transport.responseText.isJSON()) {
                            json = transport.responseText.evalJSON();
                        }

                        if (options.callback) {
                            options.callback(transport.responseText, json);
                        }
                    },
                    onFailure: function () {
                        alert(self.get_translation('Error'));
                    },
                    onComplete: function () {
                        if (controls.showOverlay() && controls.overlay) {
                            setTimeout(function () {
                                controls.overlay.hide();
                            }, 500);
                        }
                    }
                });
            },
            getAllowedItems: function (callback) {
                methods.request({
                    action: 'GetAllowedItemTypes',
                    data: {                        
                        ItemType: controls.itemList.value(),
                        ContentStructure: controls.contentStructure.value(),
                        TargetPageAreaId: parameters.areaId,
                        TargetPageId: document.getElementById('TargetPageID').value || parameters.pageId,
                        TargetPagePlaceholder: controls.targetPagePlaceholder.value()
                    },
                    callback: function (response, json) {
                        if (!json) {
                            alert(parameters.get_translation('Error'));
                        }

                        if (json.Error) {
                            alert(json.Error);
                        }

                        if (callback) {
                            callback(json.Result);
                        }
                    }
                });


            },
            getItemFields: function (callback) {
                methods.request({
                    action: 'GetItemFields',
                    data: {
                        ItemType: controls.itemList.value()
                    },
                    callback: function (response, json) {
                        if (!json) {
                            alert(parameters.get_translation('Error'));
                        }

                        if (json.Error) {
                            alert(json.Error);
                        }

                        if (callback) {
                            callback(json.Result);
                        }
                    }
                });
            },
            getPlaceHolders: function (callback) {
                var targetPageId = document.getElementById('TargetPageID').value || parameters.pageId;

                methods.request({
                    action: 'GetPagePlaceholders',
                    data: {
                        TargetPageId: targetPageId
                    },
                    callback: function (response, json) {
                        if (!json) {
                            alert(parameters.get_translation('Error'));
                        }

                        if (json.Error) {
                            alert(json.Error);
                        }

                        if (callback) {
                            callback(json.Result);
                        }
                    }
                });
            },
            getNamedLists: function (callback) {

                var targetPageId = document.getElementById('TargetPageID').value || parameters.pageId;

                methods.request({
                    action: 'GetNamedLists',
                    data: {
                        TargetPageId: targetPageId,
                        ItemType: controls.itemList.value()
                    },
                    callback: function (response, json) {
                        if (!json) {
                            alert(parameters.get_translation('Error'));
                        }

                        if (json.Error) {
                            alert(json.Error);
                        }

                        if (callback) {
                            callback(json.Result);
                        }
                    }
                });
            }
        };

        controls = {
            itemList: {
                el: $('ItemType'),
                value: function (val) {
                    if (typeof(val) !== 'undefined') {
                        this.el.value = val;
                    }

                    return this.el.value;
                },
                find: function (val) {
                    return this.el.select('option[value="' + val + '"]')[0];
                },
                options: function (opt) {
                    if (typeof (opt) !== 'undefined') {
                        methods.fillDropdown(this.el, opt);
                    }

                    return this;
                },
                validation: function (doValidation) {
                    var index, that = this;
                    if (validators || validators.manager) {
                        index = -1;
                        validators.manager.get_validators().forEach(function (e, i) {
                            if (e._target === that.el.identify()) {
                                index = i;
                            }
                        });

                        if (doValidation) {
                            if (index === -1) {
                                validators.manager.get_validators().push(validators.itemListValidator);
                            }
                        } else {
                            if (index >= 0) {
                                validators.manager.get_validators().splice(index, 1);
                            }
                        }
                    }

                    return this;
                }
            },
            // el: represents an array of all MailProvider ItemField selectors
            // options: sets options for each ItemField selector
            mailProviderItemFieldLists: {
                el: $$('.MailProviderItemFieldList'),
                setOptions: function (opt) {
                    if (typeof (opt) !== 'undefined') {
                        this.el.forEach(function (element) { methods.fillDropdown(element, opt) });
                    } else {
                        this.el.forEach(function (element) { methods.fillDropdown(element, {'': ''}) });
                    }
                },
            },
            mailSaveProviderItemType: {
                el: $('MailSaveProvider.ItemType'),
                value: function (val) {
                    if (typeof (val) !== 'undefined') {
                        this.el.value = val;
                    }

                    return this.el.value;
                },
            },
            mailReceiptSaveProviderItemType: {
                el: $('MailReceiptSaveProvider.ItemType'),
                value: function (val) {
                    if (typeof (val) !== 'undefined') {
                        this.el.value = val;
                    }

                    return this.el.value;
                },
            },
            targetPagePlaceholder: {
                el: $('TargetPagePlaceholder'),
                value: function(val) {
                    if (typeof(val) !== 'undefined') {
                        this.el.value = val;
                    }

                    return this.el.value;
                },
                find: function (val) {
                    return this.el.select('option[value="' + val + '"]')[0];
                },
                options: function(opt) {
                    if (typeof(opt) !== 'undefined') {
                        methods.fillDropdown(this.el, opt);
                    }

                    return this.el.options;
                },
                validation: function (doValidation) {
                    var index, that = this;
                    if (validators || validators.manager) {
                        index = -1;
                        validators.manager.get_validators().forEach(function (e, i) {
                            if (e._target === that.el.identify()) {
                                index = i;
                            }
                        });

                        if (doValidation) {
                            if (index === -1) {
                                validators.manager.get_validators().push(validators.targetPagePlaceholderValidator);
                            }
                        } else {
                            if (index >= 0) {
                                validators.manager.get_validators().splice(index, 1);
                            }
                        }
                    }

                    return this;
                }
            },
            targetNamedList:{
                el: $('TargetNamedList'),
                options: function (opt) {
                    if (typeof (opt) !== 'undefined') {
                        methods.fillDropdown(this.el, opt);
                    }

                    return this.el.options;
                },
                validation: function (doValidation) {
                    var index, that = this;
                    if (validators || validators.manager) {
                        index = -1;
                        validators.manager.get_validators().forEach(function (e, i) {
                            if (e._target === that.el.identify()) {
                                index = i;
                            }
                        });

                        if (doValidation) {
                            if (index === -1) {
                                validators.manager.get_validators().push(validators.targetNamedListValidator);
                            }
                        } else {
                            if (index >= 0) {
                                validators.manager.get_validators().splice(index, 1);
                            }
                        }
                    }

                    return this;
                }
            },
            contentStructure: {
                el: $$('input[name="ContentStructure"]'),
                value: function() {
                    return this.el.find(function(c) { return c.checked; }).value;
                }
            },
            contentCreationStatus: {
                el: $$('input[name="ContentCreationStatus"]'),
                optionUnpublished: $$('input[name="ContentCreationStatus"][value="1"]')[0],
                optionHidden: $$('input[name="ContentCreationStatus"][value="2"]')[0],
                value: function (val) {
                    if (typeof(val) !== 'undefined') {
                        this.el.each(function (c) { c.checked = false; });
                        this.el.find(function (c) { return c.value === val; }).checked = true;
                    }

                    return this.el.find(function (c) { return c.checked; }).value;
                }
            },
            providers: function() {
                var el = $('Providers');
                
                return {                    
                    el: el,
                    array: el.value.split(';'),
                    value: function (val) {
                    
                        if (typeof(val) !== 'undefined') {
                            this.el.value = val;
                        }

                        return this.el.value;
                    }
                };
            }(),
            overlay: new overlay('ParagraphEditModuleOverlay'),
            showOverlay: function () { return window.opener != null; },
            btnSave: {
                el: (function () {
                    var ret = null;
                    if (parent) {
                        ret = parent.document.getElementById('cmdSave');
                        if (!ret) {
                            ret = parent.document.getElementById('Save');
                        }
                    }

                    return ret;
                })()
            },
            btnSaveAndClose: {
                el: (function () {
                    var ret = null;
                    if (parent) {
                        ret = parent.document.getElementById('cmdSaveAndClose');
                        if (!ret) {
                            ret = parent.document.getElementById('SaveAndClose');
                        }
                    }

                    return ret;
                })()
            },
        };

        validators = {
            manager: new Dynamicweb.Validation.ValidationManager(),
            targetPagePlaceholderValidator: function () {
                var el, message, id;
                el = controls.targetPagePlaceholder.el;
                message = el.readAttribute('data-validation-message');
                id = el.identify();

                return new Dynamicweb.Validation.RequiredFieldValidator(id, message);
            }(),
            targetNamedListValidator: function () {
                var el, message, id;
                el = controls.targetNamedList.el;
                message = el.readAttribute('data-validation-message');
                id = el.identify();

                return new Dynamicweb.Validation.RequiredFieldValidator(id, message);
            }(),
            itemListValidator: function () {
                var el, message, id;
                el = controls.itemList.el;
                message = el.readAttribute('data-validation-message');
                id = el.identify();

                return new Dynamicweb.Validation.RequiredFieldValidator(id, message);
            }(),
            checkItemRestrictions: function (callback) {
                if (controls.itemList.value() !== '') {
                    methods.getAllowedItems(function (result) {
                        var isValid = true;

                        if (!result[controls.itemList.value()]) {
                            isValid = false;
                        }

                        if (callback) {
                            callback({ isValid: isValid });
                        }
                    });
                } else {
                    if (callback) {
                        callback({ isValid: true });
                    }
                }
            },
            checkForm: function (callback) {
                this.manager.beginValidate(callback);
            }
        };

        $$('[data-validation]').each(function (el) {
            var message = el.readAttribute('data-validation-message');

            if (el.hasAttribute('data-validation-required')) {
                validators.manager.addValidator(new Dynamicweb.Validation.RequiredFieldValidator(el.identify(), message));
            }

            if (el.hasAttribute('data-validation-minLength') || el.hasAttribute('data-validation-maxLength')) {
                validators.manager.addValidator(new Dynamicweb.Validation.LengthValidator(el.identify(), message, el.readAttribute('data-validation-minLength'), el.readAttribute('data-validation-maxLength'), true));
            }
        });

        // paragraphs
        if (controls.contentStructure.value() === '1') {
            controls.targetPagePlaceholder.validation(true);
        }

        document.getElementById('TargetPageID').value = params.targetPage.id;
        document.getElementById('TargetPageIDText').value = params.targetPage.title;

        document.getElementById('ConfirmPageID').value = params.confirmPage.id;
        document.getElementById('ConfirmPageIDText').value = params.confirmPage.title;
        
        eventHandlers = {
            onSave: function (callback) {
                return function () {
                    validators.checkForm(function (result) {
                        if (result.isValid) {
                            controls.providers.value(controls.providers.array.join(';'));

                            if (result.isValid && callback) {
                                validators.checkItemRestrictions(function (result) {
                                    if (result.isValid && callback) {
                                        callback();
                                    }
                                });
                            }
                        }

                    });
                };
            },
            onItemTypeChange: function () {
                //update fields if item type changed
                var updateFields = function () {
                    controls.mailProviderItemFieldLists.el.forEach(function (element) {
                        var mainControl = $(element.name.substring(0, element.name.length - 'ItemField'.length))
                        mainControl.removeAttribute('readOnly');
                        mainControl.setStyle({
                            backgroundColor: 'white'
                        });
                    })
                };
                if (controls.itemList.value() !== '') {
                    methods.getItemFields(function (result) {
                        controls.mailProviderItemFieldLists.setOptions(result);
                        controls.mailSaveProviderItemType.value(controls.itemList.value());
                        controls.mailReceiptSaveProviderItemType.value(controls.itemList.value());
                        updateFields();
                    });
                } else {
                    controls.mailProviderItemFieldLists.setOptions();
                    controls.mailSaveProviderItemType.value('');
                    controls.mailReceiptSaveProviderItemType.value('');
                    updateFields();
                }
            },
            // action on changing ItemField for MailProviders
            onMailProviderItemFieldChange: function () {
                controls.mailProviderItemFieldLists.el.forEach(function (element) {
                    var mainControl = $(element.name.substring(0, element.name.length - 'ItemField'.length))
                    if (element.selectedIndex > 0) {
                        mainControl.setAttribute('readOnly', 'readOnly');
                        mainControl.setStyle({
                            backgroundColor: '#EBEBE4'
                        });
                    } else {
                        mainControl.removeAttribute('readOnly');
                        mainControl.setStyle({
                            backgroundColor: 'white'
                        });
                    }
                })
            },
            onStructureTypeChange: function () {
                var val = controls.contentStructure.value();
                methods.getAllowedItems(function (result) {
                    var val, option;
                    val = controls.itemList.value()
                    controls.itemList.options(result);

                    // restore previous value
                    if (result[val]) {
                        controls.itemList.value(val);
                    } else {
                        eventHandlers.onItemTypeChange();
                    }
                });


                if (val === '0') {
                    controls.targetPagePlaceholder.validation(false);
                    controls.targetPagePlaceholder.el.up('tr').hide();
                    controls.targetNamedList.validation(false);
                    controls.targetNamedList.el.up('tr').hide();
                    controls.itemList.validation(true);
                    controls.itemList.el.up('tr').show();
                    controls.contentCreationStatus.optionUnpublished.up('tr').show();
                    controls.contentCreationStatus.optionHidden.up('tr').show();
                } else if (val === '1') {
                    controls.targetPagePlaceholder.validation(true);
                    controls.targetPagePlaceholder.el.up('tr').show();
                    controls.targetNamedList.validation(false);
                    controls.targetNamedList.el.up('tr').hide();
                    controls.itemList.validation(true);
                    controls.itemList.el.up('tr').show();
                    controls.contentCreationStatus.optionUnpublished.up('tr').show();
                    controls.contentCreationStatus.optionHidden.up('tr').hide();

                    if (controls.contentCreationStatus.value() === '2') {
                        controls.contentCreationStatus.value('1');
                    }
                } else if (val === '2') {
                    controls.targetPagePlaceholder.validation(false);
                    controls.targetPagePlaceholder.el.up('tr').hide();
                    controls.targetNamedList.validation(true);
                    controls.targetNamedList.el.up('tr').show();
                    controls.itemList.validation(false);
                    controls.itemList.el.up('tr').hide();
                    controls.contentCreationStatus.optionUnpublished.up('tr').hide();
                    controls.contentCreationStatus.optionHidden.up('tr').hide();

                    controls.contentCreationStatus.value('0');
                    methods.getNamedLists(function (result) {
                        controls.targetNamedList.options(result);
                    });
                }

            },
            onProviderChange: function (model) {
                var control = this;
                if (!model) {
                    if (control.checked) {
                        if (!controls.providers.array.any(function (v) { return v === control.value; })) {
                            controls.providers.array.push(control.value);
                        }
                    } else {
                        controls.providers.array = controls.providers.array.reject(function (v) { return v === control.value; });
                    }
                } else {
                    if (model.checked) {
                        control.show();
                    } else {
                        control.hide();
                    }
                }
            },
            onTargetPageChange: function () {
                methods.getAllowedItems(function (result) {
                    var val = controls.itemList.value();
                    controls.itemList.options(result);

                    // restore previous value
                    if (result[val]) {
                        controls.itemList.value(val);
                    } else {
                        eventHandlers.onItemTypeChange();
                    }
                });

                methods.getPlaceHolders(function (result) {
                    controls.targetPagePlaceholder.options(result);
                });
                if (controls.contentStructure.value() === '2') {
                    methods.getNamedLists(function (result) {
                        controls.targetNamedList.options(result);
                    });
                }
            },
            onTargetPlaceholderChange: function () {
                methods.getAllowedItems(function (result) {
                    var val = controls.itemList.value();
                    controls.itemList.options(result);

                    // restore previous value
                    if (result[val]) {
                        controls.itemList.value(val);
                    } else {
                        eventHandlers.onItemTypeChange();
                    }
                });
            }
        };

        eventRouter = function (event, element) {
            var id = element.identify(),
                action = eventHandlers[element.readAttribute('data-' + event.type + '-action')],
                isModel = element.hasAttribute('data-model'),
                modelId = element.readAttribute('data-model') || id;

            if (action) {
                action.apply(element);
            }

            if (isModel && modelHandlers[modelId] && modelHandlers[modelId][event.type]) {
                if (Array.isArray(modelHandlers[modelId][event.type])) {
                    modelHandlers[modelId][event.type].each(function (subscriber) {
                        if (typeof (subscriber.handler) === 'function') {
                            subscriber.handler.apply(subscriber.element, [element]);
                        }
                    });
                }
            }
        };
        
        // overrides on click event handler
        if (controls.btnSave.el) {
            controls.btnSave.el.onclick = eventHandlers.onSave(controls.btnSave.el.onclick);
        }
        
        // overrides on click event handler
        if (controls.btnSaveAndClose.el) {
            controls.btnSaveAndClose.el.onclick = eventHandlers.onSave(controls.btnSaveAndClose.el.onclick);
        }

        // defines MailProvider ItemField selectors
        if ((controls.mailSaveProviderItemType.el.value === '' || controls.mailReceiptSaveProviderItemType.el.value === '') && controls.itemList.el.selectedIndex > 0) {
            eventHandlers.onItemTypeChange();
        };
        controls.mailProviderItemFieldLists.el.forEach(function (element) {
            element.setAttribute('data-change-action', 'onMailProviderItemFieldChange');
            if (element.selectedIndex > 0) {
                var mainControl = $(element.name.substring(0, element.name.length - 'ItemField'.length))
                mainControl.setAttribute('readOnly', 'readOnly');
                mainControl.setStyle({
                    backgroundColor: '#EBEBE4'
                });
            };
        }); 

        document.on('click', '[data-click-action]', eventRouter);
        document.on('change', '[data-change-action], [data-model]', eventRouter);

        $$('[data-bind-model]').each(function (element) {
            var models = [],
                clickHandlers = [],
                changeHandlers = [],
                subscribe = function (id, eventName, handlerName) {
                    var handler;
                    if (!id || !eventName || !handlerName) {
                        return;
                    }

                    id = id.strip();
                    handlerName = handlerName.strip();

                    handler = eventHandlers[handlerName];
                    
                    if (!handler) {
                        handler = methods[handlerName];
                        
                        if (!handler) {
                            return;
                        }
                    }

                    if (!modelHandlers) {
                        modelHandlers = {};
                    }

                    if (!modelHandlers[id]) {
                        modelHandlers[id] = {};
                    }

                    if (!modelHandlers[id][eventName] || !Array.isArray(modelHandlers[id][eventName])) {
                        modelHandlers[id][eventName] = [];
                    }

                    modelHandlers[id][eventName].push({
                        element: element,
                        handler: handler
                    });
                };
            
            if (element.hasAttribute('data-bind-model')) {
                models = element.readAttribute('data-bind-model').split(',');
            }
            
            if (element.hasAttribute('data-click-model')) {
                clickHandlers = element.readAttribute('data-click-model').split(',');
            }
            
            if (element.hasAttribute('data-change-model')) {
                changeHandlers = element.readAttribute('data-change-model').split(',');
            }

            models.each(function (model, index) {
                subscribe(model, 'change', changeHandlers[index]);
                subscribe(model, 'click', clickHandlers[index]);
            });
        });

        self.onTargetPageChange = function (key) {
            eventHandlers.onItemTypeChange();
        };

        self.get_translation = function(key) {
            return parameters.translations[key] || '';
        };
    }
});

Dynamicweb.Items.ParagraphSettings._instance = null;

Dynamicweb.Items.ParagraphSettings.get_current = function () {
    return Dynamicweb.Items.ParagraphSettings._instance;
};

Dynamicweb.Items.ParagraphSettings.prototype.SelectPage = function (targetId) {
    var self = this;

    var callback = function (options, model) {
        var valueElement = document.getElementById(targetId);
        valueElement.value = model.Selected;
        document.getElementById(targetId + "Text").value = model.SelectedPageName;
        if (valueElement.onchange) {
            valueElement.onchange();
        }
    }

    var dlgAction = createLinkDialog(LinkDialogTypes.Page, [], callback);

    Action.Execute(dlgAction);
}

Dynamicweb.Items.ParagraphSettings.prototype.ClearSelectedPage = function (targetId) {
    var valueElement = document.getElementById(targetId);
    valueElement.value = '';
    document.getElementById(targetId + "Text").value = '';
    if (valueElement.onchange) {
        valueElement.onchange();
    }
}
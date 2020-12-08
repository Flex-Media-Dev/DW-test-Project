function UserAndGroupTypeEditPage(options) {
    function hasValue(el) {
        return el && !!el.value;
    }

    var pattern = /[^a-zA-Z0-9_]/;
    function containsInvalidCharacters(el) {
        return (el.value).match(pattern);
    }

    function updateFormValues(data, frm) {
        frm = frm || document.forms[0];

        for (var key in data) {
            var el = document.getElementById(key);
            if (!el) {
                var input = document.createElement("input");
                input.setAttribute("type", "hidden");
                input.name = key;
                frm.appendChild(input);
                el = input;
            }
            el.value = typeof data[key] === "object" ? JSON.stringify(data[key]) : data[key];
        }
        return frm;
    }

    var api = {
        initialize: function (options) {
            var self = this;
            self.isNew = !(options.SystemName);
            self.labels = options.Labels;
            self.actions = options.Actions;
            self.icon = options.Icon;
            self.iconColor = options.IconColor;
            self.selectIcon();

            var txtName = document.getElementById('txtName');
            var txtSystemName = document.getElementById('txtSystemName');
            if (self.isNew) {
                IdFromNameGenerator(txtSystemName, txtName);
            }
            else {
                txtSystemName.disabled = true;
            }


            Event.observe($('dlgIconSettings').select('#IconColorSelect')[0], 'change', function (e) {
            	var newColor = e.target.value;
                var iconBlocks = $('dlgIconSettings').select("div.icon-block");
                iconBlocks.forEach(function (block) {
                    var classes = block.select('i')[0].classList;
                    if (classes.length > 3 || newColor === "") {
                        classes.remove(classes[classes.length - 1]);
                    }
                    if (newColor !== "") {
                        classes.add(newColor);
                    }
                });
                self.iconColor = newColor;
            });

            var iconBlocks = $('dlgIconSettings').select("div.icon-block");
            iconBlocks.forEach(function (block) {
                Event.observe(block, 'click', function (e) {
                    $('dlgIconSettings').select('div[class="icon-block selected"]')[0].className = "icon-block";
                    this.classList.add("selected")
                    self.icon = this.select('span')[0].textContent;
                    self.selectIcon();
                });
            });

            Event.observe($('IconSearch'), 'keyup', function (e) {
                var searchText = e.target.value.toLowerCase();
                iconBlocks.forEach(function (block) {
                    if (!searchText || block.select('span')[0].textContent.toLowerCase().indexOf(searchText) > -1) {
                        block.show();
                    } else {
                        block.hide();
                    }
                });
            });
        },

        selectIcon: function () {
            var iconSelector = document.getElementById('UserAndGroupTypeIcon');
            iconSelector.className = $('dlgIconSettings').select('div[class="icon-block selected"]')[0].select('i')[0].className;
            iconSelector.title = iconSelector.className;
            iconSelector.style.display = (this.icon === "None" || !this.icon) ? "none" : "";

            dialog.hide('dlgIconSettings');
        },

        save: function (close) {
            var self = this;
            var valid = self.validateFormData(function () {
            	updateFormValues({
                    "cmd": "save",
                    "close": close,
                    "Icon": self.icon,
                    "IconColor": self.iconColor
                });
                var cmd = document.getElementById("cmdSubmit");
                cmd.click();
            });

        },

        validateFormData: function (onComplete) {
            var result = false;
            var self = this;

            dwGlobal.hideAllControlsErrors();

            var txtName = document.getElementById('txtName');
            var txtSystemName = document.getElementById('txtSystemName');

            if (!hasValue(txtName)) {
                dwGlobal.showControlErrors(txtName, self.labels.emptyName);
                txtName.focus();
            } else if (!hasValue(txtSystemName)) {
                dwGlobal.showControlErrors(txtSystemName, self.labels.emptySystemName);
                txtSystemName.focus();
            } else if (containsInvalidCharacters(txtSystemName)) {
                dwGlobal.showControlErrors(txtSystemName, self.labels.invalidIdCharacters);
                txtSystemName.focus();
            } else {
                result = true;

                if (!self.isNew) {
                    onComplete();
                }
                else {
                    var act = self.actions.checkExistingId;
                    act.OnSuccess.Function = function () {
                        onComplete();
                    };
                    act.OnFail.Function = function () {
                        dwGlobal.showControlErrors(txtSystemName, self.labels.existingSystemName);
                        txtSystemName.focus();
                    };
                    Action.Execute(act, {
                        systemName: txtSystemName.value
                    });
                }
            }

            return result;
        },

        checkAll: function (rule) {
            var act = this.actions.confirmCheckAll;
            act.OnSubmitted.Function = function () {
                var query = 'input:not([disabled])[value="' + rule + '"]';
                var buttons = document.getElementById('fieldDefinitions').querySelectorAll(query);
                for (i = 0; i < buttons.length; ++i) {
                    buttons[i].checked = true;
                }
            };
            Action.Execute(act, {
                rule: rule
            });

        },

        cancel: function () {
            location.href = 'UserAndGroupTypeList.aspx';
        }
    };

    api.initialize(options);
    return api;
}

function IdFromNameGenerator(ctrlId, ctrlName, allowOverwriteId) {
    var isGenerateAutoId = false;

    function makeSystemName(name) {
        var ret = name;

        if (ret && ret.length) {
            ret = ret.replace(/[^0-9a-zA-Z_\s]/gi, '_'); // Replacing non alphanumeric characters with underscores
            while (ret.indexOf('_') == 0) ret = ret.substr(1); // Removing leading underscores

            ret = ret.replace(/\s+/g, ' '); // Replacing multiple spaces with single ones
            ret = ret.replace(/\s([a-z])/g, function (str, g1) { return g1.toUpperCase(); }); // Camel Casing
            ret = ret.replace(/\s/g, '_'); // Removing spaces

            if (ret.length > 1) ret = ret.substr(0, 1).toUpperCase() + ret.substr(1); else ret = ret.toUpperCase();
        }

        return ret;
    }

    function checkIsIdGenerateAllowed() {
        var autoId = makeSystemName(ctrlName.value);
        return ctrlId.value == autoId
    }

    function onAfterEditId() {
        isGenerateAutoId = checkIsIdGenerateAllowed();
    }

    function onAfterEditName() {
        if (isGenerateAutoId) {
            if (ctrlName.value && ctrlName.value.length) {
                ctrlId.value = makeSystemName(ctrlName.value);
            }
        }
    }

    function initialize() {
        isGenerateAutoId = ctrlId && ctrlName && (!ctrlId.value || !ctrlId.value.length);
        if (allowOverwriteId && !isGenerateAutoId) {
            isGenerateAutoId = checkIsIdGenerateAllowed();
        }

        if (isGenerateAutoId) {
            ctrlName.addEventListener('keyup', onAfterEditName);
            ctrlId.addEventListener('blur', onAfterEditId);
        }
    }

    initialize();
}
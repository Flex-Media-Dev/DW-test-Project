
function DataGroupEditPage(options) {
    var currentRow = null;

    function hasValue(el) {
        return el && !!el.value;
    }

    var pattern = /[^a-zA-Z0-9_]/; 
    function containsInvalidCharacters(el) {
        return (el.value).match(pattern);
    }

    function updateDataItemRow(dataItemType) {
        var cells = currentRow.getElementsByTagName('td');
        cells[0].update(dataItemType.Name);
        cells[1].update(dataItemType.Id);
    }

    function addDataItemRow(dataItemType) {
        var tbl = document.getElementById('ListTable');
        cleanDataItemTable(tbl);
        var rowCount = tbl.rows.length;
        var row = tbl.insertRow(rowCount);

        row.id = dataItemType.Id;
        row.setAttribute("itemID", dataItemType.Id);
        row.setAttribute("style", "cursor:pointer;");
        row.setAttribute("class", "listRow");

        var cell = row.insertCell(-1);
        cell.update(dataItemType.Name);
        cell.setAttribute("onclick", "currentPage.editDataItem(this);");
        cell.setAttribute("style", "width: auto");

        cell = row.insertCell(-1);
        cell.update(dataItemType.Id);
        cell.setAttribute("onclick", "currentPage.editDataItem(this);");
        cell.setAttribute("style", "width: auto");

        cell = row.insertCell(-1);
        cell.update("<i class='fa fa-remove color-danger'></i>");
        cell.setAttribute("onclick", "currentPage.deleteDataItem(this);");
        cell.setAttribute("style", "width: auto");

        cell = row.insertCell(-1);
    }

    function cleanDataItemTable(tbl) {
        var rowCount = tbl.rows.length;
        if (rowCount == 2) { 
            var infoBar = tbl.rows[1].getElementsByClassName('infobar');
            if (infoBar.length > 0) {
                tbl.rows[1].style.display = "none";
            }
        }
    }

    function openWindowWithVerb(verb, url, data, target) {
        var form = document.createElement("form");
        form.action = url;
        form.method = verb;
        form.target = target || "_self";
        if (data) {
            for (var key in data) {
                var input = document.createElement("input");
                input.setAttribute("type", "hidden");
                input.name = key;
                input.value = typeof data[key] === "object" ? JSON.stringify(data[key]) : data[key];
                form.appendChild(input);
            }
        }
        form.style.display = 'none';
        document.body.appendChild(form);
        form.submit();
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
            self.originalId = options.Id;
            self.parentId = options.ParentId;
            self.dataItemTypes = options.DataItemTypes;
            self.labels = options.Labels;
            self.actions = options.Actions;
            self.icon = options.Icon;
            self.iconColor = options.IconColor;
            self.selectIcon();

            Event.observe($('dlgIconSettings').select('#IconColorSelect')[0], 'change', function (e) {
                var newColor = e.target.value;
                var iconBlocks = $('dlgIconSettings').select("div.icon-block");
                iconBlocks.forEach(function (block) {
                    var classes = block.select('i')[0].classList;
                    if (classes.length > 3) {
                        classes.remove(classes[classes.length - 1]);
                    }
                    classes.add(newColor);
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
            Event.observe($('IconSearch'), 'keyup', iconSearch);

            var iconSearch = function (e) {
                var searchText = e.target.value.toLowerCase();
                iconBlocks.forEach(function (block) {
                    if (!searchText || block.select('span')[0].textContent.toLowerCase().indexOf(searchText) > -1) {
                        block.show();
                    } else {
                        block.hide();
                    }
                });
            }

            Event.observe($('IconSearch'), 'change', iconSearch);
            Event.observe($('IconSearch'), 'keyup', iconSearch);
        },

        addDataItem: function () {
            currentRow = null;
            dialog.show("DataItemDetailsDialog", '/Admin/Content/Management/Deployment/DataItemTypeEdit.aspx');
        },

        editDataItem: function (row) {
            currentRow = row.closest('tr');
            var dataItemTypeId = currentRow.attributes['itemid'].value;

            openWindowWithVerb('POST', '/Admin/Content/Management/Deployment/DataItemTypeEdit.aspx?dataItemTypeId=' + encodeURIComponent(dataItemTypeId), { dataItemTypeRaw: this.dataItemTypes[dataItemTypeId] }, 'DataItemDetailsDialogFrame');
            dialog.show("DataItemDetailsDialog");
        },

        deleteDataItem: function (row) {
            if (confirm(this.labels.deleteMessage)) {
                var deleteRow = row.closest('tr');
                var dataItemTypeId = deleteRow.attributes['itemid'].value;
                deleteRow.parentNode.removeChild(deleteRow);
                delete this.dataItemTypes[dataItemTypeId];
            }
        },

        onDataItemEditOk: function() {
            if (this.validateDataItem()) {
                var frame = document.getElementById("DataItemDetailsDialogFrame");
                var wnd = frame.window || frame.contentWindow;

                var parameters = wnd.getParametersFromContainer(wnd.document);
                var dataItemType = {
                    Id: wnd.document.getElementById('dataItemTypeId').value,
                    Name: wnd.document.getElementById('dataItemTypeName').value,
                    Provider: wnd.document.getElementById('Dynamicweb.Deployment.DataItemProvider_AddInTypes').value,
                    Parameters: parameters
                }
                var originalId = wnd.document.getElementById('dataItemTypeOriginalId').value || wnd.document.getElementById('dataItemTypeId').value;

                if (currentRow) {
                    updateDataItemRow(dataItemType);
                }
                else {
                    addDataItemRow(dataItemType);
                }
                this.dataItemTypes[originalId] = dataItemType;

                dialog.hide("DataItemDetailsDialog");
            }
        },

        validateDataItem: function () {
            var result = false;
            var self = this;

            var frame = document.getElementById("DataItemDetailsDialogFrame");
            var wnd = frame.window || frame.contentWindow;

            dwGlobal.hideAllControlsErrors(wnd.document);

            var itemName = wnd.document.getElementById('dataItemTypeName');
            var itemId = wnd.document.getElementById('dataItemTypeId');
            var provider = wnd.document.getElementById('Dynamicweb.Deployment.DataItemProvider_AddInTypes');

            if (!hasValue(itemName)) {
                dwGlobal.showControlErrors(itemName, self.labels.emptyName);
                itemName.focus();
            } else if (!hasValue(itemId)) {
                dwGlobal.showControlErrors(itemId, self.labels.emptyId);
                itemId.focus();
            } else if (containsInvalidCharacters(itemId)) {
                dwGlobal.showControlErrors(itemId, self.labels.invalidIdCharacters);
                itemId.focus();
            } else if (!hasValue(provider)) {
                alert(self.labels.emptyProvider);
                provider.focus();
            } else {
                result = true;
            }

            return result;
        },

        save: function () {
            var self = this;

            this.validateDataGroup(function () {
                updateFormValues({
                    "cmd": "save",
                    "parentGroupId": self.parentId,
                    "dataItemTypes": self.dataItemTypes,
                    "Icon": self.icon,
                    "IconColor": self.iconColor
                });
                var cmd = document.getElementById("cmdSubmit");
                cmd.click();
            });
        },

        validateDataGroup: function (onComplete) {
            var result = false;
            var self = this;

            dwGlobal.hideAllControlsErrors();

            var groupName = document.getElementById('dataGroupName');
            var groupId = document.getElementById('dataGroupId');
                    
            if (!hasValue(groupName)) {
                dwGlobal.showControlErrors(groupName, self.labels.emptyName);
                groupName.focus();
            } else if (!hasValue(groupId)) {
                dwGlobal.showControlErrors(groupId, self.labels.emptyId);
                groupId.focus();
            } else if (containsInvalidCharacters(groupId)) {
                dwGlobal.showControlErrors(groupId, self.labels.invalidIdCharacters);
                groupId.focus();
            } else {
                result = true;

                if (self.originalId) {
                    onComplete();
                }
                else {
                    var act = self.actions.checkExistingId;
                    act.OnSuccess.Function = function () {
                        onComplete();
                    };
                    act.OnFail.Function = function () {
                        dwGlobal.showControlErrors(groupId, self.labels.existingId);
                        groupId.focus();
                    };
                    Action.Execute(act, {
                        dataGroupId: groupId.value
                    });
                }
            }

            return result;
        },

        cancel: function () {
            var self = this;
            location.href = 'DeploymentConfiguration.aspx?dataGroupId=' + (self.id || self.parentId);
        },

        selectIcon: function () {
            var iconSelector = document.getElementById('IconSelector');
            iconSelector.className = $('dlgIconSettings').select('div[class="icon-block selected"]')[0].select('i')[0].className;
            iconSelector.title = iconSelector.className;
            iconSelector.style.display = (this.icon === "None" || !this.icon) ? "none" : "";

            dialog.hide('dlgIconSettings');
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
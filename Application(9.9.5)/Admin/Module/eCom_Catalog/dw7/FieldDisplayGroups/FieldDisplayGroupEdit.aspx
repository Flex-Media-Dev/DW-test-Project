<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FieldDisplayGroupEdit.aspx.vb" Inherits="Dynamicweb.Admin.FieldDisplayGroupEdit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
    <script>
        function createEditFieldDisplayGroupPage(opts) {
            var options = opts;
            var systemNameEl = document.getElementById(options.ids.systemName);
            var nameEl = document.getElementById(options.ids.name);
            var nameIni = nameEl.value;
            var hasValue = function (el) {
                return !!el.value;
            };
            var isSystemNameIsUnique = function() {
                if (options.isNew) {
                    if (options.allSystemNames.findIndex(id => id.toLowerCase() == systemNameEl.value.toLowerCase()) > -1) {
                        return false;
                    }
                }
                return true;
            }
            var validate = function () {
                var isValid = true;
                if (!hasValue(nameEl)) {
                    dwGlobal.showControlErrors(nameEl, options.labels.emptyName);
                    isValid || nameEl.focus();
                    isValid = false;
                }
                if (!hasValue(systemNameEl)) {
                    dwGlobal.showControlErrors(systemNameEl, options.labels.emptyName);
                    isValid || systemNameEl.focus();
                    isValid = false;
                }
                if (!isSystemNameIsUnique()) {
                    dwGlobal.showControlErrors(systemNameEl, options.labels.systemNameAlreadyExistsMessage);
                    isValid || systemNameEl.focus();
                    isValid = false;
                }
                return isValid;
            };

            var obj = {
                init: function (opts) {
                    this.options = opts;
                    systemNameEl.addEventListener("blur", function () {
                        setSystemName(nameEl, systemNameEl);
                    });
                    nameEl.addEventListener("blur", function () {
                        setSystemName(nameEl, systemNameEl);
                    });

                    function setSystemName(fromObject, toObject) {
                        if (!toObject.value.trim()) {
                            toObject.value = fromObject.value.strip().replace(/\s+/g, "_").replace(/[^a-zA-Z0-9_]+/g, "");
                        } else {
                            toObject.value = toObject.value.strip().replace(/\s+/g, "_").replace(/[^a-zA-Z0-9_]+/g, "");
                        }
                    }
                },

                save: function(close) {
                    if (validate()) {
                        if (close) {
                            document.getElementById('RedirectTo').value = "list";
                        }
                        var cmd = document.getElementById('cmdSubmit');
                        cmd.value = "Save";
                        cmd.click();
                    }
                },

                cancel: function () {
                    Action.Execute(this.options.actions.list);
                },

                confirmDeleteImageGroup: function (evt) {
                    evt.stopPropagation();
                    var confirmStr = nameIni;
                    confirmStr = confirmStr.replace('&nbsp;', "");
                    confirmStr = confirmStr.replace('&qout;', "");
                    confirmStr = "\'" + confirmStr + "\'";
                    Action.Execute(this.options.actions.delete, {
                        name: confirmStr
                    });
                },

                storeFields: function() {
                    const fieldsIds = SelectionBox.getElementsRightAsArray(this.options.ids.fieldsSelector);
                    console.log(fieldsIds);
                    const storageEl = document.getElementById(this.options.ids.fieldsStorage);
                    storageEl.value = fieldsIds;
                },

                storeShops: function() {
                    const shopIds = SelectionBox.getElementsRightAsArray(this.options.ids.shopSelector);
                    console.log(shopIds);
                    const storageEl = document.getElementById(this.options.ids.shopStorage);
                    storageEl.value = shopIds;
                },

                showUsages: function () {
                    Action.Execute(this.options.actions.usages);
                }
            };
            obj.init(opts);
            return obj;
        }
    </script>
</head>

<body class="area-teal screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
                <div class="breadcrumb">
                    <%=GetBreadCrumb()%>
                </div>
                <dwc:CardBody runat="server">
                    <asp:Literal ID="NoGroupExistsForLanguageBlock" runat="server"></asp:Literal>
                    <dwc:GroupBox ID="gbSettings" Title="Settings" runat="server">
                        <dwc:InputText ID="FieldDisplayGroupName" runat="server" Label="Name" ValidationMessage="" MaxLength="255" />
                        <dwc:InputText ID="FieldDisplayGroupSystemName" runat="server" Label="System Name" ValidationMessage="" MaxLength="255" />
                        <dw:SelectionBox ID="FieldDisplayGroupFields" runat="server" Label="Fields" Width="250" Height="250" ShowSortRight="true" />
                        <input type="hidden" name="FieldDisplayGroupFieldsIDs" id="FieldDisplayGroupFieldsIDs" value="" runat="server" />
                        <dw:SelectionBox ID="FieldDisplayGroupShops" runat="server" Label="Shops" Width="250" Height="250" ShowSortRight="true" />
                        <input type="hidden" name="FieldDisplayGroupShopIDs" id="FieldDisplayGroupShopIDs" value="" runat="server" />
                        <dwc:CheckBox ID="UseInFrontEnd" runat="server" Label="Use in frontend" />
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
            <input type="hidden" id="RedirectTo" name="RedirectTo" value="" />
            <asp:Button ID="DeleteButton" Style="display: none" runat="server"></asp:Button>
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>




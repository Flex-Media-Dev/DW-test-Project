<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditImageGroup.aspx.vb" Inherits="Dynamicweb.Admin.EditImageGroup" EnableViewState="false" ViewStateMode="Disabled" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludePrototype="true">
        <Items>
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/images/ObjectSelector.css" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/images/layermenu.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
    <script>
        function createEditImageGroupPage(opts) {
            var options = opts;
            var imageGroupNameEl = document.getElementById(options.ids.name);
            var imageGroupSystemNameEl = document.getElementById(options.ids.systemName);
            var imageGroupNameIni = imageGroupNameEl.value;
            var hasValue = function (el) {
                return !!el.value;
            };
            var validate = function () {
                var isValid = true;
                if (!hasValue(imageGroupNameEl)) {
                    dwGlobal.showControlErrors(imageGroupNameEl, options.labels.emptyName);
                    isValid || imageGroupNameEl.focus();
                    isValid = false;
                }
                if (!hasValue(imageGroupSystemNameEl)) {
                    dwGlobal.showControlErrors(imageGroupSystemNameEl, options.labels.emptySystemName);
                    isValid || imageGroupNameEl.focus();
                    isValid = false;
                }
                return isValid;
            };

            var obj = {
                init: function (opts) {
                    this.options = opts;
                    this.initSystemNameObervers();
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
                    var self = this;
                    var confirmStr = imageGroupNameIni;
                    confirmStr = confirmStr.replace('&nbsp;', "");
                    confirmStr = confirmStr.replace('&qout;', "");
                    confirmStr = "\'" + confirmStr + "\'";
                    Action.Execute(this.options.actions.delete, {
                        ids: self.options.imageGroupId,
                        names: confirmStr
                    });
                },

                initSystemNameObervers: function () {
                    var self = this;
                    Event.observe(document.getElementById("ImageGroupName"), 'blur', self.setSystemName);
                    Event.observe(document.getElementById("ImageGroupSystemName"), 'blur', self.setSystemName);
                },                

                setSystemName: function (e) {
                    var nameBox = document.getElementById("ImageGroupName");
                    var sysNameBox = document.getElementById("ImageGroupSystemName");

                    var sysName = sysNameBox.value;
                    if (sysName.strip().empty()) {
                        sysName = nameBox.value;
                    }
                    sysNameBox.value = sysName.strip().replace(/\s+/g, "_").replace(/[^a-zA-Z0-9_]+/g, "");
                }

            };
            obj.init(opts);
            return obj;
        }
    </script>
</head>

<body class="area-black screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Edit asset category" />
                <dw:Toolbar ID="MainToolbar" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save();" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(close);" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="Cancel" Text="Cancel" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" Disabled="true" OnClientClick="currentPage.confirmDeleteImageGroup(event);" />
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dw:Infobar ID="WrongLanguageForNewGroup" runat="server" Message="" Visible="false" TranslateMessage="false" />
                <dwc:CardBody runat="server">
                    <dwc:GroupBox ID="gbSettings" Title="Settings" runat="server">
                        <dwc:InputText ID="ImageGroupName" runat="server" Label="Name" ValidationMessage="" MaxLength="255" />
                        <dwc:InputText ID="ImageGroupSystemName" runat="server" Label="System name" ValidationMessage="" MaxLength="255" />
                        <dwc:RadioGroup ID="ImageGroupInheritance" runat="server" Label="Inheritance Type" />
                        <dwc:RadioGroup ID="ImageGroupControlType" runat="server" Label="Control Type" />              
                    </dwc:GroupBox>
                    <dwc:GroupBox ID="FileExtensionsGroupBox" Title="File extensions" runat="server">
                        <dwc:CheckBoxGroup ID="Extensions" runat="server" Label="&nbsp;" />
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
            <input type="hidden" id="RedirectTo" name="RedirectTo" value="" />
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>



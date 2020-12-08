<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditSettingPreset.aspx.vb" Inherits="Dynamicweb.Admin.EditSettingPreset" %>

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
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.min.css" />
        </Items>
    </dw:ControlResources>
    <script>
        function createEditPresetPage(opts) {
            var options = opts;
            var presetNameEl = document.getElementById(options.ids.name);
            var hasValue = function (el) {
                return !!el.value;
            };
            var validate = function () {
                if (!hasValue(presetNameEl)) {
                    dwGlobal.showControlErrors(presetNameEl, options.labels.emptyName);
                    presetNameEl.focus();
                    return false;
                }
                return true;
            };

            var obj = {
                init: function (opts) {
                    this.options = opts;
                    this.deletedStatesIds = [];
                },

                save: function (close, redirectToEditState) {
                    if (validate()) {
                        if (close) {
                            document.getElementById('RedirectTo').value = typeof (redirectToEditState) == "undefined" ? "list" : redirectToEditState;
                        }
                        var cmd = document.getElementById('cmdSubmit');
                        cmd.value = "Save";
                        cmd.click();
                    }
                },

                cancel: function () {
                    Action.Execute(this.options.actions.list);
                },

                deletePreset: function () {
                    Action.Execute(this.options.actions.deletePreset, { ids: options.presetId });
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
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Edit preset" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save();" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(close);" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="Cancel" Text="Cancel" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete preset" runat="server" OnClientClick="currentPage.deletePreset();"></dw:ToolbarButton>
                </dw:Toolbar>
                <dwc:CardBody runat="server">
                    <dwc:GroupBox ID="gbSettings" Title="Preset settings" runat="server">
                        <dwc:InputText ID="PresetName" runat="server" Label="Preset name" ValidationMessage="" MaxLength="255" />
                        <dwc:InputText ID="PresetTarget" runat="server" Label="Function" Disabled="True"></dwc:InputText> 
                        <div class="form-group">
                            <label class="control-label">Users/Groups</label>
                            <div class="form-group-input">
                                <dw:Infobar ID="SaveNotification" DisplayType="Warning" Message="Save the preset" Visible="false" runat="server"></dw:Infobar>
                                <dw:UserSelector ID="LinkedUsers" runat="server"></dw:UserSelector>
                            </div>
                        </div>
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


<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditCompletionRule.aspx.vb" Inherits="Dynamicweb.Admin.EditCompletionRule" %>

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
        </Items>
    </dw:ControlResources>
    <script>
        function createEditCompletionRulePage(opts) {
            var options = opts;
            var completionRuleEl = document.getElementById(options.ids.name);
            var completionRuleIni = completionRuleEl.value;
            var hasValue = function (el) {
                return !!el.value;
            };
            var validate = function () {
                var isValid = true;
                if (!hasValue(completionRuleEl)) {
                    dwGlobal.showControlErrors(completionRuleEl, options.labels.emptyName);
                    isValid || completionRuleEl.focus();
                    isValid = false;
                }
                return isValid;
            };

            var obj = {
                init: function (opts) {
                    this.options = opts;
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
                    var confirmStr = completionRuleIni;
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
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Edit completion rule" />
                <dw:Toolbar ID="MainToolbar" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save();" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(close);" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="Cancel" Text="Cancel" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" Disabled="true" OnClientClick="currentPage.confirmDeleteImageGroup(event);" />
                    <dw:ToolbarButton ID="cmdUsages" Icon="LineChart" Text="Show usage" runat="server" OnClientClick="currentPage.showUsages(event);" />                    
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dwc:CardBody runat="server">
                    <dwc:GroupBox ID="gbSettings" Title="Settings" runat="server">
                        <dwc:InputText ID="CompletionRuleName" runat="server" Label="Name" ValidationMessage="" MaxLength="255" />
                        <dwc:InputTextArea ID="CompletionRuleDescription" runat="server" Label="Description" />
                        <dw:SelectionBox ID="CompletionRuleFields" runat="server" Label="Fields" Width="250" Height="250" ShowSortRight="false" />
                        <input type="hidden" name="CompletionRuleFieldsIDs" id="CompletionRuleFieldsIDs" value="" runat="server" />
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




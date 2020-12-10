<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditToken.aspx.vb" Inherits="Dynamicweb.Admin.EditToken" %>

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
        function createEditTokenPage(opts) {
            let obj = {
                init: function (opts) {
                    this.options = opts;
                },

                save: function (close) {
                    if (close) {
                        document.getElementById('RedirectTo').value = "list";
                    }
                    let cmd = document.getElementById('cmdSubmit');
                    cmd.value = "Save";
                    cmd.click();
                },

                cancel: function () {
                    Action.Execute(this.options.actions.list);
                },

                confirmDelete: function (evt) {
                    evt.stopPropagation();
                    var self = this;
                    var ids = [self.options.tokenId];
                    Action.Execute(this.options.actions.delete, {
                        ids: ids
                    });
                },

                showUser: function (evt) {
                    evt.stopPropagation();
                    var userId = parseInt(evt.target.getAttribute("data-user-id"));
                    if (userId > 1) {
                        Action.Execute(this.options.actions.showUserInfo, {
                            userId: userId
                        });
                    }
                },
            };
            obj.init(opts);
            return obj;
        }

        function userChanged() {
            if (window.currentPage) {
                window.currentPage.userChanged();
            }
        }
    </script>
    <style>
        fieldset .form-group.textbox-ctrl .form-group-input input.form-control#TokenHash {
            width: calc(100% - 31px);
        }
    </style>
</head>

<body class="area-teal screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Edit token" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save();" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(close);" />
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" OnClientClick="currentPage.confirmDelete(event);" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="Cancel" Text="Cancel" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dwc:CardBody runat="server">
                    <dwc:GroupBox ID="gbSettings" Title="Token settings" runat="server">
                        <dwc:InputText ID="TokenName" runat="server" Label="Name" ValidationMessage="" MaxLength="255" />
                        <dwc:InputTextArea ID="TokenDescription" runat="server" Label="Description" />
                        <dwc:InputText ID="TokenDevice" runat="server" Label="Device" Disabled="true" />
                        <div class="form-group">
                            <label class="control-label">
                                <dw:TranslateLabel Text="User" runat="server" />
                            </label>
                            <div class="form-group-input">
                                <asp:Literal runat="server" ID="TokenUserName" />
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



<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomFieldOption_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomFieldOption_Edit" %>

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
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/layermenu.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>
    <script>
        function createEditFieldOptionPage(opts) {
            var hasValue = function (el) {
                return !!el.value;
            };
            var validate = function () {
                var isValid = true;
                var nameEl = document.getElementById('OptionName');
                if (!hasValue(nameEl)) {
                    dwGlobal.showControlErrors(nameEl, opts.labels.emptyName);
                    isValid || nameEl.focus();
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

                confirmDelete: function (evt) {
                    evt.stopPropagation();
                    Action.Execute(this.options.actions.delete);
                },
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
                <dw:Toolbar ID="Toolbar" runat="server">                
                    <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Image="NoImage" icon="Save" Text="Save" OnClientClick="currentPage.save(false);" />                
                    <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Divide="None" Image="NoImage" icon="Save" Text="Save and close" OnClientClick="currentPage.save(true);" />
                    <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="NoImage" icon="Cancel" Text="Cancel" OnClientClick="currentPage.cancel(true);" />
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" OnClientClick="currentPage.confirmDelete(event);" />
                </dw:Toolbar>           
                <dwc:CardBody runat="server">    
                    <dw:Infobar ID="NoFieldsExistsForLanguageBlock" DisplayType="Warning" Message="The product field does not exist in the chosen language." Visible="false" runat="server"></dw:Infobar>
                    <dw:Infobar ID="NoOptionExistsForLanguageInfo" DisplayType="Warning" Message="The field option does not exist in the chosen language." Visible="false" runat="server"></dw:Infobar>                
                    <dwc:GroupBox ID="gbSettings" Title="Settings" runat="server">
                        <dwc:InputText ID="OptionName" runat="server" Label="Name" ValidationMessage="" MaxLength="255" />
                        <dwc:InputText ID="OptionValue" runat="server" Label="Value" ValidationMessage="" MaxLength="255" />
                        <dwc:CheckBox ID="OptionIsDefault" runat="server" Label="Default" />
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




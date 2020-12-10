<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VouchersListEdit.aspx.vb" Inherits="Dynamicweb.Admin.VouchersManager.VouchersListEdit" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Ajax.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        $(document).observe('dom:loaded', function () {
            if (document.getElementById('Name')) {
                window.focus(); // for ie8-ie9 
                document.getElementById('Name').focus();
            }
        });

        function save(close) {
            $("CMD").value = close ? "SaveAndClose" : "Save";            
            Dynamicweb.Ajax.doPostBack({
                onComplete: function (data) {
                    if (data && data.responseText) {
                        var responseObject = JSON.parse(data.responseText);
                        if(responseObject){
                            if(responseObject.isNew && responseObject.listId > 0) {
                                var input = document.createElement("input");
                                input.type = "hidden";
                                input.name = "ListID";
                                input.value = responseObject.listId;
                                form2.appendChild(input);
                            }
                            if(responseObject.validationMessage) {
                                showMessage(responseObject.validationMessage);
                            }
                        }
                    } else if (close) {
                        redirect();
                    }                    
                }
            });
        }

        function showMessage(message) {
            var action = <%= New Dynamicweb.Management.Actions.ShowMessageAction("").ToJson()%>;
            action.Message = message;
            Action.Execute(action, {});
        }

        function Delete() {
            if (!confirm('<%=Translate.Translate("Delete?")%>')) {
                return;
            }

            $("CMD").value = "Delete";
            Dynamicweb.Ajax.doPostBack({
                onComplete: function () {
                    redirect();
                }
            });
        }

        function redirect() {
            location.href = "/Admin/Module/eCom_Catalog/dw7/Vouchers/VouchersManagerMain.aspx";
        }

        function help() {
		    <%=Gui.Help("", "administration.managementcenter.eCommerce.productcatalog.vouchers.edit") %>
        }

    </script>
</head>
<body>
    <form id="form2" runat="server">
        <div class="card-header">
            <h2 class="subtitle"><dw:TranslateLabel Text="Edit voucher list" runat="server" /></h2>
        </div>

        <dw:Toolbar runat="server">
            <dw:ToolbarButton ID="btnSave" Text="Save" Icon="Save" Size="Small" runat="server" OnClientClick="save(false);" />
            <dw:ToolbarButton ID="btnSaveAndClose" Text="Save and close" Icon="Save" Size="Small" runat="server" OnClientClick="save(true);" />
            <dw:ToolbarButton ID="btnCancel" Text="Close" Icon="TimesCircle" Size="Small" runat="server" OnClientClick="redirect();" />
            <dw:ToolbarButton ID="btnDelete" Text="Delete" Icon="Delete" Size="Small" runat="server" OnClientClick="Delete();" />
            <dw:ToolbarButton ID="Help" Text="Help" Icon="Help" Size="Large" runat="server" OnClientClick="help();" />
        </dw:Toolbar>

        <input type="hidden" id="CMD" name="CMD" />

        <dwc:GroupBox runat="server" ID="SettingsStart" Title="Settings">
            <table class="formsTable">
                <tr>
                    <td>
                        <dw:TranslateLabel Text="List Name" runat="server" />
                    </td>
                    <td>
                        <asp:TextBox ID="Name" runat="server" MaxLength="250" CssClass="NewUIinput" />
                        <asp:RequiredFieldValidator ID="requiredListNameValidator" runat="server" ErrorMessage="*" ControlToValidate="Name"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <dw:CheckBox Label="Active" ID="IsActive" FieldName="IsActive" runat="server" />
                    </td>
                </tr>
            </table>
        </dwc:GroupBox>
    </form>
</body>
<%Translate.GetEditOnlineScript()%>
</html>

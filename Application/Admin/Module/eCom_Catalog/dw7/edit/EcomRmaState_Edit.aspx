<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomRmaState_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomRmaState_Edit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/images/layermenu.js"></script>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />

    <title>Edit RMA states</title>

    <script type="text/javascript">
        var delocalizeMessage = "<%=delocalizeMessage %>";
        var deleteMessage = "<%=deleteMessage %>";

        function save(close) {
            if (close)
                $('SaveClose').value = 'True';
            else
                $('Save').value = 'True';

            submit();
        }

        function deleteState(deleteAll) {
            var message;
            if (deleteAll) {
                $('DeleteState').value = 'True';
                message = deleteMessage;
            } else {
                $('Delete').value = 'True';
                message = delocalizeMessage;
            }

            if (confirm(message))
                submit();
        }

        function submit() {
            document.Form1.submit();
        }
    </script>
</head>

<body class="area-pink screen-container">
    <div class="card">
        <form id="Form1" method="post" runat="server">
            <div class="card-header">
                <h2 class="subtitle"><asp:Literal runat="server" ID="Header"></asp:Literal></h2>
            </div>
            <dw:Toolbar runat="server" ID="Toolbar" ShowStart="true" ShowEnd="false"></dw:Toolbar>
            <dw:Infobar runat="server" ID="StateStatus" Visible="false" />

            <asp:HiddenField runat="server" ID="StateID" />

            <dwc:GroupBox runat="server" Title="State settings">
                <table class="formsTable">
                    <tr>
                        <td>
                            <label for="Name">
                                <dw:TranslateLabel runat="server" Text="Name" />
                            </label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="Name" CssClass="std" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="Description">
                                <dw:TranslateLabel runat="server" Text="Description" />
                            </label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="Description" TextMode="MultiLine" Height="50" CssClass="std" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" ID="DefaultForNewRMA" Label="Default for new RMA" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Active for" />
                        </td>
                        <td>
                            <div class="form-group">
                                <asp:Literal runat="server" ID="TypeSelector" />
                            </div>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <input type="hidden" name="Save" id="Save" value="" />
            <input type="hidden" name="SaveClose" id="SaveClose" value="" />
            <input type="hidden" name="Delete" id="Delete" value="" />
            <input type="hidden" name="DeleteState" id="DeleteState" value="" />
        </form>
    </div>
    <asp:Literal ID="BoxEnd" runat="server"></asp:Literal>

    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>

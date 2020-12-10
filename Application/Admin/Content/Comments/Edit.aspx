<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Edit.aspx.vb" Inherits="Dynamicweb.Admin.Edit4" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>

    <script src="Comments.js" type="text/javascript"></script>
    <script type="text/javascript">
        var commentid = <%=cID %>;
        var ItemID = '<%=ItemID %>';
        var Type = '<%=Type %>';
        var LangID = '<%=LangID %>';
        var IsFullPage = '<%=IsFullPage %>';
        var IsNewNavigator = '<%=IsNewNavigator %>';

        function save() {
            if (!validateEmail()) { return; }
            document.getElementById('form1').submit();
        }

        function validateEmail() {
            var email = document.getElementById('Email');
            if (!validateEmailAddress(email.value)) {
                dwGlobal.showControlErrors(email, '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Please use correct email format")%>');
                var overlay = new overlay("__ribbonOverlay");
                overlay.hide();
                email.focus();
                return false;
            }
            return true;
        }

        function validateEmailAddress(address) {
            var regExp = /^[\w\-_]+(\.[\w\-_]+)*@[\w\-_]+(\.[\w\-_]+)*\.[a-z]{2,4}$/i;
            return address == '' || regExp.test(address);
        }
    </script>
</head>
<body <%=If(IsNewNavigator, "class=""screen-container""", String.Empty) %>>
    <dwc:Card runat="server">
        <dwc:CardHeader ID="CardHeader" runat="server" Title="Edit comment" />
        <dwc:CardBody runat="server">
            <form id="form1" runat="server">
                <input type="hidden" name="id" id="CommentID" runat="server" />
                <dw:Toolbar ID="Toolbar1" runat="server">
                    <dw:ToolbarButton ID="ToolbarButton1" runat="server" Divide="None" Icon="Save" Text="Save" OnClientClick="save();" ShowWait="true">
                    </dw:ToolbarButton>
                    <dw:ToolbarButton ID="ToolbarButton2" runat="server" Divide="None" Icon="Cancel" Text="Cancel" OnClientClick="location.href = 'List.aspx?' + getQueryString();" ShowWait="true">
                    </dw:ToolbarButton>
                    <dw:ToolbarButton ID="DeleteToolbarBtn" runat="server" Divide="None" Icon="Delete" Text="Slet" OnClientClick="del(commentid);" ShowWait="true">
                    </dw:ToolbarButton>
                </dw:Toolbar>
                <dw:GroupBox runat="server" Title="Egenskaber">
                    <dwc:InputText ID="Parent" Label="Parent" runat="server" Disabled="true" />
                    <dwc:InputText ID="Name" Label="Navn" runat="server" />
                    <dwc:InputText ID="Email" Label="E-mail" runat="server" ValidationMessage="" />
                    <dwc:InputText ID="Website" Label="Website" runat="server" />
                    <dwc:CheckBox ID="active" Label="Active" runat="server" />
                    <dwc:SelectPicker runat="server" Label="Rating" ID="Rating">
                        <asp:ListItem Value="0" Text="0" />
                        <asp:ListItem Value="1" Text="1" />
                        <asp:ListItem Value="2" Text="2" />
                        <asp:ListItem Value="3" Text="3" />
                        <asp:ListItem Value="4" Text="4" />
                        <asp:ListItem Value="5" Text="5" />
                    </dwc:SelectPicker>
                    <dwc:InputTextArea runat="server" Label="Kommentar" ID="CommentText" Rows="5" />
                    <dwc:InputNumber ID="Likes" Label="Likes" runat="server"></dwc:InputNumber>
                    <dwc:InputNumber ID="NoLikes" Label="No likes" runat="server"></dwc:InputNumber>
                </dw:GroupBox>
                <dw:GroupBox runat="server" Title="Replies">
                    <dw:List ID="Replies" runat="server" ShowTitle="false">
                        <Columns>
                            <dw:ListColumn Name="Name" runat="server" />
                            <dw:ListColumn Name="Rating" runat="server" />
                            <dw:ListColumn Name="Comment" runat="server" />
                        </Columns>
                    </dw:List>
                </dw:GroupBox>
            </form>
        </dwc:CardBody>
    </dwc:Card>
</body>
</html>

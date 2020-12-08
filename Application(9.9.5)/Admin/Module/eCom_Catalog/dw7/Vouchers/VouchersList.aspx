<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VouchersList.aspx.vb" Inherits="Dynamicweb.Admin.VouchersManager.VouchersList" %>

<!DOCTYPE html>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title>Vouchers List</title>
    <dw:ControlResources ID="ControlResources1" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="js/VouchersManagerMain.js" />
            <dw:GenericResource Url="js/VouchersList.js" />
            <dw:GenericResource Url="js/VouchersGenerator.js" />
            <dw:GenericResource Url="../js/ecomLists.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/css/ToolTip.css" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        var vouchersCreated = '<%= Translate.Translate("Vouchers have been generated")%>';
        var onlyNumbersAreAccepted = '<%= Translate.Translate("Only numbers are accepted")%>';
        var minNumberOfVauchers = '<%= Translate.Translate("It is not possible to generate less than 1 voucher")%> ';
        var maxNumberOfVouchersExceededWarning ='<%= Translate.Translate("It is not possible to generate more than 50000 vouchers at a time")%>';
        var ListID = <%=ListID%>;

        function help() {
		    <%=Gui.Help("", "administration.managementcenter.eCommerce.productcatalog.vouchers") %>
        }

        function showMessage(message) {
            var action = <%= New Dynamicweb.Management.Actions.ShowMessageAction("").ToJson()%>;
            action.Message = message;
            Action.Execute(action, {});
        }

        function generateOnSelect() {
            vouchersGenerator.GetNumberOfUsers();
        }
    </script>
</head>
<body>
    <form id="form2" runat="server">
        <div class="card-header">
            <h2 class="subtitle">
                <dw:TranslateLabel Text="Edit reward" runat="server" />
            </h2>
        </div>

        <dw:Toolbar ID="ListBar1" runat="server" ShowEnd="false">
            <dw:ToolbarButton ID="CloseToolbarButton" runat="server" Divide="None" Icon="timesCircle" Text="Close" OnClientClick="openInContentFrame('VouchersManagerMain.aspx');"></dw:ToolbarButton>
            <dw:ToolbarButton ID="AddVoucherToolbarButton" runat="server" Divide="None" Icon="PlusSquare" Text="Add Vouchers" OnClientClick="vouchersList.openAddVouchers();"></dw:ToolbarButton>
            <dw:ToolbarButton ID="DeleteVoucherToolbarButton" runat="server" Divide="None" Icon="Delete" Text="Delete Voucher"></dw:ToolbarButton>
            <dw:ToolbarButton ID="GenerateVouchersToolbarButton" runat="server" Divide="None" Icon="Refresh" Text="Generate Vouchers" OnClientClick="vouchersGenerator.openGenerateVouchers();"></dw:ToolbarButton>
            <dw:ToolbarButton ID="ActivateListToolbarButton" runat="server" Divide="None" Icon="Check" IconColor="Default" Text="Activate List"></dw:ToolbarButton>
            <dw:ToolbarButton ID="DeactivateListToolbarButton" runat="server" Divide="None" Icon="Delete" Text="Deactivate List"></dw:ToolbarButton>
            <dw:ToolbarButton ID="SendMailsToolbarButton" runat="server" Divide="None" Icon="Mail" Text="Send Mails" OnClientClick="vouchersList.openSendMails();"></dw:ToolbarButton>
            <dw:ToolbarButton ID="ExportToCsv" runat="server" Divide="None" Icon="FileExelO" Text="Download vouchers in CSV"></dw:ToolbarButton>
            <dw:ToolbarButton ID="HelpToolbarButton" runat="server" Divide="None" Icon="Help" Text="Help" OnClientClick="help();"></dw:ToolbarButton>
        </dw:Toolbar>

        <dw:List ID="vouchersList" ShowFooter="true" runat="server" TranslateTitle="True" ShowTitle="true" PageSize="25" ShowPaging="true" AllowMultiSelect="true">
            <Columns>
                <dw:ListColumn ID="ListColumn4" EnableSorting="false" runat="server" Name="" Width="5"></dw:ListColumn>
                <dw:ListColumn ID="VoucherCode" EnableSorting="true" runat="server" Name="Voucher Code" Width="80"></dw:ListColumn>
                <dw:ListColumn ID="DateUsed" EnableSorting="true" runat="server" Name="Date Used" WidthPercent="15"></dw:ListColumn>
                <dw:ListColumn ID="OrderID" EnableSorting="true" runat="server" Name="Order" WidthPercent="15"></dw:ListColumn>
                <dw:ListColumn ID="EmailSend" EnableSorting="true" runat="server" Name="Send to" WidthPercent="15"></dw:ListColumn>
                <dw:ListColumn ID="VoucherStatus" EnableSorting="true" runat="server" Name="Voucher status" Width="30"></dw:ListColumn>
            </Columns>
        </dw:List>

        <dw:ContextMenu ID="vouchersContextMenu" runat="server" OnClientSelectView="vouchersList.contextMenuView">
            <dw:ContextMenuButton ID="DeleteVoucherMenuButton" runat="server" Divide="After" Icon="PlusSquare" Text="New Thread" OnClientClick="message.addThread();">
            </dw:ContextMenuButton>
        </dw:ContextMenu>

        <dw:Dialog runat="server" ID="vouchersGeneratorDialog" Size="Medium" Title="Vouchers Generator" ShowOkButton="true" OkText="Generate" OkAction="vouchersGenerator.GenerateVouchers();" ShowCancelButton="true">
            <dw:Overlay ID="GeneratorOverlay" Message="Please wait" runat="server"></dw:Overlay>
            <dwc:GroupBox runat="server" Title="Settings">
                <dwc:InputNumber ID="numberOfVouchers" runat="server" Label="Enter number of vouchers to generate:" />
            </dwc:GroupBox>
            <br />
            <dwc:GroupBox runat="server" Title="Select group(s) and user(s)" DoTranslation="true">
                <input type="hidden" id="formmode" name="formmode" value="" />
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel Text="Get number from User Management" runat="server" />
                        &nbsp;
                        <a class="tooltip" style="z-index: 1000; position: fixed;">
                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.QuestionCircle) %>" style="cursor: pointer;">
                                <span>
                                    <dw:TranslateLabel Text="If you want to match the number of vouchers with a number of users," runat="server" />
                                    <br />
                                    <dw:TranslateLabel Text="you can get the number from User Management field by selecting users/groups here." runat="server" />
                                </span>
                            </i>
                        </a>
                    </label>
                    <div class="form-group-input">
                        <dw:UserSelector runat="server" ID="UserSelector" OnSelectScript="generateOnSelect" DisplayDefaultUser="false" HeightInRows="7" />
                    </div>
                </div>
            </dwc:GroupBox>
        </dw:Dialog>

        <dw:Dialog runat="server" ID="vouchersDialog" Size="Medium" Title="Add Voucher" ShowOkButton="true" OkText="Add" OkAction="vouchersList.AddVouchers();" ShowCancelButton="true">
            <dw:Overlay ID="AddVouchersOverlay" Message="Please wait" runat="server"></dw:Overlay>
            <dwc:GroupBox Title="Voucher Code" runat="server">
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel Text="Voucher Code" runat="server" />
                    </label>
                    <div class="input-group">
                        <div class="form-group-input">
                            <asp:TextBox ID="txVoucherCode" CssClass="std field-name" runat="server" ClientIDMode="Static" TextMode="MultiLine" Rows="13" />
                        </div>
                    </div>
                </div>
            </dwc:GroupBox>
        </dw:Dialog>

        <dw:Dialog runat="server" ID="vouchersSendMailsDialog" Size="Medium" Title="Send Mails" ShowOkButton="true" OkText="Send" OkAction="vouchersList.SendMails();" ShowCancelButton="true">
            <dw:Overlay ID="MailOverlay" Message="Please wait" runat="server"></dw:Overlay>
            <dwc:GroupBox runat="server" Title="Select group(s) and user(s)">
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel Text="Select" runat="server" />
                    </label>
                    <div class="form-group-input">
                        <dw:UserSelector runat="server" ID="UserSelectorMail" DisplayDefaultUser="false" HeightInRows="7" />
                    </div>
                </div>
            </dwc:GroupBox>

            <dwc:GroupBox Title="MailSettings" runat="server">
                <dwc:InputText runat="server" Label="Sender name" ID="VoucherSenderName" Name="VoucherSenderName" />
                <dwc:InputText runat="server" Label="Sender email" ID="VoucherSenderEmail" Name="VoucherSenderEmail" />
                <dwc:InputText runat="server" Label="Subject" ID="VoucherSubject" Name="VoucherSubject" />
                <dw:FileManager Label="Template" ID="VoucherMailTemplate" runat="server" Folder="/Templates/eCom7/Vouchers" />
            </dwc:GroupBox>
        </dw:Dialog>

        <%Translate.GetEditOnlineScript()%>
    </form>
</body>
</html>


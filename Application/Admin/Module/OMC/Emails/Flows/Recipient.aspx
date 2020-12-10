<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="Recipient.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.Flows.Recipient" %>

<%@ Import Namespace="Dynamicweb.EmailMarketing" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content runat="server" ContentPlaceHolderID="HeadContent">
    <script>
        function showHelp() {
            <%=Gui.Help("omc.email.flow", "omc.email.flow")%>
        }
        function createViewRecipientPage(opts) {
            var options = opts;
            var obj = {
                init: function (opts) {
                    this.options = opts;
                },

                cancel: function () {
                    Action.Execute(this.options.actions.cancel);
                }
            };
            obj.init(opts);
            return obj;
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="PageTitle" DoTranslate="false" Title="Show recipient"></dwc:CardHeader>
        <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false">
            <dw:ToolbarButton ID="cmdClose" Icon="Cancel" Text="Close" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
            <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="Before" Icon="Help" Text="Help" OnClientClick="showHelp();" />
        </dw:Toolbar>
        <dwc:CardBody runat="server">
            <dwc:GroupBox ID="gbSettings" Title="" runat="server">
                <dwc:InputText runat="server" ID="EmailAddress" Label="Email address" Disabled="true" />
                <dwc:InputText runat="server" ID="LastStep" Label="Last step" Disabled="true" />
                <dwc:InputText runat="server" ID="LastEmail" Label="Last Email" Disabled="true" />
                <dwc:InputText runat="server" ID="SendTime" Label="Send time" Disabled="true" />
            </dwc:GroupBox>
            <dwc:GroupBox ID="gbHistory" Title="History" runat="server">
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel runat="server" Text="History" />
                    </label>
                    <div class="form-group-input history-list-container">
                        <dw:List ID="HistoryList" runat="server" Title="" ShowTitle="False" AllowMultiSelect="false">
	                        <Columns>
                                <dw:ListColumn ID="colStep" runat="server" Name="Step" />
		                        <dw:ListColumn ID="colEmail" runat="server" Name="Email" />
			                    <dw:ListColumn ID="colSendDate" runat="server" Name="Send date" />
		                    </Columns>
	                    </dw:List>
                    </div>
                </div>
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>


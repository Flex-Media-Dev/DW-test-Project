<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="ViewFlow.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.Flows.ViewFlow" %>

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
        function createViewFlowPage(opts) {
            var options = opts;
            var obj = {
                init: function (opts) {
                    this.options = opts;
                },

                cancel: function () {
                    Action.Execute(this.options.actions.cancel);
                },
                showRecipientInfo: function (recipientId) {
                    Action.Execute(this.options.actions.showRecipient, {
                        recipientId: recipientId,
                        flowId: this.options.flowId,
                        folderId: this.options.folderId,
                        folderPath: this.options.folderPath
                    });
                }
            };
            obj.init(opts);
            return obj;
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="PageTitle" DoTranslate="false" Title="View Flow"></dwc:CardHeader>
        <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false">
            <dw:ToolbarButton ID="cmdClose" Icon="Cancel" Text="Close" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
            <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="Before" Icon="Help" Text="Help" OnClientClick="showHelp();" />
        </dw:Toolbar>
        <dwc:CardBody runat="server">
            <dwc:GroupBox ID="gbSettings" Title="" runat="server">
                <dwc:InputText runat="server" ID="FlowName" Label="Name" Disabled="true" />
                <dwc:InputNumber runat="server" ID="NewRecipients" Label="New Recipients" Disabled="true" Info="Recipients who are included in this flow but have not yet received an email" />
                <dwc:InputNumber runat="server" ID="ProcessedRecipients" Label="Processed Recipients" Disabled="true" Info="Recipients who have received an email from any flow step" />
                <asp:Repeater runat="server" ID="RecipientsPerStep">
                    <ItemTemplate>
                        <dwc:InputNumber runat="server" ID="StepRecipients" Label=" - Step" Disabled="true" DoTranslate="false" Info="Recipients who last received the step email" />
                    </ItemTemplate>
                </asp:Repeater>
                <dwc:InputNumber runat="server" ID="CompletedRecipients" Label="Completed Recipients" Disabled="true" Info="Recipients who have completed the email flow" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="gbRecipients" Title="Recipients" runat="server">
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel runat="server" Text="Recipients" />
                    </label>
                    <div class="form-group-input recipients-list-container">
                        <dw:List ID="RecipientsList" runat="server" Title="" ShowTitle="False" AllowMultiSelect="false" HandlePagingManually="true" UseCountForPaging="true" PageSize="20">
	                        <Columns>
                                <dw:ListColumn ID="colEmail" runat="server" Name="Email address" />
                                <dw:ListColumn ID="colLastStep" runat="server" Name="Last step" />
		                        <dw:ListColumn ID="colEmailSubject" runat="server" Name="Last email subject" />
			                    <dw:ListColumn ID="colLastSendTime" runat="server" Name="Last send time" />
		                    </Columns>
	                    </dw:List>
                    </div>
                </div>
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>


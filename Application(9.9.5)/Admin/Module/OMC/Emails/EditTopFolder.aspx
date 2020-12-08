<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="EditTopFolder.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.EditTopFolder" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
    <script>
        function showHelp() {
            <%=Gui.Help("omc.email.list", "omc.email.list")%>
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="true">
            <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save(false)" />
            <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(true)" />
            <dw:ToolbarButton ID="cmdCancel" Icon="Cancel" IconColor="Danger" Text="Cancel" runat="server" OnClientClick="currentPage.cancel()" />
            <dw:ToolbarButton ID="cmdHelp" Icon="Help" Text="Help" OnClientClick="currentPage.help();" runat="server" Divide="Before" />
        </dw:Toolbar>
        <dwc:CardBody runat="server">
            <dwc:GroupBox ID="gbGeneral" Title="General" runat="server">
                <dwc:InputText runat="server" ID="txtFolderName" Label="Folder Name" ValidationMessage="" />
                <dwc:InputText runat="server" ID="txSenderName" Label="From: Name" />
                <dwc:InputText runat="server" ID="txSenderEmail" Label="From: e-mail" />
                <dwc:InputText runat="server" ID="txSubject" Label="Subject" />
                <dwc:SelectPicker runat="server" ID="DomainSelector" Label="Domain" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="gbContent" Title="Content" runat="server">
                <dwc:CheckBox runat="server" ID="cbRenderContent" Indent="true" Label="Render content for each recipient" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="gbUnsubscribe" Title="Unsubscribe" runat="server">
                <dwc:InputText runat="server" ID="txbUnsubscribeText" Label="Unsubscribe text" />
                <div class="form-group">
                    <dw:TranslateLabel runat="server" CssClass="control-label" UseLabel="true" Text="Redirect after unsubscribe" />
                    <dw:LinkManager ID="lmUnsubscriptionPage" runat="server" DisableFileArchive="true" DisableParagraphSelector="true" DisableTyping="true" />
                </div>
            </dwc:GroupBox>

            <dwc:GroupBox ID="gbEngagementIndex" Title="Engagement Indexes" runat="server">
                <div class="form-group">
                    <strong class="control-label"><%=Translate.Translate("Conversion") %></strong>
                    <div class="form-group-input">
                        <strong><%=Translate.Translate("Engagement Index") %></strong>
                    </div>
                </div>
                <dwc:InputNumber runat="server" ID="numOpenMail" Min="0" Max="100" Label="Open the e-mail" />
                <dwc:InputNumber runat="server" ID="numClickLink" Min="0" Max="100" Label="Click a link" />
                <dwc:InputNumber runat="server" ID="numAddingProductsToCart" Min="0" Max="100" Label="Adding products to cart" />
                <dwc:InputNumber runat="server" ID="numSigningNewsletter" Min="0" Max="100" Label="Signing on to e-mail" />
                <dwc:InputNumber runat="server" ID="numUnsubscribesNewsletter" Min="-100" Max="100" Label="Unsubscribes the e-mail" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="gbTrackingProvider" runat="server" Title="Tracking provider">
                <%= TrackingProviderAddIn.Jscripts %>
                <de:AddInSelector
                    ID="TrackingProviderAddIn"
                    runat="server"
                    AddInShowNothingSelected="true"
                    AddInGroupName="Select Tracking"
                    AddInParameterName="Settings"
                    AddInTypeName="Dynamicweb.EmailMarketing.EmailTrackingProvider"
                    AddInShowFieldset="false" />
                <%= TrackingProviderAddIn.LoadParameters %>
            </dwc:GroupBox>

            <dwc:GroupBox ID="gbDeliveryProviders" runat="server" Title="Delivery provider">
                <dwc:SelectPicker runat="server" ID="ddlDeliveryProviders" Label="Configuration" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="gbRecipientProvider" runat="server" Title="Recipient provider">
                <%= RecipientProviderAddIn.Jscripts %>
                <de:AddInSelector ID="RecipientProviderAddIn" runat="server" AddInShowNothingSelected="False" AddInGroupName="Select Recipient Provider" AddInParameterName="Settings" AddInTypeName="Dynamicweb.EmailMarketing.EmailRecipientProvider" AddInShowFieldset="False" />
                <%= RecipientProviderAddIn.LoadParameters %>
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>
    <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
    <input type="hidden" id="CloseOnSave" name="CloseOnSave" value="True" />
</asp:Content>

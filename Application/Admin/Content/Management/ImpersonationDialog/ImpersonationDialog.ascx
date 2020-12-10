<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ImpersonationDialog.ascx.vb" Inherits="Dynamicweb.Admin.ImpersonationDialog" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<dw:Dialog ID="dlgLogin" Width="450" Title="Impersonation" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" runat="server">
    <dwc:GroupBox runat="server">
        <%=RenderImpersonationTypes()%>
    </dwc:GroupBox>
    <div ID="customCredentials" style="display: none">
        <dwc:GroupBox runat="server" Title="Credentials">
            <dwc:InputText runat="server" Id="ImpersonationUsername" Label="Username"/>
            <dwc:InputText runat="server" Id="ImpersonationPassword" Label="Password" Password="true" />
            <dwc:InputText runat="server" Id="ImpersonationDomain" Label="Domain" />
        </dwc:GroupBox>
    </div> 
    
    <input type="hidden" class="impersonate" id="DoImpersonation" value="false" runat="server" />
</dw:Dialog>

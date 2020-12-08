<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="EmailTypeSelect.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.EmailTypeSelect" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dw:Overlay ID="ribbonOverlay" runat="server" Message="" ShowWaitAnimation="True" />
        <dwc:CardHeader runat="server" DoTranslate="true" Title="New email" />
        <dwc:CardBody runat="server">
            <input type="hidden" id="templateId" name="templateId" value="" />
            <dwc:GroupBox runat="server">
                <div onclick="currentPage.createEmail();" class="item-type" runat="server">
                    <span class="large-icon"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Email)%>"></i></span>
                    <div>
                        <dw:TranslateLabel runat="server" Text="Blank e-mail" UseLabel="false" />
                    </div>
                    <div class="description"><small></small></div>
                </div>
                <asp:Repeater ID="EmailTemplatesRepeater" runat="server" EnableViewState="false">
                    <ItemTemplate>
                        <div onclick="currentPage.createEmail(<%#Eval("Id")%>);" class="item-type">
                            <span class="large-icon"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Email)%>"></i></span>
                            <div><%#Eval("TemplateName")%></div>
                            <div class="description"><small><%# Converter.ToString(Eval("TemplateDescription"))%></small></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>
    <dw:Overlay ID="wait" runat="server"></dw:Overlay>
</asp:Content>


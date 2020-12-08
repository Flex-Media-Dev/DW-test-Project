<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="PackageSettings.aspx.vb" Inherits="Dynamicweb.Admin.PackageSettings" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Imaging" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Dynamicweb.controls" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="/Admin/Validation.js"></script>
    <script type="text/javascript" src="PackageSettings.js"></script>
    <script>
        initPage({
            messages: {
                oneSourceShouldSelected: '<%=Translate.Translate("At least one package source should be selected")%>'
            }
        });
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Package settings"></dwc:CardHeader>
        <dwc:CardBody runat="server">
            <asp:HiddenField ID="PostBackAction" runat="server" />
            <dw:Infobar runat="server" ID="ErrorBlock" Type="Error" Visible="false" Message="This solution doesn't have the setup to use packages." Title="Error" />
            <dwc:GroupBox ID="GroupBoxSettings" runat="server" Title="Settings" GroupWidth="6">
                <dwc:InputText ID="RepositoryPath" runat="server" Label="Repository path" ToolTip="A relative path can be used. The root folder of related path is '/Files/System/Packages'" />
                <dwc:CheckBoxGroup runat="server" ID="PackagesSources" Name="PackagesSources" Label="Packages sources"></dwc:CheckBoxGroup>
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>
    <% Translate.GetEditOnlineScript() %>
</asp:Content>
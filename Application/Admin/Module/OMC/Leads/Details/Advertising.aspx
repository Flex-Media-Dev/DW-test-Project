<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Leads/Details/EntryContent.Master" CodeBehind="Advertising.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.Details.Advertising" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="visitor-details-advertising">
        <dw:GroupBox ID="gbDynamicweb" Title="Dynamicweb" runat="server">
            <div class="omc-padding">
                <table border="0">
                    <tr>
                        <td style="width: 170px"><dw:TranslateLabel ID="lbCampaign" Text="Campaign" runat="server" /></td>
                        <td><asp:Literal ID="litCampaign" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </dw:GroupBox>

        <div class="omc-separator"></div>

        <dw:GroupBox ID="gbAdWords" Title="Google AdWords" DoTranslation="false" runat="server">
            <div class="omc-padding">
                <table border="0">
                    <tr>
                        <td style="width: 170px"><dw:TranslateLabel ID="lbGoogleCampaign" Text="Campaign" runat="server" /></td>
                        <td><asp:Literal ID="litGoogleCampaign" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbGoogleMedium" Text="Medium" runat="server" /></td>
                        <td><asp:Literal ID="litGoogleMedium" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbGoogleSource" Text="Source" runat="server" /></td>
                        <td><asp:Literal ID="litGoogleSource" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbGoogleTerm" Text="Term" runat="server" /></td>
                        <td><asp:Literal ID="litGoogleTerm" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </dw:GroupBox>
    </div>
</asp:Content>

<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Leads/Details/EntryContent.Master" CodeBehind="Basic.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.Details.Basic" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="visitor-details-basic">
        <dw:GroupBox ID="gbSession" Title="Session" runat="server">
            <div class="omc-padding">
                <table border="0">
                    <tr>
                        <td style="width: 170px"><dw:TranslateLabel ID="lbID" Text="Id" runat="server" /></td>
                        <td><asp:Literal ID="litID" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbVisitorID" Text="Visitor Id" runat="server" /></td>
                        <td><asp:Literal ID="litVisitorID" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbPeriod" Text="Period" runat="server" /></td>
                        <td><asp:Literal ID="litPeriod" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbDuration" Text="Duration" runat="server" /></td>
                        <td><asp:Literal ID="litDuration" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </dw:GroupBox>

        <div class="omc-separator"></div>

         <dw:GroupBox ID="gbActivity" Title="Activity" runat="server">
            <div class="omc-padding">
                <table border="0">
                    <tr>
                        <td style="width: 170px"><dw:TranslateLabel ID="lbArea" Text="Language/Area" runat="server" /></td>
                        <td><asp:Literal ID="litArea" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbLandingPage" Text="Landing page" runat="server" /></td>
                        <td><asp:Literal ID="litLandingPage" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbExitPage" Text="Exit page" runat="server" /></td>
                        <td><asp:Literal ID="litExitPage" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbPageviews" Text="Pageviews" runat="server" /></td>
                        <td><asp:Literal ID="litPageviews" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbAvgTimeOnPage" Text="Average time on page" runat="server" /></td>
                        <td><asp:Literal ID="litAvgTimeOnPage" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </dw:GroupBox>

        <div class="omc-separator"></div>

        <dw:GroupBox ID="gbSystem" Title="System" runat="server">
            <div class="omc-padding">
                <table border="0">
                    <tr>
                        <td style="width: 170px"><dw:TranslateLabel ID="lbOperatingSystem" Text="Operating system" runat="server" /></td>
                        <td><asp:Literal ID="litOperatingSystem" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbScreen" Text="Screen settings" runat="server" /></td>
                        <td><asp:Literal ID="litScreen" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </dw:GroupBox>

        <div class="omc-separator"></div>

        <dw:GroupBox ID="gbBrowser" Title="Browser" runat="server">
            <div class="omc-padding">
                <table border="0">
                    <tr>
                        <td style="width: 170px"><dw:TranslateLabel ID="lbName" Text="Name" runat="server" /></td>
                        <td><asp:Literal ID="litName" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbLanguage" Text="Language" runat="server" /></td>
                        <td><asp:Literal ID="litLanguage" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbIsMobile" Text="Is mobile" runat="server" /></td>
                        <td><asp:Literal ID="litIsMobile" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </dw:GroupBox>
    </div>
</asp:Content>

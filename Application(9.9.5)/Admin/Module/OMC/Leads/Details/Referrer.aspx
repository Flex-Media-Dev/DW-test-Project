<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Leads/Details/EntryContent.Master" CodeBehind="Referrer.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.Details.Referrer" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="visitor-details-referrer">
        <dw:GroupBox ID="gbFields" Title="Details" runat="server">
            <div class="omc-padding">
                <table border="0">
                    <tr>
                        <td style="width: 170px"><dw:TranslateLabel ID="lbUrl" Text="URL" runat="server" /></td>
                        <td><asp:Literal ID="litURL" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbHost" Text="Host" runat="server" /></td>
                        <td><asp:Literal ID="litHost" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbDomain" Text="Domain" runat="server" /></td>
                        <td><asp:Literal ID="litDomain" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbPath" Text="Path" runat="server" /></td>
                        <td><asp:Literal ID="litPath" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </dw:GroupBox>

        <div class="omc-separator"></div>

        <dw:GroupBox ID="gbSearch" Title="Search engine" runat="server">
            <div class="omc-padding">
                <table border="0">
                    <tr>
                        <td style="width: 170px"><dw:TranslateLabel ID="lbKeywords" Text="Keywords" runat="server" /></td>
                        <td><asp:Literal ID="litKeywords" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbPage" Text="Page number" runat="server" /></td>
                        <td><asp:Literal ID="litPage" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbPosition" Text="Position" runat="server" /></td>
                        <td><asp:Literal ID="litPosition" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </dw:GroupBox>

        <div class="omc-separator"></div>

        <dw:GroupBox ID="gbQuery" Title="Query string parameters" runat="server">
            <div class="omc-padding">
                <div class="visitor-details-border">
                    <dw:List ID="lstQuery" PageSize="5" ShowTitle="false" NoItemsMessage="No parameters found" runat="server">
                        <Columns>
                            <dw:ListColumn ID="colName" Name="Name" Width="150" runat="server" />
                            <dw:ListColumn ID="colValue" Name="Value" Width="400" runat="server" />
                        </Columns>
                    </dw:List>
                </div>
            </div>
        </dw:GroupBox>
    </div>
</asp:Content>

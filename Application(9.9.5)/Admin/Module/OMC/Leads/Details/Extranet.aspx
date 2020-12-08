<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Leads/Details/EntryContent.Master" CodeBehind="Extranet.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.Details.Extranet" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="visitor-details-extranet">
        <dw:GroupBox ID="gbUserInformation" Title="User information" runat="server">
            <div class="omc-padding">
                <table border="0">
                    <tr>
                        <td style="width: 170px"><dw:TranslateLabel ID="lbUsername" Text="User name" runat="server" /></td>
                        <td><asp:Literal ID="litUsername" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbName" Text="Name" runat="server" /></td>
                        <td><asp:Literal ID="litName" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbAddress" Text="Address" runat="server" /></td>
                        <td><asp:Literal ID="litAddress" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbZipCode" Text="Zip code" runat="server" /></td>
                        <td><asp:Literal ID="litZipCode" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbCity" Text="City" runat="server" /></td>
                        <td><asp:Literal ID="litCity" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbCountry" Text="Country" runat="server" /></td>
                        <td><asp:Literal ID="litCountry" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </dw:GroupBox>

        <div class="omc-separator"></div>

        <dw:GroupBox ID="gbContactDetails" Title="Contact details" runat="server">
            <div class="omc-padding">
                <table border="0">
                    <tr>
                        <td style="width: 170px"><dw:TranslateLabel ID="lbEmail" Text="Email" runat="server" /></td>
                        <td><asp:Literal ID="litEmail" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbPhone" Text="Phone" runat="server" /></td>
                        <td><asp:Literal ID="litPhone" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbFax" Text="Fax" runat="server" /></td>
                        <td><asp:Literal ID="litFax" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </dw:GroupBox>

        <div class="omc-separator"></div>

        <dw:GroupBox ID="gbGroups" Title="Member of groups" runat="server">
            <div class="omc-padding">
                <div class="visitor-details-border">
                    <dw:List ID="lstGroups" PageSize="5" ShowTitle="false" NoItemsMessage="No groups found" runat="server">
                        <Columns>
                            <dw:ListColumn ID="colName" Name="Name" Width="400" runat="server" />
                        </Columns>
                    </dw:List>
                </div>
            </div>
        </dw:GroupBox>
    </div>
</asp:Content>

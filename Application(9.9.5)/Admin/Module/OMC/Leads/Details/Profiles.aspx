<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Leads/Details/EntryContent.Master" CodeBehind="Profiles.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.Details.Profiles" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="visitor-details-profiles">
        <dw:GroupBox ID="gbFields" Title="Details" runat="server">
            <div class="omc-padding">
                <table border="0">
                    <tr>
                        <td style="width: 170px"><dw:TranslateLabel ID="lbPrimary" Text="Primary profile" runat="server" /></td>
                        <td><asp:Literal ID="litPrimary" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbSecondary" Text="Secondary profile" runat="server" /></td>
                        <td><asp:Literal ID="litSecondary" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </dw:GroupBox>

        <div class="omc-separator"></div>

        <dw:GroupBox ID="gbPoints" Title="Profile points" runat="server">
            <div class="omc-padding">
                <div class="visitor-details-border">
                    <dw:List ID="lstEstimates" PageSize="10" ShowTitle="false" NoItemsMessage="No profiles found" runat="server">
                        <Columns>
                            <dw:ListColumn ID="colName" Name="Name" Width="350" runat="server" />
                            <dw:ListColumn ID="colPoints" Name="Points earned" Width="115" HeaderAlign="Center" ItemAlign="Center" runat="server" />
                        </Columns>
                    </dw:List>
                </div>
            </div>
        </dw:GroupBox>
    </div>
</asp:Content>

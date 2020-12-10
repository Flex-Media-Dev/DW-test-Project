<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Leads/Details/EntryContent.Master" CodeBehind="Location.aspx.vb" EnableViewState="false" Inherits="Dynamicweb.Admin.OMC.Leads.Details.Location" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        <asp:Literal ID="litInitialization" runat="server" />
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="visitor-details-location">
        <dw:GroupBox ID="gbFields" Title="Details" runat="server">
            <div class="omc-padding">
                <table border="0">
                    <tr>
                        <td style="width: 170px"><dw:TranslateLabel ID="lbAddress" Text="IP-address" runat="server" /></td>
                        <td><asp:Literal ID="litAddress" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbISP" Text="ISP" runat="server" /></td>
                        <td><div class="omc-nowrap visitor-details-location-field"><asp:Literal ID="litISP" runat="server" /></div></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbDomain" Text="Domain" runat="server" /></td>
                        <td><asp:Literal ID="litDomain" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbCompany" Text="Company" runat="server" /></td>
                        <td><asp:Literal ID="litCompany" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbZip" Text="Zip" runat="server" /></td>
                        <td><asp:Literal ID="litZip" runat="server" /></td>
                    </tr>
                        <tr>
                        <td><dw:TranslateLabel ID="lbCity" Text="City" runat="server" /></td>
                        <td><asp:Literal ID="litCity" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbRegion" Text="Region" runat="server" /></td>
                        <td><asp:Literal ID="litRegion" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbCountry" Text="Country" runat="server" /></td>
                        <td><asp:Literal ID="litCountry" runat="server" /></td>
                    </tr>
                    <tr>
                        <td><dw:TranslateLabel ID="lbCoordinates" Text="Corrdinates" runat="server" /></td>
                        <td><asp:Literal ID="litCoordinates" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </dw:GroupBox>

        <div class="omc-separator"></div>

        <dw:GroupBox ID="gbMap" Title="Map" runat="server">
            <div class="omc-padding">
                <div id="mapContainer"></div>
            </div>
        </dw:GroupBox>
    </div>
    
    <dw:Dialog ID="RenameLeadDialog" runat="server" Title="Rename lead" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true"  Width="450" >
        <iframe id="RenameLeadDialogFrame" runat="server" frameborder="0"></iframe>
    </dw:Dialog>
</asp:Content>

<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Leads/Details/EntryContent.Master" CodeBehind="About.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.Details.About" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        $(document).observe('dom:loaded', function () {
            var url = $$('.details-about-pageurl')[0];

            if (url) {
                // If the page was loaded from within a frame, getting a URL of the parent page
                if (parent && parent.location) {
                    url.value = parent.location.href;
                }

                // Pre-selecting the URL field
                setTimeout(function () {
                    try {
                        url.focus();
                        url.select();
                    } catch (ex) { }
                }, 50);
            }
        });
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="visitor-details-about">
        <dw:GroupBox ID="gbGeneral" Title="General" runat="server">
            <div class="omc-padding">
                <table border="0">
                    <tr>
                        <td style="width: 170px"><dw:TranslateLabel ID="lbPageURL" Text="Page URL" runat="server" /></td>
                        <td><input id="txURL" type="text" class="std details-about-pageurl" autocomplete="off" spellcheck="false" onpaste="return false;" onmouseup="this.select();" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </dw:GroupBox>
    </div>
</asp:Content>
